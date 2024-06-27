import pandas as pd
import sys

def modify(file,dict_curated):
   
    df = pd.read_csv(file, header=1,low_memory=False)

    # Drop rows where all elements are NaN
    df = df.dropna(how='all')

    #print(df)

    # Iterate over the DataFrame rows
    for index, row in df.iterrows():
        sample_description = row['original_sample_description']
        if sample_description in dict_curated.keys():
            for key in dict_curated[sample_description]:
                #print (key)
                if key in row.keys():
                    if dict_curated[sample_description][key] != row[key] and (not pd.isna(dict_curated[sample_description][key])):
    #   
                        print (dict_curated[sample_description][key], "AAAAA", row[key])
                        df.at[index, key] = dict_curated[sample_description][key]
                        

            
        
    return(df)
    