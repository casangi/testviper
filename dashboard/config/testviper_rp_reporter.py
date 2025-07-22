"""
TestViper ReportPortal Enhanced Reporter
Namespace-protected enhanced reporting module for ReportPortal integration.
"""

import os
import sys
import logging
import time
from datetime import datetime
from pathlib import Path
import json
from typing import Dict, Any, Optional, List
import traceback
from dataclasses import dataclass, field
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

@dataclass
class TVReportMetrics:
    """TestViper ReportPortal test metrics data class"""
    test_name: str
    start_time: float
    end_time: Optional[float] = None
    status: str = "running"
    duration: Optional[float] = None
    error_message: Optional[str] = None
    screenshot_path: Optional[str] = None
    log_attachments: List[str] = field(default_factory=list)
    custom_attributes: Dict[str, Any] = field(default_factory=dict)

class TVReportPortalEnhancer:
    """
    TestViper ReportPortal Enhanced Reporter with Coverage Integration
    
    Provides enhanced test reporting capabilities with ReportPortal integration,
    namespace-protected to avoid conflicts with existing enhanced_* scripts.
    Includes coverage data collection and attribute injection.
    """
    
    def __init__(self, base_reports_dir: str = None):
        """Initialize the enhanced reporter"""
        if base_reports_dir is None:
            # Auto-detect reports directory relative to current working directory
            cwd = Path.cwd()
            if (cwd / "dashboard" / "reports").exists():
                base_reports_dir = "dashboard/reports"
            elif (cwd.parent / "dashboard" / "reports").exists():
                base_reports_dir = "../dashboard/reports"
            else:
                base_reports_dir = "dashboard/reports"
        
        self.base_reports_dir = Path(base_reports_dir)
        self.session_start_time = None
        self.test_metrics: Dict[str, TVReportMetrics] = {}
        
        # Coverage integration
        self.component_name = os.getenv("TV_COMPONENT_NAME", "unknown")
        self.enable_coverage = os.getenv("TV_ENABLE_COVERAGE", "false").lower() == "true"
        self.coverage_file = os.getenv("TV_COVERAGE_FILE", "")
        self.coverage_data = None
        
        # Create enhanced directory structure
        self._setup_directories()
        
        # Setup logging
        self.logger = self._setup_logging()
        
        # Load coverage data after logger is initialized
        if self.enable_coverage and self.coverage_file:
            self.coverage_data = self._load_coverage_data()
        else:
            self.coverage_data = None  # No coverage data available
        
        # Log initialization
        self.logger.info("TestViper ReportPortal Enhanced Reporter initialized")
        self.logger.info(f"Base reports directory: {self.base_reports_dir.absolute()}")
    
    def _setup_directories(self):
        """Setup enhanced reporting directory structure"""
        # Create base directory and subdirectories
        self.reports_dir = self.base_reports_dir
        
        # Enhanced subdirectories (namespace protected)
        self.tv_screenshots_dir = self.reports_dir / "tv_screenshots"
        self.tv_logs_dir = self.reports_dir / "tv_logs"
        self.tv_json_dir = self.reports_dir / "tv_json"
        self.tv_attachments_dir = self.reports_dir / "tv_attachments"
        
        # Use existing subdirectories
        self.xml_dir = self.reports_dir / "xml"
        self.html_dir = self.reports_dir / "html"
        self.artifacts_dir = self.reports_dir / "artifacts"
        
        # Create all directories
        for directory in [
            self.reports_dir,
            self.tv_screenshots_dir,
            self.tv_logs_dir,
            self.tv_json_dir,
            self.tv_attachments_dir,
            self.xml_dir,
            self.html_dir,
            self.artifacts_dir
        ]:
            directory.mkdir(parents=True, exist_ok=True)
    
    def _setup_logging(self) -> logging.Logger:
        """Setup enhanced logging configuration"""
        logger = logging.getLogger("testviper.rp_reporter")
        
        # Avoid duplicate handlers
        if logger.handlers:
            return logger
        
        logger.setLevel(logging.INFO)
        
        # Create formatter
        formatter = logging.Formatter(
            "%(asctime)s [%(levelname)8s] %(name)s: %(message)s",
            datefmt="%Y-%m-%d %H:%M:%S"
        )
        
        # File handler
        log_file = self.tv_logs_dir / "tv_test_execution.log"
        file_handler = logging.FileHandler(log_file)
        file_handler.setFormatter(formatter)
        logger.addHandler(file_handler)
        
        # Console handler
        console_handler = logging.StreamHandler(sys.stdout)
        console_handler.setFormatter(formatter)
        logger.addHandler(console_handler)
        
        return logger
    
    def pytest_sessionstart(self, session):
        """Hook called at the start of test session"""
        self.session_start_time = datetime.now()
        self.session = session  # Store session for later use
        self.logger.info(f"TestViper ReportPortal session started at {self.session_start_time}")
        
        # Debug ReportPortal configuration
        self.logger.info(f"DEBUG - Component name: {self.component_name}")
        self.logger.info(f"DEBUG - Coverage enabled: {self.enable_coverage}")
        self.logger.info(f"DEBUG - ReportPortal endpoint: {os.getenv('RP_ENDPOINT', 'not set')}")
        self.logger.info(f"DEBUG - ReportPortal project: {os.getenv('RP_PROJECT', 'not set')}")
        self.logger.info(f"DEBUG - ReportPortal launch: {os.getenv('RP_LAUNCH', 'not set')}")
        self.logger.info(f"DEBUG - ReportPortal UUID set: {'yes' if os.getenv('RP_API_KEY') else 'no'}")
        
        # Check if pytest-reportportal is active and try to get the plugin instance
        try:
            # Try to get the pytest-reportportal plugin from the session
            rp_plugin = session.config.pluginmanager.get_plugin("pytest-reportportal")
            if rp_plugin:
                self.rp_plugin = rp_plugin  # Store for later use
                self.logger.info("DEBUG - pytest-reportportal plugin found in session")
            else:
                self.logger.warning("DEBUG - pytest-reportportal plugin not found in session")
                
            from pytest_reportportal import service
            if hasattr(service, 'ReportPortalService'):
                rp_service = service.ReportPortalService.get_rp()
                if rp_service:
                    self.logger.info("DEBUG - pytest-reportportal service is ACTIVE")
                else:
                    self.logger.warning("DEBUG - pytest-reportportal service is NOT ACTIVE")
            else:
                self.logger.warning("DEBUG - pytest-reportportal service not found")
        except Exception as e:
            self.logger.error(f"DEBUG - Error checking pytest-reportportal: {e}")
        
        # Create session info
        session_info = {
            "session_id": f"testviper_rp_{datetime.now().strftime('%Y%m%d_%H%M%S')}",
            "session_start": self.session_start_time.isoformat(),
            "python_version": sys.version,
            "platform": sys.platform,
            "working_directory": str(Path.cwd()),
            "reportportal_config": {
                "endpoint": os.getenv("RP_ENDPOINT", "http://localhost:8080"),
                "project": os.getenv("RP_PROJECT", "testviper"),
                "api_key_configured": bool(os.getenv("RP_API_KEY"))
            }
        }
        
        # Save session info
        session_file = self.tv_json_dir / f"tv_session_info_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(session_file, "w") as f:
            json.dump(session_info, f, indent=2)
        
        self.logger.info(f"Session info saved to {session_file}")
    
    def pytest_collection_modifyitems(self, session, config, items):
        """Hook called after test collection, used to inject launch attributes"""
        # Always inject coverage attributes (even if coverage is 0 or disabled)
        self.logger.info(f"TestViper RP: Injecting coverage attributes for component {self.component_name}")
        
        if self.enable_coverage and self.coverage_data:
            # Coverage data available - inject actual coverage attributes
            coverage_attrs = self.get_coverage_attributes()
            if coverage_attrs:
                self.logger.info(f"TestViper RP: {len(coverage_attrs)} coverage attributes ready for ReportPortal launch")
                for attr in coverage_attrs:
                    self.logger.info(f"TestViper RP: Launch attribute ready - {attr['key']}: {attr['value']}")
            
            # Log coverage summary for launch context
            self.log_coverage_summary()
        
        # Inject coverage attributes via environment variables for ReportPortal
        # This handles both cases: with coverage data and without coverage data
        self._inject_rp_launch_attributes()
    
    def pytest_runtest_setup(self, item):
        """Hook called before each test"""
        test_name = item.nodeid
        self.test_metrics[test_name] = TVReportMetrics(
            test_name=test_name,
            start_time=time.time()
        )
        self.logger.info(f"TestViper RP: Starting test {test_name}")
    
    def pytest_runtest_call(self, item):
        """Hook called during test execution"""
        test_name = item.nodeid
        if test_name in self.test_metrics:
            self.logger.info(f"TestViper RP: Executing test {test_name}")
    
    def pytest_runtest_teardown(self, item):
        """Hook called after each test"""
        test_name = item.nodeid
        if test_name in self.test_metrics:
            metric = self.test_metrics[test_name]
            metric.end_time = time.time()
            metric.duration = metric.end_time - metric.start_time
            self.logger.info(f"TestViper RP: Test completed {test_name} (Duration: {metric.duration:.2f}s)")
    
    def pytest_runtest_makereport(self, item, call):
        """Hook called to create test reports"""
        if call.when == "call":
            test_name = item.nodeid
            if test_name in self.test_metrics:
                metric = self.test_metrics[test_name]
                
                if call.excinfo is None:
                    metric.status = "passed"
                    self.logger.info(f"TestViper RP: Test PASSED {test_name}")
                else:
                    metric.status = "failed"
                    metric.error_message = str(call.excinfo.value)
                    self.logger.error(f"TestViper RP: Test FAILED {test_name} - {metric.error_message}")
                    
                    # Capture failure details
                    self.tv_capture_failure_details(item, call.excinfo)
    
    def tv_capture_failure_details(self, item, excinfo):
        """Capture detailed failure information with TV namespace"""
        test_name = item.nodeid.replace("::", "_").replace("/", "_")
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        
        # Create failure log
        failure_log_path = self.tv_logs_dir / f"tv_failure_{test_name}_{timestamp}.log"
        
        with open(failure_log_path, "w") as f:
            f.write(f"TestViper ReportPortal Failure Report\n")
            f.write("=" * 50 + "\n")
            f.write(f"Test: {item.nodeid}\n")
            f.write(f"Time: {datetime.now().isoformat()}\n")
            f.write(f"Exception: {excinfo.typename}\n")
            f.write(f"Message: {excinfo.value}\n")
            f.write("\nTraceback:\n")
            f.write("".join(traceback.format_exception(excinfo.type, excinfo.value, excinfo.tb)))
        
        # Add to test metrics
        if item.nodeid in self.test_metrics:
            self.test_metrics[item.nodeid].log_attachments.append(str(failure_log_path))
        
        self.logger.info(f"TestViper RP: Failure details captured at {failure_log_path}")
    
    def tv_capture_screenshot(self, test_name: str, driver=None) -> Optional[str]:
        """Capture screenshot with TV namespace"""
        if not os.getenv("TV_ENABLE_SCREENSHOTS", "true").lower() == "true":
            return None
        
        try:
            if driver is None:
                self.logger.warning("TestViper RP: No driver provided for screenshot capture")
                return None
            
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            safe_test_name = test_name.replace("::", "_").replace("/", "_")
            screenshot_path = self.tv_screenshots_dir / f"tv_screenshot_{safe_test_name}_{timestamp}.png"
            
            driver.save_screenshot(str(screenshot_path))
            self.logger.info(f"TestViper RP: Screenshot captured at {screenshot_path}")
            
            return str(screenshot_path)
            
        except Exception as e:
            self.logger.error(f"TestViper RP: Failed to capture screenshot: {e}")
            return None
    
    def tv_attach_log_file(self, test_name: str, log_content: str, filename: str = None):
        """Attach custom log file to test with TV namespace"""
        if not os.getenv("TV_ENABLE_LOG_ATTACHMENTS", "true").lower() == "true":
            return
        
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        safe_test_name = test_name.replace("::", "_").replace("/", "_")
        
        if filename is None:
            filename = f"tv_custom_{safe_test_name}_{timestamp}.log"
        
        log_path = self.tv_attachments_dir / filename
        
        with open(log_path, "w") as f:
            f.write(f"TestViper ReportPortal Custom Log\n")
            f.write("=" * 40 + "\n")
            f.write(f"Test: {test_name}\n")
            f.write(f"Time: {datetime.now().isoformat()}\n")
            f.write("=" * 40 + "\n\n")
            f.write(log_content)
        
        if test_name in self.test_metrics:
            self.test_metrics[test_name].log_attachments.append(str(log_path))
        
        self.logger.info(f"TestViper RP: Custom log attachment created at {log_path}")
    
    def tv_add_test_attribute(self, test_name: str, key: str, value: Any):
        """Add custom attribute to test with TV namespace"""
        if test_name in self.test_metrics:
            self.test_metrics[test_name].custom_attributes[key] = value
            self.logger.info(f"TestViper RP: Added attribute {key}={value} to test {test_name}")
    
    def pytest_sessionfinish(self, session):
        """Hook called at the end of test session"""
        if self.session_start_time is None:
            return
        
        session_end_time = datetime.now()
        total_duration = (session_end_time - self.session_start_time).total_seconds()
        
        self.logger.info(f"TestViper ReportPortal session completed at {session_end_time}")
        self.logger.info(f"Total session duration: {total_duration:.2f}s")
        
        # Log coverage summary
        self.log_coverage_summary()
        
        # Generate session summary
        self.tv_generate_session_summary(session_end_time, total_duration)
    
    def tv_generate_session_summary(self, session_end_time: datetime, total_duration: float):
        """Generate comprehensive session summary with TV namespace"""
        summary = {
            "testviper_rp_summary": {
                "session_info": {
                    "start_time": self.session_start_time.isoformat(),
                    "end_time": session_end_time.isoformat(),
                    "total_duration": total_duration,
                    "reporter_version": "1.0.0"
                },
                "test_summary": {},
                "test_details": {},
                "environment_info": {
                    "python_version": sys.version,
                    "platform": sys.platform,
                    "working_directory": str(Path.cwd()),
                    "reportportal_endpoint": os.getenv("RP_ENDPOINT", "http://localhost:8080"),
                    "reportportal_project": os.getenv("RP_PROJECT", "testviper")
                },
                "coverage_info": self._get_coverage_summary() if self.coverage_data else {
                    "component": self.component_name,
                    "coverage_percentage": 0,
                    "statements_total": 0,
                    "statements_missing": 0,
                    "coverage_quality": "no_source_code"
                }
            }
        }
        
        # Process test metrics
        total_tests = len(self.test_metrics)
        passed_tests = sum(1 for m in self.test_metrics.values() if m.status == "passed")
        failed_tests = sum(1 for m in self.test_metrics.values() if m.status == "failed")
        
        summary["testviper_rp_summary"]["test_summary"] = {
            "total_tests": total_tests,
            "passed": passed_tests,
            "failed": failed_tests,
            "pass_rate": (passed_tests / total_tests * 100) if total_tests > 0 else 0,
            "average_duration": sum(m.duration for m in self.test_metrics.values() if m.duration) / total_tests if total_tests > 0 else 0
        }
        
        # Convert test metrics to serializable format
        for test_name, metric in self.test_metrics.items():
            summary["testviper_rp_summary"]["test_details"][test_name] = {
                "status": metric.status,
                "duration": metric.duration,
                "error_message": metric.error_message,
                "log_attachments": metric.log_attachments,
                "screenshot_path": metric.screenshot_path,
                "custom_attributes": metric.custom_attributes
            }
        
        # Save summary with safe JSON serialization
        summary_file = self.tv_json_dir / f"tv_session_summary_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
        with open(summary_file, "w") as f:
            json.dump(summary, f, indent=2, default=self._json_serializer)
        
        self.logger.info(f"TestViper RP: Session summary generated at {summary_file}")
        
        # Print summary to console
        print("\n" + "=" * 60)
        print("🎯 TestViper ReportPortal Session Summary")
        print("=" * 60)
        print(f"📊 Total Tests: {total_tests}")
        print(f"✅ Passed: {passed_tests}")
        print(f"❌ Failed: {failed_tests}")
        print(f"📈 Pass Rate: {summary['testviper_rp_summary']['test_summary']['pass_rate']:.1f}%")
        print(f"⏱️  Total Duration: {total_duration:.2f}s")
        print(f"💾 Reports saved to: {self.base_reports_dir.absolute()}")
        print("=" * 60)
        
        # Log coverage summary if available
        if self.enable_coverage:
            self.log_coverage_summary()
    
    def _load_coverage_data(self) -> Dict[str, Any]:
        """Load coverage data from JSON file."""
        try:
            if os.path.exists(self.coverage_file):
                with open(self.coverage_file, 'r') as f:
                    data = json.load(f)
                    self.logger.info(f"TestViper RP: Loaded coverage data from {self.coverage_file}")
                    return data.get("totals", {})
        except Exception as e:
            self.logger.warning(f"TestViper RP: Could not load coverage data from {self.coverage_file}: {e}")
        return {}
    
    def _get_coverage_summary(self) -> Dict[str, Any]:
        """Get coverage summary for session info."""
        if not self.coverage_data:
            return {}
        
        return {
            "component": self.component_name,
            "coverage_percentage": self.coverage_data.get("percent_covered", 0),
            "statements_total": self.coverage_data.get("num_statements", 0),
            "statements_missing": self.coverage_data.get("missing_lines", 0),
            "coverage_quality": self._get_coverage_quality(self.coverage_data.get("percent_covered", 0))
        }
    
    def get_coverage_attributes(self) -> list:
        """Generate coverage-related attributes for ReportPortal."""
        attributes = []
        
        if self.coverage_data:
            # Core coverage metrics
            coverage_pct = self.coverage_data.get("percent_covered", 0)
            attributes.extend([
                {
                    "key": "tv_coverage_percentage",
                    "value": f"{coverage_pct:.1f}%",
                    "system": False
                },
                {
                    "key": "tv_coverage_component", 
                    "value": self.component_name,
                    "system": False
                },
                {
                    "key": "tv_coverage_statements",
                    "value": str(self.coverage_data.get("num_statements", 0)),
                    "system": False
                },
                {
                    "key": "tv_coverage_missing",
                    "value": str(self.coverage_data.get("missing_lines", 0)),
                    "system": False
                }
            ])
            
            # Coverage quality indicator
            if coverage_pct >= 80:
                quality = "high"
            elif coverage_pct >= 60:
                quality = "medium"
            else:
                quality = "low"
                
            attributes.append({
                "key": "tv_coverage_quality",
                "value": quality,
                "system": False
            })
            
            self.logger.info(f"TestViper RP: Generated {len(attributes)} coverage attributes for component {self.component_name}")
        
        return attributes
    
    def _inject_rp_launch_attributes(self):
        """Inject coverage attributes into ReportPortal launch via API"""
        try:
            import requests
            
            # Get ReportPortal configuration
            rp_endpoint = os.getenv("RP_ENDPOINT", "http://localhost:8080")
            rp_project = os.getenv("RP_PROJECT", "testviper")
            rp_token = os.getenv("RP_API_KEY", "")
            
            if not rp_token:
                self.logger.warning("TestViper RP: No RP_API_KEY found, cannot inject launch attributes")
                return
            
            # Prepare coverage attributes
            if not self.coverage_data:
                attributes = [
                    {"key": "tv_coverage_percentage", "value": "0%"},
                    {"key": "tv_coverage_component", "value": str(self.component_name)},
                    {"key": "tv_coverage_status", "value": "no_source_code"}
                ]
                self.logger.info(f"TestViper RP: No coverage data for component {self.component_name} - setting coverage attributes to 0")
            else:
                attributes = self.get_coverage_attributes()
                self.logger.info(f"TestViper RP: Using actual coverage data for {self.component_name}")
            
            # Store attributes to inject later when we have launch ID
            self.pending_launch_attributes = attributes
            
            for attr in attributes:
                self.logger.info(f"TestViper RP: Will inject launch attribute {attr['key']}={attr['value']}")
                
        except Exception as e:
            self.logger.error(f"TestViper RP: Error preparing launch attributes: {e}")
    
    def pytest_runtest_logfinish(self, nodeid, location):
        """Hook called at the end of running a test (after call and teardown)"""
        # Try to inject launch attributes if we haven't done so yet
        if hasattr(self, 'pending_launch_attributes') and self.pending_launch_attributes:
            self._inject_launch_attributes_via_api()
    
    def pytest_sessionfinish(self, session, exitstatus):
        """Hook called after whole test run finished, including teardown"""
        # Final attempt to inject launch attributes at the end of the session
        if hasattr(self, 'pending_launch_attributes') and self.pending_launch_attributes:
            import time
            time.sleep(2)  # Give ReportPortal time to fully create the launch
            self.logger.info("TestViper RP: Final attempt to inject launch attributes")
            self._inject_launch_attributes_via_api()
    
    def _inject_launch_attributes_via_api(self):
        """Inject launch attributes using ReportPortal API"""
        try:
            import requests
            
            # Get ReportPortal configuration
            rp_endpoint = os.getenv("RP_ENDPOINT", "http://localhost:8080")
            rp_project = os.getenv("RP_PROJECT", "testviper")
            rp_token = os.getenv("RP_API_KEY", "")
            
            if not rp_token or not hasattr(self, 'pending_launch_attributes'):
                return
            
            # Try to get the launch ID directly from the pytest-reportportal plugin
            launch_id = None
            try:
                # Use the stored plugin instance from pytest_sessionstart
                if hasattr(self, 'rp_plugin') and self.rp_plugin:
                    # Access the ReportPortal service through the plugin
                    rp_service = getattr(self.rp_plugin, 'rp_service', None)
                    if rp_service:
                        # Try different ways to get the launch ID
                        if hasattr(rp_service, 'launch_uuid'):
                            launch_id = rp_service.launch_uuid
                        elif hasattr(rp_service, 'launch_id'):
                            launch_id = rp_service.launch_id
                        elif hasattr(rp_service, '_launch_uuid'):
                            launch_id = rp_service._launch_uuid
                        elif hasattr(rp_service, 'current_item'):
                            # Sometimes launch ID is in the current item
                            current_item = rp_service.current_item
                            if current_item and hasattr(current_item, 'launch_uuid'):
                                launch_id = current_item.launch_uuid
                        
                        if launch_id:
                            self.logger.info(f"TestViper RP: Got launch ID from pytest-reportportal plugin: {launch_id}")
                        else:
                            self.logger.warning("TestViper RP: No launch ID found in pytest-reportportal plugin")
                    else:
                        self.logger.warning("TestViper RP: No rp_service found in pytest-reportportal plugin")
                else:
                    self.logger.warning("TestViper RP: No stored pytest-reportportal plugin instance")
                    
            except Exception as e:
                self.logger.error(f"TestViper RP: Error getting launch ID from pytest-reportportal: {e}")
            
            # If we couldn't get the launch ID from the session, skip attribute injection
            if not launch_id:
                self.logger.warning("TestViper RP: Cannot inject attributes without launch ID")
                return
            
            headers = {
                "Authorization": f"Bearer {rp_token}",
                "Content-Type": "application/json"
            }
            
            # Get the current launch to retrieve existing attributes
            launch_url = f"{rp_endpoint}/api/v1/{rp_project}/launch/{launch_id}"
            response = requests.get(launch_url, headers=headers)
            
            if response.status_code == 200:
                current_launch = response.json()
                
                # Update launch with attributes
                update_url = f"{rp_endpoint}/api/v1/{rp_project}/launch/{launch_id}/update"
                
                # Get existing attributes and add our coverage attributes
                existing_attributes = current_launch.get("attributes", [])
                
                # Remove any existing tv_coverage attributes to avoid duplicates
                filtered_attributes = [attr for attr in existing_attributes 
                                     if not attr.get("key", "").startswith("tv_coverage")]
                
                # Add our new coverage attributes
                all_attributes = filtered_attributes + self.pending_launch_attributes
                
                update_data = {
                    "attributes": all_attributes
                }
                
                response = requests.put(update_url, headers=headers, json=update_data)
                if response.status_code == 200:
                    self.logger.info(f"TestViper RP: Successfully injected {len(self.pending_launch_attributes)} coverage attributes to launch {launch_id}")
                    for attr in self.pending_launch_attributes:
                        self.logger.info(f"TestViper RP: Injected attribute {attr['key']}={attr['value']}")
                    # Clear pending attributes
                    self.pending_launch_attributes = []
                else:
                    self.logger.error(f"TestViper RP: Failed to update launch attributes: {response.status_code} - {response.text}")
            else:
                self.logger.error(f"TestViper RP: Failed to get launch {launch_id}: {response.status_code}")
                
        except Exception as e:
            self.logger.error(f"TestViper RP: Error injecting launch attributes via API: {e}")
    
    def _get_coverage_quality(self, coverage_pct: float) -> str:
        """Determine coverage quality based on percentage."""
        if coverage_pct >= 80:
            return "high"
        elif coverage_pct >= 60:
            return "medium"
        else:
            return "low"
    
    def _json_serializer(self, obj):
        """Custom JSON serializer for handling non-serializable objects."""
        try:
            # Handle datetime objects
            if hasattr(obj, 'isoformat'):
                return obj.isoformat()
            # Handle Path objects
            elif hasattr(obj, '__fspath__'):
                return str(obj)
            # Handle exceptions and other problematic objects
            elif hasattr(obj, '__class__'):
                if 'Exc' in obj.__class__.__name__ or 'Exception' in obj.__class__.__name__:
                    return str(obj)
                # Try to convert to string for any other object
                return str(obj)
            else:
                return str(obj)
        except Exception:
            # Last resort - return object type name
            return f"<{type(obj).__name__}>"
    
    def enhance_launch_attributes(self, existing_attributes: list = None) -> list:
        """Add coverage attributes to launch."""
        attributes = existing_attributes or []
        coverage_attrs = self.get_coverage_attributes()
        attributes.extend(coverage_attrs)
        return attributes
    
    def log_coverage_summary(self):
        """Log coverage summary to console and files."""
        if self.coverage_data:
            coverage_pct = self.coverage_data.get("percent_covered", 0)
            statements = self.coverage_data.get("num_statements", 0)
            missing = self.coverage_data.get("missing_lines", 0)
            
            print("\n" + "="*50)
            print("📈 COVERAGE SUMMARY")
            print("="*50)
            print(f"   Component: {self.component_name}")
            print(f"   Coverage: {coverage_pct:.1f}%")
            print(f"   Statements: {statements}")
            print(f"   Missing lines: {missing}")
            print("="*50)
            
            self.logger.info(f"TestViper RP: Coverage Summary - {self.component_name}: {coverage_pct:.1f}% ({statements} statements, {missing} missing)")

# Global instance for easy access
_tv_reporter_instance = None

def get_tv_reporter() -> TVReportPortalEnhancer:
    """Get the global TestViper ReportPortal reporter instance"""
    global _tv_reporter_instance
    if _tv_reporter_instance is None:
        _tv_reporter_instance = TVReportPortalEnhancer()
    return _tv_reporter_instance

def tv_log_test_info(test_name: str, message: str):
    """Convenience function to log test information"""
    reporter = get_tv_reporter()
    reporter.tv_attach_log_file(test_name, message)

def tv_add_test_tag(test_name: str, tag: str):
    """Convenience function to add test tag"""
    reporter = get_tv_reporter()
    reporter.tv_add_test_attribute(test_name, "tag", tag)

def tv_mark_test_performance(test_name: str, duration: float):
    """Convenience function to mark test performance"""
    reporter = get_tv_reporter()
    reporter.tv_add_test_attribute(test_name, "performance_duration", duration)