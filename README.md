# TestVIPER
Automated Test Repository for the VIPER Ecosystem

[![Python 3.11 3.12 3.13](https://img.shields.io/badge/python-3.11%20%7C%203.12%20%7C%203.13-blue)](https://www.python.org/downloads/release/python-3130/)
[![Coverage](https://codecov.io/gh/casangi/testviper/branch/main/graph/badge.svg)](https://codecov.io/gh/casangi/testviper/branch/main/testviper)
[![Documentation Status](https://readthedocs.org/projects/testviper/badge/?version=latest)](https://testviper.readthedocs.io)
[![Version Status](https://img.shields.io/pypi/v/testviper.svg)](https://pypi.python.org/pypi/testviper/)

In-progress....

This repository is used to build and run integration tests for the VIPER Ecosystem.
It will install all components and run the available tests in the CI.
Proposed structure for this repository:
- tests
- requirements
- docs
- docs/user_stories
- ci
- tests/integration
- ......

User stories are saved in Issues with the label "User Story" and linked to the issue that implements
the test. The user stories can also be added to the documentation of the test framework.

Some basic tests to verify that the components are properly installed
- test_basic_toolviper.py
- test_basic_xradio.py

## Workflows for build and test
.github/workflows....yaml files
Steps to have in the workflows

- build toolviper
- build xradio
- run unit tests
- run component/stakeholder tests
- run workflow integration tests

## Setup with Virtual Environment
Install the components and run the tests inside a virtual environment. This
setup will not install python-casacore on macOS because it needs to use conda-forge.
If installing on a macOS system, please use the pixi setup.

To run the tests
```bash
python3.13 -m venv venv-3.13
source venv-3.13/bin/activate
make build-main
make test-main
```

...

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

## CI/CD
A few things to try here.
- GitHub Datadog CI Visibility: for monitoring services
- Git Action Board
- Octolense.com
- Testspace.com
- Test-reporter GitHub action

### Testspace
Free account. Unlimited for open-source; includes constraints for private usage.
Use the GitHub Marketplace to install Testspace - https://github.com/marketplace/testspace-com
Live demo: https://s2.testspace.com/spaces/145811/current/308836/automated%20tests/Code%20Coverage/_details

### test-reporter
It is a github action that displays test results from popular testing frameworks directly in GitHub. https://github.com/marketplace/actions/test-reporter. It would be a complementary tool to testspace because testspace does not have the feature of showing which test failed in a PR or annotations and diffs.

## Central Dashboard for VIPER Ecosystem Integration Tests

### What the Dashboard Should Show
- Test status per component (e.g., AstroVIPER, ToolVIPER, etc.)
- Latest test runs and build status
- Test trends over time (pass/fail rates, flakiness)
- Linked user stories or features
- Links to detailed test reports (e.g., Allure, HTML, logs)
- Metadata: commit ID, test duration, environment