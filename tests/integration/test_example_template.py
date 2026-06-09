import pytest
import astroviper
from prefect.testing.utilities import prefect_test_harness
from flowviper.prefect_workflow.example_template import math_flow, compute_data

# Automatically provide an isolated Prefect backend database for all tests
@pytest.fixture(autouse=True, scope="session")
def prefect_test_fixture():
    with prefect_test_harness():
        yield

# Test the flow as a whole
def test_math_flow():
    flow_result = math_flow(10, 5)
    assert flow_result == 15

# Test the task individually
def test_compute_data_task():
    task_result = compute_data(3, 4)
    assert task_result == 7