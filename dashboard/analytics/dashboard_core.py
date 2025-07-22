"""
TestViper Dashboard Core
Main dashboard logic and metrics display
"""

import json
import os
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional
import logging
from dataclasses import dataclass, field

from .rp_client import TVReportPortalClient

@dataclass
class TVDashboardMetrics:
    """Data class for dashboard metrics"""
    timestamp: datetime
    total_launches: int = 0
    total_tests: int = 0
    passed_tests: int = 0
    failed_tests: int = 0
    skipped_tests: int = 0
    pass_rate: float = 0.0
    avg_duration: float = 0.0
    flaky_tests: int = 0
    recent_failures: List[Dict[str, Any]] = field(default_factory=list)
    performance_trends: Dict[str, Any] = field(default_factory=dict)
    local_session_data: Dict[str, Any] = field(default_factory=dict)

class TVDashboard:
    """
    TestViper Dashboard Core
    
    Provides comprehensive dashboard functionality combining ReportPortal data
    and local enhanced reporting data
    """
    
    def __init__(self, reports_dir: str = "dashboard/reports"):
        """Initialize dashboard"""
        self.reports_dir = Path(reports_dir)
        self.rp_client = TVReportPortalClient()
        self.logger = logging.getLogger("testviper.dashboard")
        
        # Ensure reports directory exists
        self.reports_dir.mkdir(parents=True, exist_ok=True)
        
        self.logger.info(f"TVDashboard initialized with reports dir: {self.reports_dir}")
    
    def get_comprehensive_metrics(self) -> TVDashboardMetrics:
        """Get comprehensive dashboard metrics"""
        try:
            # Get ReportPortal metrics
            rp_metrics = self.rp_client.get_dashboard_metrics()
            
            # Get local session data
            local_metrics = self._get_local_session_metrics()
            
            # Combine metrics
            metrics = TVDashboardMetrics(
                timestamp=datetime.now(),
                total_launches=rp_metrics.get("total_launches", 0),
                pass_rate=rp_metrics.get("pass_rate", 0.0),
                avg_duration=rp_metrics.get("avg_duration", 0.0),
                flaky_tests=len(rp_metrics.get("flaky_tests", [])),
                recent_failures=rp_metrics.get("recent_launches", []),
                local_session_data=local_metrics
            )
            
            # Add local session test counts
            if local_metrics:
                metrics.total_tests = local_metrics.get("total_tests", 0)
                metrics.passed_tests = local_metrics.get("passed_tests", 0)
                metrics.failed_tests = local_metrics.get("failed_tests", 0)
                metrics.skipped_tests = local_metrics.get("skipped_tests", 0)
            
            # Calculate performance trends
            metrics.performance_trends = self._analyze_performance_trends()
            
            self.logger.info(f"Generated comprehensive metrics with {metrics.total_tests} total tests")
            return metrics
            
        except Exception as e:
            self.logger.error(f"Error generating comprehensive metrics: {e}")
            return TVDashboardMetrics(timestamp=datetime.now())
    
    def _get_local_session_metrics(self) -> Dict[str, Any]:
        """Get metrics from local enhanced reporting sessions"""
        try:
            json_dir = self.reports_dir / "tv_json"
            if not json_dir.exists():
                return {}
            
            # Get all session summary files
            session_files = list(json_dir.glob("tv_session_summary_*.json"))
            
            if not session_files:
                return {}
            
            # Get the most recent session
            latest_session = max(session_files, key=lambda f: f.stat().st_mtime)
            
            with open(latest_session, 'r') as f:
                session_data = json.load(f)
            
            # Extract key metrics
            tv_summary = session_data.get("testviper_rp_summary", {})
            test_summary = tv_summary.get("test_summary", {})
            
            return {
                "session_file": str(latest_session),
                "total_tests": test_summary.get("total_tests", 0),
                "passed_tests": test_summary.get("passed", 0),
                "failed_tests": test_summary.get("failed", 0),
                "skipped_tests": test_summary.get("skipped", 0),
                "pass_rate": test_summary.get("pass_rate", 0.0),
                "avg_duration": test_summary.get("average_duration", 0.0),
                "session_info": tv_summary.get("session_info", {}),
                "environment_info": tv_summary.get("environment_info", {}),
                "test_details": tv_summary.get("test_details", {})
            }
            
        except Exception as e:
            self.logger.error(f"Error reading local session metrics: {e}")
            return {}
    
    def _analyze_performance_trends(self) -> Dict[str, Any]:
        """Analyze performance trends from local sessions"""
        try:
            json_dir = self.reports_dir / "tv_json"
            if not json_dir.exists():
                return {}
            
            # Get all session summary files
            session_files = list(json_dir.glob("tv_session_summary_*.json"))
            
            if len(session_files) < 2:
                return {"status": "insufficient_data", "sessions": len(session_files)}
            
            # Analyze recent sessions
            recent_sessions = sorted(session_files, key=lambda f: f.stat().st_mtime)[-10:]
            
            trends = {
                "session_count": len(recent_sessions),
                "duration_trend": [],
                "pass_rate_trend": [],
                "test_count_trend": [],
                "slowest_tests": [],
                "most_failing_tests": []
            }
            
            for session_file in recent_sessions:
                try:
                    with open(session_file, 'r') as f:
                        session_data = json.load(f)
                    
                    tv_summary = session_data.get("testviper_rp_summary", {})
                    test_summary = tv_summary.get("test_summary", {})
                    session_info = tv_summary.get("session_info", {})
                    
                    # Extract trends
                    trends["duration_trend"].append({
                        "session": session_file.name,
                        "duration": session_info.get("total_duration", 0)
                    })
                    
                    trends["pass_rate_trend"].append({
                        "session": session_file.name,
                        "pass_rate": test_summary.get("pass_rate", 0)
                    })
                    
                    trends["test_count_trend"].append({
                        "session": session_file.name,
                        "total_tests": test_summary.get("total_tests", 0)
                    })
                    
                    # Analyze individual test performance
                    test_details = tv_summary.get("test_details", {})
                    for test_name, test_data in test_details.items():
                        if test_data.get("duration"):
                            trends["slowest_tests"].append({
                                "test_name": test_name,
                                "duration": test_data["duration"],
                                "session": session_file.name
                            })
                        
                        if test_data.get("status") == "failed":
                            trends["most_failing_tests"].append({
                                "test_name": test_name,
                                "error": test_data.get("error_message", "Unknown error"),
                                "session": session_file.name
                            })
                
                except Exception as e:
                    self.logger.warning(f"Error processing session file {session_file}: {e}")
                    continue
            
            # Sort and limit results
            trends["slowest_tests"] = sorted(
                trends["slowest_tests"], 
                key=lambda x: x["duration"], 
                reverse=True
            )[:10]
            
            trends["most_failing_tests"] = trends["most_failing_tests"][-10:]
            
            return trends
            
        except Exception as e:
            self.logger.error(f"Error analyzing performance trends: {e}")
            return {"error": str(e)}
    
    def generate_dashboard_report(self, output_file: str = None) -> str:
        """Generate comprehensive dashboard report"""
        try:
            metrics = self.get_comprehensive_metrics()
            
            # Create report data
            report_data = {
                "dashboard_report": {
                    "generated_at": metrics.timestamp.isoformat(),
                    "summary": {
                        "total_launches": metrics.total_launches,
                        "total_tests": metrics.total_tests,
                        "passed_tests": metrics.passed_tests,
                        "failed_tests": metrics.failed_tests,
                        "skipped_tests": metrics.skipped_tests,
                        "pass_rate": metrics.pass_rate,
                        "avg_duration": metrics.avg_duration,
                        "flaky_tests": metrics.flaky_tests
                    },
                    "recent_failures": metrics.recent_failures,
                    "performance_trends": metrics.performance_trends,
                    "local_session_data": metrics.local_session_data,
                    "connection_status": self.rp_client.test_connection()
                }
            }
            
            # Save report
            if output_file is None:
                output_file = self.reports_dir / "tv_json" / f"tv_dashboard_report_{datetime.now().strftime('%Y%m%d_%H%M%S')}.json"
            
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            
            with open(output_path, 'w') as f:
                json.dump(report_data, f, indent=2)
            
            self.logger.info(f"Dashboard report generated: {output_path}")
            return str(output_path)
            
        except Exception as e:
            self.logger.error(f"Error generating dashboard report: {e}")
            raise
    
    def get_test_failure_analysis(self, days: int = 7) -> Dict[str, Any]:
        """Get detailed test failure analysis"""
        try:
            # Get ReportPortal failed tests
            rp_failures = self.rp_client.get_failed_tests(days=days)
            
            # Get local failure data
            local_failures = self._get_local_failure_data()
            
            analysis = {
                "analysis_period_days": days,
                "reportportal_failures": rp_failures,
                "local_failures": local_failures,
                "failure_patterns": self._analyze_failure_patterns(rp_failures + local_failures),
                "recommendations": self._generate_failure_recommendations(rp_failures + local_failures)
            }
            
            return analysis
            
        except Exception as e:
            self.logger.error(f"Error generating failure analysis: {e}")
            return {"error": str(e)}
    
    def _get_local_failure_data(self) -> List[Dict[str, Any]]:
        """Get failure data from local logs"""
        try:
            logs_dir = self.reports_dir / "tv_logs"
            if not logs_dir.exists():
                return []
            
            failure_files = list(logs_dir.glob("tv_failure_*.log"))
            failures = []
            
            for failure_file in failure_files:
                try:
                    with open(failure_file, 'r') as f:
                        content = f.read()
                    
                    # Extract basic failure info from filename and content
                    failures.append({
                        "source": "local",
                        "test_name": failure_file.name.replace("tv_failure_", "").replace(".log", ""),
                        "failure_time": datetime.fromtimestamp(failure_file.stat().st_mtime),
                        "log_file": str(failure_file),
                        "content_preview": content[:200] + "..." if len(content) > 200 else content
                    })
                except Exception as e:
                    self.logger.warning(f"Error processing failure file {failure_file}: {e}")
            
            return failures
            
        except Exception as e:
            self.logger.error(f"Error getting local failure data: {e}")
            return []
    
    def _analyze_failure_patterns(self, failures: List[Dict[str, Any]]) -> Dict[str, Any]:
        """Analyze patterns in test failures"""
        if not failures:
            return {"status": "no_failures"}
        
        patterns = {
            "most_common_failures": {},
            "failure_times": [],
            "error_types": {},
            "flaky_candidates": []
        }
        
        for failure in failures:
            test_name = failure.get("test_name", "unknown")
            
            # Count test failures
            if test_name in patterns["most_common_failures"]:
                patterns["most_common_failures"][test_name] += 1
            else:
                patterns["most_common_failures"][test_name] = 1
            
            # Track failure times
            failure_time = failure.get("failure_time")
            if failure_time:
                patterns["failure_times"].append({
                    "test": test_name,
                    "time": failure_time.isoformat() if isinstance(failure_time, datetime) else str(failure_time)
                })
        
        # Identify flaky candidates (tests that fail multiple times)
        patterns["flaky_candidates"] = [
            {"test": test, "failure_count": count}
            for test, count in patterns["most_common_failures"].items()
            if count > 1
        ]
        
        return patterns
    
    def _generate_failure_recommendations(self, failures: List[Dict[str, Any]]) -> List[str]:
        """Generate recommendations based on failure analysis"""
        recommendations = []
        
        if not failures:
            recommendations.append("✅ No recent test failures detected")
            return recommendations
        
        failure_count = len(failures)
        
        if failure_count > 10:
            recommendations.append(f"⚠️  High failure rate detected ({failure_count} failures)")
            recommendations.append("Consider reviewing test stability and environment configuration")
        
        if failure_count > 5:
            recommendations.append("🔍 Investigate common failure patterns")
            recommendations.append("Consider adding retry logic for flaky tests")
        
        recommendations.append("📊 Monitor failure trends over time")
        recommendations.append("🔧 Review test logs for root cause analysis")
        
        return recommendations
    
    def get_dashboard_summary(self) -> Dict[str, Any]:
        """Get a quick dashboard summary for display"""
        try:
            metrics = self.get_comprehensive_metrics()
            
            return {
                "status": "success",
                "timestamp": metrics.timestamp.isoformat(),
                "summary": {
                    "total_tests": metrics.total_tests,
                    "pass_rate": f"{metrics.pass_rate:.1f}%",
                    "avg_duration": f"{metrics.avg_duration:.2f}s",
                    "recent_launches": metrics.total_launches,
                    "flaky_tests": metrics.flaky_tests
                },
                "health_indicators": {
                    "pass_rate_status": "good" if metrics.pass_rate >= 90 else "warning" if metrics.pass_rate >= 70 else "critical",
                    "performance_status": "good" if metrics.avg_duration < 60 else "warning" if metrics.avg_duration < 120 else "slow",
                    "stability_status": "stable" if metrics.flaky_tests < 3 else "unstable"
                },
                "local_session_available": bool(metrics.local_session_data),
                "reportportal_connected": metrics.total_launches > 0
            }
            
        except Exception as e:
            self.logger.error(f"Error generating dashboard summary: {e}")
            return {
                "status": "error",
                "error": str(e),
                "timestamp": datetime.now().isoformat()
            }