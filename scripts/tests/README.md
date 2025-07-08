# Local Testing Guide

This guide explains how to test the TestViper workflow locally before pushing to GitHub.

## Prerequisites

1. **Python 3.12** with pip
2. **Dependencies installed**:
   ```bash
   pip install -r requirements/base.txt
   pip install -r requirements/main.txt
   ```
3. **Allure CLI** (optional, for full report generation):
   ```bash
   # macOS
   brew install allure
   
   # Linux
   wget -qO- https://github.com/allure-framework/allure2/releases/download/2.24.1/allure-2.24.1.tgz | tar -xz
   sudo mv allure-2.24.1 /opt/allure
   sudo ln -s /opt/allure/bin/allure /usr/local/bin/allure
   ```

## Testing Options

### 1. Quick Summary Test (Recommended)
Tests just the summary page generation with mock data:
```bash
./test_summary_only.sh
```

**What it does:**
- Creates mock test results and coverage data
- Generates the summary HTML page
- Shows test statistics
- Takes ~5 seconds to run

### 2. Full Workflow Test
Runs the complete test suite and generates all reports:
```bash
./test_local.sh
```

**What it does:**
- Runs all component tests (integration, toolviper, xradio, graphviper, astroviper)
- Generates coverage reports
- Creates individual Allure reports for each component
- Generates the summary landing page
- Takes several minutes to run

## Viewing Results

After running either test, you can view the results by:

1. **Direct file access:**
   ```bash
   open main/index.html
   ```

2. **Local web server:**
   ```bash
   python -m http.server 8000
   # Then go to: http://localhost:8000/main/
   ```

## Generated Structure

```
main/
├── index.html              # Summary landing page
├── testviper/index.html    # Integration tests report
├── toolviper/index.html    # ToolViper tests report
├── xradio/index.html       # XRadio tests report
├── graphviper/index.html   # GraphViper tests report
└── astroviper/index.html   # AstroViper tests report

coverage/
├── coverage-*.xml          # Coverage XML reports
├── coverage-*.json         # Coverage JSON reports
└── htmlcov-*/              # HTML coverage reports
```

## Troubleshooting

### Common Issues

1. **Missing dependencies:**
   ```bash
   pip install -r requirements/base.txt
   pip install -r requirements/main.txt
   ```

2. **Component repositories not found:**
   The components will be automatically cloned if not present, or you can clone them manually:
   ```bash
   git clone https://github.com/casangi/toolviper.git
   git clone https://github.com/casangi/xradio.git
   git clone https://github.com/casangi/graphviper.git
   git clone https://github.com/casangi/astroviper.git
   ```

3. **Allure CLI not found:**
   Install Allure CLI or skip the full report generation (summary page will still work).

### Testing Individual Components

You can also test individual components:

```bash
# Test just integration tests
pytest -v tests/integration --alluredir=allure-results/integration

# Test just one component
pytest -v toolviper/tests/ --alluredir=allure-results/toolviper --cov=toolviper

# Generate summary page after any test run
python scripts/generate_summary_page.py
```

## Continuous Integration

The local tests simulate the GitHub Actions workflow defined in:
- `.github/workflows/test-integration-allure-branch.yml`

The workflow will:
1. Run all the same tests
2. Generate reports with history preservation
3. Deploy to `gh-pages-staging` branch
4. Create status checks

## Files Created

- `test_local.sh` - Full workflow test
- `test_summary_only.sh` - Quick summary test
- `scripts/generate_allure_summary_page.py` - Summary page generator
- `.github/workflows/test-integration-allure-branch.yml` - CI workflow
