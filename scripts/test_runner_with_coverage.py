#!/usr/bin/env python3
"""
Test runner with coverage collection for all components
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
    """Run all tests with coverage collection"""
    
    # Ensure directories exist
    ensure_dir("allure-results/integration")
    ensure_dir("allure-results/toolviper") 
    ensure_dir("allure-results/xradio")
    ensure_dir("coverage")
    
    success = True
    
    # Run Integration Tests (testviper)
    print("=" * 50)
    print("Running Integration Tests (testviper)")
    print("=" * 50)
    print(os.getcwd())
    cmd = """
    pytest tests/integration \
        --alluredir=allure-results/integration \
        --cov=toolviper --cov=xradio \
        --cov-report=xml:coverage/coverage-integration.xml \
        --cov-report=html:coverage/htmlcov-integration \
        --cov-report=json:coverage/coverage-integration.json
    """
    if not run_command(cmd):
        success = False
    
    # Run Toolviper Component Tests
    print("=" * 50)
    print("Running Toolviper Component Tests")
    print("=" * 50)
    print(os.getcwd())
    print(os.system('ls -l'))
    cmd = """
    pytest toolviper/tests/ \
        --alluredir=allure-results/toolviper \
        --cov=toolviper \
        --cov-report=xml:coverage/coverage-toolviper.xml \
        --cov-report=html:coverage/htmlcov-toolviper \
        --cov-report=json:coverage/coverage-toolviper.json
    """
    if not run_command(cmd, cwd="toolviper"):
        success = False
    
    # Run Xradio Component Tests
    print("=" * 50)
    print("Running Xradio Component Tests")
    print("=" * 50)
    cmd = """
    pytest xradio/tests/unit \
        --alluredir=allure-results/xradio \
        --cov=xradio \
        --cov-report=xml:coverage/coverage-xradio.xml \
        --cov-report=html:coverage/htmlcov-xradio \
        --cov-report=json:coverage/coverage-xradio.json
    """
    if not run_command(cmd, cwd="xradio"):
        success = False
    
    print("=" * 50)
    print("Test execution completed")
    print("=" * 50)
    
    # List generated files
    run_command("ls -la allure-results/")
    run_command("ls -la coverage/")
    
    return success

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)