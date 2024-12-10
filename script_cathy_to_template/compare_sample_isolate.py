import pandas as pd
import sys

def check_library_ids(file_path):
    try:
        # Load the specific sheets
        merged_sheet = pd.read_excel(file_path, sheet_name="Merged Sheet", header=1, engine="openpyxl")
        sample_sheet = pd.read_excel(file_path, sheet_name="Sequence Information", header=1, engine="openpyxl")

        # Extract the specified columns
        merged_col = merged_sheet['library_ID']
        print(merged_col)
        sample_col = sample_sheet['library_ID']
        missing_ids = sample_col[~sample_col.isin(merged_col)]
        # Compare the two columns
         # Print results
        if missing_ids.empty:
            print("All library_IDs in Sequence Information are found in Merged Sheet.")
        else:
            print("The following library_IDs in Sequence Information are not found in Merged Sheet:")
            print(missing_ids)
    
    except KeyError as e:
        print(f"Column not found: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python compare_columns.py <file_path>")
    else:
        file_path = sys.argv[1]
        check_library_ids(file_path)