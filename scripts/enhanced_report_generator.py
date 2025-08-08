#!/usr/bin/env python3
"""
Enhanced Allure Report Generator
Generates individual Allure reports for each component with history preservation
and back links to the summary page.
"""

import os
import json
import subprocess
import shutil
from pathlib import Path

# Component configurations
COMPONENTS = [
    {
        'name': 'testviper',
        'display_name': 'TestViper Integration',
        'path': '.',
        'test_path': 'tests/integration',
        'icon': '🔬'
    },
    {
        'name': 'toolviper',
        'display_name': 'ToolViper',
        'path': 'toolviper',
        'test_path': 'tests',
        'icon': '🛠️'
    },
    {
        'name': 'xradio',
        'display_name': 'Xradio',
        'path': 'xradio',
        'test_path': 'tests',
        'icon': '📡'
    },
    {
        'name': 'graphviper',
        'display_name': 'GraphViper',
        'path': 'graphviper',
        'test_path': 'tests',
        'icon': '📊'
    },
    {
        'name': 'astroviper',
        'display_name': 'AstroViper',
        'path': 'astroviper',
        'test_path': 'tests',
        'icon': '🌟'
    }
]

def create_allure_environment(component_name, component_path):
    """Create environment.properties for Allure report"""
    env_content = f"""Component={component_name}
Python.Version=3.12
Test.Framework=pytest
CI=GitHub Actions
Repository=casangi/{component_name}
"""
    
    env_file = Path(f"allure-results-{component_name}/environment.properties")
    env_file.parent.mkdir(parents=True, exist_ok=True)
    env_file.write_text(env_content)

def add_back_link_to_report(report_path, component_name):
    """Add back link to summary page in Allure report"""
    
    # Create a custom JavaScript file to add back link
    js_content = """
window.addEventListener('load', function() {
    // Wait for Allure to load
    setTimeout(function() {
        const headerElement = document.querySelector('.side-nav__brand');
        if (headerElement && !document.querySelector('.back-to-summary')) {
            const backLink = document.createElement('a');
            backLink.href = '../index.html';
            backLink.innerHTML = '← Back to Summary';
            backLink.className = 'back-to-summary';
            backLink.style.cssText = `
                display: block;
                margin-top: 10px;
                padding: 8px 12px;
                background: #007bff;
                color: white;
                text-decoration: none;
                border-radius: 4px;
                font-size: 14px;
                text-align: center;
            `;
            headerElement.appendChild(backLink);
        }
    }, 1000);
});
"""
    
    # Create plugins directory and add custom JS
    plugins_dir = Path(report_path) / "plugins"
    plugins_dir.mkdir(exist_ok=True)
    
    js_file = plugins_dir / "back-link.js"
    js_file.write_text(js_content)
    
    # Modify the index.html to include our custom script
    index_file = Path(report_path) / "index.html"
    if index_file.exists():
        content = index_file.read_text()
        if "back-link.js" not in content:
            # Add script before closing body tag
            content = content.replace(
                "</body>",
                f'<script src="plugins/back-link.js"></script></body>'
            )
            index_file.write_text(content)

def run_component_tests(component):
    """Run tests for a specific component and generate Allure results"""
    component_name = component['name']
    component_path = component['path']
    test_path = component['test_path']
    
    print(f"Running tests for {component_name}...")
    
    # Create results directory
    results_dir = f"allure-results-{component_name}"
    os.makedirs(results_dir, exist_ok=True)
    
    # Create environment file
    create_allure_environment(component_name, component_path)
    
    # Check if test path exists
    full_test_path = Path(component_path) / test_path
    if not full_test_path.exists():
        print(f"Test path {full_test_path} does not exist for {component_name}")
        create_minimal_result(results_dir, component_name, "Test directory not found")
        return
    
    # Run pytest with allure
    test_command = [
        "python", "-m", "pytest",
        str(full_test_path),
        f"--alluredir={results_dir}",
        "--tb=short",
        "-v",
        f"--junitxml={component['test_path']}/{component_name}-pytest-report.xml"
    ]
    
    try:
        # Add timeout to prevent hanging
        print(f"Running command: {' '.join(test_command)}")
        result = subprocess.run(test_command, capture_output=True, text=True)  
        print(f"Tests completed for {component_name}")
        print(f"Exit code: {result.returncode}")
        if result.stdout:
            print("STDOUT (last 200 chars):", result.stdout[-200:])
        if result.stderr and result.stderr.strip():
            print("STDERR (last 200 chars):", result.stderr[-200:])
    except subprocess.TimeoutExpired:
        print(f"Tests for {component_name} timed out after # minutes")
        create_minimal_result(results_dir, component_name, "Tests timed out")
    except Exception as e:
        print(f"Error running tests for {component_name}: {e}")
        create_minimal_result(results_dir, component_name, f"Failed to run tests: {e}")

