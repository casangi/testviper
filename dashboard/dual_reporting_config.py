#!/usr/bin/env python3
"""
TestViper Dual Reporting Configuration
Supports both local and cloud ReportPortal instances for comprehensive coverage tracking
"""

import json
import os
import sys
from pathlib import Path
from typing import Dict, List, Optional, Any
from dataclasses import dataclass, asdict
import argparse

@dataclass
class ReportPortalConfig:
    """Configuration for a ReportPortal instance"""
    name: str
    endpoint: str
    project: str
    api_key: str
    enabled: bool = True
    description: str = ""
    priority: int = 1  # 1 = primary, 2 = secondary
    timeout: int = 30
    retry_count: int = 3
    launch_attributes: Optional[Dict[str, str]] = None
    
    def __post_init__(self):
        if self.launch_attributes is None:
            self.launch_attributes = {}

class DualReportingConfigManager:
    """Manages multiple ReportPortal configurations for dual reporting"""
    
    DEFAULT_CONFIG_FILE = "dashboard/config/dual_reporting_config.json"
    
    def __init__(self, config_file: Optional[str] = None):
        """Initialize with optional config file path"""
        self.config_file = config_file or self.DEFAULT_CONFIG_FILE
        self.configs = {}
        self.load_config()
    
    def load_config(self):
        """Load configuration from file"""
        if os.path.exists(self.config_file):
            try:
                with open(self.config_file, 'r') as f:
                    data = json.load(f)
                
                # Load ReportPortal configurations
                for name, config_data in data.get("reportportal_instances", {}).items():
                    self.configs[name] = ReportPortalConfig(
                        name=name,
                        endpoint=config_data.get("endpoint", ""),
                        project=config_data.get("project", ""),
                        api_key=config_data.get("api_key", ""),
                        enabled=config_data.get("enabled", True),
                        description=config_data.get("description", ""),
                        priority=config_data.get("priority", 1),
                        timeout=config_data.get("timeout", 30),
                        retry_count=config_data.get("retry_count", 3),
                        launch_attributes=config_data.get("launch_attributes", {})
                    )
                    
                print(f"✅ Loaded {len(self.configs)} ReportPortal configurations from {self.config_file}")
                
            except Exception as e:
                print(f"⚠️  Error loading config file {self.config_file}: {e}")
                self.create_default_config()
        else:
            print(f"📋 Config file {self.config_file} not found, creating default...")
            self.create_default_config()
    
    def create_default_config(self):
        """Create default dual reporting configuration"""
        # Default configurations
        self.configs = {
            "local": ReportPortalConfig(
                name="local",
                endpoint=os.getenv("RP_ENDPOINT", "http://localhost:8080"),
                project=os.getenv("RP_PROJECT", "testviper"),
                api_key=os.getenv("RP_API_KEY", ""),
                enabled=True,
                description="Local ReportPortal instance for development",
                priority=1,
                launch_attributes={"environment": "local", "team": "development"}
            ),
            "cloud": ReportPortalConfig(
                name="cloud",
                endpoint=os.getenv("RP_CLOUD_ENDPOINT", "https://reportportal.example.com"),
                project=os.getenv("RP_CLOUD_PROJECT", "testviper"),
                api_key=os.getenv("RP_CLOUD_API_KEY", ""),
                enabled=bool(os.getenv("RP_CLOUD_ENABLED", "false").lower() == "true"),
                description="Cloud ReportPortal instance for CI/CD",
                priority=2,
                launch_attributes={"environment": "cloud", "team": "ci"}
            )
        }
        
        self.save_config()
    
    def save_config(self):
        """Save current configuration to file"""
        try:
            # Ensure directory exists
            os.makedirs(os.path.dirname(self.config_file), exist_ok=True)
            
            # Convert to serializable format
            config_data = {
                "description": "TestViper Dual Reporting Configuration",
                "version": "1.0.0",
                "reportportal_instances": {},
                "usage_notes": [
                    "Configure multiple ReportPortal instances for comprehensive reporting",
                    "Priority 1 = primary instance, Priority 2+ = secondary instances",
                    "Set enabled=false to disable an instance temporarily",
                    "Use environment variables for sensitive API keys"
                ]
            }
            
            for name, config in self.configs.items():
                config_data["reportportal_instances"][name] = asdict(config)
            
            with open(self.config_file, 'w') as f:
                json.dump(config_data, f, indent=2)
            
            print(f"💾 Configuration saved to {self.config_file}")
            
        except Exception as e:
            print(f"❌ Error saving configuration: {e}")
    
    def get_enabled_configs(self) -> List[ReportPortalConfig]:
        """Get all enabled ReportPortal configurations sorted by priority"""
        enabled_configs = [config for config in self.configs.values() if config.enabled]
        return sorted(enabled_configs, key=lambda x: x.priority)
    
    def get_primary_config(self) -> Optional[ReportPortalConfig]:
        """Get the primary (priority 1) configuration"""
        enabled_configs = self.get_enabled_configs()
        return enabled_configs[0] if enabled_configs else None
    
    def get_secondary_configs(self) -> List[ReportPortalConfig]:
        """Get all secondary configurations"""
        enabled_configs = self.get_enabled_configs()
        return enabled_configs[1:] if len(enabled_configs) > 1 else []
    
    def validate_config(self, config: ReportPortalConfig) -> Dict[str, Any]:
        """Validate a ReportPortal configuration"""
        issues = []
        
        # Check required fields
        if not config.endpoint:
            issues.append("Missing endpoint URL")
        if not config.project:
            issues.append("Missing project name")
        if not config.api_key:
            issues.append("Missing API key")
        
        # Check endpoint format
        if config.endpoint and not (config.endpoint.startswith("http://") or config.endpoint.startswith("https://")):
            issues.append("Endpoint must start with http:// or https://")
        
        return {
            "valid": len(issues) == 0,
            "issues": issues,
            "config_name": config.name
        }
    
    def validate_all_configs(self) -> Dict[str, Any]:
        """Validate all configurations"""
        results = {}
        overall_valid = True
        
        for name, config in self.configs.items():
            if config.enabled:
                validation = self.validate_config(config)
                results[name] = validation
                if not validation["valid"]:
                    overall_valid = False
        
        return {
            "overall_valid": overall_valid,
            "configurations": results
        }
    
    def print_config_summary(self):
        """Print summary of current configuration"""
        print("\n" + "="*60)
        print("📊 DUAL REPORTING CONFIGURATION SUMMARY")
        print("="*60)
        
        enabled_configs = self.get_enabled_configs()
        
        if not enabled_configs:
            print("❌ No enabled ReportPortal configurations found!")
            return
        
        print(f"✅ {len(enabled_configs)} enabled ReportPortal instance(s)")
        print(f"📄 Configuration file: {self.config_file}")
        print()
        
        for config in enabled_configs:
            priority_text = "PRIMARY" if config.priority == 1 else f"SECONDARY ({config.priority})"
            print(f"🔧 {config.name.upper()} ({priority_text})")
            print(f"   Endpoint: {config.endpoint}")
            print(f"   Project: {config.project}")
            print(f"   API Key: {'✅ Configured' if config.api_key else '❌ Missing'}")
            print(f"   Description: {config.description}")
            
            if config.launch_attributes:
                attrs = ", ".join([f"{k}={v}" for k, v in config.launch_attributes.items()])
                print(f"   Launch Attributes: {attrs}")
            print()
        
        # Validation summary
        validation = self.validate_all_configs()
        if validation["overall_valid"]:
            print("✅ All enabled configurations are valid")
        else:
            print("❌ Configuration issues detected:")
            for name, result in validation["configurations"].items():
                if not result["valid"]:
                    print(f"   • {name}: {', '.join(result['issues'])}")
        
        print("="*60)
    
    def setup_environment_for_config(self, config: ReportPortalConfig):
        """Set up environment variables for a specific configuration"""
        env_vars = {
            "RP_ENDPOINT": config.endpoint,
            "RP_PROJECT": config.project,
            "RP_API_KEY": config.api_key,
            "RP_UUID": config.api_key,  # Alternative name
            "RP_TIMEOUT": str(config.timeout)
        }
        
        # Set environment variables
        for key, value in env_vars.items():
            if value:
                os.environ[key] = value
        
        return env_vars
    
    def generate_pytest_args(self, config: ReportPortalConfig, launch_name: str) -> List[str]:
        """Generate pytest arguments for a specific configuration"""
        args = [
            "-p", "pytest_reportportal",
            "--reportportal",
            f"--rp-endpoint={config.endpoint}",
            f"--rp-project={config.project}",
            f"--rp-launch={launch_name}",
            f"--rp-launch-description=TestViper component tests with coverage"
        ]
        
        # Add launch attributes
        if config.launch_attributes:
            for key, value in config.launch_attributes.items():
                args.extend([f"--rp-launch-attribute", f"{key}:{value}"])
        
        return args
    
    def test_connections(self) -> Dict[str, Any]:
        """Test connections to all enabled ReportPortal instances"""
        results = {}
        
        for config in self.get_enabled_configs():
            print(f"🔍 Testing connection to {config.name} ({config.endpoint})...")
            
            try:
                # Set up environment for this config
                self.setup_environment_for_config(config)
                
                # Try to create a client and test connection
                from analytics.rp_client import TVReportPortalClient
                client = TVReportPortalClient()
                status = client.test_connection()
                
                results[config.name] = {
                    "success": status.get("status") == "success",
                    "endpoint": config.endpoint,
                    "project": config.project,
                    "response": status
                }
                
                if results[config.name]["success"]:
                    print(f"   ✅ Connection successful")
                else:
                    print(f"   ❌ Connection failed: {status.get('error', 'Unknown error')}")
                    
            except Exception as e:
                results[config.name] = {
                    "success": False,
                    "endpoint": config.endpoint,
                    "project": config.project,
                    "error": str(e)
                }
                print(f"   ❌ Connection failed: {e}")
        
        return results

