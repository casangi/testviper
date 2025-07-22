#!/usr/bin/env python3
"""
Comprehensive ReportPortal Launch Status Checker
Checks for unclosed/active launches and provides detailed analysis
"""

import sys
import os
import json
from datetime import datetime, timedelta
from dateutil.parser import parse as parse_datetime
from typing import List, Dict, Any, Optional

# Add the dashboard directory to the path
sys.path.insert(0, os.path.join(os.path.dirname(__file__), 'dashboard'))

from analytics.rp_client import TVReportPortalClient

def parse_timestamp(timestamp_str: Optional[str]) -> Optional[datetime]:
    """Parse ISO 8601 timestamp string"""
    if timestamp_str is None:
        return None
    try:
        return parse_datetime(timestamp_str)
    except Exception:
        return None

def format_datetime(dt: Optional[datetime]) -> str:
    """Format datetime for display"""
    if dt is None:
        return "N/A"
    return dt.strftime("%Y-%m-%d %H:%M:%S")

def format_duration(start: Optional[datetime], end: Optional[datetime] = None) -> str:
    """Format duration for display"""
    if start is None:
        return "N/A"
    
    if end is None:
        end = datetime.now()
    
    duration = end - start
    total_seconds = int(duration.total_seconds())
    
    if total_seconds < 60:
        return f"{total_seconds}s"
    elif total_seconds < 3600:
        minutes = total_seconds // 60
        seconds = total_seconds % 60
        return f"{minutes}m {seconds}s"
    else:
        hours = total_seconds // 3600
        minutes = (total_seconds % 3600) // 60
        seconds = total_seconds % 60
        return f"{hours}h {minutes}m {seconds}s"

def get_launch_age_category(start_time: Optional[datetime]) -> str:
    """Categorize launch by age"""
    if start_time is None:
        return "unknown"
    
    age = datetime.now() - start_time
    
    if age < timedelta(hours=1):
        return "recent"
    elif age < timedelta(hours=24):
        return "today"
    elif age < timedelta(days=7):
        return "week"
    else:
        return "old"

