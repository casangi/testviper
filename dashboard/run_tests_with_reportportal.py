#!/usr/bin/env python3
"""
TestViper ReportPortal Integration Script with Coverage Tracking
Enhanced script to run tests with ReportPortal integration and coverage collection
"""

import json
import os
import sys
import subprocess
import argparse
from pathlib import Path
from datetime import datetime
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

# Add dashboard directory to path for analytics import
dashboard_dir = Path(__file__).parent
sys.path.insert(0, str(dashboard_dir))

def collect_coverage_data(test_path, component_name):
    """
    Collect coverage data for the specified component and test path.
    Returns coverage percentage and additional metrics.
    """
    coverage_file = f"coverage_{component_name}.json"
    xml_file = f"coverage_{component_name}.xml"
    
    try:
        # Read JSON coverage report
        if os.path.exists(coverage_file):
            with open(coverage_file, 'r') as f:
                coverage_data = json.load(f)
                
            total_coverage = coverage_data.get("totals", {}).get("percent_covered", 0)
            line_coverage = coverage_data.get("totals", {}).get("percent_covered_display", "0%")
            num_statements = coverage_data.get("totals", {}).get("num_statements", 0)
            missing_lines = coverage_data.get("totals", {}).get("missing_lines", 0)
            
            return {
                "coverage_percentage": round(total_coverage, 2),
                "coverage_display": line_coverage,
                "total_statements": num_statements,
                "missing_lines": missing_lines,
                "coverage_file": coverage_file
            }
    except Exception as e:
        print(f"Warning: Could not read coverage data: {e}")
    
    return {
        "coverage_percentage": 0,
        "coverage_display": "N/A",
        "total_statements": 0,
        "missing_lines": 0,
        "coverage_file": "none"
    }

def determine_component_name(test_path):
    """Determine component name from test path for coverage tracking."""
    # Check for component names first (higher priority for component-specific tests)
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

def setup_coverage_for_component(test_path, component_name):
    """Setup component-specific coverage configuration."""
    
    # Determine source directory for coverage
    if component_name == "testviper_integration":
        src_dir = "src"  # Main testviper source
    elif component_name == "testviper_misc":
        # testviper has no source code, skip coverage
        return None
    else:
        src_dir = f"{component_name}/src"  # Component source
        
    # Check if source directory exists
    if not os.path.exists(src_dir):
        print(f"Warning: Source directory {src_dir} not found for coverage")
        return None  # Don't collect coverage if no source exists
    
    return src_dir

def generate_launch_name(test_path, custom_name=None):
    """Generate component-specific launch names"""
    if custom_name:
        return custom_name
    
    # Use TV_COMPONENT_NAME if set, otherwise determine from test path
    component = os.getenv("TV_COMPONENT_NAME")
    if not component:
        component = determine_component_name(test_path)
    
    # Default to component name (requirement: if launch name is not given, use component name)
    return component

def generate_launch_description(test_path):
    """Generate component-specific descriptions"""
    # Use TV_COMPONENT_NAME if set, otherwise determine from test path
    component = os.getenv("TV_COMPONENT_NAME")
    if not component:
        component = determine_component_name(test_path)
    descriptions = {
        "xradio": "XRADIO Component Tests with Coverage",
        "toolviper": "ToolViper Component Tests with Coverage", 
        "graphviper": "GraphViper Component Tests with Coverage",
        "astroviper": "AstroViper Component Tests with Coverage",
        "testviper_integration": "TestViper Integration Tests with Coverage",
        "testviper_misc": f"TestViper Tests: {test_path} with Coverage"
    }
    return descriptions.get(component, f"TestViper Tests: {test_path}")

def check_reportportal_connection():
    """Check if ReportPortal is accessible"""
    try:
        from analytics.rp_client import TVReportPortalClient
        client = TVReportPortalClient()
        status = client.test_connection()
        return status.get("status") == "success", status
    except Exception as e:
        return False, {"error": str(e)}

def check_environment():
    """Check environment configuration"""
    issues = []
    
    # Check API key
    if not os.getenv("RP_API_KEY"):
        issues.append("❌ RP_API_KEY not found in environment")
    
    # Check ReportPortal endpoint
    endpoint = os.getenv("RP_ENDPOINT", "http://localhost:8080")
    project = os.getenv("RP_PROJECT", "testviper")
    
    print(f"🔍 Environment Check:")
    print(f"  ReportPortal Endpoint: {endpoint}")
    print(f"  Project: {project}")
    print(f"  API Key: {'✅ Configured' if os.getenv('RP_API_KEY') else '❌ Missing'}")
    
    return issues

