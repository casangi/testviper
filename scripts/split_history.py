import argparse
from collections import defaultdict
from datetime import datetime
import json
import os
import sys

DEFAULT_INPUT_FILE = "history.jsonl"
DEFAULT_OUTPUT_DIR = "history_split"

def get_month_key(line_dict):
    """Extracts the year-month key from the allure history record.

    Looks for 'start' or 'time.start' timestamp (in milliseconds).
    Falls back to current month if not found.
    """
    # Allure 3 runs often put timestamps under 'start' or inside a 'time' object
    timestamp_ms = line_dict.get("timestamp") or line_dict.get("start") or (line_dict.get("time", {}).get("start") if "time" in line_dict else None)
    if not timestamp_ms and "time" in line_dict:
        timestamp_ms = line_dict["time"].get("start")

    if timestamp_ms:
        # Convert milliseconds to datetime object
        dt = datetime.fromtimestamp(int(timestamp_ms) / 1000.0)
        return dt.strftime("%Y-%m")

    return "unknown-date"


def split_history_by_month(input_file, output_dir, component=None):
    if not os.path.exists(input_file):
        print(f"Error: {input_file} not found.")
        return
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)
    # Dictionary to keep open file handles or append to files efficiently
    files_tracked = set()

    with open(input_file, "r", encoding="utf-8") as infile:
        for line in infile:
            line = line.strip()
            if not line:
                continue

            try:
                data = json.loads(line)
                month_key = get_month_key(data)
                output_filename = f"allure-history-{component}-{month_key}.jsonl"

                # Append line to the specific month's file
                mode = "a" if output_filename in files_tracked else "w"
                with open(os.path.join(output_dir, output_filename), mode, encoding="utf-8") as outfile:
                    outfile.write(line + "\n")

                files_tracked.add(output_filename)
            except json.JSONDecodeError:
                # Fallback for malformed lines
                with open(
                    os.path.join(output_dir, "history_corrupted.jsonl"), "a", encoding="utf-8"
                ) as outfile:
                    outfile.write(line + "\n")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Split history.jsonl into monthly chunks based on timestamps."
    )
    parser.add_argument(
        "-i",
        "--input",
        type=str,
        default=DEFAULT_INPUT_FILE,
        help="Input history.jsonl file (default: history.jsonl)",
    )
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        default=DEFAULT_OUTPUT_DIR,
        help="Output directory for split files (default: history_split)",
    )
    parser.add_argument(
        "-c", "--component",
        type=str,
        default=None,
        help="Viper component name",
        action="store"
    )
    args = parser.parse_args()
    input_file = args.input
    output_dir = args.output
    component = args.component

    print("")
    print(f"Splitting {input_file} into monthly chunks...")
    split_history_by_month(input_file, output_dir, component)
    print("Done!")