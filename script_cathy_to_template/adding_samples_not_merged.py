import pandas as pd

# Load the Excel file
file_path = "WP4.2_GRDI_Harmonization-Template_v9.0.0_v31Oct2024.xlsm"  # Replace with your file path
sheet_merged = "Merged Sheet"
sheet_sample = "Sample Collection & Processing"

# Read the sheets, specifying the header row (row 2 -> header=1)
merged_sheet_df = pd.read_excel(file_path, sheet_name=sheet_merged, header=1)
sample_collection_df = pd.read_excel(file_path, sheet_name=sheet_sample, header=1)

# Identify the 'sample_collector_sample_ID' column in both dataframes
sample_id_col = "sample_collector_sample_ID"  # Update this if the column name is different

# Find IDs in sample_collection_df that are not in merged_sheet_df
missing_ids = sample_collection_df[~sample_collection_df[sample_id_col].isin(merged_sheet_df[sample_id_col])]

# Append the missing rows to the merged_sheet_df
updated_merged_df = pd.concat([merged_sheet_df, missing_ids], ignore_index=True)

# Save the updated merged sheet to a new Excel file
output_file = "WP4.2_GRDI_Harmonization-Template_v9.0.0_v31Oct2024_updated.csv"
updated_merged_df.to_csv(output_file, index=False)

# Generate a report of added sample IDs
report_file = "added_sample_ids.txt"
with open(report_file, "w") as report:
    report.write("Added Sample IDs:\n")
    for sample_id in missing_ids[sample_id_col]:
        report.write(f"{sample_id}\n")

print(f"Updated merged sheet saved to {output_file}")
print(f"Report of added sample IDs saved to {report_file}")
