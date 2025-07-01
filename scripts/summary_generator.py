#!/usr/bin/env python3
"""
Generate summary HTML report with links to individual component reports
"""
import json
import os
import xml.etree.ElementTree as ET
from pathlib import Path
from datetime import datetime
import sys

def parse_coverage_xml(xml_path):
    """Parse coverage XML file and extract metrics"""
    try:
        if not os.path.exists(xml_path):
            return {"line_rate": 0, "lines_covered": 0, "lines_valid": 0}
            
        tree = ET.parse(xml_path)
        root = tree.getroot()
        
        line_rate = float(root.get('line-rate', 0))
        lines_covered = int(root.get('lines-covered', 0))
        lines_valid = int(root.get('lines-valid', 0))
        
        return {
            "line_rate": line_rate,
            "lines_covered": lines_covered,
            "lines_valid": lines_valid,
            "percentage": round(line_rate * 100, 2)
        }
    except Exception as e:
        print(f"Error parsing coverage XML {xml_path}: {e}")
        return {"line_rate": 0, "lines_covered": 0, "lines_valid": 0, "percentage": 0}

def parse_allure_summary(report_path):
    """Parse Allure report summary from widgets"""
    try:
        widgets_path = os.path.join(report_path, "widgets", "summary.json")
        if not os.path.exists(widgets_path):
            return {"total": 0, "passed": 0, "failed": 0, "broken": 0, "skipped": 0}
            
        with open(widgets_path, 'r') as f:
            data = json.load(f)
            
        statistic = data.get('statistic', {})
        return {
            "total": statistic.get('total', 0),
            "passed": statistic.get('passed', 0),
            "failed": statistic.get('failed', 0),
            "broken": statistic.get('broken', 0),
            "skipped": statistic.get('skipped', 0)
        }
    except Exception as e:
        print(f"Error parsing Allure summary {report_path}: {e}")
        return {"total": 0, "passed": 0, "failed": 0, "broken": 0, "skipped": 0}

