#!/usr/bin/env python3
"""
Advanced coverage analytics for ReportPortal integration.

This module provides comprehensive coverage analysis and trend tracking
by fetching data from ReportPortal launches and analyzing coverage patterns.
"""

import json
import requests
import os
import sys
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Tuple
from pathlib import Path

class CoverageAnalytics:
    """Advanced coverage analytics for ReportPortal integration."""
    
    def __init__(self, rp_endpoint: str = None, rp_project: str = None, rp_token: str = None):
        """Initialize the coverage analytics engine."""
        self.rp_endpoint = rp_endpoint or os.getenv("RP_ENDPOINT", "http://localhost:8080")
        self.rp_project = rp_project or os.getenv("RP_PROJECT", "testviper")
        self.rp_token = rp_token or os.getenv("RP_API_KEY", "")
        
        if not self.rp_token:
            print("⚠️  Warning: No ReportPortal API key found. Set RP_API_KEY environment variable.")
            print("🔍 Attempting to run in demo mode with mock data...")
            self.demo_mode = True
        else:
            self.demo_mode = False
        
        self.headers = {
            "Authorization": f"Bearer {self.rp_token}",
            "Content-Type": "application/json"
        }
        
        # Component mapping for better analysis
        self.component_names = {
            "xradio": "XRADIO",
            "toolviper": "ToolViper", 
            "graphviper": "GraphViper",
            "astroviper": "AstroViper",
            "testviper_integration": "TestViper Integration",
            "testviper_misc": "TestViper Misc"
        }
    
    def get_launches_with_coverage(self, days_back: int = 30) -> List[Dict]:
        """Fetch launches with coverage attributes from ReportPortal."""
        if self.demo_mode:
            return self._get_mock_launches(days_back)
        
        end_date = datetime.now()
        start_date = end_date - timedelta(days=days_back)
        
        url = f"{self.rp_endpoint}/api/v1/{self.rp_project}/launch"
        params = {
            "filter.gte.startTime": int(start_date.timestamp() * 1000),
            "filter.lte.startTime": int(end_date.timestamp() * 1000),
            "page.size": 100,
            "page.sort": "startTime,DESC"
        }
        
        try:
            response = requests.get(url, headers=self.headers, params=params)
            response.raise_for_status()
            
            launches = response.json().get("content", [])
            
            # Filter launches that have coverage attributes
            coverage_launches = []
            for launch in launches:
                coverage_attrs = self._extract_coverage_attributes(launch)
                if coverage_attrs.get("component"):
                    coverage_launches.append({
                        **launch,
                        "coverage_data": coverage_attrs
                    })
            
            print(f"📊 Found {len(coverage_launches)} launches with coverage data out of {len(launches)} total launches")
            return coverage_launches
            
        except requests.RequestException as e:
            print(f"❌ Error fetching launches from ReportPortal: {e}")
            return []
    
    def _get_mock_launches(self, days_back: int) -> List[Dict]:
        """Generate mock launch data for demo purposes."""
        mock_launches = []
        base_time = datetime.now()
        
        components = ["xradio", "astroviper", "toolviper", "testviper_misc"]
        
        for i in range(min(days_back, 20)):  # Generate up to 20 mock launches
            launch_time = base_time - timedelta(days=i, hours=i*2)
            component = components[i % len(components)]
            
            # Simulate coverage trends
            base_coverage = {"xradio": 75, "astroviper": 45, "toolviper": 65, "testviper_misc": 0}[component]
            coverage_variation = (i % 5 - 2) * 5  # -10 to +10 variation
            coverage_pct = max(0, min(100, base_coverage + coverage_variation))
            
            quality = "high" if coverage_pct >= 80 else "medium" if coverage_pct >= 60 else "low" if coverage_pct > 0 else "no_source_code"
            
            mock_launch = {
                "id": f"mock-{i}",
                "name": f"{component}_tests #{i+1}",
                "startTime": int(launch_time.timestamp() * 1000),
                "attributes": [
                    {"key": "tv_coverage_percentage", "value": f"{coverage_pct}%"},
                    {"key": "tv_coverage_component", "value": component},
                    {"key": "tv_coverage_quality", "value": quality},
                    {"key": "tv_coverage_statements", "value": str(int(coverage_pct * 4))},
                    {"key": "tv_coverage_missing", "value": str(int((100 - coverage_pct) * 2))}
                ],
                "coverage_data": {
                    "percentage": coverage_pct,
                    "component": component,
                    "quality": quality,
                    "statements": int(coverage_pct * 4),
                    "missing": int((100 - coverage_pct) * 2)
                }
            }
            mock_launches.append(mock_launch)
        
        print(f"📊 Generated {len(mock_launches)} mock launches for demo")
        return mock_launches
    
    def _extract_coverage_attributes(self, launch: Dict) -> Dict:
        """Extract coverage attributes from a launch."""
        coverage_data = {}
        
        for attr in launch.get("attributes", []):
            key = attr.get("key", "")
            value = attr.get("value", "")
            
            if key == "tv_coverage_percentage":
                try:
                    coverage_data["percentage"] = float(value.replace("%", ""))
                except (ValueError, AttributeError):
                    coverage_data["percentage"] = 0.0
            elif key == "tv_coverage_component":
                coverage_data["component"] = value
            elif key == "tv_coverage_quality":
                coverage_data["quality"] = value
            elif key == "tv_coverage_statements":
                try:
                    coverage_data["statements"] = int(value)
                except (ValueError, AttributeError):
                    coverage_data["statements"] = 0
            elif key == "tv_coverage_missing":
                try:
                    coverage_data["missing"] = int(value)
                except (ValueError, AttributeError):
                    coverage_data["missing"] = 0
            elif key == "tv_coverage_status":
                coverage_data["status"] = value
        
        return coverage_data
    
    def generate_coverage_report(self, days_back: int = 30) -> Dict:
        """Generate comprehensive coverage analytics report."""
        launches = self.get_launches_with_coverage(days_back)
        
        if not launches:
            return {
                "error": "No launches with coverage data found",
                "summary": {"total_launches": 0}
            }
        
        report = {
            "metadata": {
                "generated_at": datetime.now().isoformat(),
                "analysis_period": f"Last {days_back} days",
                "total_launches_analyzed": len(launches),
                "report_version": "1.0.0"
            },
            "summary": {
                "total_launches": len(launches),
                "date_range": f"Last {days_back} days",
                "components": {}
            },
            "trends": {},
            "insights": [],
            "recommendations": []
        }
        
        # Analyze by component
        component_data = {}
        
        for launch in launches:
            try:
                coverage = launch["coverage_data"]
                component = coverage.get("component", "unknown")
                percentage = coverage.get("percentage", 0)
                
                # Ensure percentage is a number
                if isinstance(percentage, str):
                    percentage = float(percentage.replace("%", ""))
                percentage = float(percentage)
                
                # Handle startTime - could be ISO string or timestamp
                start_time = launch["startTime"]
                if isinstance(start_time, str):
                    # Try to parse as ISO format first
                    try:
                        launch_time = datetime.fromisoformat(start_time.replace('Z', '+00:00'))
                    except ValueError:
                        # Fallback to timestamp
                        start_time = int(start_time)
                        launch_time = datetime.fromtimestamp(start_time / 1000)
                else:
                    launch_time = datetime.fromtimestamp(start_time / 1000)
                
                if component not in component_data:
                    component_data[component] = {
                        "launches": [],
                        "percentages": [],
                        "qualities": [],
                        "statements": [],
                        "missing": []
                    }
                
                component_data[component]["launches"].append({
                    "id": launch["id"],
                    "name": launch["name"],
                    "time": launch_time.isoformat(),
                    "percentage": percentage,
                    "quality": coverage.get("quality", "unknown"),
                    "statements": coverage.get("statements", 0),
                    "missing": coverage.get("missing", 0),
                    "status": coverage.get("status", "normal")
                })
                component_data[component]["percentages"].append(percentage)
                component_data[component]["qualities"].append(coverage.get("quality", "unknown"))
                component_data[component]["statements"].append(coverage.get("statements", 0))
                component_data[component]["missing"].append(coverage.get("missing", 0))
                
            except Exception as e:
                print(f"⚠️  Error processing launch {launch.get('name', 'unknown')}: {e}")
                continue
        
        # Generate component summaries and trends
        for component, data in component_data.items():
            if not data["percentages"]:
                continue
                
            percentages = data["percentages"]
            launches_count = len(data["launches"])
            
            # Calculate statistics
            avg_coverage = sum(percentages) / len(percentages)
            max_coverage = max(percentages)
            min_coverage = min(percentages)
            
            # Calculate trend
            trend_direction = self._calculate_trend(data["launches"])
            
            # Quality distribution
            quality_dist = {}
            for quality in data["qualities"]:
                quality_dist[quality] = quality_dist.get(quality, 0) + 1
            
            report["summary"]["components"][component] = {
                "display_name": self.component_names.get(component, component.title()),
                "launches": launches_count,
                "avg_coverage": round(avg_coverage, 2),
                "max_coverage": max_coverage,
                "min_coverage": min_coverage,
                "trend": trend_direction,
                "quality_distribution": quality_dist,
                "last_coverage": percentages[0] if percentages else 0,
                "coverage_stability": self._calculate_stability(percentages)
            }
            
            # Generate trend data for charts
            report["trends"][component] = [
                {
                    "date": launch["time"],
                    "coverage": launch["percentage"],
                    "quality": launch["quality"],
                    "launch_name": launch["name"]
                }
                for launch in sorted(data["launches"], key=lambda x: x["time"])
            ]
        
        # Generate insights and recommendations
        report["insights"] = self._generate_insights(report["summary"]["components"])
        report["recommendations"] = self._generate_recommendations(report["summary"]["components"])
        
        return report
    
    def _calculate_trend(self, launches: List[Dict]) -> str:
        """Calculate coverage trend direction."""
        if len(launches) < 2:
            return "insufficient_data"
        
        # Sort by time and get recent vs older percentages
        sorted_launches = sorted(launches, key=lambda x: x["time"])
        
        if len(sorted_launches) < 4:
            recent_avg = sorted_launches[-1]["percentage"]
            older_avg = sorted_launches[0]["percentage"]
        else:
            # Compare last quarter with first quarter
            quarter_size = len(sorted_launches) // 4
            recent_launches = sorted_launches[-quarter_size:]
            older_launches = sorted_launches[:quarter_size]
            
            recent_avg = sum(l["percentage"] for l in recent_launches) / len(recent_launches)
            older_avg = sum(l["percentage"] for l in older_launches) / len(older_launches)
        
        diff = recent_avg - older_avg
        
        if diff > 5:
            return "improving"
        elif diff < -5:
            return "declining"
        else:
            return "stable"
    
    def _calculate_stability(self, percentages: List[float]) -> str:
        """Calculate coverage stability."""
        if len(percentages) < 3:
            return "insufficient_data"
        
        # Calculate coefficient of variation
        avg = sum(percentages) / len(percentages)
        if avg == 0:
            return "no_coverage"
        
        variance = sum((x - avg) ** 2 for x in percentages) / len(percentages)
        std_dev = variance ** 0.5
        cv = (std_dev / avg) * 100
        
        if cv < 10:
            return "very_stable"
        elif cv < 25:
            return "stable"
        elif cv < 50:
            return "variable"
        else:
            return "highly_variable"
    
    def _generate_insights(self, components: Dict) -> List[str]:
        """Generate analytical insights from component data."""
        insights = []
        
        if not components:
            return ["📊 No coverage data available for analysis"]
        
        # Overall coverage analysis
        all_coverages = [comp["avg_coverage"] for comp in components.values()]
        overall_avg = sum(all_coverages) / len(all_coverages)
        
        insights.append(f"📈 Overall average coverage across all components: {overall_avg:.1f}%")
        
        # Best performing component
        best_component = max(components.items(), key=lambda x: x[1]["avg_coverage"])
        insights.append(f"🏆 Best performing component: {best_component[1]['display_name']} ({best_component[1]['avg_coverage']:.1f}%)")
        
        # Components needing attention
        low_coverage_components = [
            (name, data) for name, data in components.items() 
            if data["avg_coverage"] < 60
        ]
        
        if low_coverage_components:
            comp_names = [data["display_name"] for _, data in low_coverage_components]
            insights.append(f"⚠️  Components below 60% coverage: {', '.join(comp_names)}")
        
        # Trend analysis
        improving_components = [
            data["display_name"] for data in components.values() 
            if data["trend"] == "improving"
        ]
        declining_components = [
            data["display_name"] for data in components.values() 
            if data["trend"] == "declining"
        ]
        
        if improving_components:
            insights.append(f"📈 Improving coverage trends: {', '.join(improving_components)}")
        if declining_components:
            insights.append(f"📉 Declining coverage trends: {', '.join(declining_components)}")
        
        return insights
    
    def _generate_recommendations(self, components: Dict) -> List[str]:
        """Generate actionable recommendations."""
        recommendations = []
        
        for component, data in components.items():
            display_name = data["display_name"]
            avg_coverage = data["avg_coverage"]
            trend = data["trend"]
            stability = data["coverage_stability"]
            
            # Coverage level recommendations
            if avg_coverage < 40:
                recommendations.append(f"🔴 {display_name}: Critical - Coverage below 40%. Immediate action needed to add comprehensive tests.")
            elif avg_coverage < 60:
                recommendations.append(f"🟡 {display_name}: Coverage below 60%. Consider adding more unit tests and integration tests.")
            elif avg_coverage > 85:
                recommendations.append(f"✅ {display_name}: Excellent coverage! Maintain current testing practices.")
            
            # Trend-based recommendations
            if trend == "declining":
                recommendations.append(f"📉 {display_name}: Coverage is declining. Review recent changes and ensure new code includes tests.")
            elif trend == "improving":
                recommendations.append(f"📈 {display_name}: Coverage improving - great job! Continue current testing efforts.")
            
            # Stability recommendations
            if stability == "highly_variable":
                recommendations.append(f"🔄 {display_name}: Coverage is highly variable. Implement consistent testing practices.")
        
        # General recommendations
        if len(components) > 1:
            recommendations.append("🎯 Focus testing efforts on components with lowest coverage first for maximum impact.")
            recommendations.append("📊 Use ReportPortal dashboard filters to track component-specific coverage trends.")
        
        return recommendations
    
    def save_report(self, report: Dict, output_dir: str = "dashboard/reports/tv_json") -> str:
        """Save the coverage report to a file."""
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"tv_coverage_analytics_report_{timestamp}.json"
        filepath = Path(output_dir) / filename
        
        # Ensure directory exists
        filepath.parent.mkdir(parents=True, exist_ok=True)
        
        with open(filepath, 'w') as f:
            json.dump(report, f, indent=2, default=str)
        
        return str(filepath)
    
    def print_summary(self, report: Dict):
        """Print a human-readable summary of the coverage report."""
        print("\n" + "="*70)
        print("📊 COVERAGE ANALYTICS SUMMARY")
        print("="*70)
        
        metadata = report.get("metadata", {})
        print(f"📅 Analysis Period: {metadata.get('analysis_period', 'Unknown')}")
        print(f"🚀 Total Launches: {metadata.get('total_launches_analyzed', 0)}")
        print(f"⏰ Generated: {metadata.get('generated_at', 'Unknown')}")
        
        components = report.get("summary", {}).get("components", {})
        if components:
            print(f"\n📈 COMPONENT COVERAGE SUMMARY:")
            print("-" * 50)
            
            for component, data in components.items():
                trend_emoji = {"improving": "📈", "declining": "📉", "stable": "➡️"}.get(data["trend"], "❓")
                print(f"{data['display_name']:20} | {data['avg_coverage']:6.1f}% | {trend_emoji} {data['trend']:10} | {data['launches']} launches")
        
        insights = report.get("insights", [])
        if insights:
            print(f"\n🔍 KEY INSIGHTS:")
            print("-" * 30)
            for insight in insights:
                print(f"  {insight}")
        
        recommendations = report.get("recommendations", [])
        if recommendations:
            print(f"\n💡 RECOMMENDATIONS:")
            print("-" * 35)
            for rec in recommendations[:5]:  # Show top 5 recommendations
                print(f"  {rec}")
            
            if len(recommendations) > 5:
                print(f"  ... and {len(recommendations) - 5} more recommendations")
        
        print("="*70)