def create_sample_config():
    """Create a sample configuration file with examples"""
    config_manager = DualReportingConfigManager()
    
    # Add sample configurations
    config_manager.configs["local"] = ReportPortalConfig(
        name="local",
        endpoint="http://localhost:8080",
        project="testviper",
        api_key="your-local-api-key",
        enabled=True,
        description="Local development ReportPortal",
        priority=1,
        launch_attributes={"environment": "local", "team": "development"}
    )
    
    config_manager.configs["staging"] = ReportPortalConfig(
        name="staging",
        endpoint="https://staging-reportportal.example.com",
        project="testviper-staging",
        api_key="your-staging-api-key",
        enabled=True,
        description="Staging environment ReportPortal",
        priority=2,
        launch_attributes={"environment": "staging", "team": "qa"}
    )
    
    config_manager.configs["production"] = ReportPortalConfig(
        name="production",
        endpoint="https://reportportal.example.com",
        project="testviper-prod",
        api_key="your-production-api-key",
        enabled=False,  # Disabled by default
        description="Production ReportPortal (enable for release testing)",
        priority=3,
        launch_attributes={"environment": "production", "team": "release"}
    )
    
    config_manager.save_config()
    return config_manager

def main():
    """Main CLI function"""
    parser = argparse.ArgumentParser(
        description="TestViper Dual Reporting Configuration",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python dual_reporting_config.py --show                    # Show current configuration
  python dual_reporting_config.py --test                    # Test all connections
  python dual_reporting_config.py --create-sample          # Create sample config file
  python dual_reporting_config.py --validate               # Validate configuration
        """
    )
    
    parser.add_argument(
        "--config", "-c",
        help="Path to configuration file (default: dashboard/config/dual_reporting_config.json)"
    )
    
    parser.add_argument(
        "--show", "-s",
        action="store_true",
        help="Show current configuration summary"
    )
    
    parser.add_argument(
        "--test", "-t",
        action="store_true",
        help="Test connections to all enabled ReportPortal instances"
    )
    
    parser.add_argument(
        "--validate", "-v",
        action="store_true",
        help="Validate configuration"
    )
    
    parser.add_argument(
        "--create-sample",
        action="store_true",
        help="Create sample configuration file"
    )
    
    args = parser.parse_args()
    
    if args.create_sample:
        config_manager = create_sample_config()
        print("📋 Sample configuration created!")
        config_manager.print_config_summary()
        return 0
    
    # Initialize configuration manager
    config_manager = DualReportingConfigManager(config_file=args.config)
    
    if args.show:
        config_manager.print_config_summary()
    
    if args.validate:
        validation = config_manager.validate_all_configs()
        if validation["overall_valid"]:
            print("✅ All configurations are valid")
        else:
            print("❌ Configuration validation failed:")
            for name, result in validation["configurations"].items():
                if not result["valid"]:
                    print(f"   • {name}: {', '.join(result['issues'])}")
            return 1
    
    if args.test:
        print("🔍 Testing connections to all enabled ReportPortal instances...")
        results = config_manager.test_connections()
        
        success_count = sum(1 for r in results.values() if r["success"])
        total_count = len(results)
        
        print(f"\n📊 Connection test results: {success_count}/{total_count} successful")
        
        if success_count == total_count:
            print("✅ All connections successful!")
            return 0
        else:
            print("❌ Some connections failed")
            return 1
    
    if not any([args.show, args.test, args.validate]):
        config_manager.print_config_summary()
    
    return 0

if __name__ == "__main__":
    sys.exit(main())