def create_minimal_result(results_dir, component_name, error_message):
    """Create a minimal test result for components with issues"""
    minimal_result = {
        "uuid": f"test-{component_name}",
        "historyId": f"test-{component_name}", 
        "testCaseId": f"test-{component_name}",
        "name": f"Tests for {component_name}",
        "status": "broken",
        "statusMessage": error_message,
        "stage": "finished",
        "start": 0,
        "stop": 0
    }
    
    with open(f"{results_dir}/minimal-test-result.json", "w") as f:
        json.dump(minimal_result, f, indent=2)

def generate_allure_report(component):
    """Generate Allure HTML report for a component"""
    component_name = component['name']
    results_dir = f"allure-results-{component_name}"
    report_dir = f"allure-report/{component_name}"
    
    print(f"Generating Allure report for {component_name}...")
    
    # The workflow now restores per-component history to allure-results-<component>/history
    # No need to copy a global history directory here
    # (Removed buggy block that copied allure-results/history to each component)
    
    # Generate report
    generate_command = [
        "allure", "generate", results_dir,
        "--output", report_dir,
        "--clean"
    ]
    
    try:
        result = subprocess.run(generate_command, capture_output=True, text=True)
        print(f"Allure report generated for {component_name}")
        
        # Add back link to the report
        add_back_link_to_report(report_dir, component_name)
        
        # Copy history for next run
        history_output = f"allure-report/allure-history/{component_name}"
        if os.path.exists(f"{report_dir}/history"):
            os.makedirs(history_output, exist_ok=True)
            shutil.copytree(f"{report_dir}/history", history_output, dirs_exist_ok=True)
            
    except Exception as e:
        print(f"Error generating Allure report for {component_name}: {e}")
        # Create a minimal HTML report
        os.makedirs(report_dir, exist_ok=True)
        error_html = f"""
<!DOCTYPE html>
<html>
<head>
    <title>{component['display_name']} - Test Report</title>
    <style>
        body {{ font-family: Arial, sans-serif; margin: 40px; }}
        .error {{ background: #f8d7da; color: #721c24; padding: 20px; border-radius: 8px; }}
        .back-link {{ display: inline-block; margin-top: 20px; padding: 10px 20px; 
                     background: #007bff; color: white; text-decoration: none; border-radius: 4px; }}
    </style>
</head>
<body>
    <h1>{component['icon']} {component['display_name']}</h1>
    <div class="error">
        <h2>Report Generation Error</h2>
        <p>Unable to generate test report: {e}</p>
    </div>
    <a href="../index.html" class="back-link">← Back to Summary</a>
</body>
</html>
"""
        with open(f"{report_dir}/index.html", "w") as f:
            f.write(error_html)

def main():
    """Main function to orchestrate the report generation"""
    print("Starting enhanced Allure report generation...")
    
    # Create main report directory
    os.makedirs("allure-report", exist_ok=True)
    
    # Process each component
    processed_count = 0
    for component in COMPONENTS:
        print(f"\n{'='*50}")
        print(f"Processing {component['display_name']}")
        print(f"Path: {component['path']}")
        print(f"{'='*50}")
        
        if os.path.exists(component['path']):
            print(f"✓ Component path exists: {component['path']}")
            
            # Run tests and generate results
            run_component_tests(component)
            
            # Generate HTML report
            generate_allure_report(component)
            processed_count += 1
        else:
            print(f"⚠️  Skipping {component['name']} - path not found: {component['path']}")
            # Still create a minimal report for missing components
            results_dir = f"allure-results-{component['name']}"
            os.makedirs(results_dir, exist_ok=True)
            create_allure_environment(component['name'], component['path'])
            create_minimal_result(results_dir, component['name'], "Component directory not found")
            generate_allure_report(component)
    
    print(f"\nEnhanced Allure report generation completed!")
    print(f"Processed {processed_count} components successfully.")

if __name__ == "__main__":
    main()
