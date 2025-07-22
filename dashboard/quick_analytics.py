#!/usr/bin/env python3
"""
TestViper Quick Analytics
Simple tool to quickly check test analytics and ReportPortal status
"""

import sys
from pathlib import Path

# Add dashboard directory to path for analytics import
dashboard_dir = Path(__file__).parent
sys.path.insert(0, str(dashboard_dir))

def main():
    """Main function for quick analytics"""
    try:
        from analytics.simple_report_generator import TVSimpleReportGenerator
        
        generator = TVSimpleReportGenerator()
        
        # Check if we have any arguments
        if len(sys.argv) > 1:
            command = sys.argv[1]
            
            if command == "status":
                print(generator.get_quick_status())
            elif command == "report":
                report_path = generator.save_analytics_report()
                print(f"📄 Analytics report saved: {report_path}")
            elif command == "help":
                print("""
TestViper Quick Analytics

Commands:
  status   - Show quick status
  report   - Generate and save analytics report
  help     - Show this help message
  
No arguments: Show full analytics summary
""")
            else:
                print(f"Unknown command: {command}")
                print("Use 'help' to see available commands")
        else:
            # Default: show full summary
            generator.print_summary()
    
    except Exception as e:
        print(f"❌ Error: {e}")
        return 1
    
    return 0

if __name__ == "__main__":
    sys.exit(main())