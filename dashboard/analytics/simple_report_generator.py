"""
TestViper Simple Report Generator
Focused on key analytics to supplement ReportPortal dashboard
"""

import json
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any, Optional
import logging

from .metrics_analyzer import TVMetricsAnalyzer
from .rp_client import TVReportPortalClient

class TVSimpleReportGenerator:
    """
    Simplified Report Generator for TestViper
    
    Focuses on generating key analytics reports to supplement ReportPortal
    """
    
    def __init__(self, reports_dir: str = "dashboard/reports"):
        """Initialize simple report generator"""
        self.reports_dir = Path(reports_dir)
        self.analyzer = TVMetricsAnalyzer(reports_dir)
        self.rp_client = TVReportPortalClient()
        self.logger = logging.getLogger("testviper.simple_report")
        
        # Ensure output directories exist
        (self.reports_dir / "tv_json").mkdir(parents=True, exist_ok=True)
        
        self.logger.info("TVSimpleReportGenerator initialized")
    
    def generate_analytics_summary(self) -> Dict[str, Any]:
        """Generate analytics summary focusing on key insights"""
        try:
            # Get local session data
            local_data = self._get_latest_local_session()
            
            # Get ReportPortal connection status
            rp_status = self.rp_client.test_connection()
            
            # Get analytics insights
            insights = self.analyzer.generate_insights_summary()
            
            # Generate flaky test analysis
            flaky_tests = self.analyzer.analyze_flaky_tests(days=7)
            
            # Create summary report
            summary = {
                "report_info": {
                    "generated_at": datetime.now().isoformat(),
                    "report_type": "analytics_summary",
                    "purpose": "Supplement ReportPortal dashboard with advanced analytics"
                },
                "connection_status": {
                    "reportportal_connected": rp_status.get("status") == "success",
                    "reportportal_launches": rp_status.get("total_launches", 0),
                    "local_sessions_available": bool(local_data)
                },
                "key_insights": {
                    "total_tests_analyzed": insights.get("summary", {}).get("total_tests_analyzed", 0),
                    "critical_issues": len(insights.get("critical_issues", [])),
                    "warnings": len(insights.get("warnings", [])),
                    "improvements": len(insights.get("improvements", [])),
                    "flaky_tests_detected": len(flaky_tests)
                },
                "local_session_summary": local_data,
                "top_concerns": self._extract_top_concerns(insights, flaky_tests),
                "recommendations": self._generate_key_recommendations(insights, flaky_tests, rp_status)
            }
            
            return summary
            
        except Exception as e:
            self.logger.error(f"Error generating analytics summary: {e}")
            return {"error": str(e)}
    
    def _get_latest_local_session(self) -> Dict[str, Any]:
        """Get the latest local session data"""
        try:
            json_dir = self.reports_dir / "tv_json"
            if not json_dir.exists():
                return {}
            
            # Get the most recent session summary
            session_files = list(json_dir.glob("tv_session_summary_*.json"))
            if not session_files:
                return {}
            
            latest_file = max(session_files, key=lambda f: f.stat().st_mtime)
            
            with open(latest_file, 'r') as f:
                data = json.load(f)
            
            tv_summary = data.get("testviper_rp_summary", {})
            return {
                "session_file": str(latest_file),
                "test_summary": tv_summary.get("test_summary", {}),
                "session_duration": tv_summary.get("session_info", {}).get("total_duration", 0),
                "test_count": len(tv_summary.get("test_details", {}))
            }
            
        except Exception as e:
            self.logger.error(f"Error getting latest local session: {e}")
            return {}
    
    def _extract_top_concerns(self, insights: Dict[str, Any], flaky_tests: List[Dict[str, Any]]) -> List[Dict[str, Any]]:
        """Extract top concerns for immediate attention"""
        concerns = []
        
        # Critical issues
        for issue in insights.get("critical_issues", [])[:3]:
            concerns.append({
                "type": "critical",
                "description": issue,
                "priority": "high"
            })
        
        # Top flaky tests
        for test in flaky_tests[:2]:  # Top 2 flaky tests
            concerns.append({
                "type": "flaky_test",
                "description": f"Test '{test['test_name']}' has {test['success_rate']:.1%} success rate",
                "priority": "medium" if test['success_rate'] > 0.5 else "high"
            })
        
        # Warnings
        for warning in insights.get("warnings", [])[:2]:
            concerns.append({
                "type": "warning",
                "description": warning,
                "priority": "medium"
            })
        
        return concerns
    
    def _generate_key_recommendations(self, insights: Dict[str, Any], flaky_tests: List[Dict[str, Any]], rp_status: Dict[str, Any]) -> List[str]:
        """Generate key recommendations"""
        recommendations = []
        
        # ReportPortal integration recommendations
        if rp_status.get("status") != "success":
            recommendations.append("🔗 Fix ReportPortal connection to enable full dashboard functionality")
        elif rp_status.get("total_launches", 0) == 0:
            recommendations.append("📊 Run tests to populate ReportPortal dashboard with data")
        
        # Test quality recommendations
        if len(flaky_tests) > 0:
            recommendations.append(f"🔄 Address {len(flaky_tests)} flaky tests to improve test reliability")
        
        critical_count = insights.get("summary", {}).get("critical_issues", 0)
        if critical_count > 0:
            recommendations.append(f"🚨 Resolve {critical_count} critical issues immediately")
        
        # General recommendations
        recommendations.append("📈 Use ReportPortal dashboard at http://localhost:8080 for detailed test analysis")
        recommendations.append("🔍 Review this analytics report regularly to monitor test health")
        
        return recommendations
    
    def save_analytics_report(self, output_file: str = None) -> str:
        """Save analytics report to file"""
        try:
            summary = self.generate_analytics_summary()
            
            if output_file is None:
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                output_file = self.reports_dir / "tv_json" / f"tv_analytics_report_{timestamp}.json"
            
            output_path = Path(output_file)
            output_path.parent.mkdir(parents=True, exist_ok=True)
            
            with open(output_path, 'w') as f:
                json.dump(summary, f, indent=2)
            
            self.logger.info(f"Analytics report saved: {output_path}")
            return str(output_path)
            
        except Exception as e:
            self.logger.error(f"Error saving analytics report: {e}")
            raise
    
    def print_summary(self):
        """Print a formatted summary to console"""
        try:
            summary = self.generate_analytics_summary()
            
            print("\n" + "=" * 60)
            print("🧪 TestViper Analytics Summary")
            print("=" * 60)
            
            # Connection status
            conn = summary.get("connection_status", {})
            print(f"🔗 ReportPortal Connected: {'✅' if conn.get('reportportal_connected') else '❌'}")
            print(f"📊 ReportPortal Launches: {conn.get('reportportal_launches', 0)}")
            print(f"📂 Local Sessions: {'✅' if conn.get('local_sessions_available') else '❌'}")
            
            # Key insights
            insights = summary.get("key_insights", {})
            print(f"\n📈 Key Insights:")
            print(f"  Tests Analyzed: {insights.get('total_tests_analyzed', 0)}")
            print(f"  Critical Issues: {insights.get('critical_issues', 0)}")
            print(f"  Warnings: {insights.get('warnings', 0)}")
            print(f"  Improvements: {insights.get('improvements', 0)}")
            print(f"  Flaky Tests: {insights.get('flaky_tests_detected', 0)}")
            
            # Local session info
            local = summary.get("local_session_summary", {})
            if local:
                test_summary = local.get("test_summary", {})
                print(f"\n📂 Latest Local Session:")
                print(f"  Total Tests: {test_summary.get('total_tests', 0)}")
                print(f"  Pass Rate: {test_summary.get('pass_rate', 0):.1f}%")
                print(f"  Duration: {local.get('session_duration', 0):.2f}s")
            
            # Top concerns
            concerns = summary.get("top_concerns", [])
            if concerns:
                print(f"\n⚠️  Top Concerns:")
                for concern in concerns[:5]:
                    priority_emoji = {"high": "🚨", "medium": "⚠️", "low": "ℹ️"}.get(concern.get("priority", "low"), "ℹ️")
                    print(f"  {priority_emoji} {concern.get('description', 'Unknown')}")
            
            # Recommendations
            recommendations = summary.get("recommendations", [])
            if recommendations:
                print(f"\n💡 Key Recommendations:")
                for rec in recommendations:
                    print(f"  {rec}")
            
            print("=" * 60)
            print(f"🌐 Access full dashboard: http://localhost:8080")
            print("=" * 60)
            
        except Exception as e:
            print(f"❌ Error generating summary: {e}")
    
    def get_quick_status(self) -> str:
        """Get quick status string"""
        try:
            summary = self.generate_analytics_summary()
            
            conn = summary.get("connection_status", {})
            insights = summary.get("key_insights", {})
            
            rp_status = "Connected" if conn.get("reportportal_connected") else "Disconnected"
            issues = insights.get("critical_issues", 0)
            flaky = insights.get("flaky_tests_detected", 0)
            
            return f"ReportPortal: {rp_status} | Issues: {issues} | Flaky Tests: {flaky}"
            
        except Exception as e:
            return f"Error: {e}"