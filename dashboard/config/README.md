# TestViper ReportPortal Configuration

This directory contains the configuration files for TestViper's ReportPortal dashboard integration.

## Files

### Core Configuration
- `testviper_rp_reporter.py` - Enhanced reporting module with namespace protection
- `conftest.py` - pytest configuration and fixtures for ReportPortal integration
- `pytest_dashboard.ini` - pytest configuration file for dashboard tests
- `__init__.py` - Package initialization file

### Setup

Before running tests, you need to set up the environment:

1. **Install python-casacore** (required for xradio on macOS):
   ```bash
   conda install -c conda-forge python-casacore
   ```

2. **Install requirements**:
   ```bash
   pip install -r requirements/base.txt
   ```

3. **Build components**:
   ```bash
   make build-main
   ```

4. **Ensure ReportPortal is running**:
   ```bash
   cd dashboard/reportportal
   ./setup.sh
   ```

### Usage

#### Running Tests with Dashboard Integration

**Option 1: Use the dashboard test runner**
```bash
# From the dashboard directory
python run_tests_with_dashboard.py

# Or run specific tests
python run_tests_with_dashboard.py tests/integration/test_specific.py
```

**Option 2: Use pytest directly from testviper root**
```bash
# From testviper root directory
pytest -v tests/integration
```

**Option 3: Use pytest with dashboard config**
```bash
# From testviper root directory
pytest -c dashboard/config/pytest_dashboard.ini -v tests/integration
```

## Features

### Enhanced Reporting
- **Namespace Protection**: All functions/classes prefixed with `TV` to avoid conflicts
- **Automatic Failure Capture**: Detailed logs and context for failed tests
- **Performance Tracking**: Duration and timing metrics for all tests
- **Screenshot Capture**: UI test screenshot support
- **Custom Attributes**: Add metadata to tests for better analysis

### Directory Structure
```
dashboard/
├── config/
│   ├── __init__.py
│   ├── conftest.py
│   ├── testviper_rp_reporter.py
│   ├── pytest_dashboard.ini
│   └── README.md
├── reports/
│   ├── tv_screenshots/     # UI test screenshots
│   ├── tv_logs/           # Detailed test logs
│   ├── tv_json/           # JSON session summaries
│   ├── tv_attachments/    # Custom log attachments
│   ├── xml/               # JUnit XML reports
│   ├── html/              # HTML reports
│   └── artifacts/         # General artifacts
├── reportportal/          # Docker setup
└── scripts/               # Utility scripts
```

### Environment Variables

Required in `.env` file:
```bash
RP_API_KEY=your_reportportal_api_key
RP_ENDPOINT=http://localhost:8080
RP_PROJECT=testviper
```

Optional:
```bash
TV_ENABLE_SCREENSHOTS=true
TV_ENABLE_LOG_ATTACHMENTS=true
```

## Custom Markers

The configuration adds custom pytest markers:
- `@pytest.mark.tv_critical` - Critical tests
- `@pytest.mark.tv_integration` - Integration tests  
- `@pytest.mark.tv_performance` - Performance monitored tests
- `@pytest.mark.tv_flaky` - Potentially flaky tests
- `@pytest.mark.tv_component` - Component-specific tests

## Integration with Existing Scripts

The configuration is designed to work alongside existing enhanced_* scripts in the scripts/ directory without conflicts through namespace protection.

## Troubleshooting

1. **Import Errors**: Make sure you're running from the correct directory
2. **Missing Reports**: Check that dashboard/reports directory exists
3. **ReportPortal Connection**: Verify RP_API_KEY and endpoint configuration
4. **Permission Issues**: Ensure write permissions on dashboard/reports directory