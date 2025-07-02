import pytest
import xarray as xr
from xradio.measurement_set.measurement_set_xdt import (
    MeasurementSetXdt,
    InvalidAccessorLocation,
)


class TestBasicXradio2:
    """Tests for checking basic functionality of xradio"""

    def test_simple2(self):
        assert True

    def test_simple_string2(self, sample_fixture):
        print(f"Sample fixture value: {sample_fixture}")
        assert sample_fixture == "sample_data"

    def test_invalid_sel2(self):
        ms_xdt = MeasurementSetXdt(xr.DataTree())

        with pytest.raises(InvalidAccessorLocation, match="not a MSv4 node"):
            assert ms_xdt.sel()

if __name__ == "__main__":
    pytest.main(["-v", "-s", __file__])
# This is a simple test to ensure that pytest is working correctly.
# It should be run with pytest to verify that the testing framework is set up properly.
# To run this test, use the command: pytest -v __test_example__.py
# This will execute the test and show the results in verbose mode.