def main():
    """Main function for running coverage analytics."""
    import argparse
    
    parser = argparse.ArgumentParser(description="Generate coverage analytics report from ReportPortal")
    parser.add_argument("--days", type=int, default=30, help="Number of days to analyze (default: 30)")
    parser.add_argument("--output", type=str, default="dashboard/reports/tv_json", help="Output directory for reports")
    parser.add_argument("--save", action="store_true", help="Save report to file")
    parser.add_argument("--quiet", action="store_true", help="Suppress summary output")
    
    args = parser.parse_args()
    
    try:
        # Initialize analytics engine
        analytics = CoverageAnalytics()
        
        # Generate report
        print(f"🔍 Analyzing coverage data for the last {args.days} days...")
        report = analytics.generate_coverage_report(days_back=args.days)
        
        if report.get("error"):
            print(f"❌ Error: {report['error']}")
            sys.exit(1)
        
        # Save report if requested
        if args.save:
            filepath = analytics.save_report(report, args.output)
            print(f"💾 Report saved to: {filepath}")
        
        # Print summary unless quiet mode
        if not args.quiet:
            analytics.print_summary(report)
        
        # Output JSON for programmatic use
        if args.quiet:
            print(json.dumps(report, indent=2, default=str))
            
    except Exception as e:
        print(f"❌ Error running coverage analytics: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()