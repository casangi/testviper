# TestVIPER
Automated Test Repository for the VIPER Ecosystem

[![Python 3.11 3.12 3.13](https://img.shields.io/badge/python-3.11%20%7C%203.12%20%7C%203.13-blue)](https://www.python.org/downloads/release/python-3130/)
[![Coverage](https://codecov.io/gh/casangi/testviper/branch/main/graph/badge.svg)](https://codecov.io/gh/casangi/testviper/branch/main/testviper)
[![Documentation Status](https://readthedocs.org/projects/testviper/badge/?version=latest)](https://testviper.readthedocs.io)
[![Version Status](https://img.shields.io/pypi/v/testviper.svg)](https://pypi.python.org/pypi/testviper/)


This repository is used to build and run integration tests for the VIPER Ecosystem.
It will install all components and run the available tests in the CI.
Proposed structure for this repository:
- tests
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

## Setup

1. Install PIXI:
```bash
curl -fsSL https://pixi.sh/install.sh | sh
export PATH=/user/../.pixi/bin:$PATH
```

2. Initialize the environment:
```bash
pixi install
```

3. Run tests:
```bash
pixi run pytest
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

## Stages
Test different stages of the components and use pipelines that test with multiple
supported versions of python for each of the stages.

Test integration branch
- Use pixi --environment integration to install the integration branch

Test release branch
- Use pixi --environment main to install the latest release

Test main branch
- Use pixi --environment main to build the main branch. Use for example:
  - xradio = { path = ".", editable = true }
  - toolviper = { path = "../toolviper", editable = true }
To Check: how to install the dependencies of toolviper and xradio


## CI/CD
A few things to try here.
- GitHub Datadog CI Visibility: for monitoring services
- Git Action Board
- Octolense.com
- Testspace.com

### Testspace
Free account. Unlimited for open-source; includes constraints for private usage.
Use the GitHub Marketplace to install Testspace - https://github.com/marketplace/testspace-com
Live demo: https://s2.testspace.com/spaces/145811/current/308836/automated%20tests/Code%20Coverage/_details

## Central Dashboard for VIPER Ecosystem Integration Tests

### What the Dashboard Should Show
- Test status per component (e.g., AstroVIPER, ToolVIPER, etc.)
- Latest test runs and build status
- Test trends over time (pass/fail rates, flakiness)
- Linked user stories or features
- Links to detailed test reports (e.g., Allure, HTML, logs)
- Metadata: commit ID, test duration, environment