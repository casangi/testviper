import random
import pytest
import ctypes


def test_random_failure():
    assert random.random() < 0.3, "Random failure triggered (30% chance)"

def test_random_segfault():
    "Random Seg Fault triggered (10% chance)"
    if random.random() < 0.10:
        ctypes.string_at(0)
    assert True

