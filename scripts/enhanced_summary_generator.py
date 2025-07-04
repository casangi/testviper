#!/usr/bin/env python3
"""
Enhanced Summary Report Generator
Generates a comprehensive summary page with links to individual Allure reports
and CodeCov badges for each component.
"""

import os
import json
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path

# Component configurations with CodeCov links
COMPONENTS = [
    {
        'name': 'testviper',
        'display_name': 'TestViper Integration',
        'description': 'Integration test suite',
        'path': '.',
        'test_path': 'tests',
        'icon': '🔬',
        'codecov_url': 'https://app.codecov.io/gh/casangi/testviper',
        'codecov_badge': 'https://codecov.io/gh/casangi/testviper/branch/main/graph/badge.svg'
    },
    {
        'name': 'toolviper',
        'display_name': 'ToolViper',
        'description': 'Tool component tests',
        'path': 'toolviper',
        'test_path': 'tests',
        'icon': '🛠️',
        'codecov_url': 'https://app.codecov.io/gh/casangi/toolviper',
        'codecov_badge': 'https://codecov.io/gh/casangi/toolviper/branch/main/graph/badge.svg'
    },
    {
        'name': 'xradio',
        'display_name': 'XRadio',
        'description': 'Radio component tests',
        'path': 'xradio',
        'test_path': 'tests',
        'icon': '📡',
        'codecov_url': 'https://app.codecov.io/gh/casangi/xradio',
        'codecov_badge': 'https://codecov.io/gh/casangi/xradio/branch/main/graph/badge.svg'
    },
    {
        'name': 'graphviper',
        'display_name': 'GraphViper',
        'description': 'Graph component tests',
        'path': 'graphviper',
        'test_path': 'tests',
        'icon': '📊',
        'codecov_url': 'https://app.codecov.io/gh/casangi/graphviper',
        'codecov_badge': 'https://codecov.io/gh/casangi/graphviper/branch/main/graph/badge.svg'
    },
    {
        'name': 'astroviper',
        'display_name': 'AstroViper',
        'description': 'Astronomy component tests',
        'path': 'astroviper',
        'test_path': 'tests',
        'icon': '🌟',
        'codecov_url': 'https://app.codecov.io/gh/casangi/astroviper',
        'codecov_badge': 'https://codecov.io/gh/casangi/astroviper/branch/main/graph/badge.svg'
    }
]

def parse_allure_results(results_dir):
    """Parse Allure results to extract test statistics"""
    if not os.path.exists(results_dir):
        return {
            'total': 0,
            'passed': 0,
            'failed': 0,
            'broken': 0,
            'skipped': 0
        }
    
    stats = {
        'total': 0,
        'passed': 0,
        'failed': 0,
        'broken': 0,
        'skipped': 0
    }
    
    # Look for JSON result files
    for file_path in Path(results_dir).glob("*.json"):
        if file_path.name.endswith("-result.json"):
            try:
                with open(file_path, 'r') as f:
                    result = json.load(f)
                    status = result.get('status', 'unknown')
                    stats['total'] += 1
                    if status in stats:
                        stats[status] += 1
            except (json.JSONDecodeError, KeyError):
                continue
    
    return stats

def parse_coverage_xml(component_path):
    """Parse coverage.xml to extract coverage percentage"""
    coverage_file = Path(component_path) / "coverage.xml"
    
    if not coverage_file.exists():
        return {'percentage': 0.0, 'lines_covered': 0, 'lines_total': 0}
    
    try:
        tree = ET.parse(coverage_file)
        root = tree.getroot()
        
        # Find coverage element
        coverage_elem = root.find('.//coverage')
        if coverage_elem is not None:
            line_rate = float(coverage_elem.get('line-rate', 0))
            lines_covered = int(coverage_elem.get('lines-covered', 0))
            lines_valid = int(coverage_elem.get('lines-valid', 0))
            
            return {
                'percentage': line_rate * 100,
                'lines_covered': lines_covered,
                'lines_total': lines_valid
            }
    except Exception as e:
        print(f"Error parsing coverage for {component_path}: {e}")
    
    return {'percentage': 0.0, 'lines_covered': 0, 'lines_total': 0}

