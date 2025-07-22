"""
TestViper ReportPortal Integration - conftest.py
Enhanced pytest configuration with ReportPortal integration
"""

import pytest
import os
import logging
import sys
from pathlib import Path
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Import the TestViper ReportPortal reporter
try:
    # Try relative import first (when running from dashboard/config)
    from .testviper_rp_reporter import TVReportPortalEnhancer, get_tv_reporter
except ImportError:
    # Try absolute import (when running from root via symlink)
    from dashboard.config.testviper_rp_reporter import TVReportPortalEnhancer, get_tv_reporter

# Global reporter instance
tv_reporter = None

def pytest_configure(config):
    """Configure pytest with TestViper ReportPortal enhanced reporting"""
    global tv_reporter
    
    # Initialize TestViper ReportPortal reporter
    tv_reporter = TVReportPortalEnhancer()
    
    # Register the reporter hooks with pytest
    config.pluginmanager.register(tv_reporter, "testviper_rp_enhancer")
    
    # Log configuration
    logger = logging.getLogger("testviper.conftest")
    logger.info("TestViper ReportPortal integration configured")
    
    # Check environment variables
    rp_endpoint = os.getenv("RP_ENDPOINT", "http://localhost:8080")
    rp_project = os.getenv("RP_PROJECT", "testviper")
    rp_api_key = os.getenv("RP_API_KEY")
    
    logger.info(f"ReportPortal endpoint: {rp_endpoint}")
    logger.info(f"ReportPortal project: {rp_project}")
    logger.info(f"ReportPortal API key configured: {bool(rp_api_key)}")
    
    if not rp_api_key:
        logger.warning("⚠️  RP_API_KEY not found in environment variables")
        logger.warning("   Tests will run but may not be sent to ReportPortal")
        logger.warning("   Check your .env file or environment configuration")
    
    # Configure custom markers for TestViper
    config.addinivalue_line(
        "markers", "tv_critical: mark test as critical for TestViper"
    )
    config.addinivalue_line(
        "markers", "tv_integration: mark test as integration test"
    )
    config.addinivalue_line(
        "markers", "tv_performance: mark test for performance monitoring"
    )
    config.addinivalue_line(
        "markers", "tv_flaky: mark test as potentially flaky"
    )
    config.addinivalue_line(
        "markers", "tv_component: mark test with component name"
    )

@pytest.fixture(scope="session")
def tv_reporter_session():
    """Provide access to TestViper ReportPortal reporter for session-level operations"""
    return tv_reporter

@pytest.fixture(scope="function")
def tv_reporter_test():
    """Provide access to TestViper ReportPortal reporter for individual tests"""
    return tv_reporter

@pytest.fixture(scope="function")
def tv_test_logger(request):
    """Provide test-specific logger with TestViper namespace"""
    test_name = request.node.name
    logger = logging.getLogger(f"testviper.test.{test_name}")
    
    # Add custom logging handler for this test
    handler = logging.StreamHandler(sys.stdout)
    handler.setFormatter(logging.Formatter(
        f"🧪 TV-{test_name}: %(message)s"
    ))
    logger.addHandler(handler)
    logger.setLevel(logging.INFO)
    
    return logger

@pytest.fixture(scope="function")
def tv_capture_on_failure(request, tv_reporter_test):
    """Automatically capture TestViper artifacts on test failure"""
    yield
    
    # Check if test failed
    if hasattr(request.node, 'rep_call') and request.node.rep_call.failed:
        test_name = request.node.nodeid
        
        # Capture screenshot if webdriver is available
        if hasattr(request, 'instance') and hasattr(request.instance, 'driver'):
            screenshot_path = tv_reporter_test.tv_capture_screenshot(test_name, request.instance.driver)
            if screenshot_path and test_name in tv_reporter_test.test_metrics:
                tv_reporter_test.test_metrics[test_name].screenshot_path = screenshot_path
        
        # Add failure context information
        failure_context = f"""
TestViper ReportPortal Failure Context
=====================================
Test: {test_name}
Node ID: {request.node.nodeid}
Time: {datetime.now().isoformat()}
Function: {request.node.function.__name__ if hasattr(request.node, 'function') else 'N/A'}
File: {request.node.fspath if hasattr(request.node, 'fspath') else 'N/A'}
Line: {request.node.function.__code__.co_firstlineno if hasattr(request.node, 'function') else 'N/A'}

Test Parameters:
{dict(request.node.callspec.params) if hasattr(request.node, 'callspec') else 'No parameters'}

Environment:
- Python: {sys.version}
- Platform: {sys.platform}
- Working Directory: {Path.cwd()}
- ReportPortal Endpoint: {os.getenv('RP_ENDPOINT', 'Not configured')}
- ReportPortal Project: {os.getenv('RP_PROJECT', 'Not configured')}
"""
        
        # Attach failure context
        tv_reporter_test.tv_attach_log_file(
            test_name, 
            failure_context, 
            f"tv_failure_context_{test_name.replace('/', '_').replace('::', '_')}.log"
        )
        
        # Add failure tag
        tv_reporter_test.tv_add_test_attribute(test_name, "failure_captured", True)

