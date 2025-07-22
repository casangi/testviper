# TestViper ReportPortal + Coverage Integration - Deployment Guide

This guide covers deploying the complete TestViper ReportPortal integration system with coverage tracking, analytics, and CI/CD integration.

## Table of Contents

1. [System Overview](#system-overview)
2. [Prerequisites](#prerequisites)
3. [Local Development Deployment](#local-development-deployment)
4. [Cloud/Production Deployment](#cloudproduction-deployment)
5. [Configuration](#configuration)
6. [Verification](#verification)
7. [Troubleshooting](#troubleshooting)

## System Overview

The TestViper ReportPortal integration provides:

- **Multi-component coverage tracking** (XRADIO, AstroViper, ToolViper, GraphViper)
- **ReportPortal test result reporting** with coverage attributes
- **Advanced analytics** with trend analysis and regression detection
- **CI/CD integration** with GitHub Actions
- **Dual reporting** support (local + cloud ReportPortal instances)
- **Threshold enforcement** with configurable quality gates

### Architecture Components

```
TestViper System
├── Core Components
│   ├── dashboard/run_tests_with_reportportal.py      # Main test runner
│   ├── dashboard/config/testviper_rp_reporter.py     # ReportPortal reporter
│   └── dashboard/analytics/                          # Analytics system
├── Coverage Tools
│   ├── dashboard/coverage_threshold_checker.py       # Threshold enforcement
│   ├── dashboard/coverage_regression_detector.py     # Regression detection
│   └── dashboard/analytics/coverage_analytics.py     # Coverage analytics
├── Dual Reporting
│   ├── dashboard/dual_reporting_config.py           # Configuration manager
│   └── dashboard/dual_reporting_runner.py           # Multi-instance runner
└── CI/CD
    └── .github/workflows/python-test-reportportal.yml # GitHub Actions
```

## Prerequisites

### Software Requirements

- **Python 3.10+** with pip
- **ReportPortal instance** (local or cloud)
- **Git** for version control
- **Docker** (optional, for local ReportPortal)

### Python Dependencies

```bash
# Core dependencies
pip install pytest pytest-cov pytest-reportportal python-dotenv requests

# Component-specific dependencies
pip install -r requirements/base.txt
```

### ReportPortal Setup

#### Option 1: Local ReportPortal (Docker)

```bash
# Clone ReportPortal docker setup
git clone https://github.com/reportportal/reportportal.git
cd reportportal

# Start ReportPortal services
docker-compose up -d

# Access ReportPortal at http://localhost:8080
# Default credentials: superadmin/erebus
```

#### Option 2: Cloud ReportPortal

Contact your ReportPortal administrator for:
- Endpoint URL
- Project name
- API token

## Local Development Deployment

### 1. Clone and Setup

```bash
# Clone the repository
git clone <repository-url>
cd testviper

# Create virtual environment
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate

# Install dependencies
pip install -r requirements/base.txt
pip install pytest-cov pytest-reportportal python-dotenv requests
```

### 2. Environment Configuration

Create `.env` file in the project root:

```bash
# ReportPortal Configuration
RP_ENDPOINT=http://localhost:8080
RP_PROJECT=testviper
RP_API_KEY=your-api-key-here

# Optional: Cloud ReportPortal
RP_CLOUD_ENDPOINT=https://your-cloud-reportportal.com
RP_CLOUD_PROJECT=testviper-cloud
RP_CLOUD_API_KEY=your-cloud-api-key
RP_CLOUD_ENABLED=false

# Component Configuration
TV_COMPONENT_NAME=auto  # auto-detect or specify: xradio, astroviper, etc.
TV_ENABLE_COVERAGE=true
```

### 3. Initialize Configuration

```bash
# Create dual reporting configuration
python dashboard/dual_reporting_config.py --create-sample

# Create coverage threshold configuration
python dashboard/coverage_threshold_checker.py --create-config

# Verify configuration
python dashboard/dual_reporting_config.py --show
```

### 4. Build Components

```bash
# Build all components
make build-main

# Or build specific components
make build-xradio
make build-astroviper
```

### 5. Test the Setup

```bash
# Run a quick test
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py --check-only

# Run integration tests
python dashboard/run_tests_with_reportportal.py tests/integration
```

## Cloud/Production Deployment

### 1. GitHub Repository Setup

#### Environment Variables

Configure in GitHub repository settings → Secrets and variables:

**Secrets:**
```
RP_TOKEN=your-reportportal-api-key
RP_CLOUD_TOKEN=your-cloud-reportportal-api-key
```

**Variables:**
```
RP_ENDPOINT=https://your-reportportal-instance.com
RP_PROJECT=testviper
RP_CLOUD_ENDPOINT=https://cloud-reportportal.com
RP_CLOUD_PROJECT=testviper-cloud
ENFORCE_COVERAGE_THRESHOLDS=true
```

### 2. GitHub Actions Workflow

The workflow is already configured in `.github/workflows/python-test-reportportal.yml`.

Features:
- **Matrix testing** across all components
- **Coverage collection** with threshold enforcement
- **Regression detection** with trend analysis
- **PR comments** with coverage summaries
- **Artifact preservation** for historical analysis

### 3. Cloud ReportPortal Configuration

#### Update Dual Reporting Config

```bash
# Edit the configuration
vim dashboard/config/dual_reporting_config.json

# Enable cloud reporting
{
  "reportportal_instances": {
    "cloud": {
      "enabled": true,
      "endpoint": "https://your-cloud-reportportal.com",
      "project": "testviper-prod",
      "api_key": "${RP_CLOUD_TOKEN}",
      "priority": 2
    }
  }
}
```

#### Test Cloud Connection

```bash
# Test cloud connection
python dashboard/dual_reporting_config.py --test
```

### 4. CI/CD Pipeline Configuration

#### Workflow Triggers

- **Push** to any branch
- **Pull request** to any branch
- **Manual dispatch** with component selection

#### Component Matrix

The workflow automatically tests:
- XRADIO components
- AstroViper components
- ToolViper components
- GraphViper components
- Integration tests

#### Coverage Thresholds

Configure in `dashboard/coverage_threshold_checker.py`:

```python
DEFAULT_THRESHOLDS = {
    "xradio": 70.0,           # XRADIO should have high coverage
    "astroviper": 65.0,       # AstroViper needs good coverage  
    "toolviper": 60.0,        # ToolViper moderate coverage
    "graphviper": 60.0,       # GraphViper moderate coverage
    "testviper_integration": 50.0,  # Integration tests baseline
    "testviper_misc": 30.0,   # Misc tests lower threshold
    "overall": 60.0           # Overall project threshold
}
```

## Configuration

### 1. ReportPortal Configuration

#### Single Instance (Local)

```bash
# Edit .env file
RP_ENDPOINT=http://localhost:8080
RP_PROJECT=testviper
RP_API_KEY=your-api-key
```

#### Dual Instance (Local + Cloud)

```bash
# Configure dual reporting
python dashboard/dual_reporting_config.py --create-sample

# Edit dashboard/config/dual_reporting_config.json
{
  "reportportal_instances": {
    "local": {
      "enabled": true,
      "endpoint": "http://localhost:8080",
      "project": "testviper",
      "api_key": "local-api-key",
      "priority": 1
    },
    "cloud": {
      "enabled": true,
      "endpoint": "https://cloud-reportportal.com",
      "project": "testviper-cloud",
      "api_key": "cloud-api-key",
      "priority": 2
    }
  }
}
```

### 2. Coverage Thresholds

```bash
# Create threshold configuration
python dashboard/coverage_threshold_checker.py --create-config

# Edit coverage_thresholds.json
{
  "thresholds": {
    "xradio": 70.0,
    "astroviper": 65.0,
    "overall": 60.0
  }
}
```

### 3. Component Detection

The system automatically detects components based on test paths:

- `xradio/tests/` → xradio component
- `astroviper/tests/` → astroviper component
- `tests/integration/` → integration tests
- Other paths → misc tests

Override with environment variable:
```bash
export TV_COMPONENT_NAME=xradio
```

### 4. Coverage Settings

```bash
# Enable/disable coverage
export TV_ENABLE_COVERAGE=true

# Custom coverage source directory
export TV_COVERAGE_SOURCE=custom/src/directory
```

## Verification

### 1. Test Local Setup

```bash
# Check environment
python dashboard/run_tests_with_reportportal.py --check-only

# Run basic tests
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py

# Check ReportPortal UI
open http://localhost:8080
```

### 2. Test Dual Reporting

```bash
# Test dual reporting
python dashboard/dual_reporting_runner.py tests/integration/test_basic_xradio.py

# Check both ReportPortal instances
```

### 3. Test Coverage Analytics

```bash
# Generate coverage report
python dashboard/analytics/coverage_analytics.py --generate-report

# Check threshold enforcement
python dashboard/coverage_threshold_checker.py

# Test regression detection
python dashboard/coverage_regression_detector.py
```

### 4. Test CI/CD Integration

```bash
# Push to test branch
git checkout -b test-deployment
git push origin test-deployment

# Create PR and check:
# - GitHub Actions workflow runs
# - Coverage reports generated
# - PR comments with coverage summary
# - ReportPortal launches created
```

## Troubleshooting

### Common Issues

#### 1. ReportPortal Connection Failed

```bash
# Check connection
python dashboard/dual_reporting_config.py --test

# Common causes:
# - Wrong endpoint URL
# - Invalid API key
# - Network connectivity issues
# - ReportPortal service down
```

#### 2. Coverage Not Collected

```bash
# Check source directories
ls -la */src/

# Verify component detection
python -c "
from dashboard.run_tests_with_reportportal import determine_component_name
print(determine_component_name('xradio/tests/unit'))
"

# Check coverage files
ls -la coverage_*.json
```

#### 3. Tests Not Appearing in ReportPortal

```bash
# Check pytest-reportportal plugin
pip list | grep reportportal

# Verify environment variables
env | grep RP_

# Check launch names
python dashboard/run_tests_with_reportportal.py --help
```

#### 4. GitHub Actions Failing

```bash
# Check workflow file
cat .github/workflows/python-test-reportportal.yml

# Verify secrets and variables in GitHub
# Check workflow logs for specific errors
```

### Debug Commands

```bash
# Test ReportPortal client
python -c "
from dashboard.analytics.rp_client import TVReportPortalClient
client = TVReportPortalClient()
print(client.test_connection())
"

# Check configuration
python dashboard/dual_reporting_config.py --show --validate

# Generate analytics report
python dashboard/analytics/simple_report_generator.py
```

### Log Locations

- **Test logs**: Console output during test runs
- **Coverage reports**: `coverage_*.json` files
- **Analytics reports**: `dashboard/reports/tv_json/`
- **GitHub Actions logs**: Available in GitHub Actions UI

### Getting Help

1. **Check system status**:
   ```bash
   python dashboard/run_tests_with_reportportal.py --check-only
   ```

2. **Validate configuration**:
   ```bash
   python dashboard/dual_reporting_config.py --validate
   ```

3. **Test individual components**:
   ```bash
   python dashboard/coverage_threshold_checker.py --help
   python dashboard/coverage_regression_detector.py --help
   ```

4. **Check component source**:
   Review the implementation files in `dashboard/` for detailed understanding.

## Next Steps

After successful deployment:

1. **Monitor coverage trends** using the analytics dashboard
2. **Adjust thresholds** based on project needs
3. **Set up alerts** for coverage regressions
4. **Train team** on using the ReportPortal dashboard
5. **Regular maintenance** of the system (see MAINTENANCE_GUIDE.md)

For detailed usage instructions, see [USAGE_GUIDE.md](USAGE_GUIDE.md).
For maintenance procedures, see [MAINTENANCE_GUIDE.md](MAINTENANCE_GUIDE.md).