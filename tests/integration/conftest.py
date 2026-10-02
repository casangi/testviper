import pytest
from toolviper.utils.data import download  # noqa: F401  (import smoke check)
from xradio.measurement_set import (
    convert_msv2_to_processing_set,  # noqa: F401  (import smoke check)
)


@pytest.fixture(scope="module")
def sample_fixture():
    return "sample_data"
