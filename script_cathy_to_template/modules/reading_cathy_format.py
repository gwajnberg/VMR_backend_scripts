import pandas as pd
import sys

def reading_cathy(file):

    df = pd.read_excel(file, header=None)
    # Extract headers from the first column
    headers = df.iloc[:, 0]
        
    # Extract data starting from the 5th column
    data = df.iloc[:, 4:]

    transformed_df = data.T.set_axis(headers, axis=1).T
    final_dict = {}
    
    for col in transformed_df.columns:
       #print(f"Column: {col}")
        #print(transformed_df[col])
        ref=""
        for idx in transformed_df[col].index:
            row_name = idx
            value = transformed_df[col][idx]
           # print(row_name,value)
            if (row_name == "Field_Name"):
                ref = value
                final_dict[ref]={}
            else:
                if "authors" not in row_name and "DataHarmonizer" not in row_name:
                    final_dict[ref][row_name]=value

        #print (final_dict)
        #sys.exit()
        #ys.exit()
    
    return(final_dict)