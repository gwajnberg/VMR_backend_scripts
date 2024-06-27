import psycopg2
import pandas as pd
import sys


def fill_ontology_fields(conn,cursor,xls):
    def term_insertion(table,field,term,identifier,description):
        
        #sql = "INSERT INTO "+str(table.upper())+"("+str(field.upper())+",ONTOLOGY_ID,DESCRUPTION) VALUES ('"+str(term)+"','"+str(identifier)+"','"+str(description)+"')"
        
        sql = "INSERT INTO "+str(table.upper())+"("+str(field.upper())+",ONTOLOGY_ID,DESCRIPTION) VALUES (%s,%s,%s)"
        print(sql,(term,identifier,description))
        cursor.execute(sql,(term,identifier,description))
    fields_sheet = pd.read_excel(xls,keep_default_na=False, sheet_name="Field Reference Guide", header=0,skiprows=range(1, 5))
    
    # Keep only the rows where the second column is not blank
    
    terms_sheet = pd.read_excel(xls,keep_default_na=False, sheet_name="Term Reference Guide", header=0,skiprows=range(1, 8))
    for index, row in fields_sheet.iterrows():
        if row['Field']:
            #print (row)
            #sql = "INSERT INTO ONTOLOGY_REFERENCE(NAME,BASE_ONTOLOGY_NAME,BASE_ONTOLOGY_IDENTIFIER,DEFINITION ,GUIDENCE,EXAMPLE) VALUES ('"+str(row['Field'])+"','"+str(row['Field'])+"','"+str(row['Ontology Identifier'])+"','"+str(row['Definition'])+"','"+str(row['Guidance'])+"','"+str(row['Examples'])+"')"
            sql = "INSERT INTO ONTOLOGY_REFERENCES(NAME,BASE_ONTOLOGY_NAME,BASE_ONTOLOGY_IDENTIFIER,DEFINITION ,GUIDENCE,EXAMPLE) VALUES (%s,%s,%s,%s,%s,%s)"
            print (sql,(row['Field'],row['Field'],row['Ontology Identifier'],row['Definition'],row['Guidance'],row['Examples']))
            cursor.execute(sql,(row['Field'],row['Field'],row['Ontology Identifier'],row['Definition'],row['Guidance'],row['Examples']))
            #sys.exit()
    
    institution=[]
    purpose=[]
    activity=[]
    country=[]
    for index, row in terms_sheet.iterrows():
        if row['Term']:
            if "by" in row['Field']:
                term = row['Term'].strip()
                if term not in institution and "Environment Canada" not in term:
                    institution.append(term)
                    term_insertion ("agencies","agency",term,row['Ontology Identifier'], row['Definition'])
            elif  "purpose" in row['Field']:
               
                term = row['Term'].strip()
                if term not in purpose:
                    purpose.append(term)
                    term_insertion ("purposes","purpose",term,row['Ontology Identifier'], row['Definition'])  
            elif "presampling_activity" in row['Field'] or "experimental_intervention" in row['Field']:
                term = row['Term'].strip()
                if term not in activity:
                    activity.append(term)
                    term_insertion ("activities","activity",term,row['Ontology Identifier'], row['Definition']) 
            elif "country" in row['Field']:
                term = row['Term'].strip()
                if term not in country:
                    country.append(term)
                    term_insertion ("countries","country",term,row['Ontology Identifier'], row['Definition'])
            elif "geo_loc_name (state/province/region)" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("STATE_PROVINCE_REGIONS","GEO_LOC_STATE_PROVINCE_REGION",term,row['Ontology Identifier'], row['Definition'])
            elif "geo_loc_name (site)" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("GEO_LOC_NAME_SITES","GEO_LOC_NAME_SITE",term,row['Ontology Identifier'], row['Definition'])
            elif "temperature_units" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("TEMPERATURE_UNITS","TEMPERATURE_UNIT",term,row['Ontology Identifier'], row['Definition'])
            elif "volume_measurement_unit" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("VOLUME_MEASUREMENT_UNITS","VOLUME_MEASUREMENT_UNIT",term,row['Ontology Identifier'], row['Definition'])
            elif "quality_control_issues" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("QUALITY_CONTROL_ISSUES","QUALITY_CONTROL_ISSUE",term,row['Ontology Identifier'], row['Definition'])
            elif "duration_unit" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("DURATION_UNITS","DURATION_UNIT",term,row['Ontology Identifier'], row['Definition'])
            elif "host (common name)" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("HOST_COMMON_NAMES","HOST_COMMON_NAME",term,row['Ontology Identifier'], row['Definition'])
            elif "host (scientific name)" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("HOST_SCIENTIFIC_NAMES","HOST_SCIENTIFIC_NAME",term,row['Ontology Identifier'], row['Definition'])
            elif "host (food production name)" in row['Field']:
                term = row['Term'].strip()
                term_insertion ("HOST_FOOD_PRODUCTION_NAMES","HOST_FOOD_PRODUCTION_NAME",term,row['Ontology Identifier'], row['Definition'])
            elif "antimicrobial_agent_name" in row ['Field']:
                term = row['Term'].strip()
                term_insertion ("ANTIMICROBIAL_AGENTS","ANTIMICROBIAL_AGENT",term,row['Ontology Identifier'], row['Definition'])
            elif "production_stream" in row ['Field']:
                term = row['Term'].strip()
                term_insertion ("FOOD_PRODUCT_PRODUCTION_STREAM","FOOD_PRODUCT_PRODUCTION_STREAM",term,row['Ontology Identifier'], row['Definition'])
            elif "site" in row['Field'] or "population" in row['Field'] or "material" in row['Field'] or "product" in row['Field']or "part" in row['Field'] or "region" in row['Field'] or "device" in row['Field'] or "quality_control_determination" in row['Field'] or "method" in row['Field'] or "organism" in row['Field'] or "platform" in row['Field'] or "instrument" in row['Field'] or "experimental_specimen_role_type" in row['Field']or "sequencing_assay_type" in row['Field'] or "package" in row['Field']:
                term = row['Term'].strip()
                if (row['Field'] == "food_product_properties"):
                    field = row['Field']
                    row['Field'] = "food_product_property"
                    term_insertion (field,row['Field'],term,row['Ontology Identifier'], row['Definition'])
                elif ("antimicrobial" in row['Field']):
                    field = row ['Field'].replace("antimicrobial_", "", 1)
                    field1 = field + "s"
                    term_insertion (field1,field,term,row['Ontology Identifier'], row['Definition'])
                else:
                    field = row['Field']+"s"
                    print (field,"THISONE")
                    term_insertion (field,row['Field'],term,row['Ontology Identifier'], row['Definition'])
                #sys.exit()
            elif "taxonomic_identification_process" in row ['Field']:
                term = row['Term'].strip()
                row['Field'] = row['Field'].strip()
                field = row['Field']+"es"
                print (field,"THISONE")
                term_insertion (field,row['Field'],term,row['Ontology Identifier'], row['Definition'])

            elif "antimicrobial_" in row ['Field']:
                term = row['Term'].strip()
                field = row ['Field'].replace("antimicrobial_", "", 1)
                print (term," and ", field, row['Ontology Identifier'], row['Definition'])
                
                if "phenotype" in row['Field']:
                    field = row['Field'] + "s"
                    term_insertion (field,row['Field'],term,row['Ontology Identifier'], row['Definition'])
                
                elif "vendor_name" in field:
                    #print("DAMN HERE")
                    field1 = field + "s"
                    term_insertion (field1,field,term,row['Ontology Identifier'], row['Definition'])

                else:
                    
                    term_insertion (field,field,term,row['Ontology Identifier'], row['Definition'])


            

            else:

                term = row['Term'].strip() 
                print(row['Field'], "HEREHERE")
                field = row['Field']
                if row['Field'] == "available_data_types":
                    row['Field'] = "AVAILABLE_DATA_TYPE"
                elif row['Field'] == "weather_type":
                    field = "weather_types"
                term_insertion (field,row['Field'],term,row['Ontology Identifier'], row['Definition'])
    
    conn.commit()         
           

            
             


    #sys.exit()

