# GitHub Workflows Overview

This folder contains the active CI/CD automation for `testviper`.  
This page summarizes each workflow's scope and when it executes.

## Active workflows

| Workflow | File | Scope | Executes when |
|---|---|---|---|
| Integration Tests with Allure Report | `python-tests-allure-report.yml` | Runs integration tests, generates Allure reports/summary, uploads artifacts, and deploys history/report content to `gh-pages`. | - Push to `main` (except docs-only changes via `paths-ignore` for `**.md`/`**.rst`)  <br> - Manual run (`workflow_dispatch`) |
| Integration Tests on Branch - Linux | `integration_tests_linux.yml` | Runs Linux integration tests (Python 3.13), gathers test outputs, and uploads artifacts for branch/PR validation. | - Push to non-`main` branches (except docs-only changes via `paths-ignore`)  <br> - Pull requests (`pull_request`) |
| Bake CI Dashboard | `bake-dashboard.yml` | Builds and bakes the CI dashboard, validates generated output, and publishes dashboard assets to `gh-pages` under `ci/`. | - Repository dispatch event type `integration-test-trigger`  <br> - Push to `main`  <br> - Scheduled cron (`0 * * * *`, hourly)  <br> - Manual run (`workflow_dispatch`) |
| Dispatch Receiver - Integration Test Trigger | `dispatch-receiver.yml` | Receives cross-repo dispatch events, triggers `python-tests-allure-report.yml` via workflow dispatch, and posts a pending commit status back to the source repo. | - Repository dispatch event type `integration-test-trigger` |

## Trigger flow notes

- External repos can send `repository_dispatch` (`integration-test-trigger`) events to this repository.
- `dispatch-receiver.yml` uses that event to start `python-tests-allure-report.yml` with source metadata.
- `bake-dashboard.yml` also listens to the same dispatch event to refresh the pre-baked dashboard state.
- Dashboard deploy target is `gh-pages/ci`, while Allure content is deployed under `gh-pages/main`, reducing publish-path conflicts.
