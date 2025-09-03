#!/usr/bin/env python3
"""
Test script for Enhanced Allure Reporting System
Verifies that the enhanced reporting system works correctly.
"""

import os
import sys
import subprocess
import tempfile
import shutil
from pathlib import Path

def create_sample_test_files():
    """Create sample test files for testing the report generation"""
    print("Creating sample test files...")
    
    # Create a simple test file
    test_content = '''
import pytest

def test_sample_passing():
    """A sample passing test"""
    assert True

def test_sample_calculation():
    """A sample calculation test"""
    assert 2 + 2 == 4

@pytest.mark.skip(reason="Sample skipped test")
def test_sample_skipped():
    """A sample skipped test"""
    assert False
'''
    
    # Ensure tests directory exists
    test_dir = Path("tests")
    test_dir.mkdir(exist_ok=True)
    
    # Write test file
    test_file = test_dir / "test_sample.py"
    test_file.write_text(test_content)
    print(f"Created test file: {test_file}")

def install_requirements():
    """Install required packages for testing"""
    print("Installing required packages...")
    
    packages = [
        "pytest",
        "allure-pytest", 
        "coverage",
        "beautifulsoup4"
    ]
    
    for package in packages:
        try:
            result = subprocess.run([
                sys.executable, "-m", "pip", "install", package
            ], capture_output=True, text=True)
            
            if result.returncode == 0:
                print(f"✓ {package} installed successfully")
            else:
                print(f"✗ Failed to install {package}: {result.stderr}")
                return False
        except Exception as e:
            print(f"✗ Error installing {package}: {e}")
            return False
    
    return True

def check_allure_cli():
    """Check if Allure CLI is available"""
    print("Checking Allure CLI availability...")
    
    try:
        result = subprocess.run(["allure", "--version"], 
                              capture_output=True, text=True)
        if result.returncode == 0:
            print(f"✓ Allure CLI found: {result.stdout.strip()}")
            return True
        else:
            print("✗ Allure CLI not found")
            return False
    except FileNotFoundError:
        print("✗ Allure CLI not found in PATH")
        print("Please install Allure CLI: https://docs.qameta.io/allure/#_installing_a_commandline")
        return False

def run_sample_tests():
    """Run sample tests to generate Allure results"""
    print("Running sample tests...")
    
    # Clean up previous results
    results_dir = "allure-results-testviper"
    if os.path.exists(results_dir):
        shutil.rmtree(results_dir)
    
    # Run pytest with Allure
    cmd = [
        sys.executable, "-m", "pytest",
        "tests/",
        f"--alluredir={results_dir}",
        "--tb=short",
        "-v"
    ]
    
    try:
        result = subprocess.run(cmd, capture_output=True, text=True)
        print(f"Test execution completed with exit code: {result.returncode}")
        
        if result.stdout:
            print("STDOUT:", result.stdout[-300:])
        
        return os.path.exists(results_dir) and os.listdir(results_dir)
    except Exception as e:
        print(f"Error running tests: {e}")
        return False

def test_enhanced_scripts():
    """Test the enhanced report generation scripts"""
    print("\nTesting enhanced report generation...")
    
    # Test enhanced report generator
    print("1. Testing enhanced_report_generator.py...")
    try:
        result = subprocess.run([
            sys.executable, "scripts/enhanced_report_generator.py"
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✓ Enhanced report generator completed successfully")
        else:
            print(f"✗ Enhanced report generator failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"✗ Error running enhanced report generator: {e}")
        return False
    
    # Test enhanced summary generator
    print("2. Testing enhanced_summary_generator.py...")
    try:
        result = subprocess.run([
            sys.executable, "scripts/enhanced_summary_generator.py"
        ], capture_output=True, text=True)
        
        if result.returncode == 0:
            print("✓ Enhanced summary generator completed successfully")
        else:
            print(f"✗ Enhanced summary generator failed: {result.stderr}")
            return False
    except Exception as e:
        print(f"✗ Error running enhanced summary generator: {e}")
        return False
    
    return True

def verify_output():
    """Verify that the expected output files were created"""
    print("\nVerifying output files...")
    
    expected_files = [
        "allure-report/index.html",
        "allure-report/testviper/index.html"
    ]
    
    all_exist = True
    for file_path in expected_files:
        if os.path.exists(file_path):
            print(f"✓ {file_path} exists")
        else:
            print(f"✗ {file_path} missing")
            all_exist = False
    
    # Check for specific content in summary page
    summary_file = "allure-report/index.html"
    if os.path.exists(summary_file):
        with open(summary_file, 'r') as f:
            content = f.read()
            
        checks = [
            ("CodeCov Integration", "codecov" in content.lower()),
            ("Back Navigation", "back to summary" in content.lower()),
            ("TestViper Component", "testviper" in content.lower()),
            ("Responsive Design", "grid-template-columns" in content)
        ]
        
        for check_name, check_result in checks:
            if check_result:
                print(f"✓ {check_name} found in summary")
            else:
                print(f"✗ {check_name} missing from summary")
                all_exist = False
    
    return all_exist

def main():
    """Main test function"""
    print("🧪 Testing Enhanced Allure Reporting System")
    print("=" * 50)
    
    # Check prerequisites
    if not install_requirements():
        print("❌ Failed to install required packages")
        return False
    
    if not check_allure_cli():
        print("❌ Allure CLI not available")
        print("⚠️  You can still test the scripts, but reports won't be generated")
        # Continue anyway for script testing
    
    # Create sample test files
    create_sample_test_files()
    
    # Run sample tests
    if not run_sample_tests():
        print("⚠️  Sample tests failed, but continuing with script testing")
    
    # Test enhanced scripts
    if not test_enhanced_scripts():
        print("❌ Enhanced scripts failed")
        return False
    
    # Verify output
    if not verify_output():
        print("❌ Output verification failed")
        return False
    
    print("\n" + "=" * 50)
    print("✅ Enhanced Allure Reporting System test completed successfully!")
    print("\nGenerated files:")
    print("- allure-report/index.html (Summary dashboard)")
    print("- allure-report/testviper/index.html (Component report)")
    print("\nTo view the reports:")
    print("  open allure-report/index.html")
    
    return True

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)
