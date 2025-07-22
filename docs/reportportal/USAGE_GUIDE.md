# TestViper ReportPortal + Coverage Integration - Usage Guide

This guide covers how to run tests, configure parameters, and use all features of the TestViper ReportPortal integration system.

## Table of Contents

1. [Quick Start](#quick-start)
2. [Basic Test Execution](#basic-test-execution)
3. [Advanced Features](#advanced-features)
4. [Configuration Parameters](#configuration-parameters)
5. [Analytics and Reporting](#analytics-and-reporting)
6. [CI/CD Integration](#cicd-integration)
7. [Troubleshooting](#troubleshooting)

## Quick Start

### Run Integration Tests

```bash
# Basic integration test run
python dashboard/run_tests_with_reportportal.py tests/integration

# Run with custom launch name
python dashboard/run_tests_with_reportportal.py tests/integration --launch-name "my_custom_tests"

# Run without coverage (faster)
python dashboard/run_tests_with_reportportal.py tests/integration --no-coverage
```

### Run Component Tests

```bash
# XRADIO tests
python dashboard/run_tests_with_reportportal.py xradio/tests

# AstroViper tests  
python dashboard/run_tests_with_reportportal.py astroviper/tests

# Specific test file
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py
```

### Check System Status

```bash
# Verify ReportPortal connection and environment
python dashboard/run_tests_with_reportportal.py --check-only

# Show dual reporting configuration
python dashboard/dual_reporting_config.py --show
```

## Basic Test Execution

### Main Test Runner

The primary tool is `dashboard/run_tests_with_reportportal.py`:

```bash
python dashboard/run_tests_with_reportportal.py [TEST_PATH] [OPTIONS]
```

#### Basic Usage Examples

```bash
# Run all integration tests
python dashboard/run_tests_with_reportportal.py tests/integration

# Run specific component tests
python dashboard/run_tests_with_reportportal.py xradio/tests/unit

# Run with custom launch name
python dashboard/run_tests_with_reportportal.py tests/integration --launch-name "nightly_regression"

# Run without coverage tracking
python dashboard/run_tests_with_reportportal.py tests/integration --no-coverage

# Run with additional pytest arguments
python dashboard/run_tests_with_reportportal.py tests/integration --pytest-args "--maxfail=5" "-v"
```

#### Command Line Options

| Option | Description | Example |
|--------|-------------|---------|
| `TEST_PATH` | Path to tests to run | `tests/integration` |
| `--test-path` | Alternative way to specify test path | `--test-path tests/unit` |
| `--launch-name` | Custom launch name | `--launch-name "my_tests"` |
| `--no-coverage` | Disable coverage tracking | `--no-coverage` |
| `--pytest-args` | Additional pytest arguments | `--pytest-args "--maxfail=5"` |
| `--check-only` | Only check environment and connection | `--check-only` |
| `--analytics-only` | Only generate analytics report | `--analytics-only` |
| `--skip-analytics` | Skip analytics generation | `--skip-analytics` |

### Component Detection

The system automatically detects components based on test paths:

```bash
# These automatically set component to 'xradio'
python dashboard/run_tests_with_reportportal.py xradio/tests
python dashboard/run_tests_with_reportportal.py xradio/tests/unit
python dashboard/run_tests_with_reportportal.py xradio/tests/integration

# These automatically set component to 'astroviper'
python dashboard/run_tests_with_reportportal.py astroviper/tests
python dashboard/run_tests_with_reportportal.py astroviper/tests/unit

# This sets component to 'testviper_integration'
python dashboard/run_tests_with_reportportal.py tests/integration

# Override component detection
export TV_COMPONENT_NAME=xradio
python dashboard/run_tests_with_reportportal.py tests/custom
```

### Coverage Configuration

#### Enable/Disable Coverage

```bash
# Enable coverage (default)
python dashboard/run_tests_with_reportportal.py tests/integration

# Disable coverage
python dashboard/run_tests_with_reportportal.py tests/integration --no-coverage

# Environment variable
export TV_ENABLE_COVERAGE=false
```

#### Coverage Source Directories

The system automatically determines source directories:

- `xradio` → `xradio/src/`
- `astroviper` → `astroviper/src/`
- `toolviper` → `toolviper/src/`
- `graphviper` → `graphviper/src/`
- `testviper_integration` → `src/`
- `testviper_misc` → No coverage (no source)

## Advanced Features

### Dual Reporting

Run tests against multiple ReportPortal instances:

```bash
# Configure dual reporting
python dashboard/dual_reporting_config.py --create-sample

# Run tests with dual reporting
python dashboard/dual_reporting_runner.py tests/integration

# Run sequentially (safer for limited resources)
python dashboard/dual_reporting_runner.py tests/integration --sequential

# Run with custom launch name
python dashboard/dual_reporting_runner.py xradio/tests --launch-name "xradio_ci"
```

#### Dual Reporting Options

| Option | Description | Example |
|--------|-------------|---------|
| `TEST_PATH` | Path to tests | `tests/integration` |
| `--config` | Configuration file | `--config custom_config.json` |
| `--launch-name` | Custom launch name | `--launch-name "custom_tests"` |
| `--no-coverage` | Disable coverage | `--no-coverage` |
| `--sequential` | Run sequentially | `--sequential` |
| `--max-workers` | Max parallel workers | `--max-workers 5` |
| `--show-config` | Show configuration | `--show-config` |
| `--output` | Output file | `--output results.json` |

### Coverage Analytics

#### Generate Coverage Reports

```bash
# Generate coverage analytics
python dashboard/analytics/coverage_analytics.py --generate-report

# Generate with custom date range
python dashboard/analytics/coverage_analytics.py --generate-report --days-back 14

# Save report to specific file
python dashboard/analytics/coverage_analytics.py --generate-report --output my_report.json
```

#### Coverage Threshold Checking

```bash
# Check coverage thresholds
python dashboard/coverage_threshold_checker.py

# Check with custom configuration
python dashboard/coverage_threshold_checker.py --config custom_thresholds.json

# Check specific directory
python dashboard/coverage_threshold_checker.py --dir build/

# Strict mode (warnings also fail)
python dashboard/coverage_threshold_checker.py --strict

# Create default configuration
python dashboard/coverage_threshold_checker.py --create-config
```

#### Coverage Regression Detection

```bash
# Detect coverage regressions
python dashboard/coverage_regression_detector.py

# Analyze last 14 days
python dashboard/coverage_regression_detector.py --days 14

# Alert mode (for CI)
python dashboard/coverage_regression_detector.py --alert-only

# Custom reports directory
python dashboard/coverage_regression_detector.py --reports-dir custom/reports
```

### Batch Testing

#### Test Multiple Components

```bash
# Test all components sequentially
for component in xradio astroviper toolviper graphviper; do
    if [ -d "$component/tests" ]; then
        echo "Testing $component..."
        python dashboard/run_tests_with_reportportal.py "$component/tests" --launch-name "${component}_batch"
    fi
done

# Test with integration tests
python dashboard/run_tests_with_reportportal.py tests/integration --launch-name "integration_batch"
```

#### Parallel Component Testing

```bash
# Using dual reporting for parallel execution
python dashboard/dual_reporting_runner.py tests/integration --max-workers 4
```

## Configuration Parameters

### Environment Variables

#### ReportPortal Configuration

```bash
# Primary ReportPortal instance
export RP_ENDPOINT=http://localhost:8080
export RP_PROJECT=testviper
export RP_API_KEY=your-api-key

# Cloud ReportPortal instance
export RP_CLOUD_ENDPOINT=https://cloud-reportportal.com
export RP_CLOUD_PROJECT=testviper-cloud
export RP_CLOUD_API_KEY=your-cloud-api-key
export RP_CLOUD_ENABLED=true

# Alternative API key name
export RP_UUID=your-api-key  # Same as RP_API_KEY
```

#### TestViper Configuration

```bash
# Component override
export TV_COMPONENT_NAME=xradio

# Coverage settings
export TV_ENABLE_COVERAGE=true
export TV_COVERAGE_FILE=coverage_custom.json

# Launch customization
export TV_LAUNCH_NAME=custom_launch
export TV_LAUNCH_DESCRIPTION="Custom test description"
```

### Configuration Files

#### Dual Reporting Configuration

Edit `dashboard/config/dual_reporting_config.json`:

```json
{
  "reportportal_instances": {
    "local": {
      "name": "local",
      "endpoint": "http://localhost:8080",
      "project": "testviper",
      "api_key": "local-api-key",
      "enabled": true,
      "priority": 1,
      "launch_attributes": {
        "environment": "local",
        "team": "development"
      }
    },
    "cloud": {
      "name": "cloud",
      "endpoint": "https://cloud-reportportal.com",
      "project": "testviper-cloud",
      "api_key": "cloud-api-key",
      "enabled": true,
      "priority": 2,
      "launch_attributes": {
        "environment": "cloud",
        "team": "ci"
      }
    }
  }
}
```

#### Coverage Thresholds Configuration

Edit `coverage_thresholds.json`:

```json
{
  "thresholds": {
    "xradio": 70.0,
    "astroviper": 65.0,
    "toolviper": 60.0,
    "graphviper": 60.0,
    "testviper_integration": 50.0,
    "testviper_misc": 30.0,
    "overall": 60.0
  }
}
```

### Component-Specific Settings

#### XRADIO Configuration

```bash
# Run XRADIO tests with specific settings
export TV_COMPONENT_NAME=xradio
export TV_COVERAGE_SOURCE=xradio/src
python dashboard/run_tests_with_reportportal.py xradio/tests --launch-name "xradio_comprehensive"
```

#### AstroViper Configuration

```bash
# Run AstroViper tests
export TV_COMPONENT_NAME=astroviper
python dashboard/run_tests_with_reportportal.py astroviper/tests --launch-name "astroviper_tests"
```

#### Integration Tests Configuration

```bash
# Run integration tests with specific coverage
export TV_COMPONENT_NAME=testviper_integration
export TV_COVERAGE_SOURCE=src
python dashboard/run_tests_with_reportportal.py tests/integration --launch-name "integration_comprehensive"
```

## Analytics and Reporting

### Available Reports

#### 1. Coverage Analytics Report

```bash
# Generate comprehensive coverage report
python dashboard/analytics/coverage_analytics.py --generate-report

# Sample output structure:
# {
#   "metadata": {
#     "generated_at": "2025-01-14T10:00:00",
#     "total_launches_analyzed": 25
#   },
#   "summary": {
#     "components": {
#       "xradio": {
#         "avg_coverage": 81.0,
#         "trend": "improving",
#         "quality_distribution": {"high": 8, "good": 2}
#       }
#     }
#   }
# }
```

#### 2. Threshold Enforcement Report

```bash
# Check thresholds and generate report
python dashboard/coverage_threshold_checker.py

# Sample output:
# ✅ OVERALL RESULT: PASS
# 📈 Average Coverage: 75.5% (threshold: 60.0%)
# 📊 COMPONENT BREAKDOWN:
# xradio        | 81.0% | 70.0% | ✅ PASS | 🌟 excellent
# astroviper    | 70.0% | 65.0% | ✅ PASS | 🟢 good
```

#### 3. Regression Detection Report

```bash
# Detect coverage regressions
python dashboard/coverage_regression_detector.py

# Sample output:
# 🚨 COVERAGE REGRESSION DETECTION REPORT
# ✅ No coverage regressions detected!
# 📈 COMPONENT TREND SUMMARY:
# xradio        | 81.0% | 📈 improving | 🟢 Low | ✅ Good
```

### Report Files

All reports are saved in `dashboard/reports/tv_json/`:

- `tv_coverage_analytics_report_*.json` - Coverage analytics
- `tv_threshold_report_*.json` - Threshold check results
- `tv_regression_report_*.json` - Regression detection results
- `tv_analytics_report_*.json` - General analytics summary
- `tv_session_summary_*.json` - Test session summaries

### Viewing Reports

#### Command Line

```bash
# View latest coverage report
python -c "
import json, glob
files = glob.glob('dashboard/reports/tv_json/tv_coverage_analytics_report_*.json')
if files:
    with open(max(files), 'r') as f:
        data = json.load(f)
        print(json.dumps(data, indent=2))
"
```

#### Web Dashboard

```bash
# Generate HTML reports (if available)
python dashboard/analytics/simple_report_generator.py --html

# Open in browser
open dashboard/reports/tv_html/latest_report.html
```

### Automated Reporting

#### Schedule Regular Reports

```bash
# Add to crontab for daily reports
crontab -e

# Add line:
0 9 * * * cd /path/to/testviper && python dashboard/analytics/coverage_analytics.py --generate-report
```

#### Integration with CI/CD

The GitHub Actions workflow automatically generates reports:

- **On every push**: Coverage analytics
- **On pull requests**: Threshold checks and regression detection
- **Scheduled runs**: Weekly comprehensive reports

## CI/CD Integration

### GitHub Actions Workflow

The workflow in `.github/workflows/python-test-reportportal.yml` provides:

#### Manual Trigger

```bash
# Go to GitHub Actions tab
# Click "Run workflow"
# Select component: all, xradio, astroviper, toolviper, graphviper, integration
```

#### Workflow Features

1. **Matrix Testing**: Tests all components in parallel
2. **Coverage Collection**: Generates coverage reports for each component
3. **Threshold Enforcement**: Checks coverage thresholds
4. **Regression Detection**: Identifies coverage drops
5. **PR Comments**: Adds coverage summary to pull requests
6. **Artifact Preservation**: Saves reports for historical analysis

#### Workflow Configuration

Environment variables in GitHub repository settings:

```bash
# Repository secrets
RP_TOKEN=your-reportportal-api-key

# Repository variables
RP_ENDPOINT=https://your-reportportal.com
RP_PROJECT=testviper
ENFORCE_COVERAGE_THRESHOLDS=true
```

### Local CI Simulation

```bash
# Simulate CI workflow locally
python dashboard/run_tests_with_reportportal.py tests/integration --launch-name "CI_integration_tests_local"

# Run threshold checks
python dashboard/coverage_threshold_checker.py

# Run regression detection
python dashboard/coverage_regression_detector.py --days 7
```

## Troubleshooting

### Common Issues and Solutions

#### 1. No Coverage Data

```bash
# Check if source directories exist
ls -la */src/

# Verify component detection
python -c "
from dashboard.run_tests_with_reportportal import determine_component_name
print(determine_component_name('xradio/tests/unit'))
"

# Check coverage files
ls -la coverage_*.json
```

#### 2. ReportPortal Connection Issues

```bash
# Test connection
python dashboard/dual_reporting_config.py --test

# Check environment variables
env | grep RP_

# Verify API key
curl -H "Authorization: Bearer $RP_API_KEY" "$RP_ENDPOINT/api/v1/project/$RP_PROJECT"
```

#### 3. Launch Not Appearing

```bash
# Check launch name generation
python -c "
from dashboard.run_tests_with_reportportal import generate_launch_name
print(generate_launch_name('xradio/tests'))
"

# Verify pytest-reportportal is working
python -m pytest --help | grep reportportal
```

#### 4. Coverage Thresholds Not Working

```bash
# Check threshold configuration
python dashboard/coverage_threshold_checker.py --create-config
cat coverage_thresholds.json

# Test threshold checking
python dashboard/coverage_threshold_checker.py --dir . --output test_threshold.json
```

### Debug Commands

```bash
# Enable debug logging
export PYTHONPATH="$PYTHONPATH:$(pwd)/dashboard"
export TV_DEBUG=true

# Test individual components
python dashboard/analytics/rp_client.py  # Test ReportPortal client
python dashboard/coverage_threshold_checker.py --help
python dashboard/coverage_regression_detector.py --help
```

### Getting Help

1. **Check system status**: `python dashboard/run_tests_with_reportportal.py --check-only`
2. **Validate configuration**: `python dashboard/dual_reporting_config.py --validate`
3. **Review logs**: Check console output during test runs
4. **Consult documentation**: See `DEPLOYMENT_GUIDE.md` and `MAINTENANCE_GUIDE.md`

## Best Practices

### Test Execution

1. **Use descriptive launch names**: `--launch-name "feature_xyz_validation"`
2. **Run coverage regularly**: Don't skip coverage unless necessary
3. **Monitor trends**: Use analytics to track coverage over time
4. **Component isolation**: Test components separately when debugging

### Configuration Management

1. **Use environment variables**: For sensitive data like API keys
2. **Version control configuration**: Track changes to threshold configs
3. **Document customizations**: Keep notes on non-standard settings
4. **Regular validation**: Run configuration checks periodically

### CI/CD Integration

1. **Set appropriate thresholds**: Balance quality with practicality
2. **Monitor regression alerts**: Address coverage drops promptly
3. **Use PR comments**: Leverage automated coverage feedback
4. **Preserve artifacts**: Keep historical reports for trend analysis

For deployment instructions, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md).
For maintenance procedures, see [MAINTENANCE_GUIDE.md](MAINTENANCE_GUIDE.md).