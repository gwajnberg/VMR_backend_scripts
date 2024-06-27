import pandas as pd
import sys

def modification(file,data):
   
    df = pd.read_excel(file, header=1)
    
    for index, row in df.iterrows():
        if data['antibiogram']:
            id_anti = row['sample_collector_sample_ID'] +"-"+ row['isolate_ID']
            if id_anti in data['antibiogram'].keys():
                
                for antibiotic in  data['antibiogram'][id_anti]:
                    for key in antibiotic.keys():
                        
                        if key in row.keys():
                            if antibiotic[key] != row[key] and (not pd.isna(antibiotic[key])):
        #   
                                #print (antibiotic[key], "AAAAA", row[key])
                                df.at[index, key] = antibiotic[key]
                        else: 
                            print (key, 'not in the template')
                    
        if data['sequencing']:
            id_sequencing = row['strain']
            if id_sequencing in data['sequencing'].keys():
                for key in data['sequencing'][id_sequencing][0].keys():
                    print (key)
                    if key in row.keys():
                       
                        if data['sequencing'][id_sequencing][0][key] != row[key] and (not pd.isna(data['sequencing'][id_sequencing][0][key])):
        #   
                            print (data['sequencing'][id_sequencing][0][key] , "AAAAA", row[key])
                            df.at[index, key] = data['sequencing'][id_sequencing][0][key]
                            
                        else:
                            print (row[key],'equal to ', data['sequencing'][id_sequencing][0][key])
                    else: 
                        print (key, 'not in the template')
                #sys.exit()
            #print(df[df['strain'] == id_sequencing])
                    

              
    return(df)
                