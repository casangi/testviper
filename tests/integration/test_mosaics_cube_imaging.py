import os
import pickle
import shutil

import numpy as np
import pytest
import xarray as xr
from toolviper.utils.data import download

from flowviper.prefect_workflow.mosaics_cube_imaging import (
    DEFAULT_IMAGE_DATA_VARIABLES_KEEP,
    DEFAULT_PS_STORE,
    DEFAULT_SCAN_INTENTS,
    configure_image_params,
    create_imaging_summary_artifact,
    mosaics_cube_imaging_flow,
    plot_image_products,
    prepare_image_store,
    save_results,
)

@pytest.fixture
def sample_imaging_metadata():
    """Minimal imaging metadata dict matching the structure returned by inspect_processing_set."""
    return {
        "ps_store": "dummy.ps.zarr",
        "scan_intents": ["OBSERVE_TARGET#ON_SOURCE"],
        "ms_key": "dummy_ms",
        "center_field_name": "field_0",
        "phase_direction": np.array([0.0, 0.0]),
        "frequency_coords": np.array([1.4e9, 1.401e9, 1.402e9, 1.403e9]),
    }


@pytest.fixture(scope="session")
def antennae_processing_set():
    """Download the Antennae North processing set once per test session."""
    download(file=DEFAULT_PS_STORE)


@pytest.fixture(scope="session")
def tmp_work_dir(tmp_path_factory):
    """Shared writable directory for E2E imaging outputs."""
    return tmp_path_factory.mktemp("mosaics_work")


E2E_CASES = [
    pytest.param(
        (256, 256),
        0.13,
        ["I"],
        id="small-I",
    ),
    # pytest.param(
    #     (500, 500),
    #     0.13,
    #     ["I", "Q"],
    #     id="default-IQ",
    # ),
    # pytest.param(
    #     (256, 256),
    #     0.26,
    #     ["I"],
    #     id="coarse-cell-I",
    # ),
    # pytest.param(
    #     (1024, 512),
    #     0.13,
    #     ["I", "Q"],
    #     id="wide-IQ",
    # ),
]

NON_SPATIAL_DIMS = {"polarization", "frequency", "time"}


def _expected_cell_size(cell_arcsec: float) -> np.ndarray:
    return np.array([-cell_arcsec, cell_arcsec]) * np.pi / (180 * 3600)


def _spatial_sizes(data_array: xr.DataArray) -> list[int]:
    spatial_dims = [dim for dim in data_array.dims if dim not in NON_SPATIAL_DIMS]
    return [data_array.sizes[dim] for dim in spatial_dims]


def _assert_image_store(
    image_name: str,
    image_size: tuple[int, int],
    cell_arcsec: float,
    polarization_coords: list[str],
) -> dict:
    assert os.path.isdir(image_name)

    img_xds = xr.open_zarr(image_name)
    for variable in DEFAULT_IMAGE_DATA_VARIABLES_KEEP:
        upper_name = variable.upper()
        assert upper_name in img_xds.data_vars

    psf = img_xds.POINT_SPREAD_FUNCTION
    assert _spatial_sizes(psf) == list(image_size)
    assert psf.sizes["polarization"] == len(polarization_coords)
    assert np.isfinite(psf.values).any()

    results_path = image_name + "_imaging_results.pkl"
    assert os.path.isfile(results_path)

    with open(results_path, "rb") as handle:
        results = pickle.load(handle)

    saved_image_params = results["imaging_config"]["image_params"]
    assert saved_image_params["image_size"] == list(image_size)
    assert saved_image_params["polarization_coords"] == polarization_coords
    np.testing.assert_allclose(
        saved_image_params["cell_size"],
        _expected_cell_size(cell_arcsec),
    )
    return results


@pytest.mark.parametrize("image_size", [(256, 256), (500, 500), (1024, 512)], ids=["256", "500", "wide"])
@pytest.mark.parametrize("cell_arcsec", [0.065, 0.13, 0.26], ids=["fine", "default", "coarse"])
def test_configure_image_params(image_size, cell_arcsec, sample_imaging_metadata):
    config = configure_image_params.fn(
        sample_imaging_metadata,
        image_size=image_size,
        cell_arcsec=cell_arcsec,
    )

    image_params = config["image_params"]
    assert image_params["image_size"] == list(image_size)
    np.testing.assert_allclose(
        image_params["cell_size"],
        _expected_cell_size(cell_arcsec),
    )
    np.testing.assert_array_equal(
        image_params["phase_direction"],
        sample_imaging_metadata["phase_direction"],
    )
    np.testing.assert_array_equal(
        image_params["frequency_coords"],
        sample_imaging_metadata["frequency_coords"],
    )
    assert image_params["polarization_coords"] == ["I", "Q"]
    assert image_params["time_coords"] == [0]
    assert image_params["fft_padding"] == 1.0
    assert config["imaging_weights_params"]["weighting"] == "natural"
    assert config["iteration_control_params"]["niter"] == 0
    assert config["image_data_variables_keep"] == list(DEFAULT_IMAGE_DATA_VARIABLES_KEEP)


