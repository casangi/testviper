# ReportPortal Integration Setup Guide

## 🚀 Overview

This document provides comprehensive setup instructions for the ReportPortal integration in TestVIPER, including recent fixes and troubleshooting.

## 📋 Prerequisites

- Docker and Docker Compose installed
- Python 3.11+ with pytest
- All VIPER components (toolviper, graphviper, xradio, astroviper) available

## 🔧 Installation & Setup

### 1. Start ReportPortal Services

```bash
# Start ReportPortal containers
docker-compose up -d

# Verify services are running
docker-compose ps
```

### 2. Access ReportPortal Dashboard

- **URL**: http://localhost:8080
- **Login**: `superadmin`
- **Password**: `erebus`

### 3. Environment Configuration

Create or verify the `.env` file:

```bash
# ReportPortal Configuration
RP_ENDPOINT=http://localhost:8080
RP_PROJECT=testviper
RP_API_KEY=your_jwt_token_here

# Note: RP_LAUNCH is NOT set here - launch names are generated dynamically
# based on component names (e.g., "xradio", "toolviper", "graphviper")
# or custom names provided via --launch-name parameter
```

### 4. Get API Key

1. Login to ReportPortal dashboard
2. Go to User Profile (top right)
3. Copy the API Key (JWT token)
4. Update the `RP_API_KEY` in your `.env` file

## 🔧 Critical Configuration Fixes

### Fix 1: pytest.ini Configuration

**Issue**: xradio tests were not creating launches in ReportPortal.

**Root Cause**: Incorrect pytest-reportportal plugin configuration.

**Fix**: Updated `pytest.ini` line 6:

```ini
# Before (incorrect)
rp_uuid = ${RP_API_KEY}

# After (correct)
rp_api_key = ${RP_API_KEY}
```

**Location**: `/opt/scastro/casangi/demonstrator/reportportal/testviper/pytest.ini:6`

### Fix 2: Plugin Manager Access

**Issue**: Error: `'Session' object has no attribute 'pluginmanager'`

**Root Cause**: Outdated pytest plugin manager access pattern.

**Fix**: Updated `testviper_rp_reporter.py` line 156:

```python
# Before (incorrect)
rp_plugin = session.pluginmanager.get_plugin("pytest-reportportal")

# After (correct)
rp_plugin = session.config.pluginmanager.get_plugin("pytest-reportportal")
```

**Location**: `/opt/scastro/casangi/demonstrator/reportportal/testviper/dashboard/config/testviper_rp_reporter.py:156`

### Fix 3: Launch Creation Verification

**Status**: All components now create launches successfully:
- ✅ toolviper
- ✅ graphviper  
- ✅ xradio (fixed)
- ✅ astroviper

## 🚀 Running Tests

### Basic Usage

```bash
# Run all integration tests
python dashboard/run_tests_with_reportportal.py

# Run specific test file
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py

# Run component tests
python dashboard/run_tests_with_reportportal.py toolviper/tests/unit
```

### Advanced Usage

```bash
# Custom launch names
python dashboard/run_tests_with_reportportal.py --launch-name "feature_xyz"
python dashboard/run_tests_with_reportportal.py --launch-name "nightly_regression"

# Component-specific testing
TV_COMPONENT_NAME=xradio python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py

# Test with additional pytest arguments
python dashboard/run_tests_with_reportportal.py --pytest-args "--capture=no --log-cli-level=DEBUG"

# Check configuration only
python dashboard/run_tests_with_reportportal.py --check-only
```

### Launch Naming Convention

- **Default**: Uses component name automatically determined from test path:
  - `tests/integration/test_basic_xradio.py` → Launch: `xradio`
  - `toolviper/tests/unit/test_*.py` → Launch: `toolviper`
  - `graphviper/tests/` → Launch: `graphviper`
- **Auto-indexing**: ReportPortal automatically adds `#2`, `#3`, etc. for duplicate names
- **Custom**: Use `--launch-name` for organized tracking (e.g., `--launch-name "nightly_regression"`)
- **Environment Override**: Set `TV_COMPONENT_NAME=component_name` to force specific component naming

