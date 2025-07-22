"""
TestViper Report Generator
Generates comprehensive HTML and JSON reports for the dashboard
"""

import json
import os
from pathlib import Path
from datetime import datetime
from typing import Dict, List, Any, Optional
import logging

from .dashboard_core import TVDashboard
from .metrics_analyzer import TVMetricsAnalyzer

class TVReportGenerator:
    """
    TestViper Report Generator
    
    Generates comprehensive reports combining all analytics
    """
    
    def __init__(self, reports_dir: str = "dashboard/reports"):
        """Initialize report generator"""
        self.reports_dir = Path(reports_dir)
        self.dashboard = TVDashboard(reports_dir)
        self.analyzer = TVMetricsAnalyzer(reports_dir)
        self.logger = logging.getLogger("testviper.report_generator")
        
        # Ensure output directories exist
        (self.reports_dir / "html").mkdir(parents=True, exist_ok=True)
        (self.reports_dir / "tv_json").mkdir(parents=True, exist_ok=True)
        
        self.logger.info("TVReportGenerator initialized")
    
    def generate_comprehensive_report(self, output_format: str = "both") -> Dict[str, str]:
        """Generate comprehensive report in specified format(s)"""
        try:
            # Collect all data
            dashboard_summary = self.dashboard.get_dashboard_summary()
            comprehensive_metrics = self.dashboard.get_comprehensive_metrics()
            insights_summary = self.analyzer.generate_insights_summary()
            failure_analysis = self.dashboard.get_test_failure_analysis()
            
            # Create comprehensive report data
            report_data = {
                "report_metadata": {
                    "generated_at": datetime.now().isoformat(),
                    "generator_version": "1.0.0",
                    "report_type": "comprehensive_dashboard",
                    "data_sources": ["local_sessions", "reportportal", "analytics"]
                },
                "dashboard_summary": dashboard_summary,
                "metrics": {
                    "total_tests": comprehensive_metrics.total_tests,
                    "pass_rate": comprehensive_metrics.pass_rate,
                    "avg_duration": comprehensive_metrics.avg_duration,
                    "flaky_tests": comprehensive_metrics.flaky_tests,
                    "performance_trends": comprehensive_metrics.performance_trends
                },
                "insights": insights_summary,
                "failure_analysis": failure_analysis,
                "local_session_data": comprehensive_metrics.local_session_data
            }
            
            results = {}
            
            # Generate JSON report
            if output_format in ["json", "both"]:
                json_path = self._generate_json_report(report_data)
                results["json"] = json_path
            
            # Generate HTML report
            if output_format in ["html", "both"]:
                html_path = self._generate_html_report(report_data)
                results["html"] = html_path
            
            self.logger.info(f"Generated comprehensive report in {output_format} format")
            return results
            
        except Exception as e:
            self.logger.error(f"Error generating comprehensive report: {e}")
            raise
    
    def _generate_json_report(self, report_data: Dict[str, Any]) -> str:
        """Generate JSON report"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        json_path = self.reports_dir / "tv_json" / f"tv_comprehensive_report_{timestamp}.json"
        
        with open(json_path, 'w') as f:
            json.dump(report_data, f, indent=2, default=str)
        
        return str(json_path)
    
    def _generate_html_report(self, report_data: Dict[str, Any]) -> str:
        """Generate HTML report"""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        html_path = self.reports_dir / "html" / f"tv_dashboard_{timestamp}.html"
        
        html_content = self._create_html_template(report_data)
        
        with open(html_path, 'w') as f:
            f.write(html_content)
        
        return str(html_path)
    
    def _create_html_template(self, report_data: Dict[str, Any]) -> str:
        """Create HTML template for the report"""
        
        # Extract key metrics
        dashboard_summary = report_data.get("dashboard_summary", {})
        metrics = report_data.get("metrics", {})
        insights = report_data.get("insights", {})
        failure_analysis = report_data.get("failure_analysis", {})
        
        # Create HTML
        html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TestViper Dashboard Report</title>
    <style>
        {self._get_css_styles()}
    </style>
</head>
<body>
    <div class="container">
        <header class="header">
            <h1>🧪 TestViper Dashboard Report</h1>
            <p class="subtitle">Generated on {report_data.get('report_metadata', {}).get('generated_at', 'Unknown')}</p>
        </header>
        
        <div class="dashboard-grid">
            {self._create_summary_section(dashboard_summary)}
            {self._create_metrics_section(metrics)}
            {self._create_insights_section(insights)}
            {self._create_failure_analysis_section(failure_analysis)}
        </div>
        
        <footer class="footer">
            <p>Report generated by TestViper Dashboard Analytics v1.0.0</p>
        </footer>
    </div>
    
    <script>
        {self._get_javascript()}
    </script>
</body>
</html>
"""
        
        return html_content
    
    def _create_summary_section(self, dashboard_summary: Dict[str, Any]) -> str:
        """Create summary section HTML"""
        summary = dashboard_summary.get("summary", {})
        health = dashboard_summary.get("health_indicators", {})
        
        return f"""
        <div class="card summary-card">
            <h2>📊 Dashboard Summary</h2>
            <div class="summary-grid">
                <div class="metric-item">
                    <span class="metric-value">{summary.get('total_tests', 0)}</span>
                    <span class="metric-label">Total Tests</span>
                </div>
                <div class="metric-item">
                    <span class="metric-value">{summary.get('pass_rate', '0%')}</span>
                    <span class="metric-label">Pass Rate</span>
                </div>
                <div class="metric-item">
                    <span class="metric-value">{summary.get('avg_duration', '0s')}</span>
                    <span class="metric-label">Avg Duration</span>
                </div>
                <div class="metric-item">
                    <span class="metric-value">{summary.get('flaky_tests', 0)}</span>
                    <span class="metric-label">Flaky Tests</span>
                </div>
            </div>
            
            <div class="health-indicators">
                <h3>Health Indicators</h3>
                <div class="indicator-item">
                    <span class="indicator-label">Pass Rate:</span>
                    <span class="indicator-status {health.get('pass_rate_status', 'unknown')}">{health.get('pass_rate_status', 'unknown').title()}</span>
                </div>
                <div class="indicator-item">
                    <span class="indicator-label">Performance:</span>
                    <span class="indicator-status {health.get('performance_status', 'unknown')}">{health.get('performance_status', 'unknown').title()}</span>
                </div>
                <div class="indicator-item">
                    <span class="indicator-label">Stability:</span>
                    <span class="indicator-status {health.get('stability_status', 'unknown')}">{health.get('stability_status', 'unknown').title()}</span>
                </div>
            </div>
        </div>
        """
    
    def _create_metrics_section(self, metrics: Dict[str, Any]) -> str:
        """Create metrics section HTML"""
        performance_trends = metrics.get("performance_trends", {})
        
        return f"""
        <div class="card metrics-card">
            <h2>📈 Performance Metrics</h2>
            <div class="metrics-content">
                <div class="trend-info">
                    <h3>Performance Trends</h3>
                    <p>Sessions analyzed: {performance_trends.get('session_count', 0)}</p>
                    <p>Status: {performance_trends.get('status', 'Available' if performance_trends.get('session_count', 0) > 0 else 'Insufficient data')}</p>
                </div>
                
                <div class="slowest-tests">
                    <h3>Slowest Tests</h3>
                    <ul>
                        {self._create_test_list(performance_trends.get('slowest_tests', [])[:5])}
                    </ul>
                </div>
                
                <div class="failing-tests">
                    <h3>Recent Failures</h3>
                    <ul>
                        {self._create_test_list(performance_trends.get('most_failing_tests', [])[:5])}
                    </ul>
                </div>
            </div>
        </div>
        """
    
    def _create_insights_section(self, insights: Dict[str, Any]) -> str:
        """Create insights section HTML"""
        summary = insights.get("summary", {})
        critical_issues = insights.get("critical_issues", [])
        warnings = insights.get("warnings", [])
        improvements = insights.get("improvements", [])
        
        return f"""
        <div class="card insights-card">
            <h2>🔍 Insights & Analysis</h2>
            <div class="insights-summary">
                <div class="insight-stat">
                    <span class="stat-number">{summary.get('tests_analyzed', 0)}</span>
                    <span class="stat-label">Tests Analyzed</span>
                </div>
                <div class="insight-stat critical">
                    <span class="stat-number">{summary.get('critical_issues', 0)}</span>
                    <span class="stat-label">Critical Issues</span>
                </div>
                <div class="insight-stat warning">
                    <span class="stat-number">{summary.get('warnings', 0)}</span>
                    <span class="stat-label">Warnings</span>
                </div>
                <div class="insight-stat good">
                    <span class="stat-number">{summary.get('improvements', 0)}</span>
                    <span class="stat-label">Improvements</span>
                </div>
            </div>
            
            {self._create_issues_section("Critical Issues", critical_issues, "critical")}
            {self._create_issues_section("Warnings", warnings, "warning")}
            {self._create_issues_section("Improvements", improvements, "good")}
        </div>
        """
    
    def _create_failure_analysis_section(self, failure_analysis: Dict[str, Any]) -> str:
        """Create failure analysis section HTML"""
        rp_failures = failure_analysis.get("reportportal_failures", [])
        local_failures = failure_analysis.get("local_failures", [])
        patterns = failure_analysis.get("failure_patterns", {})
        recommendations = failure_analysis.get("recommendations", [])
        
        return f"""
        <div class="card failure-card">
            <h2>❌ Failure Analysis</h2>
            <div class="failure-summary">
                <div class="failure-stat">
                    <span class="stat-number">{len(rp_failures)}</span>
                    <span class="stat-label">ReportPortal Failures</span>
                </div>
                <div class="failure-stat">
                    <span class="stat-number">{len(local_failures)}</span>
                    <span class="stat-label">Local Failures</span>
                </div>
                <div class="failure-stat">
                    <span class="stat-number">{len(patterns.get('flaky_candidates', []))}</span>
                    <span class="stat-label">Flaky Candidates</span>
                </div>
            </div>
            
            <div class="recommendations">
                <h3>Recommendations</h3>
                <ul>
                    {self._create_recommendations_list(recommendations)}
                </ul>
            </div>
        </div>
        """
    
    def _create_test_list(self, tests: List[Dict[str, Any]]) -> str:
        """Create HTML list of tests"""
        if not tests:
            return "<li>No data available</li>"
        
        items = []
        for test in tests:
            test_name = test.get("test_name", "Unknown")
            duration = test.get("duration", 0)
            items.append(f"<li>{test_name} ({duration:.2f}s)</li>")
        
        return "\n".join(items)
    
    def _create_issues_section(self, title: str, issues: List[str], css_class: str) -> str:
        """Create issues section HTML"""
        if not issues:
            return f"""
            <div class="issues-section {css_class}">
                <h3>{title}</h3>
                <p>No {title.lower()} identified</p>
            </div>
            """
        
        issue_items = "\n".join([f"<li>{issue}</li>" for issue in issues])
        
        return f"""
        <div class="issues-section {css_class}">
            <h3>{title}</h3>
            <ul>
                {issue_items}
            </ul>
        </div>
        """
    
    def _create_recommendations_list(self, recommendations: List[str]) -> str:
        """Create recommendations list HTML"""
        if not recommendations:
            return "<li>No specific recommendations at this time</li>"
        
        return "\n".join([f"<li>{rec}</li>" for rec in recommendations])
    
    def _get_css_styles(self) -> str:
        """Get CSS styles for the HTML report"""
        return """
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f5f5f5;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        .header {
            text-align: center;
            margin-bottom: 30px;
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            border-radius: 10px;
        }
        
        .header h1 {
            font-size: 2.5em;
            margin-bottom: 10px;
        }
        
        .subtitle {
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .dashboard-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(500px, 1fr));
            gap: 20px;
            margin-bottom: 30px;
        }
        
        .card {
            background: white;
            border-radius: 10px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        }
        
        .card h2 {
            color: #333;
            margin-bottom: 15px;
            font-size: 1.5em;
        }
        
        .summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .metric-item {
            text-align: center;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .metric-value {
            display: block;
            font-size: 2em;
            font-weight: bold;
            color: #667eea;
        }
        
        .metric-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .health-indicators {
            margin-top: 20px;
        }
        
        .indicator-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #eee;
        }
        
        .indicator-status {
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.8em;
            font-weight: bold;
            text-transform: uppercase;
        }
        
        .indicator-status.good {
            background: #d4edda;
            color: #155724;
        }
        
        .indicator-status.warning {
            background: #fff3cd;
            color: #856404;
        }
        
        .indicator-status.critical {
            background: #f8d7da;
            color: #721c24;
        }
        
        .insights-summary {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(120px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .insight-stat {
            text-align: center;
            padding: 15px;
            border-radius: 8px;
            background: #f8f9fa;
        }
        
        .insight-stat.critical {
            background: #f8d7da;
        }
        
        .insight-stat.warning {
            background: #fff3cd;
        }
        
        .insight-stat.good {
            background: #d4edda;
        }
        
        .stat-number {
            display: block;
            font-size: 1.8em;
            font-weight: bold;
        }
        
        .stat-label {
            color: #666;
            font-size: 0.9em;
        }
        
        .issues-section {
            margin: 15px 0;
            padding: 15px;
            border-radius: 8px;
        }
        
        .issues-section.critical {
            background: #f8d7da;
            border-left: 4px solid #dc3545;
        }
        
        .issues-section.warning {
            background: #fff3cd;
            border-left: 4px solid #ffc107;
        }
        
        .issues-section.good {
            background: #d4edda;
            border-left: 4px solid #28a745;
        }
        
        .footer {
            text-align: center;
            padding: 20px;
            color: #666;
            font-size: 0.9em;
        }
        
        ul {
            padding-left: 20px;
        }
        
        li {
            margin-bottom: 5px;
        }
        
        @media (max-width: 768px) {
            .dashboard-grid {
                grid-template-columns: 1fr;
            }
            
            .summary-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }
        """
    
    def _get_javascript(self) -> str:
        """Get JavaScript for the HTML report"""
        return """
        // Add any interactive functionality here
        document.addEventListener('DOMContentLoaded', function() {
            console.log('TestViper Dashboard Report loaded');
            
            // Add click handlers for collapsible sections
            const sections = document.querySelectorAll('.issues-section h3');
            sections.forEach(section => {
                section.style.cursor = 'pointer';
                section.addEventListener('click', function() {
                    const content = this.nextElementSibling;
                    if (content.style.display === 'none') {
                        content.style.display = 'block';
                    } else {
                        content.style.display = 'none';
                    }
                });
            });
        });
        """
    
    def generate_quick_summary(self) -> str:
        """Generate a quick text summary"""
        try:
            dashboard_summary = self.dashboard.get_dashboard_summary()
            summary = dashboard_summary.get("summary", {})
            
            text_summary = f"""
🧪 TestViper Dashboard Quick Summary
Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}

📊 Key Metrics:
- Total Tests: {summary.get('total_tests', 0)}
- Pass Rate: {summary.get('pass_rate', '0%')}
- Average Duration: {summary.get('avg_duration', '0s')}
- Flaky Tests: {summary.get('flaky_tests', 0)}

🔍 Status: {dashboard_summary.get('status', 'unknown')}
🔗 ReportPortal Connected: {dashboard_summary.get('reportportal_connected', False)}
📂 Local Session Available: {dashboard_summary.get('local_session_available', False)}
"""
            
            return text_summary
            
        except Exception as e:
            self.logger.error(f"Error generating quick summary: {e}")
            return f"Error generating summary: {e}"