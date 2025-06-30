#!/usr/bin/env python3
"""
Generate individual Allure reports for each component
"""
import subprocess
import sys
import os
from pathlib import Path

def run_command(cmd, cwd=None):
    """Run a command and handle errors"""
    print(f"Running: {cmd}")
    try:
        result = subprocess.run(cmd, shell=True, cwd=cwd, check=True, 
                              capture_output=True, text=True)
        print(result.stdout)
        return True
    except subprocess.CalledProcessError as e:
        print(f"Error running command: {e}")
        print(f"stdout: {e.stdout}")
        print(f"stderr: {e.stderr}")
        return False

def ensure_dir(path):
    """Ensure directory exists"""
    Path(path).mkdir(parents=True, exist_ok=True)

def main():
    """Generate all Allure reports"""
    
    # Ensure output directories exist
    ensure_dir("allure-report/integration")
    ensure_dir("allure-report/toolviper")
    ensure_dir("allure-report/xradio")
    
    success = True
    
    # Generate Integration Tests Report
    print("=" * 50)
    print("Generating Integration Tests Allure Report")
    print("=" * 50)
    cmd = "allure generate allure-results/integration -o allure-report/integration --clean"
    if not run_command(cmd):
        success = False
    
    # Generate Toolviper Report
    print("=" * 50)
    print("Generating Toolviper Allure Report")
    print("=" * 50)
    cmd = "allure generate allure-results/toolviper -o allure-report/toolviper --clean"
    if not run_command(cmd):
        success = False
    
    # Generate Xradio Report
    print("=" * 50)
    print("Generating Xradio Allure Report")
    print("=" * 50)
    cmd = "allure generate allure-results/xradio -o allure-report/xradio --clean"
    if not run_command(cmd):
        success = False
    
    print("=" * 50)
    print("Allure report generation completed")
    print("=" * 50)
    
    # List generated reports
    run_command("find allure-report -name 'index.html' -type f")
    
    return success

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)