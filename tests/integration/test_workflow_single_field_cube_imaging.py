import os
import pickle
import shutil

import numpy as np
import pytest
import xarray as xr
from astroviper.processing_functions.imaging.utils.imaging_dict import (
    imaging_dict_to_dataframe,
)
from xradio.measurement_set import open_processing_set

from flowviper.prefect_workflow.single_field_cube_imaging_example import (
    DEFAULT_IMAGE_DATA_VARIABLES_KEEP,
    DEFAULT_PS_STORE,
    DEFAULT_SCAN_INTENTS,
    single_field_cube_imaging_flow,
)

# Flow arguments shared by every case; each case overrides a subset of them.
BASE_PARAMS = {
    "image_size": (250, 250),
    "cell_arcsec": 0.13,
    "polarization_coords": ["I", "Q"],
    "weighting": "briggs",
    "robust": 0.5,
    "algorithm": "hogbom",
    "gain": 0.1,
    "max_iter": 100,
    "threshold": 0.0,
    "max_cycles": -1,
    "psf_sidelobe_factor": 1.5,
    "max_iter_per_cycle": -1,
    "min_psf_fraction": 0.05,
    "max_psf_fraction": 0.8,
}

ITERATION_CONTROL_KEYS = (
    "gain",
    "max_iter",
    "threshold",
    "max_cycles",
    "psf_sidelobe_factor",
    "max_iter_per_cycle",
    "min_psf_fraction",
    "max_psf_fraction",
)

E2E_CASES = [
    pytest.param({}, id="default-briggs"),
    pytest.param({"weighting": "natural"}, id="natural-weighting"),
    pytest.param({"robust": -2.0}, id="briggs-uniform"),
    pytest.param({"robust": 2.0}, id="briggs-robust-plus2"),
    pytest.param({"gain": 0.05, "max_iter": 300}, id="low-gain-deep-clean"),
    pytest.param({"max_iter": 20, "max_iter_per_cycle": 5}, id="short-minor-cycles"),
    pytest.param({"threshold": 0.2, "max_iter": 1000}, id="threshold-stop"),
    pytest.param(
        {"image_size": (128, 128), "cell_arcsec": 0.26}, id="small-coarse-cell"
    ),
    pytest.param({"image_size": (300, 200)}, id="rectangular-image"),
    pytest.param({"create_plots": True, "plot_frequency_index": 0}, id="create-plots"),
    pytest.param(
        {"max_iter": 0, "max_cycles": 0},
        id="dirty-image-only",
        marks=pytest.mark.xfail(
            strict=True,
            reason=(
                "With max_iter=0 astroviper fails to write the image chunks "
                "(KeyError: no SKY_MODEL, which is in "
                "DEFAULT_IMAGE_DATA_VARIABLES_KEEP), leaving the PSF all-NaN "
                "while the flow still reports success."
            ),
        ),
    ),
]


@pytest.fixture(scope="session")
def twhya_processing_set(tmp_path_factory, stage_processing_set):
    """Download the TW Hya set into a temp dir and delete it after the session.

    Returns ``(ps_store, n_channels)``. A store already in the working
    directory is removed first.
    """
    data_dir = tmp_path_factory.mktemp("twhya_data")
    ps_store = stage_processing_set(data_dir, DEFAULT_PS_STORE)
    ps_xdt = open_processing_set(ps_store, scan_intents=DEFAULT_SCAN_INTENTS)
    n_channels = len(ps_xdt.xr_ps.get_freq_axis())
    yield ps_store, n_channels
    shutil.rmtree(data_dir, ignore_errors=True)


@pytest.fixture(autouse=True)
def cleanup_test_outputs(tmp_path):
    """Remove this test's image stores when the test finishes."""
    yield
    shutil.rmtree(tmp_path, ignore_errors=True)


def _run_imaging(tmp_path, name, ps_store, **overrides):
    """Run the flow into a pytest temp directory and return the store path, params, and result."""
    params = {**BASE_PARAMS, **overrides}
    image_name = str(tmp_path / f"{name}.img.zarr")
    result = single_field_cube_imaging_flow(
        ps_store=ps_store,
        image_name=image_name,
        scan_intents=list(DEFAULT_SCAN_INTENTS),
        dask_cores=2,
        dask_memory_limit="4GB",
        **params,
    )
    return image_name, params, result


def _expected_cell_size(cell_arcsec: float) -> np.ndarray:
    return np.array([-cell_arcsec, cell_arcsec]) * np.pi / (180 * 3600)


