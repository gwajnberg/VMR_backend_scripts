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
    #print (data_dict)
    #sys.exit()
    return(data_dict)

def print_inserts(insert_string,values):
        formatted_insert = insert_string
        formatted_insert = formatted_insert.replace(" RETURNING id", "")
        if values:
            for term in values:
                if term is None:
                    term_str = 'NULL'
                elif isinstance(term, str):
                    term_str = f"'{term}'"
                else:
                    term_str = str(term)
        
                formatted_insert = formatted_insert.replace('%s', term_str, 1)

        output_file = "formatted_sql_command_genes.txt"
        with open(output_file, "a") as file:  # 'a' mode opens the file for appending
            file.write(formatted_insert + ";\n")
def insert_data(data_dict,conn,cursor,mode):
    results={}
    table_ex = ""
    if (mode == "wgs"):
            table_ex= "wgs_extractions"
    elif (mode == "metagenomics"):
            table_ex = "metagenomic_extractions"
    else:
        print ("Invalid response. Please enter 'wgs' or 'metagenomics'.")
        exit()
    for row in data_dict.keys():
        
        isolate = data_dict[row]["Isolate"]
        gene =data_dict[row]["Best_Hit_ARO"]
        if "''" in data_dict[row]["Best_Hit_ARO"]:
            gene = data_dict[row]["Best_Hit_ARO"].replace("''","''''")
        elif "'" in data_dict[row]["Best_Hit_ARO"]:
            gene = data_dict[row]["Best_Hit_ARO"].replace("'","''")
        if isolate+":"+gene not in results.keys():
            results[isolate+":"+gene] =0
            insert = """
            WITH sequencing_info AS (
                SELECT s.id
                FROM sequencing s
                JOIN {} we ON s.extraction_id = we.extraction_id
                JOIN isolates i ON we.isolate_id = i.id
                WHERE i.isolate_id = %s
            )
            INSERT INTO bioinf.AMR_GENES_PROFILES (SEQUENCING_ID, CUT_OFF, BEST_HIT_ARO, MODEL_TYPE)
            SELECT id, %s, %s, %s
            FROM sequencing_info

            """.format(table_ex)
            print_inserts(insert,(isolate,data_dict[row]["Cut_Off"],gene,data_dict[row]["Model_type"],))
            #sys.exit()
            cursor.execute(insert,(isolate,data_dict[row]["Cut_Off"],gene,data_dict[row]["Model_type"],))
            conn.commit()
            #print (data_dict[row]['Drug_Class'] )
            #data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
            #print (data_dict[row]['Drug_Class'])
            #insert mobsuite results
            insert = """
            WITH genes_info AS (
                SELECT agp.id
                FROM bioinf.AMR_GENES_PROFILES agp
                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                JOIN {} we ON s.extraction_id = we.extraction_id
                JOIN isolates i ON we.isolate_id = i.id
                WHERE i.isolate_id = %s
                AND agp.BEST_HIT_ARO = %s
            )
            INSERT INTO bioinf.AMR_MOB_SUITE (AMR_GENES_ID, MOLECULE_TYPE, PRIMARY_CLUSTER_ID, SECONDARY_CLUSTER_ID)
            SELECT id,%s,%s,%s
            FROM genes_info
            """.format(table_ex)
            list_var =[]
            if (data_dict[row]["Molecule_Type"] == "chromosome"):
                list_var.extend(['chromosome',None,None])
                #insert += "'chromosome',NULL,NULL)"
                print_inserts(insert,(isolate,gene,list_var[0],list_var[1],list_var[2]))
                cursor.execute(insert,(isolate,gene,list_var[0],list_var[1],list_var[2]))
                conn.commit()
            else:
                list_var.append('plasmid')
                #insert += "'plasmid',"
                if (data_dict[row]["Primary_cluster_id"] != "-"):
                    list_var.append(data_dict[row]["Primary_cluster_id"])
                    #insert += "'"+data_dict[row]["Primary_cluster_id"]+"',"
                else:
                    insert += "NULL,"
                if (data_dict[row]["Secondary_cluster_id"] != "-"):
                    list_var.append(data_dict[row]['Secondary_cluster_id'])
                   # insert += "'"+data_dict[row]['Secondary_cluster_id']+"')"
                else:
                    list_var.append(None)
                    #insert += "NULL)"
                
                print_inserts(insert,(isolate,gene,list_var[0],list_var[1],list_var[2],))
                cursor.execute(insert,(isolate,gene,list_var[0],list_var[1],list_var[2],))
                conn.commit()
                
                if (data_dict[row]["Rep_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Rep_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert="""
                            WITH genes_info AS (
                                SELECT agp.id
                                FROM bioinf.AMR_GENES_PROFILES agp
                                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                JOIN isolates i ON we.isolate_id = i.id
                                WHERE i.isolate_id = %s
                                AND agp.BEST_HIT_ARO = %s
                            )
                            INSERT INTO bioinf.AMR_REF_TYPE (AMR_GENES_ID,REP_TYPE)
                            SELECT id,%s
                            FROM genes_info
                            """.format(table_ex)
                            
                            #insert = "INSERT INTO AMR_REF_TYPE(AMR_GENES_ID,REP_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print_inserts(insert,(isolate,gene,element,))
                            cursor.execute(insert,(isolate,gene,element,))
                            conn.commit()
                if (data_dict[row]["Relaxase_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Relaxase_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert="""
                            WITH genes_info AS (
                                SELECT agp.id
                                FROM bioinf.AMR_GENES_PROFILES agp
                                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                JOIN isolates i ON we.isolate_id = i.id
                                WHERE i.isolate_id = %s
                                AND agp.BEST_HIT_ARO = %s
                            )
                            INSERT INTO bioinf.AMR_RELAXASE_TYPE (AMR_GENES_ID,RELAXASE_TYPE)
                            SELECT id,%s
                            FROM genes_info
                            """.format(table_ex)
                            #insert = "INSERT INTO AMR_RELAXASE_TYPE(AMR_GENES_ID,RELAXASE_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print_inserts(insert,(isolate,gene,element,))
                            cursor.execute(insert,(isolate,gene,element,))
                            conn.commit()
                if (data_dict[row]["Mpf_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Mpf_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert="""
                            WITH genes_info AS (
                                SELECT agp.id
                                FROM bioinf.AMR_GENES_PROFILES agp
                                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                JOIN isolates i ON we.isolate_id = i.id
                                WHERE i.isolate_id = %s
                                AND agp.BEST_HIT_ARO = %s
                            )
                            INSERT INTO bioinf.AMR_MPF_TYPE (AMR_GENES_ID,MPF_TYPE)
                            SELECT id,%s
                            FROM genes_info
                            """.format(table_ex)
                            #insert = "INSERT INTO AMR_MPF_TYPE(AMR_GENES_ID,MPF_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print_inserts(insert,(isolate,gene,element,))
                            cursor.execute(insert,(isolate,gene,element,))
                            conn.commit()
                if (data_dict[row]["Orit_type"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Orit_type'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert="""
                            WITH genes_info AS (
                                SELECT agp.id
                                FROM bioinf.AMR_GENES_PROFILES agp
                                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                JOIN isolates i ON we.isolate_id = i.id
                                WHERE i.isolate_id = %s
                                AND agp.BEST_HIT_ARO = %s
                            )
                            INSERT INTO bioinf.AMR_ORIT_TYPES (AMR_GENES_ID,ORIT_TYPE)
                            SELECT id,%s
                            FROM genes_info
                            """.format(table_ex)
                            #insert = "INSERT INTO AMR_ORIT_TYPE(AMR_GENES_ID,ORIT_TYPE) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print_inserts(insert,(isolate,gene,element,))
                            cursor.execute(insert,(isolate,gene,element,))
                            conn.commit()
                if (data_dict[row]["Predicted_mobility"] != "-"):
                    hash_ref={}
                    for element in data_dict[row]['Predicted_mobility'].split(','):
                         
                        if element not in hash_ref.keys():
                            hash_ref[element]=0
                            insert="""
                            WITH genes_info AS (
                                SELECT agp.id
                                FROM bioinf.AMR_GENES_PROFILES agp
                                JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                JOIN isolates i ON we.isolate_id = i.id
                                WHERE i.isolate_id = %s
                                AND agp.BEST_HIT_ARO = %s
                            )
                            INSERT INTO bioinf.AMR_PREDICTED_MOBILITY (AMR_GENES_ID,PREDICTED_MOBILITY)
                            SELECT id,%s
                            FROM genes_info
                            """.format(table_ex)
                            #insert = "INSERT INTO AMR_PREDICTED_MOBILITY(AMR_GENES_ID,PREDICTED_MOBILITY) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),'"+element+"')"
                            print_inserts(insert,(isolate,gene,element,))
                            cursor.execute(insert,(isolate,gene,element,))
                            
                            conn.commit()
                
                
                    
            
            for element in data_dict[row]['Drug_Class'].split('; '):
                if "''" in element: 
                    element = element.replace("''", "''''")
                elif "'" in element: 
                    element = element.replace("'", "''")
                insert="""
                        WITH genes_info AS (
                            SELECT agp.id
                            FROM bioinf.AMR_GENES_PROFILES agp
                            JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.isolate_id = %s
                            AND agp.BEST_HIT_ARO = %s
                        )
                        INSERT INTO bioinf.AMR_GENES_DRUGS (AMR_GENES_ID,DRUG_ID)
                        SELECT id,%s
                        FROM genes_info
                        """.format(table_ex)
                #insert = "INSERT INTO AMR_GENES_DRUGS(AMR_GENES_ID,DRUG_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                print_inserts(insert,(isolate,gene,element,))
                cursor.execute(insert,(isolate,gene,element,))
                conn.commit()
                
            data_dict[row]['Drug_Class'] = data_dict[row]['Drug_Class'].split('; ')
            #print (data_dict[row]['Drug_Class'])
            for element in data_dict[row]['Resistance_Mechanism'].split('; '):
                if "''" in element: 
                    element = element.replace("''", "''''")
                elif "'" in element: 
                    element = element.replace("'", "''")
                print (element)
                insert="""
                        WITH genes_info AS (
                            SELECT agp.id
                            FROM bioinf.AMR_GENES_PROFILES agp
                            JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.isolate_id = %s
                            AND agp.BEST_HIT_ARO = %s
                        )
                        INSERT INTO bioinf.AMR_GENES_RESISTANCE_MECHANISM (AMR_GENES_ID,RESISTANCE_MECHANISM_ID)
                        SELECT id,%s
                        FROM genes_info
                        """.format(table_ex)
                #insert = "INSERT INTO AMR_GENES_RESISTANCE_MECHANISM(AMR_GENES_ID,RESISTANCE_MECHANISM_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                
                print_inserts(insert,(isolate,gene,element,))
                cursor.execute(insert,(isolate,gene,element,))
                conn.commit()
                
            for element in data_dict[row]['AMR_Gene_Family'].split('; '):
                if "'" in element:
                    element = element.replace("'", "''")
                elif "''" in element: 
                    element = element.replace("''", "''''")
                
                insert="""
                        WITH genes_info AS (
                            SELECT agp.id
                            FROM bioinf.AMR_GENES_PROFILES agp
                            JOIN sequencing s ON agp.SEQUENCING_ID = s.id
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.isolate_id = %s
                            AND agp.BEST_HIT_ARO = %s
                        )
                        INSERT INTO bioinf.AMR_GENES_FAMILIES (AMR_GENES_ID,AMR_GENE_FAMILY_ID)
                        SELECT id,%s
                        FROM genes_info
                        """.format(table_ex)
                #insert = "INSERT INTO AMR_GENES_FAMILY(AMR_GENES_ID,AMR_GENE_FAMILY_ID) VALUES ((SELECT id  from AMR_GENES_PROFILE where ISOLATE_ID = (SELECT id FROM ISOLATES WHERE ISOLATE_ID = '"+isolate+"') AND BEST_HIT_ARO = '"+gene+"'),(SELECT id from TERM_LIST where TERM = '"+element+"'))"
                print_inserts(insert,(isolate,gene,element,))
                cursor.execute(insert,(isolate,gene,element,))
                conn.commit()
                

       # sys.exit()

    return()