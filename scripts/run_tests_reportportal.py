#!/usr/bin/env python3
"""
Runs pytest for each component and publishes each as a separate Launch to ReportPortal
"""

import os
import subprocess
import tomllib
from pathlib import Path

# Component configurations
COMPONENTS = [
    {
        "name": "testviper",
        "display_name": "TestViper Integration",
        "path": ".",
        "test_path": "tests/integration",
        "icon": "🔬",
    },
    {
        "name": "toolviper",
        "display_name": "ToolViper",
        "path": "external/toolviper",
        "test_path": "tests",
        "icon": "🛠️",
    },
    {
        "name": "xradio",
        "display_name": "Xradio",
        "path": "external/xradio",
        "test_path": "tests",
        "icon": "📡",
    },
    {
        "name": "graphviper",
        "display_name": "GraphViper",
        "path": "external/graphviper",
        "test_path": "tests",
        "icon": "📊",
    },
    {
        "name": "astroviper",
        "display_name": "AstroViper",
        "path": "external/astroviper",
        "test_path": "tests",
        "icon": "🌟",
    },
]


def get_run_info():
    """Get run source info from env vars"""
    unset_value = "None"
    return {
        "source_repo": os.getenv("TV_SOURCE_REPO", unset_value),
        "source_ref": os.getenv("TV_SOURCE_REF", unset_value),
        "source_sha": os.getenv("TV_SOURCE_SHA", unset_value),
        "source_actor": os.getenv("TV_SOURCE_ACTOR", unset_value),
        "source_workflow": os.getenv("TV_SOURCE_WORKFLOW", unset_value),
        "source_run_id": os.getenv("TV_SOURCE_RUN_ID", unset_value),
        "source_run_number": os.getenv("TV_SOURCE_RUN_NUMBER", unset_value),
        "triggered_by": os.getenv("TV_TRIGGERED_BY", unset_value),
        "testviper_sha": os.getenv("GITHUB_SHA", unset_value),
        "testviper_ref": os.getenv("GITHUB_REF_NAME", unset_value),
        "run_id": os.getenv("GITHUB_RUN_ID", unset_value),
        "runner_arch": os.getenv("RUNNER_ARCH", unset_value),
        "runner_os": os.getenv("RUNNER_OS", unset_value),
    }


def read_version(path_to_toml):
    """Read version from .toml"""
    if os.path.exists(os.path.join(path_to_toml, "pyproject.toml")):
        with open(os.path.join(path_to_toml, "pyproject.toml"), "rb") as f:
            data = tomllib.load(f)
            return (
                data["project"]["version"]
                if data["project"]["version"].startswith("v")
                else f"v{data['project']['version']}"
            )
    if os.path.exists(os.path.join(path_to_toml, "pixi.toml")):
        with open(os.path.join(path_to_toml, "pixi.toml"), "rb") as f:
            data = tomllib.load(f)
            return (
                data["workspace"]["version"]
                if data["workspace"]["version"].startswith("v")
                else f"v{data['workspace']['version']}"
            )

    return "v0.0.0"  # Default version if file not found


def run_component_tests(component, run_info):
    """Run tests for a specific component and publish results to ReportPortal"""
    component_name = component["name"]
    component_path = component["path"]
    component_display_name = component["display_name"]
    test_path = component["test_path"]

    print(f"Running tests for {component_name}...")

    # Check if test path exists
    full_test_path = Path(component_path) / test_path
    if not full_test_path.exists():
        print(f"Test path {full_test_path} does not exist for {component_name}")
        return

    # Run pytest with reportportal
    test_command = [
        "python",
        "-m",
        "pytest",
        "--reportportal",
        "--rp-launch",
        str(component_name),
        "--rp-launch-description",
        str(component_display_name),
        str(full_test_path),
        "--tb=short",
        "-v",
    ]

    launch_attributes = [
        "source_repo",
        "source_ref",
        "source_sha",
        "source_actor",
        "source_workflow",
        "source_run_id",
        "source_run_number",
        "triggered_by",
        "testviper_sha",
        "testviper_ref",
        "run_id",
        "runner_arch",
        "runner_os",
    ]

    for key in launch_attributes:
        test_command.extend(["-o", f"rp_launch_attributes={key}:{run_info[key]}"])

    try:
        # Add timeout to prevent hanging
        print(f"Running command: {' '.join(test_command)}")
        result = subprocess.run(test_command, capture_output=True, text=True)
        print(f"Tests completed for {component_name}")
        print(f"Exit code: {result.returncode}")
        output_file = "subprocess_return_code.txt"
        with open(output_file, "a") as f:
            f.write(str(result.returncode) + "\n")
        if result.stdout:
            print("STDOUT (last 200 chars):", result.stdout[-200:])
        if result.stderr and result.stderr.strip():
            print("STDERR (last 200 chars):", result.stderr[-200:])
    except subprocess.TimeoutExpired:
        print(f"Tests for {component_name} timed out after # minutes")
    except Exception as e:
        print(f"Error running tests for {component_name}: {e}")
    finally:
        print(f"Finished test execution for {component_name}")


def main():
    """Main function to run tests in each subproject"""
    print("Starting testviper run...")

    run_info = get_run_info()
    print("Using this source information:")
    print(f"source_repo: {run_info['source_repo']}")
    print(f"source_ref: {run_info['source_ref']}")
    print(f"source_sha: {run_info['source_sha']}")
    print(f"source_actor: {run_info['source_actor']}")
    print(f"source_workflow: {run_info['source_workflow']}")
    print(f"source_run_id: {run_info['source_run_id']}")
    print(f"source_run_number: {run_info['source_run_number']}")
    print(f"triggered_by: {run_info['triggered_by']}")

    # Process each component
    processed_count = 0
    for component in COMPONENTS:
        print(f"\n{'=' * 50}")
        component["display_name"] = "{} {}".format(
            component["display_name"], read_version(component["path"])
        )
        print(f"Processing {component['display_name']}")
        print(f"Path: {component['path']}")
        print(f"{'=' * 50}")

        if os.path.exists(component["path"]):
            print(f"✓ Component path exists: {component['path']}")

            # Run tests and generate results
            run_component_tests(component, run_info)

            processed_count += 1
        else:
            print(
                f"⚠️  Skipping {component['name']} - path not found: {component['path']}"
            )

    print("\nTestviper run completed!")
    print(f"Processed {processed_count} components successfully.")


if __name__ == "__main__":
    main()
