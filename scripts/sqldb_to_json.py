import sqlite3
import json
import argparse

def main(mydb, myjson_testcases, myjson_testsuites):
    conn = sqlite3.connect(mydb)
    cursor = conn.cursor()

    cursor.execute("SELECT * FROM test_cases")
    rows = cursor.fetchall()
    column_names = [description[0] for description in cursor.description]
    data = []
    for row in rows:
        row_dict = {}
        for i, col_name in enumerate(column_names):
            row_dict[col_name] = row[i]
        data.append(row_dict)

    with open(myjson_testcases, 'w') as f:
        json.dump(data, f, indent=4)

    cursor.execute("SELECT * FROM test_suites")
    rows = cursor.fetchall()
    column_names = [description[0] for description in cursor.description]
    data = []
    for row in rows:
        row_dict = {}
        for i, col_name in enumerate(column_names):
            row_dict[col_name] = row[i]
        data.append(row_dict)

    with open(myjson_testsuites, 'w') as f:
        json.dump(data, f, indent=4)
    conn.close()

if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Convert pytest JUnit XML to SQL records')
    parser.add_argument('--db_file', help='Path to the db file')
    parser.add_argument('--myjson_testcases', help='json output file for test cases')
    parser.add_argument('--myjson_testsuites', help='json output file for test suites')

    args = parser.parse_args()
    main(args.db_file, args.myjson_testcases, args.myjson_testsuites)
