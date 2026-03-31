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
import tomllib  # Python 3.11+ supports tomllib natively
from bs4 import BeautifulSoup
import datetime
import socket
import xml.etree.ElementTree as ET

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
        'path': 'external/toolviper',
        'test_path': 'tests',
        'icon': '🛠️'
    },
    {
        'name': 'xradio',
        'display_name': 'Xradio',
        'path': 'external/xradio',
        'test_path': 'tests',
        'icon': '📡'
    },
    {
        'name': 'graphviper',
        'display_name': 'GraphViper',
        'path': 'external/graphviper',
        'test_path': 'tests',
        'icon': '📊'
    },
    {
        'name': 'astroviper',
        'display_name': 'AstroViper',
        'path': 'external/astroviper',
        'test_path': 'tests',
        'icon': '🌟'
    }
]
def read_version(path_to_toml):
    """Read version from .toml"""
    if os.path.exists(os.path.join(path_to_toml, "pyproject.toml")):
        with open(os.path.join(path_to_toml,"pyproject.toml"), "rb") as f:
            data = tomllib.load(f)
            return data['project']['version'] if data['project']['version'].startswith("v") else f"v{data['project']['version']}"
    if os.path.exists(os.path.join(path_to_toml, "pixi.toml")):
        with open(os.path.join(path_to_toml,"pixi.toml"), "rb") as f:
            data = tomllib.load(f)
            return data['workspace']['version'] if data['workspace']['version'].startswith("v") else f"v{data['workspace']['version']}"

    return "v0.0.0"  # Default version if file not found

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

def add_back_link_to_report(report_path, component_name, allure2=True):
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
            if allure2:
                content = content.replace(
                    "</body>",
                    f'<script src="plugins/back-link.js"></script></body>'
                )
            else:
                content = content.replace(
                    "</body>",
                    f'<script src="plugins/back-link.js"></script></body>'
                ).replace("</title>", "</title><a href=\"../index.html\" class=\"back-link\">← Back to Summary</a>")
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
        output_file = "subprocess_return_code.txt"
        with open(output_file, "a") as f:
            f.write(str(result.returncode)+"\n")
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
    finally:
        if not os.path.isfile(f"{component['test_path']}/{component_name}-pytest-report.xml"):
            fMessage=f"{component_name} Test execution failed, no report generated: Exit code: {result.returncode if 'result' in locals() else 'N/A'}"
            create_static_xml_report(component['test_path'], component_name, f"{component['test_path']}/{component_name}-pytest-report.xml", fMessage)
        print(f"Finished test execution for {component_name}")

def create_static_xml_report(test_path, component_name, filename, fMessage="Test execution failed, no report generated"):
    """Create a static JUnit XML report if pytest did not generate one"""

    e = datetime.datetime.now()
    timestamp = e.strftime('%Y-%m-%dT%H:%M:%S.%f')
    data = ET.Element('testsuites')
    element1 = ET.SubElement(data, 'testsuite')
    element1.set('name', "'{}'".format(component_name))
    element1.set('errors', "0")
    element1.set('failures', "1")
    element1.set('skipped', "0")
    element1.set('tests', "1")
    element1.set('time', "0.01")
    element1.set('timestamp', timestamp)
    element1.set('hostname', socket.gethostname())
    s_elem1 = ET.SubElement(element1, 'testcase')
    s_elem1.set('classname', "{}.ScriptFailure".format(component_name))
    s_elem1.set('name', "{}".format(component_name))
    s_elem1.set('time', "0.01")
    ss_elem1 = ET.SubElement(s_elem1, 'failure')
    ss_elem1.set('message', fMessage)
    ss_elem1.text = fMessage
    b_xml = ET.tostring(data)

    with open(filename, "wb") as f:
        f.write(b_xml)

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

def write_config_file(component):
    """Write Allure configuration file"""
    # This can be changed to point to a shared history location if desired
    # Currently using allure 2 history stored in gh-pages/main
    testpath = f"{os.getcwd()}/gh-pages/main/allure3-history/{component['name']}"
    config = {
        "name" : f"{component['name']} Allure Report",
        "historyPath": f"{testpath}/allure-history-{component['name']}.jsonl",
        "appendHistory": True
        }
    os.makedirs(testpath, exist_ok=True)
    with open(f"{testpath}/allure-config-{component['name']}.json", "w") as f:
        json.dump(config, f, indent=2)
    return f"{testpath}"

def generate_allure_report(component):
    """Generate Allure HTML report for a component"""
    component_name = component['name']
    component_version = read_version(component['path'])
    results_dir = f"allure-results-{component_name}"
    report_dir = f"allure-report/{component_name}"
    
    print(f"Generating Allure report for {component_name}...")
    
    # The workflow now restores per-component history to allure-results-<component>/history
    # No need to copy a global history directory here
    # (Removed buggy block that copied allure-results/history to each component)
    
    # Generate report
    allure_path = shutil.which("allure")
    allure_version = subprocess.run([allure_path,"--version"], capture_output=True, text=True, check=True)
    if "2." in allure_version.stdout.strip():
        allure2_version = True
        generate_command = [
        "allure", "generate", results_dir,
        "--output", report_dir,
        "--clean"
    ]
    else:
        allure2_version = False
        cpath = write_config_file(component)
        config_path = os.path.join(cpath, f"allure-config-{component['name']}.json")
        history_path = os.path.join(cpath, f"allure-history-{component['name']}.jsonl")
        generate_command = [
        "allure", "generate", results_dir,
        "--output", report_dir, "--config", config_path
        ]
    try:
        result = subprocess.run(generate_command, capture_output=True, text=True)

        print(f"Allure report generated for {component_name}")
      
        # TODO: Remove add_back_link_to_report entirely once the dashboard is live
      
        # Copy history for next run
        if allure2_version:
            history_output = f"allure-report/allure-history/{component_name}"
            if os.path.exists(f"{report_dir}/history"):
                os.makedirs(history_output, exist_ok=True)
                shutil.copytree(f"{report_dir}/history", history_output, dirs_exist_ok=True)

            # Update summary.json with component name and version
        
            json_file = os.path.join(report_dir, 'widgets', 'summary.json')
        else: 
            json_file = os.path.join(report_dir,'summary.json')

        with open(json_file, "r") as file:
            data = json.load(file)

        if allure2_version:
            data["reportName"] = f'{component_name} {component_version} - {data["reportName"]}'
        else: 
            data["name"] = f'{component_name} {component_version} - {data["name"]}'
            
        with open(json_file, "w") as file:
            json.dump(data, file, indent=4)
       
        # Update index.html title
        index_file = os.path.join(report_dir,'index.html')
        with open(index_file, "r") as file:
            soup = BeautifulSoup(file, "html.parser")
        title_tag = soup.find("title")
        if title_tag:
            title_tag.string = f'{component_name} Allure Report'
        with open(index_file, "w") as file:
            file.write(str(soup))

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
        component['display_name'] = "{} {}".format(component['display_name'], read_version(component['path']))
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