def setup_python_paths():
    """Auto-detect and add component source directories to Python path"""
    current_pythonpath = os.environ.get("PYTHONPATH", "")
    python_paths = []
    
    # Add all VIPER component source directories that exist
    viper_components = ["xradio", "toolviper", "graphviper", "astroviper"]
    for component in viper_components:
        src_path = os.path.abspath(f"{component}/src")
        if os.path.exists(src_path):
            python_paths.append(src_path)
    
    # Add src/ directory versions (for components that might be in src/)
    for component in viper_components:
        src_path = os.path.abspath(f"src/{component}/src")
        if os.path.exists(src_path):
            python_paths.append(src_path)
    
    # Update PYTHONPATH with all discovered paths
    if python_paths:
        all_paths = ":".join(python_paths)
        if current_pythonpath:
            new_pythonpath = f"{all_paths}:{current_pythonpath}"
        else:
            new_pythonpath = all_paths
        os.environ["PYTHONPATH"] = new_pythonpath
        return python_paths
    
    return []

def run_tests_with_coverage_tracking(test_path, custom_launch_name=None, enable_coverage=True, additional_args=None):
    """
    Enhanced test runner that collects coverage data and adds it to ReportPortal.
    """
    
    # Setup Python paths for multi-component support
    python_paths = setup_python_paths()
    
    # Generate launch details
    component_name = determine_component_name(test_path)
    launch_name = generate_launch_name(test_path, custom_launch_name)
    launch_description = generate_launch_description(test_path)
    
    # Setup coverage if enabled
    coverage_args = []
    if enable_coverage:
        src_dir = setup_coverage_for_component(test_path, component_name)
        if src_dir:  # Only add coverage args if source directory exists
            coverage_file = f"coverage_{component_name}"
            
            coverage_args = [
                f"--cov={src_dir}",
                f"--cov-report=json:{coverage_file}.json",
                f"--cov-report=xml:{coverage_file}.xml",
                "--cov-report=term",  # Terminal output
                "--cov-branch",  # Include branch coverage
            ]
            print(f"📊 Coverage enabled for {component_name} source: {src_dir}")
        else:
            print(f"⚠️  Coverage skipped for {component_name} (no source directory)")
            enable_coverage = False  # Disable coverage tracking
    
    # Set environment variables for ReportPortal and coverage
    env = os.environ.copy()
    
    # Set all ReportPortal configuration via environment variables
    # IMPORTANT: Set these BEFORE building the command to ensure pytest-reportportal reads them
    env.update({
        "RP_ENDPOINT": os.getenv("RP_ENDPOINT", "http://localhost:8080"),
        "RP_PROJECT": os.getenv("RP_PROJECT", "testviper"),
        "RP_API_KEY": os.getenv("RP_API_KEY", ""),
        "RP_UUID": os.getenv("RP_API_KEY", ""),  # Keep for backward compatibility
        "RP_LAUNCH": launch_name,
        "RP_LAUNCH_DESCRIPTION": launch_description,
        # Coverage tracking environment variables
        "TV_COMPONENT_NAME": component_name,
        "TV_ENABLE_COVERAGE": str(enable_coverage),
        "TV_COVERAGE_FILE": f"coverage_{component_name}.json" if enable_coverage else ""
    })
    
    # Also set them in current process so our reporter can access them
    os.environ.update(env)
    
    # Prepare launch attributes for coverage
    launch_attributes = []
    if enable_coverage and src_dir:
        # Will be set by the reporter when coverage data is available
        pass  
    else:
        # No coverage - set default attributes
        launch_attributes = [
            f"tv_coverage_percentage:0%",
            f"tv_coverage_component:{component_name}",
            f"tv_coverage_status:no_source_code"
        ]
    
    # Build pytest arguments
    # Use both environment variables AND command line args for maximum compatibility
    cmd = [
        sys.executable, "-m", "pytest",
        "--verbose",
        "--tb=short",
        "-p", "pytest_reportportal",  # Explicitly load ReportPortal plugin
        "--reportportal",  # Enable ReportPortal reporting
        f"--rp-launch={launch_name}",  # Set launch name explicitly
        f"--rp-launch-description={launch_description}",  # Set description explicitly
        f"--rp-project={env['RP_PROJECT']}",  # Set project explicitly
        "--capture=no",    # Show output during tests
        "--log-cli-level=INFO",
        f"--confcutdir={os.getcwd()}",  # Search for conftest.py from testviper root
        f"-p", "no:cacheprovider"  # Disable cache to avoid conflicts
    ]
    
    # Note: --rp-launch-attributes is not supported by pytest-reportportal
    # We'll rely on the reporter plugin to inject attributes via environment variables
    if launch_attributes:
        print(f"📋 Coverage attributes will be set by reporter: {len(launch_attributes)} attributes")
    
    # Add coverage arguments
    cmd.extend(coverage_args)
    
    # Add test path
    if test_path:
        cmd.append(test_path)
    else:
        cmd.append("tests/integration")
    
    # Add additional arguments
    if additional_args:
        cmd.extend(additional_args)
    
    print(f"🚀 Running tests for {component_name} with coverage tracking...")
    print(f"📊 Launch name: {launch_name}")
    print(f"🔍 Test path: {test_path}")
    if enable_coverage:
        src_dir = setup_coverage_for_component(test_path, component_name)
        print(f"📈 Coverage will be tracked for: {src_dir}")
    if python_paths:
        print(f"   Python paths added: {', '.join(python_paths)}")
    print()
    
    print(f"🧪 Running tests with ReportPortal integration:")
    print(f"   Command: {' '.join(cmd)}")
    print(f"   Working directory: {Path.cwd()}")
    print()
    
    print(f"📊 ReportPortal Launch: {env['RP_LAUNCH']}")
    print("=" * 60)
    
    try:
        # Run tests
        result = subprocess.run(cmd, env=env, check=False)
        
        print("\\n" + "=" * 60)
        print("🏁 Test Execution Complete")
        print(f"   Exit Code: {result.returncode}")
        
        if result.returncode == 0:
            print("   ✅ All tests passed!")
        else:
            print("   ❌ Some tests failed or had issues")
        
        # Collect and display coverage results
        if enable_coverage:
            coverage_data = collect_coverage_data(test_path, component_name)
            print(f"\\n📈 Coverage Results for {component_name}:")
            print(f"   • Coverage: {coverage_data['coverage_display']}")
            print(f"   • Statements: {coverage_data['total_statements']}")
            print(f"   • Missing lines: {coverage_data['missing_lines']}")
        
        return result.returncode == 0, result.returncode
        
    except KeyboardInterrupt:
        print("\\n🛑 Tests interrupted by user")
        return False, 1
    except Exception as e:
        print(f"\\n❌ Error running tests: {e}")
        return False, 1