@pytest.mark.parametrize(
    "polarization_coords,expected",
    [
        (None, ["I", "Q"]),
        (["I"], ["I"]),
        (["I", "Q"], ["I", "Q"]),
    ],
    ids=["default", "stokes-I", "stokes-IQ"],
)
def test_configure_image_params_polarization(
    polarization_coords,
    expected,
    sample_imaging_metadata,
):
    config = configure_image_params.fn(
        sample_imaging_metadata,
        polarization_coords=polarization_coords,
    )
    assert config["image_params"]["polarization_coords"] == expected


def test_prepare_image_store_removes_existing_directory(tmp_path):
    image_name = tmp_path / "existing.img.zarr"
    image_name.mkdir()
    (image_name / "marker").write_text("old")

    result = prepare_image_store.fn(str(image_name))

    assert result == str(image_name)
    assert not image_name.exists()


def test_prepare_image_store_returns_path_for_missing_directory(tmp_path):
    image_name = tmp_path / "new.img.zarr"

    result = prepare_image_store.fn(str(image_name))

    assert result == str(image_name)
    assert not image_name.exists()


def test_save_results_writes_pickle(tmp_path, sample_imaging_metadata):
    image_name = str(tmp_path / "cube.img.zarr")
    imaging_config = configure_image_params.fn(sample_imaging_metadata)

    results_path = save_results.fn(image_name, imaging_config, sample_imaging_metadata)

    assert results_path == image_name + "_imaging_results.pkl"
    with open(results_path, "rb") as handle:
        results = pickle.load(handle)

    assert results["image_name"] == image_name

    saved_metadata = results["metadata"]
    assert saved_metadata["ps_store"] == sample_imaging_metadata["ps_store"]
    assert saved_metadata["scan_intents"] == sample_imaging_metadata["scan_intents"]
    assert saved_metadata["ms_key"] == sample_imaging_metadata["ms_key"]
    assert saved_metadata["center_field_name"] == sample_imaging_metadata["center_field_name"]
    np.testing.assert_array_equal(
        saved_metadata["phase_direction"],
        sample_imaging_metadata["phase_direction"],
    )
    np.testing.assert_array_equal(
        saved_metadata["frequency_coords"],
        sample_imaging_metadata["frequency_coords"],
    )

    saved_params = results["imaging_config"]["image_params"]
    expected_params = imaging_config["image_params"]
    assert saved_params["image_size"] == expected_params["image_size"]
    assert saved_params["polarization_coords"] == expected_params["polarization_coords"]
    np.testing.assert_allclose(saved_params["cell_size"], expected_params["cell_size"])
    np.testing.assert_array_equal(
        saved_params["phase_direction"],
        expected_params["phase_direction"],
    )
    np.testing.assert_array_equal(
        saved_params["frequency_coords"],
        expected_params["frequency_coords"],
    )


@pytest.mark.integration
@pytest.mark.timeout(1800)
@pytest.mark.parametrize(
    "image_size,cell_arcsec,polarization_coords",
    E2E_CASES,
)
def test_mosaics_cube_imaging_flow_e2e(
    antennae_processing_set,
    tmp_work_dir,
    image_size,
    cell_arcsec,
    polarization_coords,
    request,
):
    del antennae_processing_set

    case_id = request.node.callspec.id
    image_name = str(tmp_work_dir / f"cube_{case_id}.img.zarr")
    results_path = image_name + "_imaging_results.pkl"

    def cleanup_outputs():
        if os.path.isdir(image_name):
            shutil.rmtree(image_name)
        if os.path.isfile(results_path):
            os.remove(results_path)

    request.addfinalizer(cleanup_outputs)

    mosaics_cube_imaging_flow(
        ps_store=DEFAULT_PS_STORE,
        image_name=image_name,
        scan_intents=list(DEFAULT_SCAN_INTENTS),
        image_size=image_size,
        cell_arcsec=cell_arcsec,
        polarization_coords=polarization_coords,
        create_plots=False,
        dask_cores=2,
        dask_memory_limit="4GB",
    )

    _assert_image_store(image_name, image_size, cell_arcsec, polarization_coords)


@pytest.mark.integration
@pytest.mark.timeout(1800)
def test_mosaics_cube_imaging_artifact_smoke(antennae_processing_set, tmp_work_dir, request):
    del antennae_processing_set

    image_name = str(tmp_work_dir / "cube_artifact_smoke.img.zarr")
    results_path = image_name + "_imaging_results.pkl"

    def cleanup_outputs():
        if os.path.isdir(image_name):
            shutil.rmtree(image_name)
        if os.path.isfile(results_path):
            os.remove(results_path)

    request.addfinalizer(cleanup_outputs)

    mosaics_cube_imaging_flow(
        ps_store=DEFAULT_PS_STORE,
        image_name=image_name,
        scan_intents=list(DEFAULT_SCAN_INTENTS),
        image_size=(256, 256),
        cell_arcsec=0.13,
        polarization_coords=["I", "Q"],
        create_plots=False,
        dask_cores=2,
        dask_memory_limit="4GB",
    )

    _assert_image_store(image_name, (256, 256), 0.13, ["I", "Q"])
    create_imaging_summary_artifact.fn(image_name)
    plot_image_products.fn(image_name, frequency_index=0, polarization_index=0)
