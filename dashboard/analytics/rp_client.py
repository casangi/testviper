"""
TestViper ReportPortal API Client
Handles communication with ReportPortal API for dashboard data
"""

import os
import requests
import json
import logging
from typing import Dict, List, Optional, Any
from datetime import datetime, timedelta
from dataclasses import dataclass, field
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

@dataclass
class TVLaunchData:
    """Data class for ReportPortal launch information"""
    id: str
    name: str
    start_time: datetime
    end_time: Optional[datetime] = None
    status: str = "IN_PROGRESS"
    total_tests: int = 0
    passed_tests: int = 0
    failed_tests: int = 0
    skipped_tests: int = 0
    statistics: Dict[str, Any] = field(default_factory=dict)
    attributes: List[Dict[str, str]] = field(default_factory=list)

@dataclass
class TVTestItemData:
    """Data class for individual test item information"""
    id: str
    name: str
    status: str
    start_time: datetime
    end_time: Optional[datetime] = None
    duration: Optional[float] = None
    parameters: Dict[str, Any] = field(default_factory=dict)
    logs: List[Dict[str, Any]] = field(default_factory=list)

class TVReportPortalClient:
    """
    TestViper ReportPortal API Client
    
    Provides methods to fetch and analyze data from ReportPortal API
    """
    
    def __init__(self, endpoint: str = None, project: str = None, api_key: str = None):
        """Initialize ReportPortal client"""
        self.endpoint = endpoint or os.getenv("RP_ENDPOINT", "http://localhost:8080")
        self.project = project or os.getenv("RP_PROJECT", "testviper")
        self.api_key = api_key or os.getenv("RP_API_KEY")
        
        # Setup logging
        self.logger = logging.getLogger("testviper.rp_client")
        
        # Setup session
        self.session = requests.Session()
        if self.api_key:
            self.session.headers.update({
                "Authorization": f"Bearer {self.api_key}",
                "Content-Type": "application/json"
            })
        
        self.base_url = f"{self.endpoint}/api/v1/{self.project}"
        
        self.logger.info(f"TVReportPortalClient initialized for {self.endpoint}/{self.project}")
    
    def get_launches(self, limit: int = 50, status: str = None) -> List[TVLaunchData]:
        """Get recent launches from ReportPortal"""
        try:
            params = {"page.size": limit, "page.sort": "startTime,desc"}
            if status:
                params["filter.eq.status"] = status
            
            response = self.session.get(f"{self.base_url}/launch", params=params)
            response.raise_for_status()
            
            data = response.json()
            launches = []
            
            for launch_data in data.get("content", []):
                launch = TVLaunchData(
                    id=launch_data.get("id"),
                    name=launch_data.get("name"),
                    start_time=self._parse_timestamp(launch_data.get("startTime")),
                    end_time=self._parse_timestamp(launch_data.get("endTime")),
                    status=launch_data.get("status", "UNKNOWN"),
                    statistics=launch_data.get("statistics", {}),
                    attributes=launch_data.get("attributes", [])
                )
                
                # Extract test counts from statistics
                stats = launch.statistics.get("executions", {})
                launch.total_tests = stats.get("total", 0)
                launch.passed_tests = stats.get("passed", 0)
                launch.failed_tests = stats.get("failed", 0)
                launch.skipped_tests = stats.get("skipped", 0)
                
                launches.append(launch)
            
            self.logger.info(f"Retrieved {len(launches)} launches from ReportPortal")
            return launches
            
        except Exception as e:
            self.logger.error(f"Error retrieving launches: {e}")
            return []
    
    def get_launch_details(self, launch_id: str) -> Optional[TVLaunchData]:
        """Get detailed information about a specific launch"""
        try:
            response = self.session.get(f"{self.base_url}/launch/{launch_id}")
            response.raise_for_status()
            
            data = response.json()
            launch = TVLaunchData(
                id=data.get("id"),
                name=data.get("name"),
                start_time=self._parse_timestamp(data.get("startTime")),
                end_time=self._parse_timestamp(data.get("endTime")),
                status=data.get("status", "UNKNOWN"),
                statistics=data.get("statistics", {}),
                attributes=data.get("attributes", [])
            )
            
            # Extract test counts
            stats = launch.statistics.get("executions", {})
            launch.total_tests = stats.get("total", 0)
            launch.passed_tests = stats.get("passed", 0)
            launch.failed_tests = stats.get("failed", 0)
            launch.skipped_tests = stats.get("skipped", 0)
            
            return launch
            
        except Exception as e:
            self.logger.error(f"Error retrieving launch {launch_id}: {e}")
            return None
    
    def get_test_items(self, launch_id: str, limit: int = 100) -> List[TVTestItemData]:
        """Get test items for a specific launch"""
        try:
            params = {"page.size": limit}
            response = self.session.get(f"{self.base_url}/item", params=params)
            response.raise_for_status()
            
            data = response.json()
            test_items = []
            
            for item_data in data.get("content", []):
                # Filter for the specific launch
                if item_data.get("launchId") == launch_id:
                    item = TVTestItemData(
                        id=item_data.get("id"),
                        name=item_data.get("name"),
                        status=item_data.get("status", "UNKNOWN"),
                        start_time=self._parse_timestamp(item_data.get("startTime")),
                        end_time=self._parse_timestamp(item_data.get("endTime")),
                        parameters=item_data.get("parameters", {})
                    )
                    
                    # Calculate duration
                    if item.start_time and item.end_time:
                        item.duration = (item.end_time - item.start_time).total_seconds()
                    
                    test_items.append(item)
            
            self.logger.info(f"Retrieved {len(test_items)} test items for launch {launch_id}")
            return test_items
            
        except Exception as e:
            self.logger.error(f"Error retrieving test items for launch {launch_id}: {e}")
            return []
    
    def get_failed_tests(self, days: int = 7) -> List[Dict[str, Any]]:
        """Get failed tests from recent launches"""
        try:
            # Get recent launches
            launches = self.get_launches(limit=50, status="FAILED")
            
            # Filter launches from the last N days
            cutoff_date = datetime.now() - timedelta(days=days)
            recent_launches = [l for l in launches if l.start_time >= cutoff_date]
            
            failed_tests = []
            for launch in recent_launches:
                test_items = self.get_test_items(launch.id)
                for item in test_items:
                    if item.status == "FAILED":
                        failed_tests.append({
                            "launch_id": launch.id,
                            "launch_name": launch.name,
                            "test_name": item.name,
                            "failure_time": item.end_time,
                            "duration": item.duration
                        })
            
            self.logger.info(f"Found {len(failed_tests)} failed tests in last {days} days")
            return failed_tests
            
        except Exception as e:
            self.logger.error(f"Error retrieving failed tests: {e}")
            return []
    
    def get_dashboard_metrics(self) -> Dict[str, Any]:
        """Get comprehensive metrics for dashboard display"""
        try:
            launches = self.get_launches(limit=20)
            
            if not launches:
                return {
                    "total_launches": 0,
                    "recent_launches": [],
                    "pass_rate": 0,
                    "avg_duration": 0,
                    "failed_tests": 0,
                    "flaky_tests": []
                }
            
            # Calculate metrics
            total_tests = sum(l.total_tests for l in launches)
            passed_tests = sum(l.passed_tests for l in launches)
            failed_tests = sum(l.failed_tests for l in launches)
            
            pass_rate = (passed_tests / total_tests * 100) if total_tests > 0 else 0
            
            # Calculate average duration (for completed launches)
            completed_launches = [l for l in launches if l.end_time and l.start_time]
            if completed_launches:
                durations = [(l.end_time - l.start_time).total_seconds() for l in completed_launches]
                avg_duration = sum(durations) / len(durations)
            else:
                avg_duration = 0
            
            # Get recent failed tests
            recent_failed = self.get_failed_tests(days=3)
            
            # Basic flaky test detection (tests that fail intermittently)
            flaky_tests = self._detect_flaky_tests(launches)
            
            return {
                "total_launches": len(launches),
                "recent_launches": [
                    {
                        "name": l.name,
                        "status": l.status,
                        "start_time": l.start_time.isoformat() if l.start_time else None,
                        "pass_rate": (l.passed_tests / l.total_tests * 100) if l.total_tests > 0 else 0,
                        "total_tests": l.total_tests,
                        "failed_tests": l.failed_tests
                    }
                    for l in launches[:10]  # Latest 10 launches
                ],
                "pass_rate": pass_rate,
                "avg_duration": avg_duration,
                "failed_tests": len(recent_failed),
                "flaky_tests": flaky_tests
            }
            
        except Exception as e:
            self.logger.error(f"Error retrieving dashboard metrics: {e}")
            return {"error": str(e)}
    
    def _parse_timestamp(self, timestamp: Optional[int]) -> Optional[datetime]:
        """Parse ReportPortal timestamp (milliseconds since epoch)"""
        if timestamp is None:
            return None
        try:
            return datetime.fromtimestamp(timestamp / 1000.0)
        except (ValueError, TypeError):
            return None
    
    def _detect_flaky_tests(self, launches: List[TVLaunchData]) -> List[Dict[str, Any]]:
        """Basic flaky test detection based on test name patterns"""
        # This is a simplified implementation
        # In a real scenario, we'd need to track individual test results across launches
        flaky_candidates = []
        
        # Look for launches with mixed results (some passed, some failed)
        for launch in launches:
            if launch.passed_tests > 0 and launch.failed_tests > 0:
                flaky_candidates.append({
                    "launch_name": launch.name,
                    "pass_rate": (launch.passed_tests / launch.total_tests * 100) if launch.total_tests > 0 else 0,
                    "total_tests": launch.total_tests,
                    "failed_tests": launch.failed_tests
                })
        
        return flaky_candidates[:5]  # Return top 5 flaky test candidates
    
    def test_connection(self) -> Dict[str, Any]:
        """Test connection to ReportPortal"""
        try:
            response = self.session.get(f"{self.base_url}/launch", params={"page.size": 1})
            response.raise_for_status()
            
            data = response.json()
            return {
                "status": "success",
                "endpoint": self.endpoint,
                "project": self.project,
                "total_launches": data.get("page", {}).get("totalElements", 0),
                "api_authenticated": bool(self.api_key)
            }
            
        except Exception as e:
            return {
                "status": "error",
                "endpoint": self.endpoint,
                "project": self.project,
                "error": str(e),
                "api_authenticated": bool(self.api_key)
            }