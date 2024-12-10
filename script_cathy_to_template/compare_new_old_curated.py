import pandas as pd
import numpy as np

# Function to compare two values and ask the user if they should replace the old value
def compare_values(old_value, new_value, column_name,decision_cache):
    if new_value == 0.0:
        new_value = np.nan
    if pd.isna(old_value) and pd.isna(new_value):
        return old_value
    if pd.isna(new_value) and pd.notna(old_value):
        return old_value 
    
    # Automatically replace "strain" values
    if column_name.lower() == "strain" and old_value != new_value:
        return new_value
    if column_name.lower() == "sequencing_project_name":
        return new_value
    if column_name == "IRIDA_isolate_ID" or column_name == "IRIDA_project_ID":
        if pd.notna(new_value) and new_value != 0.0:
            return int(new_value)
        
    if old_value != new_value:
        # Check if we already made a decision for this value
        if (old_value, new_value) in decision_cache:
            response = decision_cache[(old_value, new_value)]
        else:
            response = input(f"Column: {column_name}\nOld value: {old_value}\nNew value: {new_value}\nShould we replace? (y/n): ")
            decision_cache[(old_value, new_value)] = response.lower()
        
        if response.lower() == 'y':
            return new_value
        else:
            return old_value
    else:
        return old_value

# Load the old and new Excel files
old_file_path = "WP4.2_GRDI_Harmonization-Template_v9.0.0_after_curation_v2.xlsx"  # Replace with your old file path
new_file_path = "WP4.2_GRDI_Harmonization-Template_v9.0.0_v31Oct2024_updated_curated.xlsx"  # Replace with your new file path

# Read the sheets, specifying the header row (row 2 -> header=1)
old_df = pd.read_excel(old_file_path, header=1)
new_df = pd.read_excel(new_file_path, header=1)

# Identify the columns to match on
sample_id_col = "sample_collector_sample_ID"  # Update if column name differs
isolate_id_col = "isolate_ID"  # Update if column name differs

# Initialize an empty list to collect rows for the new DataFrame
updated_rows = []
decision_cache = {}
# Iterate over the rows of the new DataFrame
for _, new_row in new_df.iterrows():
    # Find the matching row in the old DataFrame by sample_collector_sample_ID
    if pd.notna(new_row[isolate_id_col]):
        # Match by both sample_collector_sample_ID and Isolate_ID
        old_row = old_df[(old_df[sample_id_col] == new_row[sample_id_col]) & (old_df[isolate_id_col] == new_row[isolate_id_col])]
    else:
        # Match only by sample_collector_sample_ID if there's no Isolate_ID
        old_row = old_df[old_df[sample_id_col] == new_row[sample_id_col]]

    # If a matching row is found, compare the values in each column
    if not old_row.empty:
        old_row = old_row.iloc[0]  # Get the first (and only) matching row
        updated_row = old_row.copy()
        
        for column in old_row.index:
            # Skip matching sample_collector_sample_ID and Isolate_ID columns
            if column in [sample_id_col, isolate_id_col]:
                updated_row[column] = new_row[column]
            else:
                updated_row[column] = compare_values(old_row[column], new_row[column], column,decision_cache)
        
        updated_rows.append(updated_row)
    else:
        # If no matching row is found, add the new row to the updated rows
        updated_rows.append(new_row)

# Convert the updated rows back into a DataFrame
updated_df = pd.DataFrame(updated_rows)

# Save the updated DataFrame to a new Excel file
output_file = "WP4.2_GRDI_Harmonization-Template_v9.0.0_v5*Nov2024.xlsx"
updated_df.to_excel(output_file, index=False)

print(f"Updated file saved to {output_file}")
