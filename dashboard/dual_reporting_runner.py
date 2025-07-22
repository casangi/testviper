#!/usr/bin/env python3
"""
TestViper Dual Reporting Test Runner
Executes tests and reports to multiple ReportPortal instances simultaneously
"""

import json
import os
import sys
import subprocess
import argparse
import asyncio
import threading
from pathlib import Path
from typing import Dict, List, Optional, Any
from datetime import datetime
from concurrent.futures import ThreadPoolExecutor, as_completed

# Add dashboard directory to path
dashboard_dir = Path(__file__).parent
sys.path.insert(0, str(dashboard_dir))

from dual_reporting_config import DualReportingConfigManager, ReportPortalConfig

class DualReportingTestRunner:
    """Run tests and report to multiple ReportPortal instances"""
    
    def __init__(self, config_manager: DualReportingConfigManager):
        """Initialize with configuration manager"""
        self.config_manager = config_manager
        self.test_results = {}
        self.reporting_results = {}
    
    def run_test_for_config(self, config: ReportPortalConfig, test_path: str, 
                          launch_name: str, component_name: str, 
                          enable_coverage: bool = True) -> Dict[str, Any]:
        """Run tests for a specific ReportPortal configuration"""
        print(f"🚀 Running tests for {config.name} ({config.endpoint})")
        
        # Set up environment for this configuration
        env = os.environ.copy()
        config_env = self.config_manager.setup_environment_for_config(config)
        env.update(config_env)
        
        # Generate launch name with config suffix
        config_launch_name = f"{launch_name}_{config.name}"
        
        # Build pytest command
        cmd = [
            sys.executable, "-m", "pytest",
            "--verbose",
            "--tb=short",
            "-p", "pytest_reportportal",
            "--reportportal",
            f"--rp-endpoint={config.endpoint}",
            f"--rp-project={config.project}",
            f"--rp-launch={config_launch_name}",
            f"--rp-launch-description=TestViper {component_name} tests with coverage (reported to {config.name})",
            "--capture=no",
            "--log-cli-level=INFO",
            f"--confcutdir={os.getcwd()}",
            f"-p", "no:cacheprovider"
        ]
        
        # Add launch attributes
        if config.launch_attributes:
            for key, value in config.launch_attributes.items():
                cmd.extend(["--rp-launch-attribute", f"{key}:{value}"])
        
        # Add coverage if enabled
        if enable_coverage:
            src_dir = self.determine_source_directory(component_name)
            if src_dir:
                coverage_file = f"coverage_{component_name}_{config.name}"
                cmd.extend([
                    f"--cov={src_dir}",
                    f"--cov-report=json:{coverage_file}.json",
                    f"--cov-report=xml:{coverage_file}.xml",
                    "--cov-report=term",
                    "--cov-branch"
                ])
        
        # Add test path
        cmd.append(test_path)
        
        # Run the tests
        start_time = datetime.now()
        try:
            result = subprocess.run(cmd, env=env, capture_output=True, text=True, check=False)
            
            return {
                "config_name": config.name,
                "success": result.returncode == 0,
                "returncode": result.returncode,
                "duration": (datetime.now() - start_time).total_seconds(),
                "stdout": result.stdout,
                "stderr": result.stderr,
                "launch_name": config_launch_name,
                "endpoint": config.endpoint,
                "project": config.project
            }
            
        except Exception as e:
            return {
                "config_name": config.name,
                "success": False,
                "error": str(e),
                "duration": (datetime.now() - start_time).total_seconds(),
                "launch_name": config_launch_name,
                "endpoint": config.endpoint,
                "project": config.project
            }
    
    def determine_source_directory(self, component_name: str) -> Optional[str]:
        """Determine source directory for coverage tracking"""
        if component_name == "testviper_integration":
            return "src"
        elif component_name == "testviper_misc":
            return None  # No source code
        else:
            src_dir = f"{component_name}/src"
            return src_dir if os.path.exists(src_dir) else None
    
    def run_tests_parallel(self, test_path: str, component_name: str, 
                          launch_name: str, enable_coverage: bool = True,
                          max_workers: int = 3) -> Dict[str, Any]:
        """Run tests in parallel across multiple ReportPortal instances"""
        
        enabled_configs = self.config_manager.get_enabled_configs()
        
        if not enabled_configs:
            return {
                "success": False,
                "error": "No enabled ReportPortal configurations found",
                "results": {}
            }
        
        print(f"📊 Running tests for {component_name} across {len(enabled_configs)} ReportPortal instances")
        print(f"🧪 Test path: {test_path}")
        print(f"🚀 Launch name: {launch_name}")
        print(f"📈 Coverage enabled: {enable_coverage}")
        print()
        
        # Run tests in parallel
        with ThreadPoolExecutor(max_workers=max_workers) as executor:
            # Submit all test jobs
            future_to_config = {
                executor.submit(
                    self.run_test_for_config,
                    config, test_path, launch_name, component_name, enable_coverage
                ): config for config in enabled_configs
            }
            
            # Collect results
            results = {}
            for future in as_completed(future_to_config):
                config = future_to_config[future]
                try:
                    result = future.result()
                    results[config.name] = result
                    
                    # Print immediate feedback
                    if result["success"]:
                        print(f"✅ {config.name}: Tests completed successfully")
                    else:
                        print(f"❌ {config.name}: Tests failed (exit code: {result.get('returncode', 'unknown')})")
                        
                except Exception as e:
                    results[config.name] = {
                        "config_name": config.name,
                        "success": False,
                        "error": f"Exception during test execution: {str(e)}",
                        "endpoint": config.endpoint,
                        "project": config.project
                    }
                    print(f"💥 {config.name}: Exception during test execution: {e}")
        
        # Summary
        successful_runs = sum(1 for r in results.values() if r["success"])
        total_runs = len(results)
        
        return {
            "success": successful_runs > 0,  # Success if at least one instance succeeded
            "total_instances": total_runs,
            "successful_instances": successful_runs,
            "failed_instances": total_runs - successful_runs,
            "results": results,
            "summary": {
                "component": component_name,
                "test_path": test_path,
                "launch_name": launch_name,
                "coverage_enabled": enable_coverage,
                "timestamp": datetime.now().isoformat()
            }
        }
    
    def run_tests_sequential(self, test_path: str, component_name: str, 
                           launch_name: str, enable_coverage: bool = True) -> Dict[str, Any]:
        """Run tests sequentially across ReportPortal instances (safer for resource-constrained environments)"""
        
        enabled_configs = self.config_manager.get_enabled_configs()
        
        if not enabled_configs:
            return {
                "success": False,
                "error": "No enabled ReportPortal configurations found",
                "results": {}
            }
        
        print(f"📊 Running tests for {component_name} sequentially across {len(enabled_configs)} ReportPortal instances")
        print(f"🧪 Test path: {test_path}")
        print(f"🚀 Launch name: {launch_name}")
        print(f"📈 Coverage enabled: {enable_coverage}")
        print()
        
        results = {}
        
        for config in enabled_configs:
            print(f"🔄 Running tests for {config.name}...")
            
            result = self.run_test_for_config(
                config, test_path, launch_name, component_name, enable_coverage
            )
            
            results[config.name] = result
            
            if result["success"]:
                print(f"✅ {config.name}: Tests completed successfully (duration: {result['duration']:.1f}s)")
            else:
                print(f"❌ {config.name}: Tests failed (duration: {result['duration']:.1f}s)")
                if result.get("error"):
                    print(f"   Error: {result['error']}")
            print()
        
        # Summary
        successful_runs = sum(1 for r in results.values() if r["success"])
        total_runs = len(results)
        
        return {
            "success": successful_runs > 0,
            "total_instances": total_runs,
            "successful_instances": successful_runs,
            "failed_instances": total_runs - successful_runs,
            "results": results,
            "summary": {
                "component": component_name,
                "test_path": test_path,
                "launch_name": launch_name,
                "coverage_enabled": enable_coverage,
                "timestamp": datetime.now().isoformat()
            }
        }
    
    def print_results_summary(self, results: Dict[str, Any]):
        """Print formatted summary of dual reporting results"""
        print("\n" + "="*80)
        print("📊 DUAL REPORTING RESULTS SUMMARY")
        print("="*80)
        
        if results.get("error"):
            print(f"❌ {results['error']}")
            return
        
        summary = results["summary"]
        print(f"🧪 Component: {summary['component']}")
        print(f"📂 Test Path: {summary['test_path']}")
        print(f"🚀 Launch Name: {summary['launch_name']}")
        print(f"📈 Coverage: {'Enabled' if summary['coverage_enabled'] else 'Disabled'}")
        print()
        
        # Overall results
        total = results["total_instances"]
        successful = results["successful_instances"]
        failed = results["failed_instances"]
        
        success_rate = (successful / total * 100) if total > 0 else 0
        
        print(f"📊 Overall Results: {successful}/{total} instances successful ({success_rate:.1f}%)")
        
        if successful > 0:
            print("✅ SUCCESS: Tests reported to at least one ReportPortal instance")
        else:
            print("❌ FAILURE: No ReportPortal instances received test results")
        
        print("\n📋 Instance Details:")
        print("-" * 80)
        print(f"{'Instance':<15} | {'Status':<8} | {'Duration':<10} | {'Endpoint':<30} | {'Project'}")
        print("-" * 80)
        
        for instance_name, result in results["results"].items():
            status = "✅ PASS" if result["success"] else "❌ FAIL"
            duration = f"{result.get('duration', 0):.1f}s"
            endpoint = result.get("endpoint", "Unknown")
            project = result.get("project", "Unknown")
            
            print(f"{instance_name:<15} | {status:<8} | {duration:<10} | {endpoint:<30} | {project}")
            
            # Show error details if failed
            if not result["success"] and result.get("error"):
                print(f"{'':>17} Error: {result['error']}")
        
        print("-" * 80)
        
        # Coverage file information
        if summary['coverage_enabled']:
            print("\n📈 Coverage Reports Generated:")
            for instance_name in results["results"].keys():
                coverage_file = f"coverage_{summary['component']}_{instance_name}.json"
                if os.path.exists(coverage_file):
                    print(f"   ✅ {coverage_file}")
                else:
                    print(f"   ❌ {coverage_file} (not found)")
        
        print("="*80)
    
    def save_results(self, results: Dict[str, Any], output_file: str = None) -> str:
        """Save dual reporting results to file"""
        if not output_file:
            timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
            component = results.get("summary", {}).get("component", "unknown")
            output_file = f"dashboard/reports/tv_json/tv_dual_reporting_{component}_{timestamp}.json"
        
        try:
            os.makedirs(os.path.dirname(output_file), exist_ok=True)
            
            with open(output_file, 'w') as f:
                json.dump(results, f, indent=2)
            
            print(f"📄 Dual reporting results saved: {output_file}")
            return output_file
            
        except Exception as e:
            print(f"❌ Error saving results: {e}")
            return ""

