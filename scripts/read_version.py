#!/usr/bin/env python3
"""
Attempts to read the pyproject.toml or pixi.toml file at the given path to get the project version
"""

import os
import sys
import tomllib

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


def main():
    """Main function to run tests in each subproject"""
    print(read_version(sys.argv[1]))


if __name__ == "__main__":
    main()