def generate_analytics_report():
    """Generate analytics report after test execution"""
    try:
        from analytics.simple_report_generator import TVSimpleReportGenerator
        
        print("\\n📊 Generating Analytics Report...")
        generator = TVSimpleReportGenerator()
        
        # Save detailed report
        report_path = generator.save_analytics_report()
        print(f"   📄 Report saved: {report_path}")
        
        # Print summary
        generator.print_summary()
        
        # Generate coverage analytics report
        print(f"\\n📈 Generating Coverage Analytics Report...")
        try:
            from analytics.coverage_analytics import CoverageAnalytics
            coverage_analytics = CoverageAnalytics()
            coverage_report = coverage_analytics.generate_coverage_report(days_back=30)
            
            if not coverage_report.get("error"):
                coverage_report_file = coverage_analytics.save_report(coverage_report)
                print(f"   📄 Coverage analytics saved: {coverage_report_file}")
                
                # Print summary if we have data
                components = coverage_report.get("summary", {}).get("components", {})
                if components:
                    print(f"\\n📊 Coverage Trends Summary:")
                    for component, data in components.items():
                        trend_emoji = {"improving": "📈", "declining": "📉", "stable": "➡️"}.get(data["trend"], "❓")
                        print(f"   {data['display_name']:15} | {data['avg_coverage']:6.1f}% | {trend_emoji} {data['trend']}")
            else:
                print(f"   ⚠️  No coverage data available: {coverage_report.get('error')}")
                
        except Exception as e:
            print(f"   ⚠️  Coverage analytics generation failed: {e}")
        
        return True
        
    except Exception as e:
        print(f"❌ Error generating analytics report: {e}")
        return False

