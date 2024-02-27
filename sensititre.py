import pandas as pd
import psycopg2
import sys
import re



def sensititre(xls_file,conn,cursor):


    sensititre_tab = pd.read_excel(xls_file,keep_default_na=False, sheet_name="Sensititre_Raw_Data", header=0)


    antibiotics = {
        "AUG":	"amoxicillin-clavulanic_acid",
        "AMP":	"ampicillin",
        "AZT":	"azithromycin",
        "FOX":	"cefoxitin",
        "CEF":	"ceftiofur",
        "AXO":	"ceftriaxone",
        "CHL":	"chloramphenicol",
        "CIP":	"ciprofloxacin",
        "GEN":	"gentamicin",
        "KAN": 	"kanamycin",
        "NAL":	"nalidixic acid",
        "STR":	"streptomycin",
        "SSX":	"sulfisoxazole",
        "TET":	"tetracycline",
        "SXT": 	"trimethoprim-sulfamethoxazole"
    }
    signs = { 
        '<': 'less than (<)',
        '>': 'greater than (>)',
        '≤': 'less than or equal to (<=)',
        '≥': 'greater than or equal to (>=)'


    }
    pheno = {
        'S': 'Susceptible antimicrobial phenotype',
        'R': 'Resistant antimicrobial phenotype',
        'I': 'Intermediate antimicrobial phenotype'

    }


    for index, row in sensititre_tab.iterrows():
        
        check_isolate=  "SELECT id  from ISOLATES where ISOLATE_ID = '"
        insert_sample = "INSERT INTO SAMPLES(sample_collector_sample_id,sample_collection_date,sample_collection_date_precision) VALUES ("
        insert_isolate = "INSERT INTO ISOLATES(sample_collector_sample_id, isolate_id,organism) VALUES("
        insert_amr_col = "INSERT INTO AMR_ANTIBIOTICS_PROFILE(isolate_id,"
        insert_amr_val = " VALUES("
        sampleT=[]
        dict_results={}
        for column_name, cell_value in row.items():
            if column_name == "Isolate_Tracker":
                check_isolate += cell_value + "'"
                insert_sample += "'"+cell_value+"',"
                insert_isolate += "(SELECT id from SAMPLES where SAMPLE_COLLECTOR_SAMPLE_ID= '"+cell_value+"'),'"+cell_value+"','Escherichia coli'"
                insert_amr_val += "(SELECT id from ISOLATES where ISOLATE_ID= '"+cell_value+"'),"
            if column_name == "Date_Sampled":
                currentDateWithoutTime = ""
                cell_value = cell_value.strftime("%Y-%m-%d")
                insert_sample += "'"+cell_value+"','day'"
            if column_name in antibiotics.keys():
                if cell_value != "NT" and cell_value != "-":
                  #  print (antibiotics[column_name])
                  #  print (cell_value)
                    pattern = r'([<>=≤≥])?(\d+(\.\d+)?)'
                    matches = re.findall(pattern, str(cell_value))
                    if (matches[0][0]):
                        sign = matches[0][0]
                        if (sign in signs.keys()):
                            dict_results[antibiotics[column_name]] = [signs[sign],matches[0][1]]

                    else:
                        print (matches[0][1])
                        dict_results[antibiotics[column_name]] = ['equal to (==)',matches[0][1]]
            if column_name.upper() in antibiotics.keys() and cell_value in pheno.keys():
               # print ("pheno", antibiotics[column_name.upper()])
               # print (cell_value)
                if cell_value != 'NT' and cell_value != "NOMIC":
                    dict_results[antibiotics[column_name.upper()]].append(pheno[cell_value])
                    
   #     print (check_isolate)
        insert_sample += ")"
        insert_isolate += ")"

        cursor.execute(check_isolate)
        single_row = cursor.fetchone()
        
        if (single_row):
            print ('not empty')
        else:
           # cursor.execute(insert)
            
            print (insert_sample) 
            cursor.execute(insert_sample)       
            print (insert_isolate)
            cursor.execute(insert_isolate)  
            insert_amr_val_prov = insert_amr_val
            for antibiotic in dict_results.keys():
                insert_amr_col += "antimicrobial_agent,measurement_sign,measurement,resistance_phenotype)"
                insert_amr_val_prov += "'"+antibiotic+"','"+ dict_results[antibiotic][0]+"','"+ dict_results[antibiotic][1]+ "','"+ dict_results[antibiotic][2]+"')"
                insert_total = insert_amr_col + insert_amr_val_prov
                print (insert_total)
                cursor.execute(insert_total)  
                insert_amr_col = "INSERT INTO AMR_ANTIBIOTICS_PROFILE(isolate_id,"
                insert_amr_val_prov = insert_amr_val
            conn.commit()
        #if row["ColumnName"] == value_to_check:
        #   print(f"Row {index} contains the value {value_to_check}.")
        