## 📊 Features

### Coverage Analytics

The system automatically tracks:
- Code coverage percentage
- Number of statements
- Missing lines
- Coverage quality rating

### Launch Attributes

Each launch includes:
- Component name
- Coverage metrics
- Test execution metadata
- Environment information

### Real-time Monitoring

- Live test execution tracking
- Progress indicators
- Error reporting
- Performance metrics

## 🛠️ Troubleshooting

### Common Issues

#### 1. API Key Issues
**Error**: `Invalid access token`
**Solution**: 
- Get fresh API key from ReportPortal dashboard
- Update `.env` file with new key
- Restart test execution

#### 2. Launch Creation Failures
**Error**: Tests run but no launches appear in ReportPortal
**Solution**: 
- Verify `pytest.ini` has `rp_api_key` (not `rp_uuid`)
- Check API key is valid
- Ensure ReportPortal services are running

#### 3. Plugin Manager Errors
**Error**: `'Session' object has no attribute 'pluginmanager'`
**Solution**: 
- Update testviper_rp_reporter.py with correct plugin access
- Use `session.config.pluginmanager` instead of `session.pluginmanager`

#### 4. Import Errors
**Error**: `ModuleNotFoundError: No module named 'toolviper'`
**Solution**:
- Install all VIPER components
- Verify Python path includes component directories
- Check virtual environment activation

### Debug Commands

```bash
# Test ReportPortal connection
curl -H "Authorization: Bearer YOUR_API_KEY" http://localhost:8080/api/v1/testviper/launch

# Check Docker services
docker-compose logs reportportal-api
docker-compose logs reportportal-ui

# Verify configuration
python dashboard/run_tests_with_reportportal.py --check-only

# Test with minimal configuration
python -m pytest tests/integration/test_basic_xradio.py -v --reportportal --rp-project=testviper --rp-launch=debug_test
```

## 📁 File Structure

```
dashboard/
├── run_tests_with_reportportal.py     # Main execution script
├── config/
│   ├── testviper_rp_reporter.py       # Enhanced pytest plugin
│   └── analytics.py                   # Analytics and reporting
├── reports/                           # Generated reports
│   ├── tv_json/                       # JSON reports
│   ├── tv_logs/                       # Execution logs
│   └── tv_attachments/                # Test attachments
└── docker-compose.yml                # ReportPortal services
```

## 🔄 Maintenance

### Regular Tasks

1. **Monitor API Key Expiration**: JWT tokens expire periodically
2. **Clean Old Launches**: Remove outdated test results
3. **Update Dependencies**: Keep pytest-reportportal plugin updated
4. **Backup Configuration**: Save `.env` and `pytest.ini` settings

### Performance Optimization

- Use `--capture=no` for faster execution
- Disable unnecessary plugins with `-p no:plugin_name`
- Run tests in parallel for large test suites

## 📈 Analytics Dashboard

The system generates comprehensive analytics:

- **Test Execution Trends**: Track pass/fail rates over time
- **Coverage Analysis**: Monitor code coverage improvements
- **Performance Metrics**: Identify slow tests and bottlenecks
- **Flaky Test Detection**: Automatically identify unstable tests

Access analytics at: `dashboard/reports/tv_json/tv_analytics_report_*.json`

## 🤝 Contributing

When adding new components or tests:

1. Update component configuration in `run_tests_with_reportportal.py`
2. Ensure proper test path structure
3. Test launch creation for new components
4. Update documentation as needed

## 📚 Resources

- [ReportPortal Documentation](https://reportportal.io/docs)
- [pytest-reportportal Plugin](https://github.com/reportportal/agent-python-pytest)
- [TestVIPER Issues](https://github.com/casangi/testviper/issues)

---

> **Note**: This integration was enhanced with comprehensive fixes for xradio launch creation and plugin compatibility. All components now fully support ReportPortal integration with real-time monitoring and analytics.