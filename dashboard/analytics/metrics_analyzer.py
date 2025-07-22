"""
TestViper Metrics Analyzer
Advanced analytics and insights for test metrics
"""

import json
import statistics
from pathlib import Path
from datetime import datetime, timedelta
from typing import Dict, List, Any, Optional, Tuple
from dataclasses import dataclass, field
from collections import defaultdict, Counter
import logging

@dataclass
class TVTestTrend:
    """Data class for test trend analysis"""
    test_name: str
    trend_type: str  # "improving", "degrading", "stable", "flaky"
    confidence: float  # 0.0 to 1.0
    data_points: int
    avg_duration: float
    success_rate: float
    recent_failures: int
    recommendations: List[str] = field(default_factory=list)

@dataclass
class TVPerformanceInsight:
    """Data class for performance insights"""
    insight_type: str  # "slow_test", "performance_regression", "improvement"
    test_name: str
    metric_value: float
    baseline_value: float
    change_percentage: float
    severity: str  # "low", "medium", "high"
    description: str

class TVMetricsAnalyzer:
    """
    TestViper Metrics Analyzer
    
    Provides advanced analytics and insights for test metrics
    """
    
    def __init__(self, reports_dir: str = "dashboard/reports"):
        """Initialize metrics analyzer"""
        self.reports_dir = Path(reports_dir)
        self.logger = logging.getLogger("testviper.metrics_analyzer")
        
        # Analysis thresholds
        self.slow_test_threshold = 30.0  # seconds
        self.flaky_test_threshold = 0.7   # 70% success rate
        self.performance_regression_threshold = 0.5  # 50% increase
        
        self.logger.info("TVMetricsAnalyzer initialized")
    
    def analyze_test_trends(self, days: int = 14) -> List[TVTestTrend]:
        """Analyze test trends over time"""
        try:
            session_data = self._load_recent_sessions(days)
            if not session_data:
                return []
            
            # Group tests by name
            test_groups = defaultdict(list)
            for session in session_data:
                test_details = session.get("test_details", {})
                session_time = session.get("session_info", {}).get("start_time", "")
                
                for test_name, test_data in test_details.items():
                    test_groups[test_name].append({
                        "session_time": session_time,
                        "status": test_data.get("status", "unknown"),
                        "duration": test_data.get("duration", 0),
                        "error_message": test_data.get("error_message")
                    })
            
            trends = []
            for test_name, test_history in test_groups.items():
                if len(test_history) >= 3:  # Need at least 3 data points
                    trend = self._analyze_single_test_trend(test_name, test_history)
                    trends.append(trend)
            
            # Sort by confidence and severity
            trends.sort(key=lambda t: (t.confidence, t.recent_failures), reverse=True)
            
            self.logger.info(f"Analyzed trends for {len(trends)} tests")
            return trends
            
        except Exception as e:
            self.logger.error(f"Error analyzing test trends: {e}")
            return []
    
    def _analyze_single_test_trend(self, test_name: str, test_history: List[Dict[str, Any]]) -> TVTestTrend:
        """Analyze trend for a single test"""
        # Sort by session time
        sorted_history = sorted(test_history, key=lambda x: x.get("session_time", ""))
        
        # Calculate metrics
        durations = [h["duration"] for h in sorted_history if h["duration"] > 0]
        statuses = [h["status"] for h in sorted_history]
        
        success_count = sum(1 for s in statuses if s == "passed")
        success_rate = success_count / len(statuses) if statuses else 0
        
        avg_duration = statistics.mean(durations) if durations else 0
        recent_failures = sum(1 for s in statuses[-5:] if s == "failed")  # Last 5 runs
        
        # Determine trend type
        trend_type = "stable"
        confidence = 0.5
        recommendations = []
        
        if success_rate < self.flaky_test_threshold:
            trend_type = "flaky"
            confidence = 0.8
            recommendations.append("Consider investigating test stability")
            recommendations.append("Review test dependencies and environment")
        
        elif recent_failures >= 3:
            trend_type = "degrading"
            confidence = 0.7
            recommendations.append("Recent failure pattern detected")
            recommendations.append("Review recent code changes")
        
        elif avg_duration > self.slow_test_threshold:
            trend_type = "slow"
            confidence = 0.6
            recommendations.append("Test duration exceeds threshold")
            recommendations.append("Consider performance optimization")
        
        elif success_rate > 0.95 and avg_duration < 10:
            trend_type = "improving"
            confidence = 0.6
            recommendations.append("Test showing good performance")
        
        return TVTestTrend(
            test_name=test_name,
            trend_type=trend_type,
            confidence=confidence,
            data_points=len(sorted_history),
            avg_duration=avg_duration,
            success_rate=success_rate,
            recent_failures=recent_failures,
            recommendations=recommendations
        )
    
    def detect_performance_regressions(self, baseline_days: int = 7, comparison_days: int = 3) -> List[TVPerformanceInsight]:
        """Detect performance regressions by comparing recent performance with baseline"""
        try:
            # Get baseline period data
            baseline_end = datetime.now() - timedelta(days=comparison_days)
            baseline_start = baseline_end - timedelta(days=baseline_days)
            
            baseline_data = self._load_sessions_in_period(baseline_start, baseline_end)
            recent_data = self._load_recent_sessions(comparison_days)
            
            if not baseline_data or not recent_data:
                return []
            
            # Calculate baseline metrics
            baseline_metrics = self._calculate_performance_metrics(baseline_data)
            recent_metrics = self._calculate_performance_metrics(recent_data)
            
            insights = []
            
            # Compare test performance
            for test_name in set(baseline_metrics.keys()) & set(recent_metrics.keys()):
                baseline_duration = baseline_metrics[test_name]["avg_duration"]
                recent_duration = recent_metrics[test_name]["avg_duration"]
                
                if baseline_duration > 0 and recent_duration > 0:
                    change_percentage = ((recent_duration - baseline_duration) / baseline_duration) * 100
                    
                    if abs(change_percentage) > self.performance_regression_threshold * 100:
                        severity = "high" if abs(change_percentage) > 100 else "medium"
                        
                        insight_type = "performance_regression" if change_percentage > 0 else "improvement"
                        
                        insight = TVPerformanceInsight(
                            insight_type=insight_type,
                            test_name=test_name,
                            metric_value=recent_duration,
                            baseline_value=baseline_duration,
                            change_percentage=change_percentage,
                            severity=severity,
                            description=f"Test duration {'increased' if change_percentage > 0 else 'decreased'} by {abs(change_percentage):.1f}%"
                        )
                        
                        insights.append(insight)
            
            # Sort by severity and change percentage
            insights.sort(key=lambda i: (i.severity == "high", abs(i.change_percentage)), reverse=True)
            
            self.logger.info(f"Detected {len(insights)} performance insights")
            return insights
            
        except Exception as e:
            self.logger.error(f"Error detecting performance regressions: {e}")
            return []
    
    def _calculate_performance_metrics(self, session_data: List[Dict[str, Any]]) -> Dict[str, Dict[str, float]]:
        """Calculate performance metrics from session data"""
        test_metrics = defaultdict(lambda: {"durations": [], "success_count": 0, "total_count": 0})
        
        for session in session_data:
            test_details = session.get("test_details", {})
            
            for test_name, test_data in test_details.items():
                duration = test_data.get("duration", 0)
                status = test_data.get("status", "unknown")
                
                test_metrics[test_name]["durations"].append(duration)
                test_metrics[test_name]["total_count"] += 1
                
                if status == "passed":
                    test_metrics[test_name]["success_count"] += 1
        
        # Calculate averages
        result = {}
        for test_name, metrics in test_metrics.items():
            durations = [d for d in metrics["durations"] if d > 0]
            
            result[test_name] = {
                "avg_duration": statistics.mean(durations) if durations else 0,
                "success_rate": metrics["success_count"] / metrics["total_count"] if metrics["total_count"] > 0 else 0,
                "run_count": metrics["total_count"]
            }
        
        return result
    
    def analyze_flaky_tests(self, days: int = 14, min_runs: int = 5) -> List[Dict[str, Any]]:
        """Analyze and identify flaky tests"""
        try:
            session_data = self._load_recent_sessions(days)
            if not session_data:
                return []
            
            # Group test results by name
            test_results = defaultdict(list)
            for session in session_data:
                test_details = session.get("test_details", {})
                for test_name, test_data in test_details.items():
                    test_results[test_name].append(test_data.get("status", "unknown"))
            
            flaky_tests = []
            for test_name, results in test_results.items():
                if len(results) >= min_runs:
                    passed_count = sum(1 for r in results if r == "passed")
                    failed_count = sum(1 for r in results if r == "failed")
                    total_count = len(results)
                    
                    success_rate = passed_count / total_count
                    
                    # Identify flaky tests (tests that both pass and fail)
                    if passed_count > 0 and failed_count > 0:
                        flakiness_score = 1 - abs(success_rate - 0.5) * 2  # Higher score for 50% success rate
                        
                        flaky_tests.append({
                            "test_name": test_name,
                            "success_rate": success_rate,
                            "flakiness_score": flakiness_score,
                            "total_runs": total_count,
                            "passed_runs": passed_count,
                            "failed_runs": failed_count,
                            "stability_rating": self._calculate_stability_rating(success_rate),
                            "recommendations": self._generate_flaky_test_recommendations(success_rate, total_count)
                        })
            
            # Sort by flakiness score
            flaky_tests.sort(key=lambda t: t["flakiness_score"], reverse=True)
            
            self.logger.info(f"Identified {len(flaky_tests)} potentially flaky tests")
            return flaky_tests
            
        except Exception as e:
            self.logger.error(f"Error analyzing flaky tests: {e}")
            return []
    
    def _calculate_stability_rating(self, success_rate: float) -> str:
        """Calculate stability rating based on success rate"""
        if success_rate >= 0.95:
            return "excellent"
        elif success_rate >= 0.85:
            return "good"
        elif success_rate >= 0.70:
            return "fair"
        elif success_rate >= 0.50:
            return "poor"
        else:
            return "critical"
    
    def _generate_flaky_test_recommendations(self, success_rate: float, total_runs: int) -> List[str]:
        """Generate recommendations for flaky tests"""
        recommendations = []
        
        if success_rate < 0.5:
            recommendations.append("Critical: Test fails more often than it passes")
            recommendations.append("Consider disabling test until root cause is identified")
        
        elif success_rate < 0.8:
            recommendations.append("Add retry logic with exponential backoff")
            recommendations.append("Review test dependencies and timing issues")
        
        if total_runs < 10:
            recommendations.append("Insufficient data - monitor over more test runs")
        
        recommendations.append("Review test environment setup and teardown")
        recommendations.append("Check for race conditions or timing dependencies")
        
        return recommendations
    
    def generate_insights_summary(self) -> Dict[str, Any]:
        """Generate a comprehensive insights summary"""
        try:
            trends = self.analyze_test_trends()
            regressions = self.detect_performance_regressions()
            flaky_tests = self.analyze_flaky_tests()
            
            # Categorize insights
            critical_issues = []
            warnings = []
            improvements = []
            
            for trend in trends:
                if trend.trend_type == "degrading" and trend.confidence > 0.7:
                    critical_issues.append(f"Test '{trend.test_name}' showing degrading trend")
                elif trend.trend_type == "flaky":
                    warnings.append(f"Test '{trend.test_name}' identified as flaky")
                elif trend.trend_type == "improving":
                    improvements.append(f"Test '{trend.test_name}' showing improvement")
            
            for regression in regressions:
                if regression.severity == "high":
                    critical_issues.append(f"Performance regression in '{regression.test_name}': {regression.description}")
                else:
                    warnings.append(f"Performance change in '{regression.test_name}': {regression.description}")
            
            for flaky in flaky_tests[:5]:  # Top 5 flaky tests
                if flaky["stability_rating"] in ["critical", "poor"]:
                    critical_issues.append(f"Flaky test '{flaky['test_name']}' with {flaky['success_rate']:.1%} success rate")
            
            return {
                "summary": {
                    "total_tests_analyzed": len(trends),
                    "critical_issues": len(critical_issues),
                    "warnings": len(warnings),
                    "improvements": len(improvements),
                    "flaky_tests_detected": len(flaky_tests),
                    "performance_regressions": len([r for r in regressions if r.insight_type == "performance_regression"])
                },
                "critical_issues": critical_issues[:10],  # Top 10 critical issues
                "warnings": warnings[:10],  # Top 10 warnings
                "improvements": improvements[:10],  # Top 10 improvements
                "top_flaky_tests": flaky_tests[:5],
                "performance_insights": regressions[:5],
                "recommendations": self._generate_overall_recommendations(critical_issues, warnings, improvements)
            }
            
        except Exception as e:
            self.logger.error(f"Error generating insights summary: {e}")
            return {"error": str(e)}
    
    def _generate_overall_recommendations(self, critical_issues: List[str], warnings: List[str], improvements: List[str]) -> List[str]:
        """Generate overall recommendations based on analysis"""
        recommendations = []
        
        if critical_issues:
            recommendations.append("🚨 Address critical issues immediately")
            recommendations.append("Focus on fixing degrading and flaky tests")
        
        if warnings:
            recommendations.append("⚠️ Monitor warning conditions closely")
            recommendations.append("Consider implementing test stability improvements")
        
        if improvements:
            recommendations.append("✅ Good progress on test improvements")
            recommendations.append("Continue monitoring performance trends")
        
        recommendations.append("📊 Regular monitoring of test metrics recommended")
        recommendations.append("🔄 Implement automated alerting for critical issues")
        
        return recommendations
    
    def _load_recent_sessions(self, days: int) -> List[Dict[str, Any]]:
        """Load recent session data from JSON files"""
        try:
            json_dir = self.reports_dir / "tv_json"
            if not json_dir.exists():
                return []
            
            cutoff_date = datetime.now() - timedelta(days=days)
            session_files = list(json_dir.glob("tv_session_summary_*.json"))
            
            recent_sessions = []
            for session_file in session_files:
                # Check file modification time
                if datetime.fromtimestamp(session_file.stat().st_mtime) >= cutoff_date:
                    try:
                        with open(session_file, 'r') as f:
                            session_data = json.load(f)
                        
                        tv_summary = session_data.get("testviper_rp_summary", {})
                        recent_sessions.append(tv_summary)
                    except Exception as e:
                        self.logger.warning(f"Error loading session file {session_file}: {e}")
            
            return recent_sessions
            
        except Exception as e:
            self.logger.error(f"Error loading recent sessions: {e}")
            return []
    
    def _load_sessions_in_period(self, start_date: datetime, end_date: datetime) -> List[Dict[str, Any]]:
        """Load session data within a specific period"""
        try:
            json_dir = self.reports_dir / "tv_json"
            if not json_dir.exists():
                return []
            
            session_files = list(json_dir.glob("tv_session_summary_*.json"))
            
            period_sessions = []
            for session_file in session_files:
                file_time = datetime.fromtimestamp(session_file.stat().st_mtime)
                
                if start_date <= file_time <= end_date:
                    try:
                        with open(session_file, 'r') as f:
                            session_data = json.load(f)
                        
                        tv_summary = session_data.get("testviper_rp_summary", {})
                        period_sessions.append(tv_summary)
                    except Exception as e:
                        self.logger.warning(f"Error loading session file {session_file}: {e}")
            
            return period_sessions
            
        except Exception as e:
            self.logger.error(f"Error loading sessions in period: {e}")
            return []