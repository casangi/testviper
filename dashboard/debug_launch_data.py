#!/usr/bin/env python3
"""
Debug script to examine raw launch data from ReportPortal
"""

import sys
import os
import json
from datetime import datetime

# Add the dashboard directory to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dashboard'))

from analytics.rp_client import TVReportPortalClient

def debug_launch_data():
    """Debug the raw launch data structure"""
    print("=" * 80)
    print("DEBUGGING REPORTPORTAL LAUNCH DATA")
    print("=" * 80)
    
    # Initialize client
    client = TVReportPortalClient()
    
    # Get raw response data
    print("\n1. Getting raw launch data...")
    try:
        params = {"page.size": 5, "page.sort": "startTime,desc"}
        response = client.session.get(f"{client.base_url}/launch", params=params)
        response.raise_for_status()
        
        data = response.json()
        
        print(f"✅ Raw API response structure:")
        print(f"   Page info: {data.get('page', {})}")
        print(f"   Content length: {len(data.get('content', []))}")
        
        # Show first few launches in detail
        print("\n2. Detailed launch data (first 3 launches):")
        for i, launch_data in enumerate(data.get("content", [])[:3]):
            print(f"\n--- Launch {i+1} ---")
            print(f"ID: {launch_data.get('id')}")
            print(f"Name: {launch_data.get('name')}")
            print(f"Status: {launch_data.get('status')}")
            print(f"Start Time (raw): {launch_data.get('startTime')}")
            print(f"End Time (raw): {launch_data.get('endTime')}")
            
            # Try to parse timestamps
            start_time = launch_data.get('startTime')
            end_time = launch_data.get('endTime')
            
            if start_time is not None:
                try:
                    parsed_start = datetime.fromtimestamp(start_time / 1000.0)
                    print(f"Start Time (parsed): {parsed_start}")
                except Exception as e:
                    print(f"Start Time (parse error): {e}")
            
            if end_time is not None:
                try:
                    parsed_end = datetime.fromtimestamp(end_time / 1000.0)
                    print(f"End Time (parsed): {parsed_end}")
                except Exception as e:
                    print(f"End Time (parse error): {e}")
            
            print(f"Statistics: {launch_data.get('statistics', {})}")
            print(f"Attributes: {launch_data.get('attributes', [])}")
        
        # Look specifically for fixed_xradio_test
        print("\n3. Looking for 'fixed_xradio_test' launch...")
        for launch_data in data.get("content", []):
            if "fixed_xradio_test" in launch_data.get("name", "").lower():
                print(f"\n--- Found fixed_xradio_test launch ---")
                print(json.dumps(launch_data, indent=2))
                break
        
        # Check for IN_PROGRESS or RUNNING launches
        print("\n4. Checking for active launches...")
        active_count = 0
        for launch_data in data.get("content", []):
            if launch_data.get("status") in ["IN_PROGRESS", "RUNNING"]:
                active_count += 1
                print(f"\n--- Active Launch Found ---")
                print(f"ID: {launch_data.get('id')}")
                print(f"Name: {launch_data.get('name')}")
                print(f"Status: {launch_data.get('status')}")
                print(f"Raw data: {json.dumps(launch_data, indent=2)}")
        
        if active_count == 0:
            print("✅ No active launches found in recent data")
        else:
            print(f"⚠️  Found {active_count} active launches")
            
    except Exception as e:
        print(f"❌ Error getting launch data: {e}")
        import traceback
        traceback.print_exc()
        return False
    
    return True

if __name__ == "__main__":
    debug_launch_data()