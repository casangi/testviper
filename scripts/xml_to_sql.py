#!/usr/bin/env python3
"""
Convert pytest JUnit XML files to SQL records.

This script parses JUnit XML output from pytest and generates SQL INSERT statements
for storing test results in a database.
"""

import xml.etree.ElementTree as ET
import argparse
import sys
from datetime import datetime
from typing import List, Dict, Any
import re
import uuid

class JUnitToSQL:
    def __init__(self):
        self.test_suites = []
        self.test_cases = []
    
    def parse_junit_xml(self, xml_file_path: str) -> None:
        """Parse the JUnit XML file and extract test data."""
        try:
            tree = ET.parse(xml_file_path)
            root = tree.getroot()
        except ET.ParseError as e:
            print(f"Error parsing XML file: {e}", file=sys.stderr)
            sys.exit(1)
        except FileNotFoundError:
            print(f"File not found: {xml_file_path}", file=sys.stderr)
            sys.exit(1)
        
        # Handle both testsuites and testsuite root elements
        if root.tag == 'testsuites':
            testsuites = root.findall('testsuite')
        elif root.tag == 'testsuite':
            testsuites = [root]
        else:
            print(f"Unexpected root element: {root.tag}", file=sys.stderr)
            sys.exit(1)
        
        for testsuite in testsuites:
            self._parse_testsuite(testsuite)
    
    def _parse_testsuite(self, testsuite_elem: ET.Element) -> None:
        """Parse a single testsuite element."""
        suite_data = {
            'name': testsuite_elem.get('name', ''),
            'tests': int(testsuite_elem.get('tests', '0')),
            'failures': int(testsuite_elem.get('failures', '0')),
            'errors': int(testsuite_elem.get('errors', '0')),
            'skipped': int(testsuite_elem.get('skipped', '0')),
            'time': float(testsuite_elem.get('time', '0.0')),
            'timestamp': testsuite_elem.get('timestamp', ''),
            'hostname': testsuite_elem.get('hostname', ''),
        }
        
        #suite_id = len(self.test_suites) + 1
        suite_id = int(str(uuid.uuid4().int).replace('-', '')[:18]) + len(self.test_suites) + 1
        suite_data['id'] = suite_id
        self.test_suites.append(suite_data)
        
        # Parse test cases
        for testcase in testsuite_elem.findall('testcase'):
            self._parse_testcase(testcase, suite_id)
    
    def _parse_testcase(self, testcase_elem: ET.Element, suite_id: int) -> None:
        """Parse a single testcase element."""
        case_data = {
            'suite_id': suite_id,
            'classname': testcase_elem.get('classname', ''),
            'name': testcase_elem.get('name', ''),
            'time': float(testcase_elem.get('time', '0.0')),
            'file': testcase_elem.get('file', ''),
            'line': testcase_elem.get('line', ''),
        }
        
        # Determine test status and get details
        failure = testcase_elem.find('failure')
        error = testcase_elem.find('error')
        skipped = testcase_elem.find('skipped')
        
        if failure is not None:
            case_data['status'] = 'FAILED'
            case_data['failure_message'] = failure.get('message', '')
            case_data['failure_type'] = failure.get('type', '')
            case_data['failure_text'] = failure.text or ''
        elif error is not None:
            case_data['status'] = 'ERROR'
            case_data['error_message'] = error.get('message', '')
            case_data['error_type'] = error.get('type', '')
            case_data['error_text'] = error.text or ''
        elif skipped is not None:
            case_data['status'] = 'SKIPPED'
            case_data['skip_message'] = skipped.get('message', '')
            case_data['skip_reason'] = skipped.text or ''
        else:
            case_data['status'] = 'PASSED'
        
        # Get system output if present
        system_out = testcase_elem.find('system-out')
        system_err = testcase_elem.find('system-err')
        case_data['system_out'] = system_out.text if system_out is not None else ''
        case_data['system_err'] = system_err.text if system_err is not None else ''
        
        self.test_cases.append(case_data)
    
    def generate_create_table_sql(self) -> str:
        """Generate SQL CREATE TABLE statements."""
        return """
-- Test Suites Table
CREATE TABLE IF NOT EXISTS test_suites (
    id INTEGER PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    tests INTEGER DEFAULT 0,
    failures INTEGER DEFAULT 0,
    errors INTEGER DEFAULT 0,
    skipped INTEGER DEFAULT 0,
    time DECIMAL(10, 6) DEFAULT 0.0,
    timestamp VARCHAR(50),
    hostname VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Test Cases Table
CREATE TABLE IF NOT EXISTS test_cases (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    suite_id INTEGER NOT NULL,
    classname VARCHAR(500),
    name VARCHAR(500) NOT NULL,
    time DECIMAL(10, 6) DEFAULT 0.0,
    file VARCHAR(500),
    line VARCHAR(20),
    status TEXT CHECK( status IN ('PASSED', 'FAILED', 'ERROR', 'SKIPPED')) NOT NULL,
    failure_message TEXT,
    failure_type VARCHAR(255),
    failure_text TEXT,
    error_message TEXT,
    error_type VARCHAR(255),
    error_text TEXT,
    skip_message TEXT,
    skip_reason TEXT,
    system_out TEXT,
    system_err TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (suite_id) REFERENCES test_suites(id)
);
"""
    
    def _escape_sql_string(self, value: str) -> str:
        """Escape single quotes in SQL strings."""
        if value is None:
            return 'NULL'
        return f"'{value.replace(chr(39), chr(39) + chr(39))}'"
    
    def generate_insert_sql(self) -> str:
        """Generate SQL INSERT statements for the parsed data."""
        sql_statements = []
        
        # Insert test suites
        for suite in self.test_suites:
            timestamp_val = self._escape_sql_string(suite['timestamp']) if suite['timestamp'] else 'NULL'
            hostname_val = self._escape_sql_string(suite['hostname']) if suite['hostname'] else 'NULL'
            
            sql = f"""INSERT OR IGNORE INTO test_suites (id, name, tests, failures, errors, skipped, time, timestamp, hostname) 
VALUES ({suite['id']}, {self._escape_sql_string(suite['name'])}, {suite['tests']}, 
        {suite['failures']}, {suite['errors']}, {suite['skipped']}, {suite['time']}, 
        {timestamp_val}, {hostname_val});"""
            sql_statements.append(sql)
        
        # Insert test cases
        for i, case in enumerate(self.test_cases, 1):
            values = [
                #str(i),  # id
                str(case['suite_id'] + i),  # id
                str(case['suite_id']),
                self._escape_sql_string(case.get('classname', '')),
                self._escape_sql_string(case['name']),
                str(case['time']),
                self._escape_sql_string(case.get('file', '')),
                self._escape_sql_string(case.get('line', '')),
                f"'{case['status']}'",
            ]
            
            # Add status-specific fields
            for field in ['failure_message', 'failure_type', 'failure_text',
                         'error_message', 'error_type', 'error_text',
                         'skip_message', 'skip_reason', 'system_out', 'system_err']:
                value = case.get(field, '')
                values.append(self._escape_sql_string(value) if value else 'NULL')
            
            sql = f"""INSERT OR IGNORE INTO test_cases (id, suite_id, classname, name, time, file, line, status, 
                     failure_message, failure_type, failure_text, error_message, error_type, 
                     error_text, skip_message, skip_reason, system_out, system_err) 
VALUES ({', '.join(values)});"""
            sql_statements.append(sql)
        
        return '\n\n'.join(sql_statements)
    
    def generate_summary_sql(self) -> str:
        """Generate SQL for summary queries."""
        return """
-- Summary Queries

-- Overall test summary
SELECT 
    COUNT(*) as total_suites,
    SUM(tests) as total_tests,
    SUM(failures) as total_failures,
    SUM(errors) as total_errors,
    SUM(skipped) as total_skipped,
    SUM(time) as total_time
FROM test_suites;

-- Test results by suite
SELECT 
    ts.name as suite_name,
    ts.tests,
    ts.failures,
    ts.errors,
    ts.skipped,
    ts.time,
    ROUND((ts.tests - ts.failures - ts.errors - ts.skipped) * 100.0 / ts.tests, 2) as pass_rate
FROM test_suites ts
ORDER BY ts.time DESC;

-- Failed test cases
SELECT 
    ts.name as suite_name,
    tc.classname,
    tc.name as test_name,
    tc.status,
    tc.failure_message,
    tc.time
FROM test_cases tc
JOIN test_suites ts ON tc.suite_id = ts.id
WHERE tc.status IN ('FAILED', 'ERROR')
ORDER BY tc.time DESC;
"""


