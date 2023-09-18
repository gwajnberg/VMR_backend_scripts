import psycopg2
import pandas as pd
import sys



def parse(xls_file):
    df = pd.read_csv(xls_file)
    data_dict = {}

# Iterate over DataFrame rows using iterrows()
    
    for index, row in df.iterrows():
    # Create a dictionary for each row
        #print(row)
        
        row_dict = {"Isolate": row["Sample"], 
                    "Cut_Off": row["Cut_Off"],
                    "Best_Hit_ARO": row["Best_Hit_ARO"],
                    "Model_type": row["Model_type"],
                    "Drug_Class":row ["Drug Class"],
                    "Resistance_Mechanism": row["Resistance Mechanism"],
                    "AMR_Gene_Family": row["AMR Gene Family"],
                    "Molecule_Type": row["molecule_type"]}
        
                    
        #print (row_dict)
        #sys.exit()
    
    # Add the row dictionary to the main dictionary using the row number as the key
        data_dict[index] = row_dict
    return(data_dict)

def insert_data(data_dict,conn,cursor):
    for row in data_dict.keys():
        isolate = data_dict[row]["Isolate"]
        
        insert = "INSERT INTO AMR_GENES_PROFILE(ISOLATE_ID,CUT_OFF,BEST_HIT_ARO,MODEL_TYPE,MOLECULE_TYPE) VALUES ((SELECT id  from ISOLATES where ISOLATE_ID = '"+isolate+"'),'"+data_dict[row]["Cut_Off"] +"','"+data_dict[row]["Best_Hit_ARO"]+"','"+data_dict[row]["Model_type"]+"','"+data_dict[row]["Molecule_Type"]+"')"
        print(insert)
        cursor.execute(insert)
        conn.commit()
        #print (data_dict[row]['Drug_Class'] )
        #data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
        #print (data_dict[row]['Drug_Class'])
        for element in data_dict[row]['Drug_Class'].split('; '):
             insert = "INSERT INTO AMR_GENES_DRUGS(AMR_GENES_ID,DRUG_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where EXISTS (SELECT 1 from ISOLATES where ISOLATE_ID = '"+isolate+"' AND BEST_HIT_ARO = '"+data_dict[row]["Best_Hit_ARO"]+"')),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
             print(insert)
             cursor.execute(insert)
             conn.commit()
             
        data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
        #print (data_dict[row]['Drug_Class'])
        for element in data_dict[row]['Resistance_Mechanism'].split('; '):
             insert = "INSERT INTO AMR_GENES_RESISTANCE_MECHANISM(AMR_GENES_ID,RESISTANCE_MECHANISM_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where EXISTS (SELECT 1 from ISOLATES where ISOLATE_ID = '"+isolate+"' AND BEST_HIT_ARO = '"+data_dict[row]["Best_Hit_ARO"]+"')),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
             print(insert)
             cursor.execute(insert)
             conn.commit()
             
        for element in data_dict[row]['AMR_Gene_Family'].split('; '):
             insert = "INSERT INTO AMR_GENES_FAMILY(AMR_GENES_ID,AMR_GENE_FAMILY_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where EXISTS (SELECT 1 from ISOLATES where ISOLATE_ID = '"+isolate+"' AND BEST_HIT_ARO = '"+data_dict[row]["Best_Hit_ARO"]+"')),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
             print(insert)
             print(insert)
             cursor.execute(insert)
             conn.commit()
             

       # sys.exit()

    return()