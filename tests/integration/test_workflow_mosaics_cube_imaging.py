import os
import pickle
import shutil

import numpy as np
import pytest
import xarray as xr
from flowviper.prefect_workflow.mosaics_cube_imaging import (
    DEFAULT_IMAGE_DATA_VARIABLES_KEEP,
    DEFAULT_PS_STORE,
    DEFAULT_SCAN_INTENTS,
    mosaics_cube_imaging_flow,
)


@pytest.fixture(scope="session")
def antennae_processing_set(tmp_path_factory, stage_processing_set):
    """Download the Antennae set into a temp dir and delete it afterwards."""
    data_dir = tmp_path_factory.mktemp("antennae_data")
    ps_store = stage_processing_set(data_dir, DEFAULT_PS_STORE)
    yield ps_store
    shutil.rmtree(data_dir, ignore_errors=True)


@pytest.fixture(scope="session")
def tmp_work_dir(tmp_path_factory):
    """Shared writable directory for E2E imaging outputs, removed after the session."""
    work = tmp_path_factory.mktemp("mosaics_work")
    yield work
    shutil.rmtree(work, ignore_errors=True)


E2E_CASES = [
    pytest.param(
        (256, 256),
        0.13,
        ["I", "Q"],
        True,
        id="small-IQ-plots",
    ),
    pytest.param(
        (500, 500),
        0.13,
        ["I", "Q"],
        False,
        id="default-IQ",
    ),
    pytest.param(
        (256, 256),
        0.26,
        ["I", "Q"],
        False,
        id="coarse-cell-IQ",
    ),
    pytest.param(
        (1024, 512),
        0.13,
        ["I", "Q"],
        False,
        id="wide-IQ",
    ),
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


@pytest.mark.timeout(1800)
@pytest.mark.parametrize(
    "image_size,cell_arcsec,polarization_coords,create_plots",
    E2E_CASES,
)
def test_mosaics_cube_imaging_flow_e2e(
    antennae_processing_set,
    tmp_work_dir,
    image_size,
    cell_arcsec,
    polarization_coords,
    create_plots,
    request,
):
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
        ps_store=antennae_processing_set,
        image_name=image_name,
        scan_intents=list(DEFAULT_SCAN_INTENTS),
        image_size=image_size,
        cell_arcsec=cell_arcsec,
        polarization_coords=polarization_coords,
        create_plots=create_plots,
        plot_frequency_index=0,
        plot_polarization_index=0,
        dask_cores=2,
        dask_memory_limit="4GB",
    )

    _assert_image_store(image_name, image_size, cell_arcsec, polarization_coords)
