# TestViper ReportPortal Integration Documentation

## Overview

This document describes the ReportPortal integration implementation in the TestViper ecosystem, designed to provide comprehensive test reporting and analytics for multi-component testing workflows.

## Current Implementation

### Architecture Components

1. **ReportPortal Service** (Docker-based)
   - Running at `http://localhost:8080`
   - Login: `superadmin` / `erebus`
   - Project: `testviper`

2. **Integration Script** (`dashboard/run_tests_with_reportportal.py`)
   - Main entry point for ReportPortal-enabled test execution
   - Handles multi-component testing scenarios
   - Auto-discovery of VIPER component source paths

3. **Custom Enhanced Reporter** (`dashboard/config/testviper_rp_reporter.py`)
   - TestViper-specific test tracking and analytics
   - Namespace protection with "TV" prefix
   - Detailed test metadata collection

4. **Analytics System** (`dashboard/analytics/`)
   - Advanced test analysis and metrics
   - Flaky test detection
   - Performance trend analysis

### Integration Layers

#### Layer 1: Native pytest-reportportal Plugin
- **Purpose**: Direct integration with ReportPortal API
- **Configuration**: Environment variables (RP_ENDPOINT, RP_PROJECT, RP_UUID, RP_LAUNCH)
- **Status**: ✅ Works for tests/integration, ❌ Fails for component tests (xradio/tests/unit)

#### Layer 2: Custom Enhanced Reporter (TestViper)
- **Purpose**: Supplementary analytics and local reporting
- **Activation**: Via conftest.py pytest hooks
- **Status**: ✅ Always works regardless of test location
- **Features**: 
  - Local session tracking
  - Test metadata enrichment
  - Failure log capture
  - Analytics report generation

## Current Issue Analysis

### Working Scenarios
- ✅ `tests/integration` - Both native ReportPortal and custom reporter work
- ✅ Direct pytest execution with proper ReportPortal config

### Failing Scenarios  
- ❌ `xradio/tests/unit` - Custom reporter works, native ReportPortal doesn't trigger
- ❌ Any component tests (`toolviper/tests`, `graphviper/tests`, etc.)

### Root Cause
When running component tests (e.g., `xradio/tests/unit`), pytest:
1. Uses the component's configuration (xradio/pyproject.toml)
2. Doesn't load testviper's conftest.py with ReportPortal hooks
3. Environment variables alone are insufficient to trigger pytest-reportportal plugin
4. Maybe (pytest.ini set rp_project to testviper, but other components need their specific projects). The same happens with env variables setting projects.

### Evidence from Logs
- Custom reporter logs show: "TestViper ReportPortal Enhanced Reporter initialized"
- Missing: Native pytest-reportportal plugin activation logs
- Result: Tests tracked locally but not sent to ReportPortal API

## Multi-Component Testing Design

### Architecture Goals
Support testing across multiple cloned component repositories:
- `xradio/` (cloned from casangi/xradio)
- `toolviper/` (cloned from casangi/toolviper)  
- `graphviper/` (cloned from casangi/graphviper)
- `astroviper/` (cloned from casangi/astroviper)

### Build Process
1. **Base dependencies**: `pip install -r requirements/base.txt`
2. **Component dependencies**: `make build-main` (clones and installs components)
3. **Test execution**: Any component tests should report to ReportPortal

### Smart Path Management
The integration script auto-discovers component source directories:
```python
viper_components = ["xradio", "toolviper", "graphviper", "astroviper"]
for component in viper_components:
    src_path = os.path.abspath(f"{component}/src")
    if os.path.exists(src_path):
        python_paths.append(src_path)
```

## Configuration Strategy

### Environment Variables (Current)
```bash
RP_ENDPOINT=http://localhost:8080
RP_PROJECT=testviper  
RP_API_KEY=<api_key>
RP_LAUNCH=<auto_generated_or_custom>
```

### pytest.ini (TestViper Root)
```ini
[pytest]
rp_endpoint = http://localhost:8080
rp_project = testviper
rp_launch = testviper_integration_tests
rp_launch_description = TestViper Integration Test Suite
rp_uuid = ${RP_API_KEY}
```

## Key Features Implemented

### 1. Smart Launch Naming
- Auto-generates component-specific launch names
- `xradio/tests` → `xradio_tests`
- `tests/integration` → `test_integration_tests`
- Custom names via `--launch-name` flag

### 2. Flexible Test Path Support
```bash
# Integration tests
python dashboard/run_tests_with_reportportal.py tests/integration

# Component tests  
python dashboard/run_tests_with_reportportal.py xradio/tests/unit
python dashboard/run_tests_with_reportportal.py toolviper/tests

# Custom launch names
python dashboard/run_tests_with_reportportal.py xradio/tests --launch-name "nightly_xradio"
```

### 3. Analytics and Reporting
- **Local Session Tracking**: Every test run generates session summaries
- **ReportPortal API Integration**: Fetches launch data for analytics
- **Flaky Test Detection**: Identifies tests with inconsistent results
- **Performance Metrics**: Test duration and trend analysis

### 4. Enhanced Test Metadata
Custom reporter adds rich metadata:
- `tv_test_file`: Full file path
- `tv_test_function`: Function name
- `tv_test_class`: Class name (if applicable)
- `tv_test_module`: Module name
- `tv_marker_*`: Pytest marker information

## Current Status Summary

### ✅ What Works
1. ReportPortal service integration
2. Custom analytics and reporting
3. Multi-component path discovery
4. Integration tests reporting
5. Local test session tracking
6. Enhanced metadata collection

### ❌ What Needs Fixing
1. Native pytest-reportportal plugin activation for component tests
2. Consistent ReportPortal launch creation across all test paths
3. Component test results appearing in ReportPortal dashboard

### 🔄 Current Workaround
The custom enhanced reporter provides comprehensive local analytics and test tracking, but component test results don't appear in the ReportPortal web dashboard for centralized viewing and team collaboration.

## Next Steps for Extension

### Priority 1: Fix Native ReportPortal Integration
- Ensure pytest-reportportal plugin triggers for component tests
- Investigate conftest.py loading and plugin activation
- Consider pytest hook modifications or configuration injection

### Priority 2: Dashboard Widgets
- Create component-specific dashboard widgets
- Set up filters for different test types
- Configure trend analysis and flaky test detection widgets

### Priority 3: CI/CD Integration
- Automate component test execution with ReportPortal reporting
- Set up launch aggregation for comprehensive test coverage
- Implement automated dashboard updates

## File Structure Reference

```
testviper/
├── pytest.ini                           # ReportPortal config for testviper
├── dashboard/
│   ├── run_tests_with_reportportal.py   # Main integration script
│   ├── config/
│   │   ├── conftest.py                  # pytest hooks for enhanced reporting
│   │   └── testviper_rp_reporter.py     # Custom reporter implementation
│   ├── analytics/                       # Analytics and metrics system
│   └── reports/                         # Generated reports and logs
├── xradio/                              # Component repository
│   ├── pyproject.toml                   # Component-specific config
│   └── tests/                           # Component tests
└── tests/integration/                   # TestViper integration tests
```

This documentation provides the foundation for understanding the current implementation and planning the next phase of development to achieve full ReportPortal integration across all component testing scenarios.