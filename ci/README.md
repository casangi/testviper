# CI Workflow for Allure Reports and ReportPortal Integration

This document outlines the steps performed by the GitHub Actions workflow for integration testing, Allure report generation, ReportPortal integration, and trend history preservation in this repository.

## 🚀 ReportPortal Integration in CI

The CI workflow has been enhanced to support ReportPortal integration alongside traditional Allure reporting:

### ReportPortal CI Features
- **Automated Launch Creation**: Each CI run creates organized launches in ReportPortal
- **Component-Specific Tracking**: Individual launches for each VIPER component
- **Coverage Integration**: Automatic coverage metrics injection
- **Historical Trending**: Long-term test result analysis

### ReportPortal CI Configuration
```yaml
# Example GitHub Actions integration
- name: Run Tests with ReportPortal
  run: |
    python dashboard/run_tests_with_reportportal.py --launch-name "ci-build-${{ github.run_number }}"
  env:
    RP_ENDPOINT: ${{ secrets.RP_ENDPOINT }}
    RP_PROJECT: ${{ secrets.RP_PROJECT }}
    RP_API_KEY: ${{ secrets.RP_API_KEY }}
```

## Workflow Overview

The workflow is defined in `.github/workflows/python-tests-allure-report.yml` and is triggered on every push and pull request.

### Main Steps

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

7. **Checkout gh-pages-staging for History**
   - Checks out the `gh-pages-staging` branch to access previous Allure history and reports.

8. **Restore Allure History for Each Component**
   - For each component (`testviper`, `toolviper`, `xradio`, `graphviper`, `astroviper`):
     - If previous history exists in `gh-pages-staging/main/allure-history/<component>`, it is copied to `allure-results-<component>/history`.
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

12. **Deploy to gh-pages-staging**
    - Uses `peaceiris/actions-gh-pages` to deploy the contents of `allure-report/` to the `gh-pages-staging` branch under the `main` directory.
    - This makes the reports and history available for the next workflow run and for web viewing.

---

## Key Scripts

- **scripts/enhanced_report_generator.py**
  - Runs tests, generates Allure reports, and manages per-component history.
- **scripts/enhanced_summary_generator.py**
  - Generates a summary dashboard with test and coverage statistics.

---

## Notes
- Allure trend charts require that each component's history is preserved and restored individually.
- The workflow ensures that history is copied for each component before report generation, and saved after.
- The summary dashboard provides links to individual reports and coverage information. 