import sqlite3
import argparse

# Connect to a database file (creates it if it doesn't exist)

def main(db_file_path, sql_file_path):
    conn = sqlite3.connect(db_file_path) 
    # Create a cursor object to execute SQL commands
    cursor = conn.cursor()
    with open(sql_file_path, 'r') as sql_file:
        sql_script = sql_file.read()
    conn.executescript(sql_script)
    # Commit changes and close the connection
    conn.commit()
    conn.close()
if __name__ == '__main__':

    parser = argparse.ArgumentParser(description='Convert pytest JUnit XML to SQL records')
    parser.add_argument('--sql_file', help='Path to the sql file')
    parser.add_argument('--db_file', help='Path to the db file')

    args = parser.parse_args()
    main(args.db_file, args.sql_file)