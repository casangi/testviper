"""
Top-level integration test fixtures.

Only fixtures that are shared across ALL integration test domains (imaging,
calibration, ...) belong here.  Domain-specific fixtures live in the
per-domain conftest.py (e.g. imaging/conftest.py).
"""

import pathlib
import shutil

import pytest
from prefect.testing.utilities import prefect_test_harness
from toolviper.utils.data import download
from xradio.measurement_set import (
    convert_msv2_to_processing_set,  # noqa: F401  (import smoke check)
)


@pytest.fixture(scope="session")
def stage_processing_set():
    """Return a helper that downloads a processing set into a temp directory.

    Tests start from an empty working directory. A store already there is
    removed, then a fresh copy is downloaded into the given directory.
    """

    def _stage(data_dir, store_name: str) -> str:
        local = pathlib.Path(store_name)
        if local.exists():
            if local.is_dir():
                shutil.rmtree(local)
            else:
                local.unlink()
        download(file=store_name, folder=str(data_dir))
        return str(pathlib.Path(data_dir) / store_name)

    return _stage


@pytest.fixture(autouse=True, scope="session")
def prefect_test_fixture():
    """Run Prefect against a temporary local backend (no cluster)."""
    with prefect_test_harness():
        yield


@pytest.fixture(scope="module")
def sample_fixture():
    return "sample_data"


@pytest.fixture
def tmp_output_dir(tmp_path):
    """Generic per-test writable directory."""
    return tmp_path


# NOTE: move to imaging/conftest.py once test_cube_imaging_example.py
# and test_workflow_mosaics_cube_imaging.py are relocated to tests/integration/imaging/
@pytest.fixture(
    params=[
        pytest.param({"nsources": 1, "fluxes": [1.0]}, id="single_source"),
        pytest.param(
            {"nsources": 4, "fluxes": [1.0, 1.0, 1.0, 1.0]},
            id="four_equal_sources",
        ),
    ]
)
def synthetic_ms4_scenario(request):
    """Parameterised synthetic MSv4 datasets for imaging tests."""
    return request.param
