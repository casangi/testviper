#!/usr/bin/env python3
"""
TestViper Coverage Threshold Enforcement
Enforces minimum coverage thresholds per component and overall project
"""

import json
import os
import sys
import glob
import argparse
from pathlib import Path
from typing import Dict, List, Tuple, Optional
from datetime import datetime

class CoverageThresholdChecker:
    """Enforces coverage thresholds and generates enforcement reports"""
    
    # Component-specific thresholds (can be overridden via config)
    DEFAULT_THRESHOLDS = {
        "xradio": 70.0,           # XRADIO should have high coverage
        "astroviper": 65.0,       # AstroViper needs good coverage  
        "toolviper": 60.0,        # ToolViper moderate coverage
        "graphviper": 60.0,       # GraphViper moderate coverage
        "testviper_integration": 50.0,  # Integration tests baseline
        "testviper_misc": 30.0,   # Misc tests lower threshold
        "overall": 60.0           # Overall project threshold
    }
    
    QUALITY_LEVELS = {
        "critical": {"min": 0, "max": 40, "emoji": "🔴", "action": "FAIL"},
        "low": {"min": 40, "max": 60, "emoji": "🟡", "action": "WARN"},
        "good": {"min": 60, "max": 80, "emoji": "🟢", "action": "PASS"},
        "excellent": {"min": 80, "max": 100, "emoji": "🌟", "action": "PASS"}
    }
    
    def __init__(self, config_file: Optional[str] = None):
        """Initialize with optional configuration file"""
        self.thresholds = self.DEFAULT_THRESHOLDS.copy()
        self.results = {}
        self.overall_result = "PASS"
        
        if config_file and os.path.exists(config_file):
            self.load_config(config_file)
    
    def load_config(self, config_file: str):
        """Load threshold configuration from JSON file"""
        try:
            with open(config_file, 'r') as f:
                config = json.load(f)
                self.thresholds.update(config.get("thresholds", {}))
                print(f"📋 Loaded threshold configuration from {config_file}")
        except Exception as e:
            print(f"⚠️  Could not load config file {config_file}: {e}")
    
    def get_quality_level(self, coverage: float) -> Dict:
        """Determine quality level based on coverage percentage"""
        for level, criteria in self.QUALITY_LEVELS.items():
            if criteria["min"] <= coverage < criteria["max"]:
                return {"level": level, **criteria}
        return {"level": "excellent", **self.QUALITY_LEVELS["excellent"]}
    
    def check_coverage_file(self, coverage_file: str) -> Optional[Dict]:
        """Parse a single coverage file and extract metrics"""
        try:
            with open(coverage_file, 'r') as f:
                data = json.load(f)
            
            # Extract component name from filename
            component = coverage_file.replace('coverage_', '').replace('.json', '')
            if '/' in component:
                component = component.split('/')[-1]
            
            # Get coverage percentage
            coverage_pct = data.get("totals", {}).get("percent_covered", 0)
            
            # Get additional metrics
            total_statements = data.get("totals", {}).get("num_statements", 0)
            covered_lines = data.get("totals", {}).get("covered_lines", 0)
            missing_lines = data.get("totals", {}).get("missing_lines", 0)
            
            return {
                "component": component,
                "coverage_percentage": round(coverage_pct, 2),
                "total_statements": total_statements,
                "covered_lines": covered_lines,
                "missing_lines": missing_lines,
                "coverage_file": coverage_file
            }
            
        except Exception as e:
            print(f"❌ Error reading coverage file {coverage_file}: {e}")
            return None
    
    def check_component_threshold(self, component: str, coverage: float) -> Dict:
        """Check if component meets its threshold"""
        threshold = self.thresholds.get(component, self.thresholds.get("overall", 50.0))
        quality = self.get_quality_level(coverage)
        
        # Determine if threshold is met
        threshold_met = coverage >= threshold
        
        # Determine action based on quality level and threshold
        if not threshold_met:
            action = "FAIL"
            status_emoji = "❌"
        elif quality["action"] == "FAIL":
            action = "FAIL"
            status_emoji = "❌"
        elif quality["action"] == "WARN":
            action = "WARN" 
            status_emoji = "⚠️"
        else:
            action = "PASS"
            status_emoji = "✅"
        
        return {
            "component": component,
            "coverage": coverage,
            "threshold": threshold,
            "threshold_met": threshold_met,
            "quality_level": quality["level"],
            "quality_emoji": quality["emoji"],
            "action": action,
            "status_emoji": status_emoji,
            "gap": round(threshold - coverage, 2) if coverage < threshold else 0
        }
    
    def scan_coverage_files(self, coverage_dir: str = ".") -> List[Dict]:
        """Scan directory for coverage files and parse them"""
        coverage_files = glob.glob(os.path.join(coverage_dir, "coverage_*.json"))
        coverage_data = []
        
        for file in coverage_files:
            data = self.check_coverage_file(file)
            if data:
                coverage_data.append(data)
        
        return coverage_data
    
    def check_all_thresholds(self, coverage_dir: str = ".") -> Dict:
        """Check all components against their thresholds"""
        print(f"🔍 Scanning for coverage files in {os.path.abspath(coverage_dir)}")
        
        # Get coverage data from files
        coverage_data = self.scan_coverage_files(coverage_dir)
        
        if not coverage_data:
            print("❌ No coverage files found!")
            return {
                "overall_result": "FAIL",
                "error": "No coverage data available",
                "components": {},
                "summary": {
                    "total_components": 0,
                    "passing": 0,
                    "warnings": 0,
                    "failing": 0,
                    "average_coverage": 0
                }
            }
        
        print(f"📊 Found coverage data for {len(coverage_data)} components")
        
        # Check each component against thresholds
        component_results = {}
        total_coverage = 0
        passing = 0
        warnings = 0
        failing = 0
        
        for data in coverage_data:
            component = data["component"]
            coverage = data["coverage_percentage"]
            
            result = self.check_component_threshold(component, coverage)
            result.update(data)  # Add file details
            
            component_results[component] = result
            total_coverage += coverage
            
            if result["action"] == "PASS":
                passing += 1
            elif result["action"] == "WARN":
                warnings += 1
            else:
                failing += 1
        
        # Calculate overall metrics
        average_coverage = total_coverage / len(coverage_data) if coverage_data else 0
        overall_threshold = self.thresholds.get("overall", 60.0)
        overall_meets_threshold = average_coverage >= overall_threshold
        
        # Determine overall result
        if failing > 0:
            overall_result = "FAIL"
        elif warnings > 0:
            overall_result = "WARN"
        else:
            overall_result = "PASS"
        
        # Override if overall threshold not met
        if not overall_meets_threshold:
            overall_result = "FAIL"
        
        return {
            "overall_result": overall_result,
            "overall_coverage": round(average_coverage, 2),
            "overall_threshold": overall_threshold,
            "overall_meets_threshold": overall_meets_threshold,
            "components": component_results,
            "summary": {
                "total_components": len(coverage_data),
                "passing": passing,
                "warnings": warnings,
                "failing": failing,
                "average_coverage": round(average_coverage, 2)
            },
            "timestamp": datetime.now().isoformat()
        }
    
    def print_results(self, results: Dict):
        """Print formatted threshold check results"""
        print("\n" + "="*70)
        print("📊 COVERAGE THRESHOLD ENFORCEMENT REPORT")
        print("="*70)
        
        if results.get("error"):
            print(f"❌ {results['error']}")
            return
        
        # Overall summary
        overall = results["overall_result"]
        overall_emoji = {"PASS": "✅", "WARN": "⚠️", "FAIL": "❌"}[overall]
        
        print(f"\n{overall_emoji} OVERALL RESULT: {overall}")
        print(f"📈 Average Coverage: {results['overall_coverage']:.1f}% (threshold: {results['overall_threshold']:.1f}%)")
        
        summary = results["summary"]
        print(f"📋 Components: {summary['total_components']} total | ")
        print(f"   ✅ {summary['passing']} passing | ⚠️ {summary['warnings']} warnings | ❌ {summary['failing']} failing")
        
        # Component details
        print(f"\n📊 COMPONENT BREAKDOWN:")
        print("-" * 70)
        print(f"{'Component':<20} | {'Coverage':<10} | {'Threshold':<10} | {'Status':<8} | {'Quality'}")
        print("-" * 70)
        
        for component, data in results["components"].items():
            status_text = f"{data['status_emoji']} {data['action']}"
            quality_text = f"{data['quality_emoji']} {data['quality_level']}"
            gap_text = f"(-{data['gap']:.1f}%)" if data['gap'] > 0 else ""
            
            print(f"{component:<20} | {data['coverage']:>7.1f}% | {data['threshold']:>7.1f}% | {status_text:<8} | {quality_text} {gap_text}")
        
        # Recommendations
        print(f"\n💡 RECOMMENDATIONS:")
        print("-" * 50)
        
        failing_components = [comp for comp, data in results["components"].items() if data["action"] == "FAIL"]
        warning_components = [comp for comp, data in results["components"].items() if data["action"] == "WARN"]
        
        if failing_components:
            print(f"🔴 CRITICAL: Fix coverage for {', '.join(failing_components)}")
            for comp in failing_components:
                gap = results["components"][comp]["gap"]
                print(f"   • {comp}: Add {gap:.1f}% coverage to meet threshold")
        
        if warning_components:
            print(f"🟡 IMPROVE: Consider increasing coverage for {', '.join(warning_components)}")
        
        if results["overall_result"] == "PASS":
            print(f"🎯 All components meet minimum thresholds!")
        
        print("-" * 70)
    
    def save_results(self, results: Dict, output_file: str = None) -> str:
        """Save results to JSON file"""
        if not output_file:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            output_file = f"coverage_threshold_report_{timestamp}.json"
        
        try:
            # Ensure directory exists
            os.makedirs(os.path.dirname(output_file) if os.path.dirname(output_file) else ".", exist_ok=True)
            
            with open(output_file, 'w') as f:
                json.dump(results, f, indent=2)
            
            print(f"📄 Threshold report saved: {output_file}")
            return output_file
            
        except Exception as e:
            print(f"❌ Error saving report: {e}")
            return ""
    
    def get_exit_code(self, results: Dict) -> int:
        """Get appropriate exit code based on results"""
        if results.get("error"):
            return 2  # Error
        elif results["overall_result"] == "FAIL":
            return 1  # Failure
        elif results["overall_result"] == "WARN":
            return 0  # Warning (still pass in CI unless --strict)
        else:
            return 0  # Success