def determine_component_name(test_path: str) -> str:
    """Determine component name from test path"""
    if "xradio" in test_path:
        return "xradio"
    elif "toolviper" in test_path:
        return "toolviper"
    elif "graphviper" in test_path:
        return "graphviper"
    elif "astroviper" in test_path:
        return "astroviper"
    elif "tests/integration" in test_path:
        return "testviper_integration"
    else:
        return "testviper_misc"

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="TestViper Dual Reporting Test Runner",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python dual_reporting_runner.py tests/integration                    # Run integration tests
  python dual_reporting_runner.py xradio/tests --launch-name xradio_ci # Run xradio tests with custom launch
  python dual_reporting_runner.py --test-path tests/unit --sequential  # Run sequentially
  python dual_reporting_runner.py --show-config                        # Show configuration
        """
    )
    
    parser.add_argument(
        "test_path",
        nargs="?",
        default="tests/integration",
        help="Test path to run (default: tests/integration)"
    )
    
    parser.add_argument(
        "--config", "-c",
        help="Path to dual reporting configuration file"
    )
    
    parser.add_argument(
        "--launch-name",
        help="Custom launch name (default: auto-generated from component)"
    )
    
    parser.add_argument(
        "--no-coverage",
        action="store_true",
        help="Disable coverage tracking"
    )
    
    parser.add_argument(
        "--sequential",
        action="store_true",
        help="Run tests sequentially instead of parallel"
    )
    
    parser.add_argument(
        "--max-workers",
        type=int,
        default=3,
        help="Maximum worker threads for parallel execution (default: 3)"
    )
    
    parser.add_argument(
        "--show-config",
        action="store_true",
        help="Show configuration and exit"
    )
    
    parser.add_argument(
        "--output", "-o",
        help="Output file for results (default: auto-generated)"
    )
    
    args = parser.parse_args()
    
    # Initialize configuration manager
    config_manager = DualReportingConfigManager(config_file=args.config)
    
    if args.show_config:
        config_manager.print_config_summary()
        return 0
    
    # Determine component and launch name
    component_name = determine_component_name(args.test_path)
    launch_name = args.launch_name or f"{component_name}_tests"
    
    # Initialize runner
    runner = DualReportingTestRunner(config_manager)
    
    # Run tests
    print("🚀 Starting dual reporting test execution...")
    print(f"📊 Component: {component_name}")
    print(f"📂 Test Path: {args.test_path}")
    print(f"🚀 Launch Name: {launch_name}")
    print(f"📈 Coverage: {'Disabled' if args.no_coverage else 'Enabled'}")
    print(f"🔄 Execution Mode: {'Sequential' if args.sequential else 'Parallel'}")
    
    if args.sequential:
        results = runner.run_tests_sequential(
            test_path=args.test_path,
            component_name=component_name,
            launch_name=launch_name,
            enable_coverage=not args.no_coverage
        )
    else:
        results = runner.run_tests_parallel(
            test_path=args.test_path,
            component_name=component_name,
            launch_name=launch_name,
            enable_coverage=not args.no_coverage,
            max_workers=args.max_workers
        )
    
    # Print results
    runner.print_results_summary(results)
    
    # Save results
    runner.save_results(results, args.output)
    
    # Exit with appropriate code
    return 0 if results["success"] else 1

if __name__ == "__main__":
    sys.exit(main())