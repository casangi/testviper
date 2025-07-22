#!/usr/bin/env python3
"""
TestViper Dashboard Test Runner
Run tests with ReportPortal dashboard integration
"""

import os
import sys
import subprocess
from pathlib import Path
from dotenv import load_dotenv

# Load environment variables
load_dotenv()

def main():
    """Main function to run tests with dashboard integration"""
    
    # Set up paths
    dashboard_dir = Path(__file__).parent
    testviper_root = dashboard_dir.parent
    config_dir = dashboard_dir / "config"
    
    print("🚀 TestViper Dashboard Test Runner")
    print("=" * 50)
    print(f"📁 TestViper Root: {testviper_root}")
    print(f"📁 Dashboard Dir: {dashboard_dir}")
    print(f"📁 Config Dir: {config_dir}")
    
    # Check environment
    rp_endpoint = os.getenv("RP_ENDPOINT", "http://localhost:8080")
    rp_project = os.getenv("RP_PROJECT", "testviper")
    rp_api_key = os.getenv("RP_API_KEY")
    
    print(f"🌐 ReportPortal Endpoint: {rp_endpoint}")
    print(f"📊 ReportPortal Project: {rp_project}")
    print(f"🔑 API Key: {'✅ Configured' if rp_api_key else '❌ Missing'}")
    
    if not rp_api_key:
        print("\n⚠️  Warning: RP_API_KEY not found!")
        print("   Tests will run but may not be sent to ReportPortal")
        print("   Check your .env file or environment configuration")
    
    # Build pytest command
    cmd = [
        sys.executable, "-m", "pytest",
        "-c", str(config_dir / "pytest_dashboard.ini"),
        "--confcutdir", str(config_dir),
        "-p", "no:cacheprovider",  # Disable cache to avoid conflicts
        "--tb=short",
        "-v"
    ]
    
    # Add test path arguments
    if len(sys.argv) > 1:
        # Use provided test paths
        test_paths = sys.argv[1:]
    else:
        # Default to integration tests
        test_paths = [str(testviper_root / "tests" / "integration")]
    
    cmd.extend(test_paths)
    
    print(f"\n🧪 Running tests with command:")
    print(f"   {' '.join(cmd)}")
    print("=" * 50)
    
    # Set PYTHONPATH to include config directory
    env = os.environ.copy()
    python_path = str(config_dir)
    if "PYTHONPATH" in env:
        env["PYTHONPATH"] = f"{python_path}:{env['PYTHONPATH']}"
    else:
        env["PYTHONPATH"] = python_path
    
    # Change to testviper root directory
    os.chdir(testviper_root)
    
    # Run pytest
    try:
        result = subprocess.run(cmd, env=env, check=False)
        
        print("\n" + "=" * 50)
        print("🏁 Test Execution Complete")
        print(f"Exit Code: {result.returncode}")
        
        if result.returncode == 0:
            print("✅ All tests passed!")
        else:
            print("❌ Some tests failed or had issues")
        
        print(f"📊 Check ReportPortal: {rp_endpoint}")
        print(f"📂 Local Reports: {dashboard_dir / 'reports'}")
        print("=" * 50)
        
        return result.returncode
        
    except KeyboardInterrupt:
        print("\n🛑 Tests interrupted by user")
        return 1
    except Exception as e:
        print(f"\n❌ Error running tests: {e}")
        return 1

if __name__ == "__main__":
    sys.exit(main())