def comprehensive_launch_check():
    """Comprehensive check of ReportPortal launch statuses"""
    print("=" * 90)
    print("COMPREHENSIVE REPORTPORTAL LAUNCH STATUS CHECK")
    print("=" * 90)
    
    # Initialize client
    client = TVReportPortalClient()
    
    # Test connection
    print("\n1. Testing ReportPortal connection...")
    connection_info = client.test_connection()
    
    if connection_info["status"] == "error":
        print(f"❌ Connection FAILED: {connection_info['error']}")
        print(f"   Endpoint: {connection_info['endpoint']}")
        print(f"   Project: {connection_info['project']}")
        return False
    
    print(f"✅ Connection successful!")
    print(f"   Endpoint: {connection_info['endpoint']}")
    print(f"   Project: {connection_info['project']}")
    print(f"   Total Launches: {connection_info['total_launches']}")
    
    # Get all launches (extended limit)
    print("\n2. Fetching all launches...")
    try:
        params = {"page.size": 100, "page.sort": "startTime,desc"}
        response = client.session.get(f"{client.base_url}/launch", params=params)
        response.raise_for_status()
        
        data = response.json()
        launches = data.get("content", [])
        
        print(f"✅ Retrieved {len(launches)} launches")
        
    except Exception as e:
        print(f"❌ Error fetching launches: {e}")
        return False
    
    # Parse and categorize launches
    print("\n3. Analyzing launch data...")
    
    active_launches = []
    completed_launches = []
    failed_launches = []
    xradio_launches = []
    
    for launch_data in launches:
        name = launch_data.get("name", "")
        status = launch_data.get("status", "UNKNOWN")
        start_time = parse_timestamp(launch_data.get("startTime"))
        end_time = parse_timestamp(launch_data.get("endTime"))
        
        launch_info = {
            "id": launch_data.get("id"),
            "name": name,
            "status": status,
            "start_time": start_time,
            "end_time": end_time,
            "statistics": launch_data.get("statistics", {}),
            "attributes": launch_data.get("attributes", []),
            "raw_data": launch_data
        }
        
        # Categorize by status
        if status in ["IN_PROGRESS", "RUNNING"]:
            active_launches.append(launch_info)
        elif status == "FAILED":
            failed_launches.append(launch_info)
        else:
            completed_launches.append(launch_info)
        
        # Check for xradio-related launches
        if "xradio" in name.lower():
            xradio_launches.append(launch_info)
    
    # Check for active launches
    print(f"\n4. Active/Running launches: {len(active_launches)}")
    if active_launches:
        print("⚠️  ACTIVE LAUNCHES FOUND:")
        for launch in active_launches:
            age = get_launch_age_category(launch["start_time"])
            duration = format_duration(launch["start_time"])
            
            print(f"   🔄 ID: {launch['id']}")
            print(f"      Name: {launch['name']}")
            print(f"      Status: {launch['status']}")
            print(f"      Started: {format_datetime(launch['start_time'])} ({age})")
            print(f"      Duration: {duration}")
            
            stats = launch["statistics"].get("executions", {})
            print(f"      Tests: {stats.get('total', 0)} (P:{stats.get('passed', 0)}, F:{stats.get('failed', 0)})")
            
            # Warning for old active launches
            if age in ["week", "old"]:
                print(f"      ⚠️  WARNING: This launch is {age} and may be stuck!")
            
            print()
    else:
        print("✅ No active launches found")
    
    # Check for fixed_xradio_test specifically
    print(f"\n5. 'fixed_xradio_test' launch analysis:")
    fixed_xradio_launches = [l for l in launches if "fixed_xradio_test" in l.get("name", "").lower()]
    
    if fixed_xradio_launches:
        print(f"Found {len(fixed_xradio_launches)} 'fixed_xradio_test' launches:")
        for launch_data in fixed_xradio_launches:
            start_time = parse_timestamp(launch_data.get("startTime"))
            end_time = parse_timestamp(launch_data.get("endTime"))
            
            print(f"   📋 ID: {launch_data.get('id')}")
            print(f"      Name: {launch_data.get('name')}")
            print(f"      Status: {launch_data.get('status')}")
            print(f"      Started: {format_datetime(start_time)}")
            print(f"      Ended: {format_datetime(end_time)}")
            
            if start_time and end_time:
                duration = format_duration(start_time, end_time)
                print(f"      Duration: {duration}")
            elif start_time:
                duration = format_duration(start_time)
                print(f"      Duration: {duration} (ongoing)")
            
            stats = launch_data.get("statistics", {}).get("executions", {})
            print(f"      Tests: {stats.get('total', 0)} (P:{stats.get('passed', 0)}, F:{stats.get('failed', 0)})")
            
            # Check attributes for coverage info
            attributes = launch_data.get("attributes", [])
            coverage_attrs = {attr["key"]: attr["value"] for attr in attributes if attr["key"].startswith("tv_coverage")}
            if coverage_attrs:
                print(f"      Coverage: {coverage_attrs.get('tv_coverage_percentage', 'N/A')}")
                print(f"      Component: {coverage_attrs.get('tv_coverage_component', 'N/A')}")
            
            print()
    else:
        print("❌ No 'fixed_xradio_test' launches found")
    
    # Check for old unclosed launches (potential issue)
    print(f"\n6. Checking for potentially problematic launches...")
    
    cutoff_time = datetime.now() - timedelta(hours=24)
    old_active_launches = [l for l in active_launches if l["start_time"] and l["start_time"] < cutoff_time]
    
    if old_active_launches:
        print(f"⚠️  Found {len(old_active_launches)} old active launches (>24h):")
        for launch in old_active_launches:
            print(f"   🚨 ID: {launch['id']} - {launch['name']}")
            print(f"      Status: {launch['status']}")
            print(f"      Started: {format_datetime(launch['start_time'])}")
            print(f"      Age: {format_duration(launch['start_time'])}")
            print(f"      ⚠️  This may be preventing new launches!")
    else:
        print("✅ No old active launches found")
    
    # Recent launch summary
    print(f"\n7. Recent launch summary (last 15):")
    print("-" * 130)
    print(f"{'ID':<6} {'Name':<30} {'Status':<12} {'Started':<20} {'Duration':<12} {'Tests':<8} {'P/F/S':<8} {'Age'}")
    print("-" * 130)
    
    for launch_data in launches[:15]:
        start_time = parse_timestamp(launch_data.get("startTime"))
        end_time = parse_timestamp(launch_data.get("endTime"))
        
        if start_time and end_time:
            duration = format_duration(start_time, end_time)
        elif start_time:
            duration = format_duration(start_time) + "*"
        else:
            duration = "N/A"
        
        age = get_launch_age_category(start_time)
        stats = launch_data.get("statistics", {}).get("executions", {})
        test_summary = f"{stats.get('passed', 0)}/{stats.get('failed', 0)}/{stats.get('total', 0) - stats.get('passed', 0) - stats.get('failed', 0)}"
        
        status_icon = "🔄" if launch_data.get("status") in ["IN_PROGRESS", "RUNNING"] else ""
        
        print(f"{launch_data.get('id'):<6} {launch_data.get('name', '')[:29]:<30} {launch_data.get('status'):<12} {format_datetime(start_time):<20} {duration:<12} {stats.get('total', 0):<8} {test_summary:<8} {age} {status_icon}")
    
    # Final summary and recommendations
    print(f"\n" + "=" * 90)
    print("SUMMARY AND RECOMMENDATIONS")
    print("=" * 90)
    
    print(f"📊 Launch Statistics:")
    print(f"   Total launches: {len(launches)}")
    print(f"   Active launches: {len(active_launches)}")
    print(f"   Completed launches: {len(completed_launches)}")
    print(f"   Failed launches: {len(failed_launches)}")
    print(f"   XRadio-related launches: {len(xradio_launches)}")
    print(f"   Old active launches (>24h): {len(old_active_launches)}")
    
    # Issue assessment
    if old_active_launches:
        print(f"\n🚨 CRITICAL ISSUE DETECTED:")
        print(f"   {len(old_active_launches)} old active launches found!")
        print(f"   These launches may be preventing pytest-reportportal from creating new launches.")
        print(f"   \n   🔧 RECOMMENDED ACTIONS:")
        print(f"   1. Check ReportPortal UI for these launches")
        print(f"   2. Manually close stuck launches if possible")
        print(f"   3. Contact ReportPortal administrator")
        print(f"   4. Consider restarting ReportPortal services")
        return False
    elif active_launches:
        print(f"\n⚠️  NOTICE: {len(active_launches)} active launches found")
        print(f"   These appear to be recent and may be legitimate test runs.")
        print(f"   Monitor if they complete within reasonable time.")
    else:
        print(f"\n✅ NO ISSUES FOUND:")
        print(f"   All launches are properly closed.")
        print(f"   pytest-reportportal should be able to create new launches.")
    
    # Specific check for fixed_xradio_test
    if fixed_xradio_launches:
        latest_fixed_xradio = fixed_xradio_launches[0]
        print(f"\n📋 'fixed_xradio_test' Status:")
        print(f"   Latest launch: ID {latest_fixed_xradio.get('id')}")
        print(f"   Status: {latest_fixed_xradio.get('status')}")
        
        if latest_fixed_xradio.get('status') in ["IN_PROGRESS", "RUNNING"]:
            print(f"   ⚠️  This launch is still active!")
        else:
            print(f"   ✅ This launch is properly closed")
    
    return len(old_active_launches) == 0

if __name__ == "__main__":
    try:
        success = comprehensive_launch_check()
        sys.exit(0 if success else 1)
    except KeyboardInterrupt:
        print("\n\n❌ Interrupted by user")
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ Unexpected error: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)