def _assert_image_store(image_name: str, params: dict, n_channels: int) -> xr.Dataset:
    assert os.path.isdir(image_name)
    img_xds = xr.open_zarr(image_name)

    for variable in DEFAULT_IMAGE_DATA_VARIABLES_KEEP:
        assert variable.upper() in img_xds.data_vars

    assert [img_xds.sizes["l"], img_xds.sizes["m"]] == list(params["image_size"])
    assert img_xds.sizes["frequency"] == n_channels
    assert list(img_xds.polarization.values) == params["polarization_coords"]

    psf = img_xds.POINT_SPREAD_FUNCTION.values
    assert np.isfinite(psf).all(), "PSF contains non-finite values"
    np.testing.assert_allclose(np.nanmax(psf), 1.0, atol=1e-3)
    assert np.isfinite(img_xds.SKY_RESIDUAL.values).all()
    return img_xds


def _assert_saved_config(image_name: str, params: dict) -> None:
    results_path = image_name + "_imaging_results.pkl"
    assert os.path.isfile(results_path)
    with open(results_path, "rb") as handle:
        config = pickle.load(handle)["imaging_config"]

    image_params = config["image_params"]
    assert image_params["image_size"] == list(params["image_size"])
    assert image_params["polarization_coords"] == params["polarization_coords"]
    np.testing.assert_allclose(
        image_params["cell_size"], _expected_cell_size(params["cell_arcsec"])
    )
    assert config["imaging_weights_params"] == {
        "weighting": params["weighting"],
        "robust": params["robust"],
    }
    assert config["algorithm"] == params["algorithm"]
    for key in ITERATION_CONTROL_KEYS:
        assert config["iteration_control_params"][key] == params[key], key


def _assert_deconvolution(
    result: dict, img_xds: xr.Dataset, params: dict, n_channels: int
) -> None:
    planes = imaging_dict_to_dataframe(result["deconvolution"])
    assert len(planes) == n_channels * len(params["polarization_coords"])

    max_iter = params["max_iter"]
    assert (planes["iter_total"] <= max_iter).all()

    if params["max_iter_per_cycle"] > 0:
        for iter_done in planes["iter_done"]:
            assert max(iter_done) <= params["max_iter_per_cycle"]

    if max_iter == 0:
        assert (planes["iter_total"] == 0).all()
        return

    cleaned = planes[planes["iter_total"] > 0]
    assert not cleaned.empty, "No plane was deconvolved"
    assert (cleaned["peakres_final"].abs() < cleaned["peakres_start"].abs()).all(), (
        "CLEAN did not reduce the peak residual"
    )
    assert np.abs(img_xds.SKY_MODEL.values).max() > 0.0

    if params["threshold"] > 0.0:
        stopped_early = planes[planes["iter_total"] < max_iter]
        assert not stopped_early.empty, "No plane stopped on the threshold"
        assert (stopped_early["peakres_final"].abs() <= params["threshold"] * 1.1).all()


@pytest.mark.timeout(1800)
@pytest.mark.parametrize("overrides", E2E_CASES)
def test_single_field_cube_imaging_flow_e2e(twhya_processing_set, tmp_path, overrides):
    ps_store, n_channels = twhya_processing_set
    image_name, params, result = _run_imaging(tmp_path, "cube", ps_store, **overrides)

    assert {
        "deconvolution",
        "image_statistics",
        "timing_distributed_application",
    } <= set(result)
    img_xds = _assert_image_store(image_name, params, n_channels)
    _assert_saved_config(image_name, params)
    _assert_deconvolution(result, img_xds, params, n_channels)


@pytest.mark.timeout(1800)
def test_natural_weighting_gives_wider_beam_than_uniform(
    twhya_processing_set, tmp_path
):
    ps_store, _ = twhya_processing_set

    beams = {}
    for name, weighting, robust in (
        ("natural", "natural", 0.5),
        ("uniform", "briggs", -2.0),
    ):
        image_name, _, _ = _run_imaging(
            tmp_path,
            name,
            ps_store,
            weighting=weighting,
            robust=robust,
            max_iter=10,
        )
        beam = xr.open_zarr(image_name).BEAM_FIT_PARAMS_POINT_SPREAD_FUNCTION
        beams[weighting] = beam.isel(time=0, polarization=0)

    major_natural = beams["natural"].sel(beam_params_label="major").values
    major_uniform = beams["briggs"].sel(beam_params_label="major").values
    assert np.isfinite(major_natural).all() and np.isfinite(major_uniform).all()
    assert (major_natural > major_uniform).all()


# The TW Hya data has linear feeds with only the XX and YY correlations.
@pytest.mark.timeout(600)
@pytest.mark.parametrize(
    "polarization_coords,match",
    [
        pytest.param(["I"], "not supported", id="stokes-I-only"),
        pytest.param(["I", "Q", "U", "V"], "missing", id="full-stokes"),
    ],
)
def test_unsupported_stokes_selection_fails(
    twhya_processing_set, tmp_path, polarization_coords, match
):
    ps_store, _ = twhya_processing_set

    with pytest.raises(ValueError, match=match):
        _run_imaging(
            tmp_path, "cube", ps_store, polarization_coords=polarization_coords
        )