def main():
    parser = argparse.ArgumentParser(description='Convert pytest JUnit XML to SQL records')
    parser.add_argument('xml_file', help='Path to the JUnit XML file')
    parser.add_argument('--output', '-o', help='Output SQL file (default: stdout)')
    parser.add_argument('--create-tables', action='store_true', 
                       help='Include CREATE TABLE statements')
    parser.add_argument('--summary', action='store_true',
                       help='Include summary queries')
    
    args = parser.parse_args()
    
    converter = JUnitToSQL()
    converter.parse_junit_xml(args.xml_file)
    
    output_content = []
    
    if args.create_tables:
        output_content.append("-- CREATE TABLE statements")
        output_content.append(converter.generate_create_table_sql())
        output_content.append("\n-- INSERT statements")
    
    output_content.append(converter.generate_insert_sql())
    
    if args.summary:
        output_content.append("\n")
        output_content.append(converter.generate_summary_sql())
    
    sql_output = '\n'.join(output_content)
    
    if args.output:
        with open(args.output, 'w', encoding='utf-8') as f:
            f.write(sql_output)
        print(f"SQL output written to {args.output}")
    else:
        print(sql_output)
    
    # Print summary to stderr
    print(f"\nProcessed {len(converter.test_suites)} test suite(s) with {len(converter.test_cases)} test case(s)", file=sys.stderr)


if __name__ == '__main__':
    """
    # Basic conversion (output to stdout)
    python xml_to_sql.py results.xml

    # Save to file with table creation
    python xml_to_sql.py results.xml --create-tables --output test_results.sql

    # Include summary queries
    python xml_to_sql.py results.xml --create-tables --summary --output complete.sql
    """
    main()