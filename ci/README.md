# CI Workflow for Allure Reports and Trend History

This document outlines the steps performed by the GitHub Actions workflow for integration testing, Allure report generation, and repository dispatch responsible for triggering the execution of tests on merges to component's main branches.

## Workflow Overview

A repository dispatch is implemented in TestVIPER to trigger the execution of integration tests everytime there is
a merge to the main branch of any of the VIPER components: ToolVIPER, XRADIO, GraphVIPER and AstroVIPER. 

The dispatch sender is implemented for all components in `toolviper/.github/workflows/python-testing-integration.yml`, which will send a dispatch on the event of a merge to main in one of the components, conditionally that the workflow with tests runs successfully in the component repository.

In TestVIPER, there is a workflow configured to receive the dispatch in `.github/workflows/dispatch-receiver.yml`, which
will trigger the execution of the integration tests and generation of Allure Reports as part of the workflow
defined in `.github/workflows/python-tests-allure-report.yml`.

A new version of the Allure Reports will be created in the gh-pages branch and deployed to `https://casangi.github.io/testviper/main/index.html`, preserving the previous history of the reports.

### Main Steps

1. **Listen for Dispatch Events**
   - Uses: `actions/github-script@v6` from `.github/workflows/dispatch-receiver.yml` to trigger the execution of tests.

1. **Checkout Repository**
   - Uses `actions/checkout` to clone the main repository.

2. **Set Up Python**
   - Installs Python 3.12 using `actions/setup-python`.

3. **Install Dependencies**
   - Runs `make build-testviper` to install dependencies for the main project.

4. **Clone Component Repositories**
   - Clones the latest versions of `toolviper`, `xradio`, `graphviper`, and `astroviper`.

5. **Install Component Dependencies**
   - Runs `make build-main` to install dependencies for all components.

6. **Install Allure CLI**
   - Downloads and installs the Allure command-line tool for report generation.

7. **Checkout gh-pages for History**
   - Checks out the `gh-pages` branch to access previous Allure history and reports.

8. **Restore Allure History for Each Component**
   - For each component (`testviper`, `toolviper`, `xradio`, `graphviper`, `astroviper`):
     - If previous history exists in `gh-pages/main/allure-history/<component>`, it is copied to `allure-results-<component>/history`.
     - This enables Allure to generate trend charts and preserve test history.

9. **Run Tests and Generate Allure Reports**
   - Executes `python scripts/enhanced_report_generator.py`:
     - Runs tests for each component.
     - Generates Allure results and HTML reports for each component.
     - Saves new history for each component to `allure-report/allure-history/<component>` for future runs.

10. **Generate Enhanced Summary Report**
    - Executes `python scripts/enhanced_summary_generator.py`:
      - Creates a summary dashboard with links to each component's Allure report and CodeCov badges.

11. **Upload Allure Reports**
    - Uses `actions/upload-artifact` to save the generated Allure reports as a workflow artifact.

12. **Deploy to gh-pages**
    - Uses `peaceiris/actions-gh-pages` to deploy the contents of `allure-report/` to the `gh-pages` branch under the `main` directory. The reports can be accessed from the https://casangi.github.io/testviper/ URL.
    - This makes the reports and history available for the next workflow run and for web viewing.

---

## Key Scripts

- **scripts/enhanced_report_generator.py**
  - Runs tests, generates Allure reports, and manages per-component history.
- **scripts/enhanced_summary_generator.py**
  - Generates a summary dashboard with test and coverage statistics.

---

## Testing Locally
Manual tests are recommended when making changes to the files in scripts, html template, etc.

Inside a Python virtual environment, install all dependencies and run some tests from tests/integration and then follow  these steps manually:

### Install dependencies
`pip install pytest allure-pytest coverage`

### Run enhanced report generation
`python scripts/enhanced_report_generator.py`

### Generate summary page
`python scripts/enhanced_summary_generator.py`

### View results in a browser
`open allure-report/index.html`

Or use the provided script in `scripts/tests/test_enhanced_report.py` after
installing base.txt from the requirements.
`python scripts/tests/test_enhanced_reports.py`

### View results in a browser
`open allure-report/index.html`


## Notes
- Allure trend charts require that each component's history is preserved and restored individually.
- The workflow ensures that history is copied for each component before report generation, and saved after.
- The summary dashboard provides links to individual reports and coverage information. 