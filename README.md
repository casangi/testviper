# TestVIPER
Automated Test Repository for the VIPER Ecosystem

[![Python 3.11 3.12 3.13](https://img.shields.io/badge/python-3.11%20%7C%203.12%20%7C%203.13-blue)](https://www.python.org/downloads/release/python-3130/)
[![Linux Tests](https://github.com/casangi/testviper/actions/workflows/python-tests-allure-report.yml/badge.svg?branch=main)](https://github.com/casangi/testviper/actions/workflows/python-tests-allure-report.yml?query=branch%3Amain)
[![CI-Dashboard](https://img.shields.io/badge/Dashboard-Status-green)](https://casangi.github.io/testviper/)
![Static Badge](https://img.shields.io/badge/work_in-progress-yellow)


This repository will be used to build and run integration tests for the VIPER Ecosystem.
It will install all components and run the available tests in the CI.
Structure of this repository:
- ci: configuration for CI system
- (docs): TBD
- requirements: requirements to build dependencies
- scripts: scripts to generate reports and for installation
- tests/integration: workflow integration tests


## Installation
This repository runs integration and component tests against VIPER components in editable mode, with branch/tag/commit selection per component. The flow is PEP 508–compliant and CI-friendly.

### Prerequisites
- Python 3.12 or 3.13
- git
- pip >= 24.1 (recommended)
- macOS users need conda to install `python-casacore` (not required for the default build), but required to run tests.

### What gets installed
- Components (editable) from local clones under `external/`:
  - `external/xradio`, `external/graphviper`, `external/astroviper`, `external/toolviper`
- TestVIPER dependencies from `requirements/base.txt`

Components are synced by `scripts/sync_components.sh` and installed via `requirements/main.txt` using editable local paths (PEP 508–compliant).

### Quick start (all components on main)

#### Using Conda for macOS
Use conda-forge to install the python-casacore library as a dependency for xradio.

```bash
conda create --name testviper-venv python=3.13 --no-default-packages
conda activate testviper-venv
conda install -c conda-forge python-casacore
make build-main
```

#### Using a Python Virtual Environment
```bash
python3.13 -m venv venv
source venv/bin/activate
```

```bash
make build-main
```
Runs:
- Clone/update all components to `main`
- Install components in editable mode
- Install TestViper base dependencies

Run tests:
```bash
make test-main        # Component test suites under external/<component>/tests
make test-testviper   # Integration tests in tests/integration
```

### Build all components at the same branch/tag/commit
```bash
make build-branch REF=feature/my-branch
```
Examples:
- Branch: `make build-branch REF=19-fix-bug-in-configuration`
- Tag: `make build-branch REF=v0.3.1`
- Commit: `make build-branch REF=2c4b0f1`

### Build with per-component refs
```bash
make build-refs \
  XRADIO=78-io-rework \
  GRAPHVIPER=v0.3.1 \
  ASTROVIPER=2c4b0f1 \
  TOOLVIPER=main
```
Provide only what you need; unspecified components default to `main`.


## Alternative Installation using PIXI

1. Install PIXI:
```bash
curl -fsSL https://pixi.sh/install.sh | sh
export PATH=/user/../.pixi/bin:$PATH
```

### Package Management with PIXI

The project uses PIXI for package management. All dependencies are managed through `pixi.toml`.

To add a new dependency:
```bash
pixi add package-name
```

To remove a dependency:
```bash
pixi remove package-name
```

To add a new dependency from PyPI:
```bash
pixi add package-name --pypi
```

To update dependencies:
```bash
pixi update
```

### Build TestVIPER and the VIPER components
The file pixi.toml contains the minimum dependencies to install the
components from any branch. the pixi dependencies are installed from the
conda-forge channel. The components are installed using pip inside a pixi
environment.

The pip-branch "task" in pixi.toml allows to install the components from any branch
by giving the branch name as an argument.
```bash
pixi install
pixi run pip-install main
...
```
### Run tests from each components and the integration tests in TestVIPER
```bash
pixi run pytest -v tests/integration
pixi run pytest -v external/xradio/tests
...etc.
```

## Central Dashboard for VIPER Ecosystem Integration Tests
Currently there is a draft implementation using Allure Reports and accessible via
https://casangi.github.io/testviper/

There is another draft implementation of test aggregation using Testspace, accessible via
https://casangi.testspace.com/projects/68338/spaces and https://casangi.testspace.com/spaces/311697/metrics.

- ....