#!/usr/bin/env python3
"""
Generate summary landing page for TestViper reports
"""
import json
import os
import xml.etree.ElementTree as ET
from datetime import datetime
from pathlib import Path

def parse_allure_results(results_dir):
    """Parse Allure results to extract test statistics"""
    stats = {
        'total': 0,
        'passed': 0,
        'failed': 0,
        'broken': 0,
        'skipped': 0
    }
    
    if not os.path.exists(results_dir):
        return stats
    
    # Parse test result files
    for file_path in Path(results_dir).glob("*-result.json"):
        try:
            with open(file_path, 'r') as f:
                result = json.load(f)
                stats['total'] += 1
                status = result.get('status', 'unknown')
                if status in stats:
                    stats[status] += 1
        except (json.JSONDecodeError, KeyError):
            continue
    
    return stats

def parse_coverage_json(coverage_file):
    """Parse coverage JSON file to extract coverage percentage"""
    if not os.path.exists(coverage_file):
        return 0.0, 0, 0
    
    try:
        with open(coverage_file, 'r') as f:
            coverage_data = json.load(f)
            totals = coverage_data.get('totals', {})
            covered = totals.get('covered_lines', 0)
            total = totals.get('num_statements', 0)
            percentage = totals.get('percent_covered', 0.0)
            return percentage, covered, total
    except (json.JSONDecodeError, KeyError):
        return 0.0, 0, 0

def generate_summary_page():
    """Generate the summary landing page"""
    
    # Component configurations
    components = {
        'testviper': {
            'name': 'TestViper Integration',
            'description': 'Integration test suite',
            'emoji': '🔬',
            'repo': 'testviper'
        },
        'toolviper': {
            'name': 'ToolViper',
            'description': 'Tool component tests',
            'emoji': '🛠️',
            'repo': 'toolviper'
        },
        'xradio': {
            'name': 'XRadio',
            'description': 'Radio component tests',
            'emoji': '📡',
            'repo': 'xradio'
        },
        'graphviper': {
            'name': 'GraphViper',
            'description': 'Graph component tests',
            'emoji': '📊',
            'repo': 'graphviper'
        },
        'astroviper': {
            'name': 'AstroViper',
            'description': 'Astronomy component tests',
            'emoji': '🌟',
            'repo': 'astroviper'
        }
    }
    
    # Parse test results and coverage for each component
    component_data = {}
    overall_stats = {
        'total': 0,
        'passed': 0,
        'failed': 0,
        'broken': 0,
        'skipped': 0,
        'avg_coverage': 0.0
    }
    
    coverage_sum = 0.0
    coverage_count = 0
    
    for component_key, component_info in components.items():
        # Parse test results
        if component_key == 'testviper':
            results_dir = 'allure-results/integration'
            coverage_file = 'coverage/coverage-integration.json'
        else:
            results_dir = f'allure-results/{component_key}'
            coverage_file = f'coverage/coverage-{component_key}.json'
        
        stats = parse_allure_results(results_dir)
        coverage_pct, covered_lines, total_lines = parse_coverage_json(coverage_file)
        
        component_data[component_key] = {
            'info': component_info,
            'stats': stats,
            'coverage': {
                'percentage': coverage_pct,
                'covered': covered_lines,
                'total': total_lines
            }
        }
        
        # Update overall stats
        for key in ['total', 'passed', 'failed', 'broken', 'skipped']:
            overall_stats[key] += stats[key]
        
        if coverage_pct > 0:
            coverage_sum += coverage_pct
            coverage_count += 1
    
    # Calculate average coverage
    if coverage_count > 0:
        overall_stats['avg_coverage'] = coverage_sum / coverage_count
    
    # Generate HTML
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
            grid-template-columns: repeat(3, 1fr);
            grid-template-rows: repeat(2, 1fr);
            gap: 30px;
            margin-bottom: 40px;
        }}
        
        @media (max-width: 1200px) {{
            .summary-grid {{
                grid-template-columns: repeat(2, 1fr);
                grid-template-rows: repeat(3, 1fr);
            }}
        }}
        
        @media (max-width: 768px) {{
            .summary-grid {{
                grid-template-columns: 1fr;
                grid-template-rows: repeat(6, 1fr);
            }}
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
                        <div class="value">{overall_stats['avg_coverage']:.1f}%</div>
                    </div>
                </div>
            </div>
            
            <div class="summary-grid">
                """
    
    # Generate component cards
    for component_key, data in component_data.items():
        info = data['info']
        stats = data['stats']
        coverage = data['coverage']
        
        html_content += f"""
    <div class="component-card">
        <div class="card-header">
            <h3>{info['emoji']} {info['name']}</h3>
            <p>{info['description']}</p>
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
            <div class="coverage-text">{coverage['percentage']:.1f}% ({coverage['covered']}/{coverage['total']} lines)</div>
            
            
    <div class="codecov-badge" style="margin-top: 15px;">
        <a href="https://app.codecov.io/gh/casangi/{info['repo']}" target="_blank">
            <img src="https://codecov.io/gh/casangi/{info['repo']}/branch/main/graph/badge.svg" alt="CodeCov Badge" style="height: 20px;">
        </a>
    </div>
    
            
            <a href="{component_key}/index.html" class="report-link">View Allure Report</a>
        </div>
    </div>
    """
    
    # Close HTML
    html_content += """
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
    
    # Write the HTML file
    os.makedirs('main', exist_ok=True)
    with open('main/index.html', 'w') as f:
        f.write(html_content)
    
    print("Summary page generated successfully at main/index.html")

if __name__ == "__main__":
    generate_summary_page()