def create_default_config():
    """Create a default threshold configuration file"""
    config = {
        "description": "TestViper Coverage Threshold Configuration",
        "thresholds": CoverageThresholdChecker.DEFAULT_THRESHOLDS,
        "quality_levels": CoverageThresholdChecker.QUALITY_LEVELS,
        "notes": [
            "Adjust thresholds based on component complexity and testing needs",
            "Higher thresholds for critical components, lower for experimental code",
            "Use 'overall' threshold for project-wide minimum coverage"
        ]
    }
    
    config_file = "coverage_thresholds.json"
    with open(config_file, 'w') as f:
        json.dump(config, f, indent=2)
    
    print(f"📋 Created default threshold configuration: {config_file}")
    return config_file

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="TestViper Coverage Threshold Enforcement",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python coverage_threshold_checker.py                    # Check current directory
  python coverage_threshold_checker.py --dir build/       # Check specific directory
  python coverage_threshold_checker.py --config custom.json --strict   # Use custom config and strict mode
  python coverage_threshold_checker.py --create-config    # Create default config file
  python coverage_threshold_checker.py --report-only      # Only generate report, don't check thresholds
        """
    )
    
    parser.add_argument(
        "--dir", "-d",
        default=".",
        help="Directory to scan for coverage files (default: current directory)"
    )
    
    parser.add_argument(
        "--config", "-c",
        help="Path to threshold configuration file (JSON)"
    )
    
    parser.add_argument(
        "--output", "-o",
        help="Output file for threshold report (default: auto-generated)"
    )
    
    parser.add_argument(
        "--strict",
        action="store_true",
        help="Strict mode: warnings also cause non-zero exit code"
    )
    
    parser.add_argument(
        "--create-config",
        action="store_true", 
        help="Create a default threshold configuration file and exit"
    )
    
    parser.add_argument(
        "--report-only",
        action="store_true",
        help="Generate report without enforcing thresholds (always exit 0)"
    )
    
    parser.add_argument(
        "--quiet", "-q",
        action="store_true",
        help="Suppress output (only return exit code)"
    )
    
    args = parser.parse_args()
    
    # Create config and exit
    if args.create_config:
        create_default_config()
        return 0
    
    # Initialize checker
    checker = CoverageThresholdChecker(config_file=args.config)
    
    # Check thresholds
    results = checker.check_all_thresholds(args.dir)
    
    # Print results unless quiet
    if not args.quiet:
        checker.print_results(results)
    
    # Save report
    if args.output or not args.quiet:
        output_file = args.output
        if not output_file:
            # Save to reports directory if it exists
            reports_dir = "dashboard/reports/tv_json"
            if os.path.exists(reports_dir):
                timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
                output_file = f"{reports_dir}/tv_threshold_report_{timestamp}.json"
        
        checker.save_results(results, output_file)
    
    # Determine exit code
    if args.report_only:
        return 0
    
    exit_code = checker.get_exit_code(results)
    
    # In strict mode, warnings also fail
    if args.strict and results.get("overall_result") == "WARN":
        exit_code = 1
    
    if not args.quiet:
        action_text = {0: "✅ PASSED", 1: "❌ FAILED", 2: "💥 ERROR"}[exit_code]
        print(f"\n🎯 Threshold enforcement: {action_text} (exit code: {exit_code})")
    
    return exit_code

if __name__ == "__main__":
    sys.exit(main())