def generate_summary_html():
    """Generate the main summary HTML page"""
    
    # Get test statistics
    integration_stats = parse_allure_summary("allure-report/integration")
    toolviper_stats = parse_allure_summary("allure-report/toolviper")
    xradio_stats = parse_allure_summary("allure-report/xradio")
    graphviper_stats = parse_allure_summary("allure-report/graphviper")
    astroviper_stats = parse_allure_summary("allure-report/astroviper")
    
    # Get coverage statistics
    integration_coverage = parse_coverage_xml("coverage/coverage-integration.xml")
    toolviper_coverage = parse_coverage_xml("coverage/coverage-toolviper.xml")
    xradio_coverage = parse_coverage_xml("coverage/coverage-xradio.xml")
    graphviper_coverage = parse_coverage_xml("coverage/coverage-graphviper.xml")
    astroviper_coverage = parse_coverage_xml("coverage/coverage-astroviper.xml")
    
    # Generate timestamp
    timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S UTC")
    
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
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
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
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🧪 Test & Coverage Summary</h1>
            <p>Generated on {timestamp}</p>
        </div>
        
        <div class="content">
            <div class="overall-stats">
                <h2>Overall Statistics</h2>
                <div class="overall-grid">
                    <div class="overall-metric">
                        <h4>Total Tests</h4>
                        <div class="value">{integration_stats['total'] + toolviper_stats['total'] + xradio_stats['total']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Passed</h4>
                        <div class="value passed">{integration_stats['passed'] + toolviper_stats['passed'] + xradio_stats['passed']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Failed</h4>
                        <div class="value failed">{integration_stats['failed'] + toolviper_stats['failed'] + xradio_stats['failed']}</div>
                    </div>
                    <div class="overall-metric">
                        <h4>Avg Coverage</h4>
                        <div class="value">{round((integration_coverage['percentage'] + toolviper_coverage['percentage'] + xradio_coverage['percentage']) / 3, 1)}%</div>
                    </div>
                </div>
            </div>
            
            <div class="summary-grid">
                <div class="component-card">
                    <div class="card-header">
                        <h3>🔬 TestViper Integration</h3>
                        <p>Integration test suite</p>
                    </div>
                    <div class="card-body">
                        <div class="metrics-row">
                            <span class="metric-label">Total Tests:</span>
                            <span class="metric-value">{integration_stats['total']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Passed:</span>
                            <span class="metric-value passed">{integration_stats['passed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Failed:</span>
                            <span class="metric-value failed">{integration_stats['failed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Skipped:</span>
                            <span class="metric-value skipped">{integration_stats['skipped']}</span>
                        </div>
                        
                        <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
                        <div class="coverage-bar">
                            <div class="coverage-fill" style="width: {integration_coverage['percentage']}%"></div>
                        </div>
                        <div class="coverage-text">{integration_coverage['percentage']}% ({integration_coverage['lines_covered']}/{integration_coverage['lines_valid']} lines)</div>
                        
                        <a href="integration/index.html" class="report-link">View Full Report</a>
                    </div>
                </div>
                
                <div class="component-card">
                    <div class="card-header">
                        <h3>🛠️ ToolViper</h3>
                        <p>Tool component tests</p>
                    </div>
                    <div class="card-body">
                        <div class="metrics-row">
                            <span class="metric-label">Total Tests:</span>
                            <span class="metric-value">{toolviper_stats['total']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Passed:</span>
                            <span class="metric-value passed">{toolviper_stats['passed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Failed:</span>
                            <span class="metric-value failed">{toolviper_stats['failed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Skipped:</span>
                            <span class="metric-value skipped">{toolviper_stats['skipped']}</span>
                        </div>
                        
                        <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
                        <div class="coverage-bar">
                            <div class="coverage-fill" style="width: {toolviper_coverage['percentage']}%"></div>
                        </div>
                        <div class="coverage-text">{toolviper_coverage['percentage']}% ({toolviper_coverage['lines_covered']}/{toolviper_coverage['lines_valid']} lines)</div>
                        
                        <a href="toolviper/index.html" class="report-link">View Full Report</a>
                    </div>
                </div>
                
                <div class="component-card">
                    <div class="card-header">
                        <h3>📡 XRadio</h3>
                        <p>Radio component tests</p>
                    </div>
                    <div class="card-body">
                        <div class="metrics-row">
                            <span class="metric-label">Total Tests:</span>
                            <span class="metric-value">{xradio_stats['total']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Passed:</span>
                            <span class="metric-value passed">{xradio_stats['passed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Failed:</span>
                            <span class="metric-value failed">{xradio_stats['failed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Skipped:</span>
                            <span class="metric-value skipped">{xradio_stats['skipped']}</span>
                        </div>
                        
                        <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
                        <div class="coverage-bar">
                            <div class="coverage-fill" style="width: {xradio_coverage['percentage']}%"></div>
                        </div>
                        <div class="coverage-text">{xradio_coverage['percentage']}% ({xradio_coverage['lines_covered']}/{xradio_coverage['lines_valid']} lines)</div>
                        
                        <a href="xradio/index.html" class="report-link">View Full Report</a>
                    </div>
                </div>

                <div class="component-card">
                    <div class="card-header">
                        <h3>📡 GraphVIPER</h3>
                        <p>Radio component tests</p>
                    </div>
                    <div class="card-body">
                        <div class="metrics-row">
                            <span class="metric-label">Total Tests:</span>
                            <span class="metric-value">{graphviper_stats['total']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Passed:</span>
                            <span class="metric-value passed">{graphviper_stats['passed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Failed:</span>
                            <span class="metric-value failed">{graphviper_stats['failed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Skipped:</span>
                            <span class="metric-value skipped">{graphviper_stats['skipped']}</span>
                        </div>
                        
                        <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
                        <div class="coverage-bar">
                            <div class="coverage-fill" style="width: {graphviper_coverage['percentage']}%"></div>
                        </div>
                        <div class="coverage-text">{graphviper_coverage['percentage']}% ({graphviper_coverage['lines_covered']}/{graphviper_coverage['lines_valid']} lines)</div>
                        
                        <a href="graphviper/index.html" class="report-link">View Full Report</a>
                    </div>
                </div>
                
                <div class="component-card">
                    <div class="card-header">
                        <h3>📡 AstroVIPER</h3>
                        <p>Radio component tests</p>
                    </div>
                    <div class="card-body">
                        <div class="metrics-row">
                            <span class="metric-label">Total Tests:</span>
                            <span class="metric-value">{astroviper_stats['total']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Passed:</span>
                            <span class="metric-value passed">{astroviper_stats['passed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Failed:</span>
                            <span class="metric-value failed">{astroviper_stats['failed']}</span>
                        </div>
                        <div class="metrics-row">
                            <span class="metric-label">Skipped:</span>
                            <span class="metric-value skipped">{astroviper_stats['skipped']}</span>
                        </div>
                        
                        <h4 style="margin-top: 20px; margin-bottom: 10px;">Coverage</h4>
                        <div class="coverage-bar">
                            <div class="coverage-fill" style="width: {astroviper_coverage['percentage']}%"></div>
                        </div>
                        <div class="coverage-text">{astroviper_coverage['percentage']}% ({astroviper_coverage['lines_covered']}/{astroviper_coverage['lines_valid']} lines)</div>
                        
                        <a href="astroviper/index.html" class="report-link">View Full Report</a>
                    </div>
                </div>  
            </div>
        </div>
        
        <div class="footer">
            <p>Generated by TestViper CI/CD Pipeline</p>
        </div>
    </div>
</body>
</html>
"""
    
    # Write the HTML file
    output_path = "allure-report/index.html"
    with open(output_path, 'w') as f:
        f.write(html_content)
    
    print(f"Summary report generated: {output_path}")
    return True

def main():
    """Generate summary report"""
    try:
        # Ensure output directory exists
        Path("allure-report").mkdir(parents=True, exist_ok=True)
        
        success = generate_summary_html()
        
        if success:
            print("Summary report generation completed successfully")
        else:
            print("Summary report generation failed")
            
        return success
        
    except Exception as e:
        print(f"Error generating summary report: {e}")
        return False

if __name__ == "__main__":
    success = main()
    sys.exit(0 if success else 1)