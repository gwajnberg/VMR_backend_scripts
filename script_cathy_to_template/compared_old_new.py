import pandas as pd
import sys

def clean_column_names(df):
    # Standardize column names by removing extra spaces and special characters
    df.columns = df.columns.str.strip().str.replace(r"[^\w\s]", "", regex=True).str.replace(" ", "_")
    return df

def update_merged_sheet(file_path_old, file_path_new, output_file):
    try:
        # Load the old and new sheets
        old_data = pd.read_excel(file_path_old, header=1, engine="openpyxl")  # Header is on the second row (index 1)
        merged_sheet = pd.read_excel(file_path_new, sheet_name="Merged Sheet", header=1, engine="openpyxl")
        sample_collection_data = pd.read_excel(file_path_new, sheet_name="Sample Collection & Processing", header=1, engine="openpyxl")

        # Clean column names for all dataframes
        old_data = clean_column_names(old_data)
        merged_sheet = clean_column_names(merged_sheet)
        sample_collection_data = clean_column_names(sample_collection_data)

        # Define the matching keys for identifying rows
        matching_columns = ['sample_collector_sample_ID', 'isolate_ID', 'library_ID']

        # Merge old data into merged sheet for updates
        updated_merged_sheet = merged_sheet.merge(
            old_data,
            on=matching_columns,
            how='left',
            suffixes=('', '_old')
        )

        # Update columns with data from the old file where values are missing in the merged sheet
        for column in old_data.columns:
            if column not in matching_columns:
                old_column = f"{column}_old"
                if old_column in updated_merged_sheet.columns:
                    # Ensure the column types are compatible before combining
                    if updated_merged_sheet[column].dtype != updated_merged_sheet[old_column].dtype:
                        updated_merged_sheet[old_column] = updated_merged_sheet[old_column].astype(updated_merged_sheet[column].dtype, errors='ignore')
                    updated_merged_sheet.loc[:, column] = updated_merged_sheet[column].combine_first(updated_merged_sheet[old_column])
                    updated_merged_sheet.drop(columns=[old_column], inplace=True)  # Clean up auxiliary columns

        # Identify new rows in the old data that are not in the merged sheet
        merged_keys = merged_sheet[matching_columns]
        new_rows = old_data.merge(merged_keys, on=matching_columns, how='left', indicator=True).loc[lambda x: x['_merge'] == 'left_only'].drop(columns='_merge')

        # Append new rows to the updated merged sheet
        updated_merged_sheet = pd.concat([updated_merged_sheet, new_rows], ignore_index=True)

        # Check the Sample Collection & Processing tab for missing sample_collector_sample_IDs
        missing_samples = sample_collection_data[~sample_collection_data['sample_collector_sample_ID'].isin(updated_merged_sheet['sample_collector_sample_ID'])]

        # Efficiently add missing columns with 0 values in a single step to avoid fragmentation
        missing_columns = {col: 0 for col in updated_merged_sheet.columns if col not in missing_samples.columns}
        missing_columns_df = pd.DataFrame(missing_columns, index=missing_samples.index)
        missing_samples = pd.concat([missing_samples, missing_columns_df], axis=1)

        # Reorder columns to match updated_merged_sheet
        missing_samples = missing_samples[updated_merged_sheet.columns]

        # Append missing rows from the Sample Collection & Processing tab
        updated_merged_sheet = pd.concat([updated_merged_sheet, missing_samples], ignore_index=True)

        # Save the final updated merged sheet to a new file
        updated_merged_sheet.to_excel(output_file, index=False)
        print(f"Updated merged sheet with new and missing rows has been saved to {output_file}")

    except KeyError as e:
        print(f"Column not found in one of the files: {e}")
    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python update_merged_sheet.py <old_file_path> <new_file_path> <output_file>")
    else:
        file_path_old = sys.argv[1]
        file_path_new = sys.argv[2]
        output_file = sys.argv[3]
        update_merged_sheet(file_path_old, file_path_new, output_file)