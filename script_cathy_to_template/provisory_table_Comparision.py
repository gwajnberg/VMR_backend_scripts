import pandas as pd
import sys

def check_sample_ids(csv_file_path, excel_file_path):
    try:
        # Load the CSV file (header is in the second row, so header=1)
        csv_data = pd.read_csv(csv_file_path, header=1,encoding="ISO-8859-1")

        # Check if "Sample ID" column exists
        if "Sample ID" not in csv_data.columns:
            print("Error: 'Sample ID' column not found in the CSV file.")
            return
        
        # Load the Excel file and check if "sample_collector_sample_ID" column exists
        excel_data = pd.read_excel(excel_file_path, header=0, engine="openpyxl")
        if "sample_collector_sample_ID" not in excel_data.columns:
            print("Error: 'sample_collector_sample_ID' column not found in the Excel file.")
            return

        # Extract columns to compare
        csv_sample_ids = csv_data["Sample ID"]
        excel_sample_ids = excel_data["sample_collector_sample_ID"]

        # Check for missing IDs
        missing_ids = csv_sample_ids[~csv_sample_ids.isin(excel_sample_ids)]

        # Print the result
        if missing_ids.empty:
            print("All Sample IDs in the CSV file are found in the Excel file.")
        else:
            print("The following Sample IDs from the CSV file are not found in the Excel file:")
            print(missing_ids.to_list())

    except FileNotFoundError as e:
        print(f"File not found: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python check_sample_ids.py <csv_file_path> <excel_file_path>")
    else:
        csv_file_path = sys.argv[1]
        excel_file_path = sys.argv[2]
        check_sample_ids(csv_file_path, excel_file_path)
