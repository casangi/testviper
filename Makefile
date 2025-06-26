.PHONY: build-testviper test-testviper build-main test-main build-latest test-latest

# MAIN BRANCH Installation and Tests
# --------------------------------------------------------------
# TESTVIPER
# Build testviper dependencies and run integration tests
build-testviper:
	pip install -r requirements/base.txt

test-testviper:
	python -m pytest -v ./tests/integration --junitxml=test-results.xml

# Install and Components
build-main: 
	pip install -r requirements/main.txt

test-main: 
	python -m pytest -v toolviper/tests --junitxml=toolviper-test-results.xml
	python -m pytest -v xradio/tests --junitxml=xradio-test-results.xml
	python -m pytest -v graphviper/tests --junitxml=graphviper-test-results.xml
	python -m pytest -v astroviper/tests --junitxml=astroviper-test-results.xml

# INSTALL and TEST LATEST PyPI versions of COMPONENTS
# --------------------------------------------------------------
build-latest: 
	pip install -r requirements/latest.txt

# TBD: how to run version of tests compatible with latest PyPI versions
test-latest:
#