# TestViper ReportPortal + Coverage Integration - Maintenance Guide

This guide covers maintaining, monitoring, and troubleshooting the TestViper ReportPortal integration system for system administrators and maintainers.

## Table of Contents

1. [System Architecture](#system-architecture)
2. [Daily Operations](#daily-operations)
3. [Monitoring and Alerting](#monitoring-and-alerting)
4. [Maintenance Tasks](#maintenance-tasks)
5. [Troubleshooting](#troubleshooting)
6. [Performance Optimization](#performance-optimization)
7. [Security Considerations](#security-considerations)
8. [Backup and Recovery](#backup-and-recovery)
9. [Scaling and Upgrades](#scaling-and-upgrades)

## System Architecture

### Component Overview

```
TestViper ReportPortal Integration System
├── Core Components
│   ├── Test Runner (run_tests_with_reportportal.py)
│   ├── ReportPortal Reporter (testviper_rp_reporter.py)
│   ├── Coverage Analytics (coverage_analytics.py)
│   └── Dual Reporting (dual_reporting_*.py)
├── Quality Control
│   ├── Threshold Checker (coverage_threshold_checker.py)
│   ├── Regression Detector (coverage_regression_detector.py)
│   └── Report Generator (simple_report_generator.py)
├── CI/CD Integration
│   ├── GitHub Actions Workflow
│   └── Automated Reporting
└── Configuration Management
    ├── Environment Variables
    ├── Configuration Files
    └── Dual Reporting Config
```

### Data Flow

1. **Test Execution** → Coverage collection → ReportPortal reporting
2. **Coverage Data** → Analytics processing → Trend analysis
3. **Threshold Checking** → Quality gates → CI/CD decisions
4. **Regression Detection** → Alert generation → Notification
5. **Report Generation** → Dashboard updates → Stakeholder reports

### Key Files and Directories

```
testviper/
├── dashboard/
│   ├── config/
│   │   ├── dual_reporting_config.json       # Dual reporting configuration
│   │   └── testviper_rp_reporter.py         # ReportPortal reporter
│   ├── analytics/
│   │   ├── coverage_analytics.py            # Coverage analytics engine
│   │   ├── rp_client.py                     # ReportPortal client
│   │   └── simple_report_generator.py       # Report generation
│   ├── reports/
│   │   ├── tv_json/                         # JSON reports
│   │   └── tv_html/                         # HTML reports
│   ├── run_tests_with_reportportal.py       # Main test runner
│   ├── coverage_threshold_checker.py        # Threshold enforcement
│   ├── coverage_regression_detector.py      # Regression detection
│   ├── dual_reporting_config.py             # Dual reporting config manager
│   └── dual_reporting_runner.py             # Multi-instance runner
├── .github/workflows/
│   └── python-test-reportportal.yml         # CI/CD workflow
├── .env                                     # Environment configuration
├── coverage_thresholds.json                # Coverage thresholds
└── pytest.ini                              # Pytest configuration
```

## Daily Operations

### Daily Monitoring Checklist

#### 1. System Health Check

```bash
# Check ReportPortal connectivity
python dashboard/run_tests_with_reportportal.py --check-only

# Validate configuration
python dashboard/dual_reporting_config.py --validate

# Test connections to all instances
python dashboard/dual_reporting_config.py --test
```

#### 2. Coverage Analytics Review

```bash
# Generate daily coverage report
python dashboard/analytics/coverage_analytics.py --generate-report

# Check for regressions
python dashboard/coverage_regression_detector.py --days 1 --alert-only

# Review threshold status
python dashboard/coverage_threshold_checker.py --quiet
```

#### 3. CI/CD Pipeline Status

```bash
# Check recent GitHub Actions runs
gh run list --repo <your-repo> --workflow="python-test-reportportal.yml" --limit 10

# Review failed runs
gh run list --repo <your-repo> --status failure --limit 5
```

#### 4. Report Generation

```bash
# Generate comprehensive daily report
python dashboard/analytics/simple_report_generator.py --output daily_report.json

# Check report file sizes (cleanup if needed)
du -sh dashboard/reports/tv_json/*.json | sort -h
```

### Weekly Tasks

#### 1. Trend Analysis

```bash
# Generate weekly coverage trends
python dashboard/analytics/coverage_analytics.py --generate-report --days-back 7

# Check for declining trends
python dashboard/coverage_regression_detector.py --days 7
```

#### 2. Configuration Review

```bash
# Review and update thresholds if needed
python dashboard/coverage_threshold_checker.py --create-config

# Check dual reporting configuration
python dashboard/dual_reporting_config.py --show
```

#### 3. Cleanup Tasks

```bash
# Clean old coverage files
find . -name "coverage_*.json" -mtime +7 -delete
find . -name "coverage_*.xml" -mtime +7 -delete

# Archive old reports
find dashboard/reports/tv_json -name "*.json" -mtime +30 -exec gzip {} \;
```

### Monthly Tasks

#### 1. Performance Review

```bash
# Analyze test execution times
python -c "
import json, glob
files = glob.glob('dashboard/reports/tv_json/tv_analytics_report_*.json')
for f in sorted(files)[-10:]:
    with open(f) as file:
        data = json.load(file)
        print(f'{f}: {data.get(\"local_session_summary\", {}).get(\"session_duration\", \"N/A\")}s')
"
```

#### 2. Threshold Adjustment

```bash
# Review coverage trends for threshold adjustments
python dashboard/analytics/coverage_analytics.py --generate-report --days-back 30

# Update thresholds based on trends
vim coverage_thresholds.json
```

#### 3. System Updates

```bash
# Update dependencies
pip install --upgrade pytest-reportportal pytest-cov

# Update ReportPortal client
pip install --upgrade reportportal-client
```

## Monitoring and Alerting

### Key Metrics to Monitor

#### 1. Coverage Metrics

```bash
# Current coverage levels
python dashboard/coverage_threshold_checker.py --quiet

# Coverage trends (monitor for declining trends)
python dashboard/coverage_regression_detector.py --alert-only

# Component-specific coverage
python -c "
from dashboard.analytics.coverage_analytics import CoverageAnalytics
analytics = CoverageAnalytics()
report = analytics.generate_coverage_report()
for comp, data in report.get('summary', {}).get('components', {}).items():
    print(f'{comp}: {data.get(\"avg_coverage\", 0):.1f}%')
"
```

#### 2. System Performance

```bash
# Test execution times
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py --skip-analytics

# ReportPortal response times
python -c "
import time
from dashboard.analytics.rp_client import TVReportPortalClient
client = TVReportPortalClient()
start = time.time()
status = client.test_connection()
duration = time.time() - start
print(f'ReportPortal response time: {duration:.2f}s')
"
```

#### 3. CI/CD Pipeline Health

```bash
# Check workflow success rate
gh api repos/:owner/:repo/actions/runs --jq '.workflow_runs[] | select(.name=="Component Tests with ReportPortal & Coverage") | .conclusion' | sort | uniq -c

# Check artifact sizes
gh api repos/:owner/:repo/actions/artifacts --jq '.artifacts[] | {name: .name, size_in_bytes: .size_in_bytes}'
```

### Alerting Setup

#### 1. Coverage Regression Alerts

Create a monitoring script (`monitor_coverage.sh`):

```bash
#!/bin/bash
# monitor_coverage.sh - Coverage monitoring script

# Check for regressions
if ! python dashboard/coverage_regression_detector.py --days 1 --alert-only; then
    echo "ALERT: Coverage regression detected!"
    # Send notification (email, Slack, etc.)
    # curl -X POST -H 'Content-type: application/json' \
    #   --data '{"text":"Coverage regression detected in TestViper"}' \
    #   $SLACK_WEBHOOK_URL
fi

# Check threshold violations
if ! python dashboard/coverage_threshold_checker.py --quiet; then
    echo "ALERT: Coverage thresholds not met!"
    # Send notification
fi
```

#### 2. System Health Alerts

Create a health check script (`health_check.sh`):

```bash
#!/bin/bash
# health_check.sh - System health monitoring

# Check ReportPortal connectivity
if ! python dashboard/run_tests_with_reportportal.py --check-only > /dev/null 2>&1; then
    echo "ALERT: ReportPortal connection failed!"
    # Send notification
fi

# Check disk space for reports
USAGE=$(df dashboard/reports | tail -1 | awk '{print $5}' | sed 's/%//')
if [ $USAGE -gt 80 ]; then
    echo "ALERT: Report storage is ${USAGE}% full!"
    # Send notification
fi
```

#### 3. Automated Monitoring

Add to crontab:

```bash
# Edit crontab
crontab -e

# Add monitoring jobs
# Check coverage every 4 hours
0 */4 * * * /path/to/testviper/monitor_coverage.sh

# Health check every hour
0 * * * * /path/to/testviper/health_check.sh

# Daily report generation
0 9 * * * cd /path/to/testviper && python dashboard/analytics/coverage_analytics.py --generate-report
```

## Maintenance Tasks

### Regular Maintenance

#### 1. Database Cleanup (ReportPortal)

```bash
# Clean old launches (adjust retention as needed)
# This depends on your ReportPortal setup
# Example for PostgreSQL backend:
# psql -h localhost -U postgres -d reportportal -c "DELETE FROM launch WHERE start_time < NOW() - INTERVAL '90 days';"
```

#### 2. Log Rotation

```bash
# Rotate coverage logs
find . -name "coverage_*.log" -mtime +30 -delete

# Compress old reports
find dashboard/reports/tv_json -name "*.json" -mtime +30 -exec gzip {} \;
```

#### 3. Configuration Validation

```bash
# Validate all configurations
python dashboard/dual_reporting_config.py --validate

# Check threshold configuration
python dashboard/coverage_threshold_checker.py --create-config

# Verify pytest configuration
python -m pytest --collect-only tests/integration/ > /dev/null
```

### Periodic Updates

#### 1. Dependencies

```bash
# Update Python packages
pip install --upgrade -r requirements/base.txt
pip install --upgrade pytest-reportportal pytest-cov

# Check for security updates
pip-audit

# Update GitHub Actions
# Check .github/workflows/python-test-reportportal.yml for action updates
```

#### 2. Configuration Updates

```bash
# Review and update coverage thresholds
python dashboard/coverage_threshold_checker.py --create-config

# Update dual reporting configuration
python dashboard/dual_reporting_config.py --create-sample
```

#### 3. Documentation Updates

```bash
# Update documentation when changing configurations
# Update this file when adding new maintenance procedures
# Update USAGE_GUIDE.md when adding new features
```

## Troubleshooting

### Common Issues

#### 1. ReportPortal Connection Issues

**Symptoms**: Tests run but don't appear in ReportPortal

**Diagnosis**:
```bash
# Test connection
python dashboard/dual_reporting_config.py --test

# Check environment variables
env | grep RP_

# Verify API key
curl -H "Authorization: Bearer $RP_API_KEY" "$RP_ENDPOINT/api/v1/project/$RP_PROJECT"
```

**Solutions**:
- Verify API key is correct and not expired
- Check ReportPortal service status
- Validate network connectivity
- Check firewall settings

#### 2. Coverage Not Collected

**Symptoms**: Tests run but coverage shows 0%

**Diagnosis**:
```bash
# Check source directories
ls -la */src/

# Verify coverage files
ls -la coverage_*.json

# Check component detection
python -c "
from dashboard.run_tests_with_reportportal import determine_component_name
print(determine_component_name('xradio/tests'))
"
```

**Solutions**:
- Ensure source directories exist
- Check test path component detection
- Verify pytest-cov is installed
- Check coverage configuration

#### 3. CI/CD Pipeline Failures

**Symptoms**: GitHub Actions workflow fails

**Diagnosis**:
```bash
# Check workflow logs
gh run view <run-id> --log

# Verify secrets and variables
gh secret list
gh variable list
```

**Solutions**:
- Update expired API keys
- Check repository secrets/variables
- Verify workflow file syntax
- Check for dependency conflicts

#### 4. High Memory Usage

**Symptoms**: Tests consume excessive memory

**Diagnosis**:
```bash
# Monitor memory during test runs
python -c "
import psutil
import subprocess
import time

# Start test process
proc = subprocess.Popen(['python', 'dashboard/run_tests_with_reportportal.py', 'tests/integration'])
pid = proc.pid

# Monitor memory
while proc.poll() is None:
    try:
        process = psutil.Process(pid)
        memory = process.memory_info().rss / 1024 / 1024  # MB
        print(f'Memory usage: {memory:.1f} MB')
        time.sleep(5)
    except psutil.NoSuchProcess:
        break
"
```

**Solutions**:
- Reduce parallel workers in dual reporting
- Implement test batching
- Clean up temporary files
- Optimize coverage collection

### Debug Tools

#### 1. Diagnostic Scripts

Create `diagnose_system.py`:

```python
#!/usr/bin/env python3
"""System diagnostics for TestViper ReportPortal integration"""

import os
import sys
import json
import subprocess
from pathlib import Path

def check_environment():
    """Check environment variables"""
    required_vars = ['RP_ENDPOINT', 'RP_PROJECT', 'RP_API_KEY']
    missing = []
    
    for var in required_vars:
        if not os.getenv(var):
            missing.append(var)
    
    if missing:
        print(f"❌ Missing environment variables: {', '.join(missing)}")
        return False
    else:
        print("✅ All required environment variables set")
        return True

def check_dependencies():
    """Check Python dependencies"""
    required_packages = [
        'pytest', 'pytest-cov', 'pytest-reportportal', 
        'requests', 'python-dotenv'
    ]
    
    missing = []
    for package in required_packages:
        try:
            __import__(package.replace('-', '_'))
        except ImportError:
            missing.append(package)
    
    if missing:
        print(f"❌ Missing packages: {', '.join(missing)}")
        return False
    else:
        print("✅ All required packages installed")
        return True

def check_reportportal():
    """Check ReportPortal connectivity"""
    try:
        from dashboard.analytics.rp_client import TVReportPortalClient
        client = TVReportPortalClient()
        status = client.test_connection()
        
        if status.get('status') == 'success':
            print("✅ ReportPortal connection successful")
            return True
        else:
            print(f"❌ ReportPortal connection failed: {status.get('error')}")
            return False
    except Exception as e:
        print(f"❌ ReportPortal connection error: {e}")
        return False

def check_coverage_files():
    """Check for coverage files"""
    coverage_files = list(Path('.').glob('coverage_*.json'))
    if coverage_files:
        print(f"✅ Found {len(coverage_files)} coverage files")
        return True
    else:
        print("⚠️  No coverage files found")
        return False

def main():
    """Run all diagnostics"""
    print("🔍 TestViper System Diagnostics")
    print("=" * 50)
    
    checks = [
        check_environment,
        check_dependencies,
        check_reportportal,
        check_coverage_files
    ]
    
    results = []
    for check in checks:
        results.append(check())
    
    print("\n📊 Summary:")
    passed = sum(results)
    total = len(results)
    print(f"Passed: {passed}/{total} checks")
    
    if passed == total:
        print("✅ System is healthy")
        return 0
    else:
        print("❌ System has issues")
        return 1

if __name__ == '__main__':
    sys.exit(main())
```

#### 2. Performance Profiling

Create `profile_tests.py`:

```python
#!/usr/bin/env python3
"""Performance profiling for TestViper tests"""

import time
import psutil
import subprocess
import sys
from pathlib import Path

def profile_test_run(test_path):
    """Profile a test run"""
    print(f"🚀 Profiling test run: {test_path}")
    
    # Start monitoring
    start_time = time.time()
    start_memory = psutil.virtual_memory().used / 1024 / 1024  # MB
    
    # Run test
    cmd = [sys.executable, 'dashboard/run_tests_with_reportportal.py', test_path, '--skip-analytics']
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True, check=False)
        
        # End monitoring
        end_time = time.time()
        end_memory = psutil.virtual_memory().used / 1024 / 1024  # MB
        
        # Results
        duration = end_time - start_time
        memory_delta = end_memory - start_memory
        
        print(f"⏱️  Duration: {duration:.2f}s")
        print(f"💾 Memory delta: {memory_delta:.1f} MB")
        print(f"📊 Exit code: {result.returncode}")
        
        return {
            'duration': duration,
            'memory_delta': memory_delta,
            'exit_code': result.returncode,
            'stdout_lines': len(result.stdout.splitlines()),
            'stderr_lines': len(result.stderr.splitlines())
        }
        
    except Exception as e:
        print(f"❌ Profiling failed: {e}")
        return None

def main():
    """Profile different test scenarios"""
    test_cases = [
        'tests/integration/test_basic_xradio.py',
        'tests/integration',
        'xradio/tests' if Path('xradio/tests').exists() else None
    ]
    
    results = {}
    for test_case in test_cases:
        if test_case:
            results[test_case] = profile_test_run(test_case)
    
    print("\n📊 Performance Summary:")
    for test_case, result in results.items():
        if result:
            print(f"{test_case}: {result['duration']:.2f}s, {result['memory_delta']:.1f}MB")

if __name__ == '__main__':
    main()
```

### Log Analysis

#### 1. Coverage Log Analysis

```bash
# Analyze coverage trends
python -c "
import json, glob, statistics
from datetime import datetime

files = glob.glob('dashboard/reports/tv_json/tv_coverage_analytics_report_*.json')
coverages = []

for f in sorted(files)[-10:]:  # Last 10 reports
    with open(f) as file:
        data = json.load(file)
        for comp, comp_data in data.get('summary', {}).get('components', {}).items():
            if comp == 'xradio':  # Example: track xradio coverage
                coverages.append(comp_data.get('avg_coverage', 0))

if coverages:
    print(f'XRADIO coverage trend: {statistics.mean(coverages):.1f}% avg')
    print(f'Latest: {coverages[-1]:.1f}%, Previous: {coverages[-2]:.1f}%')
"
```

#### 2. Error Pattern Analysis

```bash
# Analyze common errors
grep -r "ERROR" dashboard/reports/tv_json/*.json | sort | uniq -c | sort -nr
```

## Performance Optimization

### Test Execution Optimization

#### 1. Parallel Execution

```bash
# Use dual reporting with optimized workers
python dashboard/dual_reporting_runner.py tests/integration --max-workers 2

# Batch test execution
python dashboard/run_tests_with_reportportal.py tests/integration --pytest-args "--maxfail=5"
```

#### 2. Coverage Optimization

```bash
# Disable coverage for quick tests
python dashboard/run_tests_with_reportportal.py tests/integration --no-coverage

# Use coverage only for specific components
export TV_COMPONENT_NAME=xradio
python dashboard/run_tests_with_reportportal.py xradio/tests
```

### Storage Optimization

#### 1. Report Cleanup

```bash
# Compress old reports
find dashboard/reports/tv_json -name "*.json" -mtime +30 -exec gzip {} \;

# Clean old coverage files
find . -name "coverage_*.json" -mtime +7 -delete
```

#### 2. Database Optimization

```bash
# ReportPortal database maintenance (PostgreSQL example)
# VACUUM FULL launch;
# REINDEX INDEX idx_launch_start_time;
```

### Network Optimization

#### 1. ReportPortal Connection

```bash
# Test connection speed
python -c "
import time
from dashboard.analytics.rp_client import TVReportPortalClient

client = TVReportPortalClient()
start = time.time()
status = client.test_connection()
duration = time.time() - start
print(f'Connection time: {duration:.2f}s')
"
```

#### 2. Dual Reporting Optimization

```bash
# Use sequential mode for slower connections
python dashboard/dual_reporting_runner.py tests/integration --sequential
```

## Security Considerations

### API Key Management

#### 1. Environment Variables

```bash
# Use environment variables for API keys
export RP_API_KEY=your-secret-key
export RP_CLOUD_API_KEY=your-cloud-secret-key

# Never commit API keys to version control
echo "RP_API_KEY=*" >> .gitignore
```

#### 2. Key Rotation

```bash
# Regular key rotation procedure
# 1. Generate new API key in ReportPortal
# 2. Update environment variables
# 3. Update CI/CD secrets
# 4. Test connectivity
# 5. Revoke old key
```

### Network Security

#### 1. HTTPS Enforcement

```bash
# Ensure all ReportPortal endpoints use HTTPS in production
# Edit dual_reporting_config.json
{
  "reportportal_instances": {
    "production": {
      "endpoint": "https://reportportal.example.com"  # Always HTTPS
    }
  }
}
```

#### 2. Firewall Configuration

```bash
# Allow only necessary ports
# ReportPortal: 8080 (local), 443 (HTTPS cloud)
# Ensure proper firewall rules
```

### Data Protection

#### 1. Report Sanitization

```bash
# Check reports for sensitive data
grep -r "password\|secret\|token" dashboard/reports/tv_json/
```

#### 2. Access Control

```bash
# Restrict access to configuration files
chmod 600 .env
chmod 600 dashboard/config/dual_reporting_config.json
```

## Backup and Recovery

### Configuration Backup

```bash
# Backup script
#!/bin/bash
# backup_config.sh

BACKUP_DIR="/backup/testviper/$(date +%Y%m%d)"
mkdir -p $BACKUP_DIR

# Backup configuration files
cp .env $BACKUP_DIR/
cp coverage_thresholds.json $BACKUP_DIR/
cp dashboard/config/dual_reporting_config.json $BACKUP_DIR/
cp pytest.ini $BACKUP_DIR/

# Backup recent reports
cp dashboard/reports/tv_json/tv_coverage_analytics_report_*.json $BACKUP_DIR/

echo "Backup completed: $BACKUP_DIR"
```

### Recovery Procedures

#### 1. Configuration Recovery

```bash
# Restore from backup
BACKUP_DIR="/backup/testviper/20250114"
cp $BACKUP_DIR/.env .
cp $BACKUP_DIR/coverage_thresholds.json .
cp $BACKUP_DIR/dual_reporting_config.json dashboard/config/

# Verify configuration
python dashboard/dual_reporting_config.py --validate
```

#### 2. Report Recovery

```bash
# Regenerate reports from ReportPortal data
python dashboard/analytics/coverage_analytics.py --generate-report --days-back 30
```

## Scaling and Upgrades

### Horizontal Scaling

#### 1. Multiple ReportPortal Instances

```bash
# Configure additional instances
python dashboard/dual_reporting_config.py --create-sample

# Add new instance to configuration
{
  "reportportal_instances": {
    "region_us": {
      "endpoint": "https://us.reportportal.com",
      "enabled": true,
      "priority": 3
    },
    "region_eu": {
      "endpoint": "https://eu.reportportal.com", 
      "enabled": true,
      "priority": 4
    }
  }
}
```

#### 2. Load Balancing

```bash
# Distribute tests across instances
python dashboard/dual_reporting_runner.py tests/integration --max-workers 4
```

### Vertical Scaling

#### 1. Resource Optimization

```bash
# Monitor resource usage
python -c "
import psutil
print(f'CPU: {psutil.cpu_percent()}%')
print(f'Memory: {psutil.virtual_memory().percent}%')
print(f'Disk: {psutil.disk_usage(\"/\").percent}%')
"
```

#### 2. Performance Tuning

```bash
# Optimize pytest execution
export PYTHONPATH="$PYTHONPATH:$(pwd)"
export PYTEST_WORKERS=4
```

### Upgrade Procedures

#### 1. Component Updates

```bash
# Update Python packages
pip install --upgrade pytest-reportportal
pip install --upgrade pytest-cov

# Test after updates
python dashboard/run_tests_with_reportportal.py --check-only
```

#### 2. System Updates

```bash
# Update system components
# 1. Test in staging environment
# 2. Backup current configuration
# 3. Update dependencies
# 4. Run validation tests
# 5. Deploy to production

# Validation test
python dashboard/run_tests_with_reportportal.py tests/integration/test_basic_xradio.py
```

## Contact and Support

### Internal Support

- **System Administrator**: Check logs and configuration
- **Development Team**: Code-related issues
- **CI/CD Team**: GitHub Actions and pipeline issues

### External Support

- **ReportPortal Community**: https://github.com/reportportal/reportportal
- **pytest-reportportal**: https://github.com/reportportal/agent-python-pytest

### Emergency Procedures

1. **System Down**: Use local test execution without ReportPortal
2. **Data Loss**: Restore from latest backup
3. **Security Breach**: Rotate all API keys immediately

For deployment procedures, see [DEPLOYMENT_GUIDE.md](DEPLOYMENT_GUIDE.md).
For usage instructions, see [USAGE_GUIDE.md](USAGE_GUIDE.md).