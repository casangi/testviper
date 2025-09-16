# TestVIPER 
Automated Test Repository for the VIPER Ecosystem

[![Python 3.11 3.12 3.13](https://img.shields.io/badge/python-3.11%20%7C%203.12%20%7C%203.13-blue)](https://www.python.org/downloads/release/python-3130/)
[![Linux Tests](https://github.com/casangi/testviper/actions/workflows/python-tests-allure-report.yml/badge.svg?branch=main)](https://github.com/casangi/testviper/actions/workflows/python-tests-allure-report.yml?query=branch%3Amain)
[![Documentation Status](https://readthedocs.org/projects/testviper/badge/?version=latest)](https://testviper.readthedocs.io)
![Static Badge](https://img.shields.io/badge/work_in-progress-yellow)


This repository will be used to build and run integration tests for the VIPER Ecosystem.
It will install all components and run the available tests in the CI.
Structure of this repository:
- tests/integration: workflow integration tests
- requirements: requirements to build dependencies
- ci: configuration for CI system
- (docs)
- (docs/user_stories)
- scripts: scripts to generate reports and results
- ......

User stories will be saved in Issues with the label "User Story" and linked to the issue that implements
the test. The user stories can also be added to the documentation of the test framework.

## Setup with Virtual Environment
Install the components and run the tests inside a virtual environment. 

To run the tests in a Linux system, use any recent Python version such as 3.11, 3.12 or 3.13:
```bash
python3.13 -m venv venv-3.13
source venv-3.13/bin/activate
make build-main
make test-main
pytest -v tests/integration
deactivate
```

To run the tests in a macOS system, it is necessary to install the python-casacore library as a dependency for xradio, using conda-forge.

```bash
conda create --name testviper-venv python=3.13 --no-default-packages
conda activate testviper-venv
conda install -c conda-forge python-casacore
pip install -r requirements/base.txt
make build-main
pytest -v tests/integration
conda deactivate
```

## Setup with PIXI

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
pixi run pytest -v xradio/tests
pixi run pytest -v toolviper/tests
pixi run pytest -v graphviper/tests
pixi run pytest -v astroviper/tests
pixi run pytest -v tests/integration
```

## CI/CD - in progress
A few things to try here.
- Allure Report
- Testspace.com
- GitHub Datadog CI Visibility: for monitoring services
- Git Action Board
- Octolense.com
- Test-reporter GitHub action

## Central Dashboard for VIPER Ecosystem Integration Tests
Currently there is a draft implementation using Allure Reports and accessible via
https://casangi.github.io/testviper/main

There is another draft implementation of test aggregation using Testspace, accessible via
https://casangi.testspace.com/projects/68338/spaces and https://casangi.testspace.com/spaces/311697/metrics.


### What the Dashboard Should Show in the future
- Test status per component (e.g., AstroVIPER, ToolVIPER, etc.)
- Latest test runs and build status
- Test trends over time (pass/fail rates, flakiness)
- Linked user stories or features
- Links to detailed test reports (e.g., Allure, HTML, logs)
- Metadata: commit ID, test duration, environment
- ....