def generate_component_card(component, stats, coverage):
    """Generate HTML card for a component"""
    
    # Create codecov badge link
    codecov_badge_html = f"""
    <div class="codecov-badge" style="margin-top: 15px;">
        <a href="{component['codecov_url']}" target="_blank">
            <img src="{component['codecov_badge']}" alt="CodeCov Badge" style="height: 20px;">
        </a>
    </div>
    """
    
    card_html = f"""
    <div class="component-card">
        <div class="card-header">
            <h3>{component['icon']} {component['display_name']}</h3>
            <p>{component['description']}</p>
        </div>
        <div class="card-body">
            <div class="metrics-row">
                <span class="metric-label">Total Tests:</span>
                <span class="metric-value">{stats['total']}</span>
            </div>
            <div class="metrics-row">
                <span class="metric-label">Passed:</span>
                <span class="metric-value passed">{stats['passed']}</span>
            </div>
            <div class="metrics-row">
                <span class="metric-label">Failed:</span>
                <span class="metric-value failed">{stats['failed']}</span>
            </div>
            <div class="metrics-row">
                <span class="metric-label">Broken:</span>
                <span class="metric-value broken">{stats['broken']}</span>
            </div>
            <div class="metrics-row">
                <span class="metric-label">Skipped:</span>
                <span class="metric-value skipped">{stats['skipped']}</span>
            </div>
            
            <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
            <div class="coverage-bar">
                <div class="coverage-fill" style="width: {coverage['percentage']:.1f}%"></div>
            </div>
            <div class="coverage-text">{coverage['percentage']:.1f}% ({coverage['lines_covered']}/{coverage['lines_total']} lines)</div>
            
            {codecov_badge_html}
            
            <a href="{component['name']}/index.html" class="report-link">View Allure Report</a>
        </div>
    </div>
    """
    
    return card_html

