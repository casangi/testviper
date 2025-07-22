#!/usr/bin/env python3
"""
TestViper ReportPortal Connection Test
"""

import requests
import json
import time
import sys
import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

# Configuration
RP_ENDPOINT = os.getenv("RP_ENDPOINT", "http://localhost:8080")
RP_PROJECT = os.getenv("RP_PROJECT", "testviper")
RP_TOKEN = os.getenv("RP_API_KEY", "your_api_token_here")  # Use RP_API_KEY from .env

def test_ui_connection():
    """Test ReportPortal UI connection"""
    print("🔍 Testing UI connection...")
    try:
        response = requests.get(f"{RP_ENDPOINT}", timeout=10)
        if response.status_code == 200:
            print("✅ UI connection successful!")
            return True
        else:
            print(f"❌ UI connection failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ UI connection error: {e}")
        return False

def test_api_connection():
    """Test ReportPortal API connection"""
    print("🔍 Testing API connection...")
    try:
        response = requests.get(f"{RP_ENDPOINT}/api/v1", timeout=10)
        if response.status_code == 200:
            print("✅ API connection successful!")
            return True
        else:
            print(f"❌ API connection failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ API connection error: {e}")
        return False

def test_project_access():
    """Test project access with API token"""
    if RP_TOKEN == "your_api_token_here":
        print("⚠️  API token not configured. Set RP_API_KEY environment variable.")
        print("   Get token from: Profile → API Keys in ReportPortal UI")
        return False
        
    print("🔍 Testing project access...")
    url = f"{RP_ENDPOINT}/api/v1/{RP_PROJECT}/launch"
    headers = {
        "Authorization": f"Bearer {RP_TOKEN}",
        "Content-Type": "application/json"
    }
    
    try:
        response = requests.get(url, headers=headers, timeout=10)
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Project access successful!")
            print(f"📊 Found {len(data.get('content', []))} launches")
            return True
        elif response.status_code == 404:
            print(f"❌ Project '{RP_PROJECT}' not found. Create it in ReportPortal UI.")
            return False
        else:
            print(f"❌ Project access failed: {response.status_code}")
            print(f"Response: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Project access error: {e}")
        return False

def main():
    """Main test function"""
    print("🚀 TestViper ReportPortal Connection Test")
    print("=" * 50)
    
    # Test UI
    ui_ok = test_ui_connection()
    time.sleep(2)
    
    # Test API
    api_ok = test_api_connection()
    time.sleep(2)
    
    # Test project access
    project_ok = test_project_access()
    
    # Summary
    print("\n" + "=" * 50)
    print("📋 Test Summary:")
    print(f"   UI Access: {'✅' if ui_ok else '❌'}")
    print(f"   API Access: {'✅' if api_ok else '❌'}")
    print(f"   Project Access: {'✅' if project_ok else '⚠️'}")
    
    if ui_ok and api_ok:
        print("\n✅ ReportPortal is ready for use!")
        print(f"🌐 Access: {RP_ENDPOINT}")
        print("👤 Default login: superadmin / erebus")
        
        if not project_ok:
            print("\n📝 Next steps:")
            print("1. Login to ReportPortal")
            print("2. Create 'testviper' project")
            print("3. Generate API token")
            print("4. Update .env file: RP_API_KEY=your_token_here")
            print("5. Run this script again")
    else:
        print("\n❌ ReportPortal setup needs attention!")
        print("Check Docker services: cd dashboard/reportportal && docker-compose ps")
        print("Check logs: cd dashboard/reportportal && docker-compose logs")
        sys.exit(1)

if __name__ == "__main__":
    main()
