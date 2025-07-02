import pytest
from toolviper.utils.data import download
from xradio.measurement_set import convert_msv2_to_processing_set


@pytest.fixture(scope="module")
def sample_fixture():
    return "sample_data"