def create_summary_html(components_data, overall_stats):
    """Create the main summary HTML page"""
    
    # Generate component cards
    cards_html = ""
    for component_data in components_data:
        cards_html += generate_component_card(
            component_data['component'],
            component_data['stats'],
            component_data['coverage']
        )
    
    # Calculate overall metrics
    avg_coverage = sum(cd['coverage']['percentage'] for cd in components_data) / len(components_data) if components_data else 0
    
    html_content = f"""
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Test & Coverage Summary Report</title>
    <style>
        * {{
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }}
        
        body {{
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 20px;
        }}
        
        .container {{
            max-width: 1200px;
            margin: 0 auto;
            background: rgba(255, 255, 255, 0.95);
            border-radius: 20px;
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.1);
            overflow: hidden;
        }}
        
        .header {{
            background: linear-gradient(135deg, #2c3e50 0%, #3498db 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }}
        
        .header h1 {{
            font-size: 2.5rem;
            margin-bottom: 10px;
            font-weight: 700;
        }}
        
        .header p {{
            font-size: 1.1rem;
            opacity: 0.9;
        }}
        
        .content {{
            padding: 40px;
        }}
        
        .summary-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(380px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }}
        
        .component-card {{
            background: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.1);
            overflow: hidden;
            transition: transform 0.3s ease, box-shadow 0.3s ease;
        }}
        
        .component-card:hover {{
            transform: translateY(-5px);
            box-shadow: 0 15px 40px rgba(0, 0, 0, 0.15);
        }}
        
        .card-header {{
            padding: 20px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }}
        
        .card-header h3 {{
            font-size: 1.4rem;
            margin-bottom: 5px;
        }}
        
        .card-body {{
            padding: 25px;
        }}
        
        .metrics-row {{
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
            padding: 10px;
            background: #f8f9fa;
            border-radius: 8px;
        }}
        
        .metric-label {{
            font-weight: 600;
            color: #555;
        }}
        
        .metric-value {{
            font-weight: 700;
            font-size: 1.1rem;
        }}
        
        .passed {{ color: #27ae60; }}
        .failed {{ color: #e74c3c; }}
        .broken {{ color: #f39c12; }}
        .skipped {{ color: #95a5a6; }}
        
        .coverage-bar {{
            width: 100%;
            height: 20px;
            background: #ecf0f1;
            border-radius: 10px;
            overflow: hidden;
            margin: 10px 0;
        }}
        
        .coverage-fill {{
            height: 100%;
            background: linear-gradient(90deg, #27ae60 0%, #2ecc71 100%);
            transition: width 0.3s ease;
        }}
        
        .coverage-text {{
            text-align: center;
            font-weight: 600;
            margin-top: 5px;
        }}
        
        .codecov-badge {{
            text-align: center;
            margin: 15px 0;
        }}
        
        .codecov-badge img {{
            border-radius: 4px;
            transition: transform 0.2s ease;
        }}
        
        .codecov-badge img:hover {{
            transform: scale(1.05);
        }}
        
        .report-link {{
            display: inline-block;
            margin-top: 20px;
            padding: 12px 24px;
            background: linear-gradient(135deg, #3498db 0%, #2980b9 100%);
            color: white;
            text-decoration: none;
            border-radius: 25px;
            font-weight: 600;
            text-align: center;
            transition: all 0.3s ease;
            width: 100%;
        }}
        
        .report-link:hover {{
            background: linear-gradient(135deg, #2980b9 0%, #3498db 100%);
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(52, 152, 219, 0.3);
        }}
        
        .overall-stats {{
            background: linear-gradient(135deg, #2c3e50 0%, #34495e 100%);
            color: white;
            padding: 30px;
            border-radius: 15px;
            margin-bottom: 30px;
            text-align: center;
        }}
        
        .overall-stats h2 {{
            margin-bottom: 20px;
            font-size: 1.8rem;
        }}
        
        .overall-grid {{
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 20px;
        }}
        
        .overall-metric {{
            background: rgba(255, 255, 255, 0.1);
            padding: 15px;
            border-radius: 10px;
        }}
        
        .overall-metric h4 {{
            font-size: 0.9rem;
            opacity: 0.8;
            margin-bottom: 5px;
        }}
        
        .overall-metric .value {{
            font-size: 1.5rem;
            font-weight: 700;
        }}
        
        .footer {{
            text-align: center;
            padding: 20px;
            color: #666;
            border-top: 1px solid #eee;
        }}
        
        .badge-info {{
            background: #17a2b8;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 0.8rem;
            margin-left: 10px;
        }}
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Test & Coverage Summary</h1>
            <p>Generated on {datetime.now().strftime('%Y-%m-%d %H:%M:%S')} UTC</p>
            <span class="badge-info">With Allure History & CodeCov Integration</span>
        </div>
        
        <div class="content">
            <div class="overall-stats">
                <h2>Overall Statistics</h2>
                <div class="overall-grid">
                    <div class="overall-metric">
                        <h4>Total Tests</h4>
                        <div class="value">{overall_stats['total']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Passed</h4>
                        <div class="value passed">{overall_stats['passed']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Failed</h4>
                        <div class="value failed">{overall_stats['failed']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Broken</h4>
                        <div class="value broken">{overall_stats['broken']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Skipped</h4>
                        <div class="value skipped">{overall_stats['skipped']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Avg Coverage</h4>
                        <div class="value">{avg_coverage:.1f}%</div>
                    </div>
                </div>
            </div>
            
            <div class="summary-grid">
                {cards_html}
            </div>
        </div>
        
        <div class="footer">
            <p>Generated by TestViper CI/CD Pipeline with Allure Framework</p>
            <p>Individual reports include historical data and trend analysis</p>
        </div>
    </div>
</body>
</html>
"""
    
    return html_content

def main():
    """Main function to generate the enhanced summary report"""
    print("Generating enhanced summary report...")
    
    components_data = []
    overall_stats = {
        'total': 0,
        'passed': 0,
        'failed': 0,
        'broken': 0,
        'skipped': 0
    }
    
    # Process each component
    for component in COMPONENTS:
        print(f"Processing {component['display_name']}...")
        
        # Parse Allure results
        results_dir = f"allure-results-{component['name']}"
        stats = parse_allure_results(results_dir)
        
        # Parse coverage data
        coverage = parse_coverage_xml(component['path'])
        
        # Update overall stats
        for key in ['total', 'passed', 'failed', 'broken', 'skipped']:
            overall_stats[key] += stats[key]
        
        components_data.append({
            'component': component,
            'stats': stats,
            'coverage': coverage
        })
    
    # Generate HTML
    html_content = create_summary_html(components_data, overall_stats)
    
    # Write to file
    output_file = "allure-report/index.html"
    os.makedirs("allure-report", exist_ok=True)
    
    with open(output_file, "w") as f:
        f.write(html_content)
    
    print(f"Enhanced summary report generated: {output_file}")
    print("Features included:")
    print("- CodeCov badge integration")
    print("- Individual Allure report links")
    print("- Historical trend support")
    print("- Responsive design")

if __name__ == "__main__":
    main()
