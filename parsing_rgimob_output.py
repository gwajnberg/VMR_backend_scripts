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
        #sys.exit()
        
        row_dict = {"Isolate": row["Sample"], 
                    "Cut_Off": row["Cut_Off"],
                    "Best_Hit_ARO": row["Best_Hit_ARO"],
                    "Model_type": row["Model_type"],
                    "Drug_Class":row ["Drug Class"],
                    "Resistance_Mechanism": row["Resistance Mechanism"],
                    "AMR_Gene_Family": row["AMR Gene Family"],
                    "Molecule_Type": row["molecule_type"],
                    "Primary_cluster_id": row["primary_cluster_id"],
                    "Secondary_cluster_id": row["primary_cluster_id"],
                    "Rep_type": row ["rep_type(s)"],
                    "Relaxase_type": row["relaxase_type(s)"],
                    "Mpf_type": row["mpf_type"],
                    "Orit_type": row["orit_type(s)"],
                    "Predicted_mobility": row["predicted_mobility"]} 

        
                    
        #print (row_dict)
        #sys.exit()
    
    # Add the row dictionary to the main dictionary using the row number as the key
        data_dict[index] = row_dict
    return(data_dict)

def insert_data(data_dict,conn,cursor):
    results={}
    for row in data_dict.keys():
        
        isolate = data_dict[row]["Isolate"]
        gene =data_dict[row]["Best_Hit_ARO"]
        if "''" in data_dict[row]["Best_Hit_ARO"]:
            gene = data_dict[row]["Best_Hit_ARO"].replace("''","''''")
        elif "'" in data_dict[row]["Best_Hit_ARO"]:
            gene = data_dict[row]["Best_Hit_ARO"].replace("'","''")
        if isolate+":"+gene not in results.keys():
            results[isolate+":"+gene] =0
            insert = "INSERT INTO AMR_GENES_PROFILE(ISOLATE_ID,CUT_OFF,BEST_HIT_ARO,MODEL_TYPE) VALUES ((SELECT id  from ISOLATES where ISOLATE_ID = '"+isolate+"'),'"+data_dict[row]["Cut_Off"] +"','"+gene+"','"+data_dict[row]["Model_type"]+"')"
            print(insert)
            cursor.execute(insert)
            conn.commit()
            #print (data_dict[row]['Drug_Class'] )
            #data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
            #print (data_dict[row]['Drug_Class'])
            #insert mobsuite results
            insert = "INSERT INTO AMR_MOB_SUITE (AMR_GENES_ID, MOLECULE_TYPE, PRIMARY_CLUSTER_ID, SECONDARY_CLUSTER_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),"
            if (data_dict[row]["Molecule_Type"] == "chromosome"):
                insert += "'chromosome',NULL,NULL)"
                print(insert)
                cursor.execute(insert)
                conn.commit()
            else:
                insert += "'plasmid',"
                if (data_dict[row]["Primary_cluster_id"] != "-"):
                    insert += "'"+data_dict[row]["Primary_cluster_id"]+"',"
                else:
                    insert += "NULL,"
                if (data_dict[row]["Secondary_cluster_id"] != "-"):
                    insert += "'"+data_dict[row]['Secondary_cluster_id']+"')"
                else:
                    insert += "NULL)"
                
                print(insert)
                cursor.execute(insert)
                conn.commit()
                
                if (data_dict[row]["Rep_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Rep_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert = "INSERT INTO AMR_REF_TYPE(AMR_GENES_ID,REP_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print(insert)
                            cursor.execute(insert)
                            conn.commit()
                if (data_dict[row]["Relaxase_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Relaxase_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert = "INSERT INTO AMR_RELAXASE_TYPE(AMR_GENES_ID,RELAXASE_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print(insert)
                            cursor.execute(insert)
                            conn.commit()
                if (data_dict[row]["Mpf_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Mpf_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert = "INSERT INTO AMR_MPF_TYPE(AMR_GENES_ID,MPF_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print(insert)
                            cursor.execute(insert)
                            conn.commit()
                if (data_dict[row]["Orit_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Orit_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert = "INSERT INTO AMR_ORIT_TYPE(AMR_GENES_ID,ORIT_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print(insert)
                            cursor.execute(insert)
                            conn.commit()
                if (data_dict[row]["Predicted_mobility"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Predicted_mobility'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert = "INSERT INTO AMR_PREDICTED_MOBILITY(AMR_GENES_ID,PREDICTED_MOBILITY) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print(insert)
                            cursor.execute(insert)
                            conn.commit()
                
                
                    
            
            for element in data_dict[row]['Drug_Class'].split('; '):
                if "''" in element: 
                    element = element.replace("''", "''''")
                elif "'" in element: 
                    element = element.replace("'", "''")
                insert = "INSERT INTO AMR_GENES_DRUGS(AMR_GENES_ID,DRUG_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                print(insert)
                cursor.execute(insert)
                conn.commit()
                
            data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
            #print (data_dict[row]['Drug_Class'])
            for element in data_dict[row]['Resistance_Mechanism'].split('; '):
                if "''" in element: 
                    element = element.replace("''", "''''")
                elif "'" in element: 
                    element = element.replace("'", "''")
                print (element)
                insert = "INSERT INTO AMR_GENES_RESISTANCE_MECHANISM(AMR_GENES_ID,RESISTANCE_MECHANISM_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                
                print(insert)
                cursor.execute(insert)
                conn.commit()
                
            for element in data_dict[row]['AMR_Gene_Family'].split('; '):
                if "'" in element:
                    element = element.replace("'", "''")
                elif "''" in element: 
                    element = element.replace("''", "''''")
                
                insert = "INSERT INTO AMR_GENES_FAMILY(AMR_GENES_ID,AMR_GENE_FAMILY_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                print(insert)
                print(insert)
                cursor.execute(insert)
                conn.commit()
                

       # sys.exit()

    return()