@pytest.fixture(scope="function")
def tv_performance_tracker(request, tv_reporter_test):
    """Track test performance with TestViper namespace"""
    test_name = request.node.nodeid
    start_time = datetime.now()
    
    yield
    
    end_time = datetime.now()
    duration = (end_time - start_time).total_seconds()
    
    # Add performance metrics
    tv_reporter_test.tv_add_test_attribute(test_name, "tv_performance_duration", duration)
    tv_reporter_test.tv_add_test_attribute(test_name, "tv_performance_start", start_time.isoformat())
    tv_reporter_test.tv_add_test_attribute(test_name, "tv_performance_end", end_time.isoformat())
    
    # Log performance
    logger = logging.getLogger("testviper.performance")
    logger.info(f"🏃 TV Performance: {test_name} completed in {duration:.2f}s")

@pytest.hookimpl(tryfirst=True, hookwrapper=True)
def pytest_runtest_makereport(item, call):
    """Hook to capture test results for TestViper reporting"""
    outcome = yield
    rep = outcome.get_result()
    
    # Store the report on the test item for later use
    setattr(item, "rep_" + rep.when, rep)
    
    # Add TestViper-specific reporting
    if call.when == "call" and tv_reporter:
        test_name = item.nodeid
        
        # Add test metadata
        tv_reporter.tv_add_test_attribute(test_name, "tv_test_file", str(item.fspath))
        tv_reporter.tv_add_test_attribute(test_name, "tv_test_function", item.name)
        tv_reporter.tv_add_test_attribute(test_name, "tv_test_class", item.cls.__name__ if item.cls else None)
        tv_reporter.tv_add_test_attribute(test_name, "tv_test_module", item.module.__name__ if item.module else None)
        
        # Add markers as attributes
        for marker in item.iter_markers():
            tv_reporter.tv_add_test_attribute(test_name, f"tv_marker_{marker.name}", True)
            if marker.args:
                tv_reporter.tv_add_test_attribute(test_name, f"tv_marker_{marker.name}_args", list(marker.args))
            if marker.kwargs:
                tv_reporter.tv_add_test_attribute(test_name, f"tv_marker_{marker.name}_kwargs", dict(marker.kwargs))

def pytest_sessionstart(session):
    """Session start hook for TestViper ReportPortal"""
    print("\n" + "=" * 60)
    print("🚀 TestViper ReportPortal Integration Started")
    print("=" * 60)
    print(f"📊 Endpoint: {os.getenv('RP_ENDPOINT', 'http://localhost:8080')}")
    print(f"📁 Project: {os.getenv('RP_PROJECT', 'testviper')}")
    print(f"🔑 API Key: {'✅ Configured' if os.getenv('RP_API_KEY') else '❌ Missing'}")
    print(f"📂 Reports Dir: {Path('dashboard/reports').absolute()}")
    print("=" * 60)

def pytest_sessionfinish(session, exitstatus):
    """Session finish hook for TestViper ReportPortal"""
    print("\n" + "=" * 60)
    print("🏁 TestViper ReportPortal Integration Finished")
    print("=" * 60)
    print(f"Exit Status: {exitstatus}")
    print(f"📊 Check ReportPortal UI: {os.getenv('RP_ENDPOINT', 'http://localhost:8080')}")
    print(f"📂 Local Reports: {Path('dashboard/reports').absolute()}")
    print("=" * 60)

# Custom markers configuration moved to main pytest_configure function above