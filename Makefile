.PHONY: build-testviper test-testviper build-main test-main build-latest test-latest sync-components build-branch build-refs bench-xradio bench-xradio-compare

# Defaults for parameterized builds (can be overridden: make build-branch REF=foo)
REF ?= main
XRADIO ?=
GRAPHVIPER ?=
ASTROVIPER ?=
TOOLVIPER ?=

# MAIN BRANCH Installation and Tests
# --------------------------------------------------------------
# TESTVIPER
# Build testviper dependencies and run integration tests
build-testviper:
	pip install -r requirements/base.txt

test-testviper:
	python -m pytest -v ./tests/integration --junitxml=test-results.xml

# Install and Components
sync-components:
	bash scripts/sync_components.sh

# Build with all components at a single ref (default main).
# Usage: make build-branch REF=feature/my-branch
build-branch:
	bash scripts/sync_components.sh --all $(REF)
	pip install -r requirements/main.txt
	pip install -r requirements/base.txt

build-main: sync-components
	pip install -r requirements/main.txt
	pip install -r requirements/base.txt

test-main: 
	python -m pytest -v external/toolviper/tests --junitxml=toolviper-test-results.xml
	python -m pytest -v external/xradio/tests --junitxml=xradio-test-results.xml
	python -m pytest -v external/graphviper/tests --junitxml=graphviper-test-results.xml
	python -m pytest -v external/astroviper/tests --junitxml=astroviper-test-results.xml

# INSTALL and TEST LATEST PyPI versions of COMPONENTS
# --------------------------------------------------------------
build-latest: 
	pip install -r requirements/latest.txt

# TBD: how to run version of tests compatible with latest PyPI versions
test-latest:
#

# Keep bench targets out of testviper's Makefile; defined in xradio's Makefile

# Build with per-component refs
# Usage:
#   make build-refs XRADIO=branch1 GRAPHVIPER=v0.3.1 ASTROVIPER=abc123 TOOLVIPER=main
build-refs:
	bash scripts/sync_components.sh \
		$(if $(XRADIO),--xradio $(XRADIO),) \
		$(if $(GRAPHVIPER),--graphviper $(GRAPHVIPER),) \
		$(if $(ASTROVIPER),--astroviper $(ASTROVIPER),) \
		$(if $(TOOLVIPER),--toolviper $(TOOLVIPER),)
	pip install -r requirements/main.txt
	pip install -r requirements/base.txt