def main():
    """Main function"""
    parser = argparse.ArgumentParser(
        description="Run TestViper tests with ReportPortal integration and coverage tracking",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python run_tests_with_reportportal.py tests/integration
  python run_tests_with_reportportal.py xradio/tests/unit
  python run_tests_with_reportportal.py tests/ --launch-name "all_tests"
  python run_tests_with_reportportal.py --test-path tests/integration/test_specific.py
  python run_tests_with_reportportal.py --launch-name "nightly_regression_tests"
  python run_tests_with_reportportal.py --check-only
  python run_tests_with_reportportal.py --analytics-only
  python run_tests_with_reportportal.py xradio/tests --no-coverage
        """
    )
    
    parser.add_argument(
        "test_path",
        nargs="?",
        default=None,
        help="Test path to run (default: tests/integration)"
    )
    
    parser.add_argument(
        "--test-path",
        dest="test_path_alt",
        help="Alternative way to specify test path (overrides positional argument)"
    )
    
    parser.add_argument(
        "--check-only",
        action="store_true",
        help="Only check ReportPortal connection and environment"
    )
    
    parser.add_argument(
        "--analytics-only",
        action="store_true",
        help="Only generate analytics report from existing data"
    )
    
    parser.add_argument(
        "--skip-analytics",
        action="store_true",
        help="Skip analytics report generation after tests"
    )
    
    parser.add_argument(
        "--pytest-args",
        nargs="*",
        help="Additional arguments to pass to pytest"
    )
    
    parser.add_argument(
        "--launch-name",
        help="Custom launch name (default: component-specific auto-generated)"
    )
    
    parser.add_argument(
        "--no-coverage",
        action="store_true",
        help="Disable coverage tracking (for quick testing)"
    )
    
    args = parser.parse_args()
    
    # Handle test path - --test-path overrides positional argument
    final_test_path = args.test_path_alt if args.test_path_alt else args.test_path
    enable_coverage = not args.no_coverage
    
    print("🚀 TestViper ReportPortal Integration")
    print("=" * 60)
    
    # Check environment
    env_issues = check_environment()
    if env_issues:
        print("\\n⚠️  Environment Issues:")
        for issue in env_issues:
            print(f"   {issue}")
        print("\\n💡 Fix these issues before running tests")
        if not args.check_only:
            return 1
    
    # Check ReportPortal connection
    print(f"\\n🔗 Checking ReportPortal connection...")
    rp_connected, rp_status = check_reportportal_connection()
    
    if rp_connected:
        print(f"   ✅ ReportPortal connected successfully")
        print(f"   📊 Available launches: {rp_status.get('total_launches', 0)}")
    else:
        print(f"   ❌ ReportPortal connection failed: {rp_status.get('error', 'Unknown error')}")
        if not args.check_only and not args.analytics_only:
            print("\\n💡 Tests will run but results may not appear in ReportPortal")
    
    # If check-only, exit here
    if args.check_only:
        print("\\n✅ Environment and connection check complete")
        return 0
    
    # If analytics-only, generate report and exit
    if args.analytics_only:
        print("\\n📊 Generating analytics report from existing data...")
        success = generate_analytics_report()
        return 0 if success else 1
    
    # Run tests
    print(f"\\n🧪 Starting test execution...")
    tests_passed, exit_code = run_tests_with_coverage_tracking(
        test_path=final_test_path,
        custom_launch_name=args.launch_name,
        enable_coverage=enable_coverage,
        additional_args=args.pytest_args
    )
    
    # Generate analytics report
    if not args.skip_analytics:
        print("\\n📊 Generating post-test analytics...")
        generate_analytics_report()
    
    # Final summary
    print("\\n" + "=" * 60)
    print("🎯 Integration Complete")
    print("=" * 60)
    print(f"📊 ReportPortal Dashboard: {os.getenv('RP_ENDPOINT', 'http://localhost:8080')}")
    print(f"📂 Local Reports: {Path('dashboard/reports').absolute()}")
    
    if rp_connected:
        print(f"🔗 View results in ReportPortal at: {os.getenv('RP_ENDPOINT', 'http://localhost:8080')}")
    else:
        print("⚠️  ReportPortal connection issues - check local reports for detailed analytics")
    
    if enable_coverage:
        component_name = determine_component_name(final_test_path or "tests/integration")
        coverage_file = f"coverage_{component_name}.json"
        if os.path.exists(coverage_file):
            print(f"📈 Coverage report: {coverage_file}")
    
    print("=" * 60)
    
    return exit_code

if __name__ == "__main__":
    sys.exit(main())