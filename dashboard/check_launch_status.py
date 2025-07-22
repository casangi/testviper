#!/usr/bin/env python3
"""
ReportPortal Launch Status Checker
Checks for unclosed/active launches that might be preventing new launch creation
"""

import sys
import os
from datetime import datetime, timedelta
from typing import List, Dict, Any

# Add the dashboard directory to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dashboard'))

from analytics.rp_client import TVReportPortalClient, TVLaunchData

def format_datetime(dt: datetime) -> str:
    """Format datetime for display"""
    if dt is None:
        return "N/A"
    return dt.strftime("%Y-%m-%d %H:%M:%S")

def format_duration(start: datetime, end: datetime = None) -> str:
    """Format duration for display"""
    if start is None:
        return "N/A"
    
    if end is None:
        # Calculate duration from start to now
        end = datetime.now()
    
    duration = end - start
    hours = int(duration.total_seconds() // 3600)
    minutes = int((duration.total_seconds() % 3600) // 60)
    seconds = int(duration.total_seconds() % 60)
    
    if hours > 0:
        return f"{hours}h {minutes}m {seconds}s"
    elif minutes > 0:
        return f"{minutes}m {seconds}s"
    else:
        return f"{seconds}s"

def check_launch_status():
    """Check ReportPortal launch statuses"""
    print("=" * 80)
    print("REPORTPORTAL LAUNCH STATUS CHECK")
    print("=" * 80)
    
    # Initialize client
    client = TVReportPortalClient()
    
    # Test connection first
    print("\n1. Testing ReportPortal connection...")
    connection_info = client.test_connection()
    
    if connection_info["status"] == "error":
        print(f"❌ Connection FAILED: {connection_info['error']}")
        print(f"   Endpoint: {connection_info['endpoint']}")
        print(f"   Project: {connection_info['project']}")
        print(f"   API Key Present: {connection_info['api_authenticated']}")
        return False
    else:
        print(f"✅ Connection successful!")
        print(f"   Endpoint: {connection_info['endpoint']}")
        print(f"   Project: {connection_info['project']}")
        print(f"   Total Launches: {connection_info['total_launches']}")
        print(f"   API Key Present: {connection_info['api_authenticated']}")
    
    # Get all recent launches
    print("\n2. Fetching recent launches...")
    launches = client.get_launches(limit=100)
    
    if not launches:
        print("❌ No launches found or error occurred")
        return False
    
    print(f"✅ Found {len(launches)} launches")
    
    # Check for active/unclosed launches
    print("\n3. Checking for active/unclosed launches...")
    active_launches = [l for l in launches if l.status in ["IN_PROGRESS", "RUNNING"]]
    
    if active_launches:
        print(f"⚠️  Found {len(active_launches)} active launches:")
        for launch in active_launches:
            print(f"   - ID: {launch.id}")
            print(f"     Name: {launch.name}")
            print(f"     Status: {launch.status}")
            print(f"     Started: {format_datetime(launch.start_time)}")
            print(f"     Duration: {format_duration(launch.start_time)}")
            print(f"     Tests: {launch.total_tests} (P:{launch.passed_tests}, F:{launch.failed_tests}, S:{launch.skipped_tests})")
            print()
    else:
        print("✅ No active launches found")
    
    # Look specifically for "fixed_xradio_test" launch
    print("\n4. Checking for 'fixed_xradio_test' launch...")
    xradio_launches = [l for l in launches if "fixed_xradio_test" in l.name.lower()]
    
    if xradio_launches:
        print(f"Found {len(xradio_launches)} launches with 'fixed_xradio_test' in name:")
        for launch in xradio_launches:
            print(f"   - ID: {launch.id}")
            print(f"     Name: {launch.name}")
            print(f"     Status: {launch.status}")
            print(f"     Started: {format_datetime(launch.start_time)}")
            print(f"     Ended: {format_datetime(launch.end_time)}")
            if launch.end_time:
                print(f"     Duration: {format_duration(launch.start_time, launch.end_time)}")
            else:
                print(f"     Duration: {format_duration(launch.start_time)} (still running)")
            print(f"     Tests: {launch.total_tests} (P:{launch.passed_tests}, F:{launch.failed_tests}, S:{launch.skipped_tests})")
            print()
    else:
        print("❌ No 'fixed_xradio_test' launches found")
    
    # Show recent launch summary
    print("\n5. Recent launch summary (last 10):")
    print("-" * 120)
    print(f"{'ID':<15} {'Name':<25} {'Status':<12} {'Started':<20} {'Duration':<12} {'Tests':<8} {'P/F/S'}")
    print("-" * 120)
    
    for launch in launches[:10]:
        duration = format_duration(launch.start_time, launch.end_time)
        if launch.end_time is None and launch.status in ["IN_PROGRESS", "RUNNING"]:
            duration += " (active)"
        
        test_summary = f"{launch.passed_tests}/{launch.failed_tests}/{launch.skipped_tests}"
        
        print(f"{launch.id:<15} {launch.name[:24]:<25} {launch.status:<12} {format_datetime(launch.start_time):<20} {duration:<12} {launch.total_tests:<8} {test_summary}")
    
    # Check for old unclosed launches
    print("\n6. Checking for old unclosed launches (>24 hours)...")
    cutoff_time = datetime.now() - timedelta(hours=24)
    old_active_launches = [l for l in active_launches if l.start_time < cutoff_time]
    
    if old_active_launches:
        print(f"⚠️  Found {len(old_active_launches)} old unclosed launches (>24h):")
        for launch in old_active_launches:
            print(f"   - ID: {launch.id}")
            print(f"     Name: {launch.name}")
            print(f"     Status: {launch.status}")
            print(f"     Started: {format_datetime(launch.start_time)}")
            print(f"     Age: {format_duration(launch.start_time)}")
            print(f"     ⚠️  This launch may be preventing new launches from being created!")
            print()
    else:
        print("✅ No old unclosed launches found")
    
    print("\n" + "=" * 80)
    print("SUMMARY")
    print("=" * 80)
    print(f"Total launches: {len(launches)}")
    print(f"Active launches: {len(active_launches)}")
    print(f"Old unclosed launches (>24h): {len(old_active_launches)}")
    print(f"'fixed_xradio_test' launches: {len(xradio_launches)}")
    
    if old_active_launches:
        print("\n⚠️  ISSUE FOUND: Old unclosed launches detected!")
        print("   These launches may be preventing pytest-reportportal from creating new launches.")
        print("   Consider manually closing these launches in ReportPortal UI or contacting administrator.")
    elif active_launches:
        print("\n⚠️  NOTICE: Active launches found, but they are recent.")
        print("   These may be legitimate ongoing test runs.")
    else:
        print("\n✅ No issues found. All launches are properly closed.")
    
    return True

if __name__ == "__main__":
    try:
        success = check_launch_status()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n❌ Interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)