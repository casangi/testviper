#!/usr/bin/env python3
"""
TestViper Coverage Regression Detection
Detects significant coverage drops and trends across components
"""

import json
import os
import sys
import glob
import argparse
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from datetime import datetime, timedelta
import statistics

class CoverageRegressionDetector:
    """Detects coverage regressions and alerts on significant drops"""
    
    # Regression detection thresholds
    REGRESSION_THRESHOLDS = {
        "major_drop": 10.0,        # > 10% drop is major regression
        "moderate_drop": 5.0,      # > 5% drop is moderate regression  
        "minor_drop": 2.0,         # > 2% drop is minor regression
        "trend_points": 5,         # Need 5+ points for trend analysis
        "trend_threshold": -0.5,   # Negative trend slope threshold
        "volatility_threshold": 5.0  # High volatility indicator
    }
    
    def __init__(self, reports_dir: str = "dashboard/reports/tv_json"):
        """Initialize with reports directory"""
        self.reports_dir = reports_dir
        self.coverage_history = {}
        self.regressions = []
        
    def load_coverage_history(self, days_back: int = 30) -> Dict:
        """Load coverage analytics history from report files"""
        coverage_files = glob.glob(os.path.join(self.reports_dir, "tv_coverage_analytics_report_*.json"))
        
        if not coverage_files:
            print(f"⚠️  No coverage analytics files found in {self.reports_dir}")
            return {}
        
        # Sort by date (most recent first)
        coverage_files.sort(reverse=True)
        
        history = {}
        cutoff_date = datetime.now() - timedelta(days=days_back)
        
        for file in coverage_files:
            try:
                with open(file, 'r') as f:
                    data = json.load(f)
                
                # Extract date from metadata
                generated_at = data.get("metadata", {}).get("generated_at")
                if not generated_at:
                    continue
                
                report_date = datetime.fromisoformat(generated_at.replace('Z', '+00:00'))
                
                # Skip if too old
                if report_date < cutoff_date:
                    continue
                
                # Extract component coverage data
                components = data.get("summary", {}).get("components", {})
                
                for component, comp_data in components.items():
                    if component not in history:
                        history[component] = []
                    
                    coverage_point = {
                        "date": report_date.isoformat(),
                        "coverage": comp_data.get("avg_coverage", 0),
                        "launches": comp_data.get("launches", 0),
                        "trend": comp_data.get("trend", "unknown"),
                        "file": file
                    }
                    
                    history[component].append(coverage_point)
            
            except Exception as e:
                print(f"⚠️  Error reading {file}: {e}")
                continue
        
        # Sort each component's history by date
        for component in history:
            history[component].sort(key=lambda x: x["date"], reverse=True)
        
        self.coverage_history = history
        return history
    
    def detect_immediate_regression(self, current_coverage: Dict, previous_coverage: Dict) -> List[Dict]:
        """Detect immediate coverage regressions between two measurements"""
        regressions = []
        
        for component in current_coverage:
            if component not in previous_coverage:
                continue
            
            current = current_coverage[component]
            previous = previous_coverage[component]
            
            # Calculate drop
            coverage_drop = previous - current
            drop_percentage = (coverage_drop / previous * 100) if previous > 0 else 0
            
            # Classify regression severity
            severity = "none"
            if coverage_drop >= self.REGRESSION_THRESHOLDS["major_drop"]:
                severity = "major"
            elif coverage_drop >= self.REGRESSION_THRESHOLDS["moderate_drop"]:
                severity = "moderate"
            elif coverage_drop >= self.REGRESSION_THRESHOLDS["minor_drop"]:
                severity = "minor"
            
            if severity != "none":
                regression = {
                    "component": component,
                    "severity": severity,
                    "current_coverage": current,
                    "previous_coverage": previous,
                    "coverage_drop": round(coverage_drop, 2),
                    "drop_percentage": round(drop_percentage, 2),
                    "type": "immediate"
                }
                regressions.append(regression)
        
        return regressions
    
    def analyze_coverage_trends(self, component: str, history: List[Dict]) -> Dict:
        """Analyze coverage trends for a single component"""
        if len(history) < self.REGRESSION_THRESHOLDS["trend_points"]:
            return {
                "has_trend": False,
                "reason": "insufficient_data",
                "points": len(history)
            }
        
        # Extract coverage values (most recent first)
        coverages = [point["coverage"] for point in history]
        
        # Calculate basic statistics
        mean_coverage = statistics.mean(coverages)
        stdev_coverage = statistics.stdev(coverages) if len(coverages) > 1 else 0
        min_coverage = min(coverages)
        max_coverage = max(coverages)
        latest_coverage = coverages[0]
        
        # Calculate trend (simple linear regression slope)
        # Using index as x (time), coverage as y
        n = len(coverages)
        x_values = list(range(n))  # 0, 1, 2, ... (oldest to newest)
        y_values = coverages[::-1]  # Reverse to go from oldest to newest
        
        x_mean = statistics.mean(x_values)
        y_mean = statistics.mean(y_values)
        
        # Calculate slope (trend)
        numerator = sum((x_values[i] - x_mean) * (y_values[i] - y_mean) for i in range(n))
        denominator = sum((x_values[i] - x_mean) ** 2 for i in range(n))
        
        slope = numerator / denominator if denominator != 0 else 0
        
        # Classify trend
        trend_direction = "stable"
        if slope > 0.5:
            trend_direction = "improving"
        elif slope < self.REGRESSION_THRESHOLDS["trend_threshold"]:
            trend_direction = "declining"
        
        # Check volatility
        volatility = (stdev_coverage / mean_coverage * 100) if mean_coverage > 0 else 0
        is_volatile = volatility > self.REGRESSION_THRESHOLDS["volatility_threshold"]
        
        return {
            "has_trend": True,
            "trend_direction": trend_direction,
            "slope": round(slope, 3),
            "mean_coverage": round(mean_coverage, 2),
            "stdev_coverage": round(stdev_coverage, 2),
            "volatility": round(volatility, 2),
            "is_volatile": is_volatile,
            "min_coverage": round(min_coverage, 2),
            "max_coverage": round(max_coverage, 2),
            "latest_coverage": round(latest_coverage, 2),
            "points": n,
            "coverage_range": round(max_coverage - min_coverage, 2)
        }
    
    def detect_trend_regressions(self) -> List[Dict]:
        """Detect trend-based regressions across all components"""
        trend_regressions = []
        
        for component, history in self.coverage_history.items():
            trend_analysis = self.analyze_coverage_trends(component, history)
            
            if not trend_analysis["has_trend"]:
                continue
            
            # Check for declining trend
            if trend_analysis["trend_direction"] == "declining":
                severity = "moderate" if trend_analysis["slope"] < -1.0 else "minor"
                
                regression = {
                    "component": component,
                    "severity": severity,
                    "type": "trend",
                    "trend_slope": trend_analysis["slope"],
                    "mean_coverage": trend_analysis["mean_coverage"],
                    "latest_coverage": trend_analysis["latest_coverage"],
                    "coverage_drop": round(trend_analysis["mean_coverage"] - trend_analysis["latest_coverage"], 2),
                    "volatility": trend_analysis["volatility"],
                    "points_analyzed": trend_analysis["points"]
                }
                trend_regressions.append(regression)
            
            # Check for high volatility (unstable coverage)
            elif trend_analysis["is_volatile"]:
                regression = {
                    "component": component,
                    "severity": "minor",
                    "type": "volatility",
                    "volatility": trend_analysis["volatility"],
                    "coverage_range": trend_analysis["coverage_range"],
                    "mean_coverage": trend_analysis["mean_coverage"],
                    "latest_coverage": trend_analysis["latest_coverage"],
                    "points_analyzed": trend_analysis["points"]
                }
                trend_regressions.append(regression)
        
        return trend_regressions
    
    def get_current_coverage_from_files(self) -> Dict:
        """Extract current coverage from latest coverage files"""
        coverage_files = glob.glob("coverage_*.json")
        current_coverage = {}
        
        for file in coverage_files:
            try:
                with open(file, 'r') as f:
                    data = json.load(f)
                
                component = file.replace('coverage_', '').replace('.json', '')
                coverage = data.get("totals", {}).get("percent_covered", 0)
                current_coverage[component] = coverage
                
            except Exception as e:
                print(f"⚠️  Error reading current coverage file {file}: {e}")
        
        return current_coverage
    
    def run_regression_detection(self, days_back: int = 30) -> Dict:
        """Run comprehensive regression detection"""
        print(f"🔍 Loading coverage history for the last {days_back} days...")
        
        # Load historical data
        history = self.load_coverage_history(days_back)
        
        if not history:
            return {
                "error": "No coverage history available",
                "regressions": [],
                "summary": {"total": 0, "major": 0, "moderate": 0, "minor": 0}
            }
        
        print(f"📊 Analyzing {len(history)} components with coverage history")
        
        # Detect trend-based regressions
        trend_regressions = self.detect_trend_regressions()
        
        # Get current coverage and compare with latest historical data
        current_coverage = self.get_current_coverage_from_files()
        immediate_regressions = []
        
        if current_coverage:
            # Get the most recent historical coverage for comparison
            latest_historical = {}
            for component, hist in history.items():
                if hist:
                    latest_historical[component] = hist[0]["coverage"]
            
            immediate_regressions = self.detect_immediate_regression(
                current_coverage, latest_historical
            )
        
        # Combine all regressions
        all_regressions = immediate_regressions + trend_regressions
        
        # Summarize by severity
        summary = {"total": len(all_regressions), "major": 0, "moderate": 0, "minor": 0}
        for regression in all_regressions:
            summary[regression["severity"]] += 1
        
        # Generate component trend summaries
        component_summaries = {}
        for component, hist in history.items():
            trend_analysis = self.analyze_coverage_trends(component, hist)
            component_summaries[component] = trend_analysis
        
        return {
            "detection_date": datetime.now().isoformat(),
            "days_analyzed": days_back,
            "components_analyzed": len(history),
            "regressions": all_regressions,
            "summary": summary,
            "component_trends": component_summaries,
            "current_coverage": current_coverage
        }
    
    def print_regression_report(self, results: Dict):
        """Print formatted regression detection report"""
        print("\n" + "="*70)
        print("🚨 COVERAGE REGRESSION DETECTION REPORT")
        print("="*70)
        
        if results.get("error"):
            print(f"❌ {results['error']}")
            return
        
        summary = results["summary"]
        regressions = results["regressions"]
        
        # Overall summary
        if summary["total"] == 0:
            print("✅ No coverage regressions detected!")
        else:
            severity_emoji = {"major": "🔴", "moderate": "🟡", "minor": "🟠"}
            print(f"🚨 {summary['total']} regression(s) detected:")
            for severity in ["major", "moderate", "minor"]:
                count = summary[severity]
                if count > 0:
                    emoji = severity_emoji[severity]
                    print(f"   {emoji} {count} {severity} regression(s)")
        
        # Regression details
        if regressions:
            print(f"\n📋 REGRESSION DETAILS:")
            print("-" * 70)
            
            # Group by severity
            for severity in ["major", "moderate", "minor"]:
                severity_regressions = [r for r in regressions if r["severity"] == severity]
                if not severity_regressions:
                    continue
                
                severity_emoji = {"major": "🔴", "moderate": "🟡", "minor": "🟠"}[severity]
                print(f"\n{severity_emoji} {severity.upper()} REGRESSIONS:")
                
                for regression in severity_regressions:
                    component = regression["component"]
                    reg_type = regression["type"]
                    
                    if reg_type == "immediate":
                        drop = regression["coverage_drop"]
                        current = regression["current_coverage"]
                        previous = regression["previous_coverage"]
                        print(f"   • {component}: {previous:.1f}% → {current:.1f}% (↓{drop:.1f}%)")
                    
                    elif reg_type == "trend":
                        slope = regression["trend_slope"]
                        latest = regression["latest_coverage"]
                        mean_cov = regression["mean_coverage"]
                        print(f"   • {component}: Declining trend (slope: {slope:.3f}, latest: {latest:.1f}%, avg: {mean_cov:.1f}%)")
                    
                    elif reg_type == "volatility":
                        volatility = regression["volatility"]
                        range_val = regression["coverage_range"]
                        print(f"   • {component}: High volatility ({volatility:.1f}%, range: {range_val:.1f}%)")
        
        # Component trend summary
        component_trends = results.get("component_trends", {})
        if component_trends:
            print(f"\n📈 COMPONENT TREND SUMMARY:")
            print("-" * 70)
            print(f"{'Component':<20} | {'Latest':<8} | {'Trend':<10} | {'Volatility':<10} | {'Status'}")
            print("-" * 70)
            
            for component, trend in component_trends.items():
                if not trend["has_trend"]:
                    continue
                
                latest = trend["latest_coverage"]
                direction = trend["trend_direction"]
                volatility = trend["volatility"]
                
                # Status indicators
                trend_emoji = {"improving": "📈", "stable": "➡️", "declining": "📉"}
                trend_icon = trend_emoji.get(direction, "❓")
                
                volatility_status = "🔶 High" if trend["is_volatile"] else "🟢 Low"
                
                status = "✅ Good"
                if direction == "declining":
                    status = "🚨 Alert"
                elif trend["is_volatile"]:
                    status = "⚠️ Watch"
                
                print(f"{component:<20} | {latest:>6.1f}% | {trend_icon} {direction:<7} | {volatility_status:<10} | {status}")
        
        print("-" * 70)
        
        # Recommendations
        if regressions:
            print(f"\n💡 RECOMMENDATIONS:")
            print("-" * 50)
            
            major_regressions = [r for r in regressions if r["severity"] == "major"]
            if major_regressions:
                print("🔴 URGENT: Major coverage drops detected")
                for reg in major_regressions:
                    print(f"   • Investigate {reg['component']} immediately")
            
            declining_components = [r["component"] for r in regressions if r.get("type") == "trend"]
            if declining_components:
                print(f"📉 MONITOR: Components with declining trends: {', '.join(declining_components)}")
            
            volatile_components = [r["component"] for r in regressions if r.get("type") == "volatility"]
            if volatile_components:
                print(f"🔶 STABILIZE: Volatile coverage components: {', '.join(volatile_components)}")
        else:
            print(f"\n🎯 All components have stable coverage trends!")
        
        print("=" * 70)
    
    def save_regression_report(self, results: Dict, output_file: str = None) -> str:
        """Save regression report to JSON file"""
        if not output_file:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"{self.reports_dir}/tv_regression_report_{timestamp}.json"
        
        try:
            # Ensure directory exists
            os.makedirs(os.path.dirname(output_file), exist_ok=True)
            
            with open(output_file, 'w') as f:
                json.dump(results, f, indent=2)
            
            print(f"📄 Regression report saved: {output_file}")
            return output_file
            
        except Exception as e:
            print(f"❌ Error saving regression report: {e}")
            return ""
    
    def get_alert_level(self, results: Dict) -> str:
        """Determine alert level based on regression results"""
        summary = results.get("summary", {})
        
        if summary.get("major", 0) > 0:
            return "CRITICAL"
        elif summary.get("moderate", 0) > 0:
            return "WARNING"
        elif summary.get("minor", 0) > 0:
            return "INFO"
        else:
            return "OK"

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="TestViper Coverage Regression Detection",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python coverage_regression_detector.py                     # Analyze last 30 days
  python coverage_regression_detector.py --days 14          # Analyze last 14 days
  python coverage_regression_detector.py --reports-dir custom/ --output report.json
        """
    )
    
    parser.add_argument(
        "--days", "-d",
        type=int,
        default=30,
        help="Number of days back to analyze (default: 30)"
    )
    
    parser.add_argument(
        "--reports-dir",
        default="dashboard/reports/tv_json",
        help="Directory containing coverage analytics reports"
    )
    
    parser.add_argument(
        "--output", "-o",
        help="Output file for regression report (default: auto-generated)"
    )
    
    parser.add_argument(
        "--quiet", "-q",
        action="store_true",
        help="Suppress output (only return exit code)"
    )
    
    parser.add_argument(
        "--alert-only",
        action="store_true",
        help="Only exit non-zero if regressions found (for CI)"
    )
    
    args = parser.parse_args()
    
    # Initialize detector
    detector = CoverageRegressionDetector(reports_dir=args.reports_dir)
    
    # Run regression detection
    results = detector.run_regression_detection(days_back=args.days)
    
    # Print results unless quiet
    if not args.quiet:
        detector.print_regression_report(results)
    
    # Save report
    if args.output or not args.quiet:
        detector.save_regression_report(results, args.output)
    
    # Determine exit code for CI
    if args.alert_only:
        summary = results.get("summary", {})
        # Exit non-zero only if major or moderate regressions found
        if summary.get("major", 0) > 0 or summary.get("moderate", 0) > 0:
            return 1
        else:
            return 0
    
    return 0

if __name__ == "__main__":
    sys.exit(main())