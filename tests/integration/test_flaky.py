import random
import pytest
import ctypes


def test_random_failure():
    if random.random() < 0.15:
        assert False, "Random failure triggered (15% chance)"
    assert True
    
def test_random_segfault():
    "Random Seg Fault triggered (0.1% chance)"
    if random.random() < 0.001:
        ctypes.string_at(0)
    assert True

@pytest.mark.skipif(random.random() < 0.5, reason="Randomly Skipped")
def test_skipped_feature():
    assert True

