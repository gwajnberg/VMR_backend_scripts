
import psycopg2
import pandas as pd
import datetime
import re
import copy
import argparse
import sys
def isNaN(string):
    return string != string

def returning_only(string,field):
    result_id = ""
    if (string != 0 and not isNaN(string) and string ):
        insert = "INSERT INTO "+field.upper()+"("+field.upper()+"_TERM,ONTOLOGY_ID) VALUES ('" + string +"',NULL) RETURNING ID" 
        print (insert)
        
        cursor.execute(insert)
        result_id = cursor.fetchone()[0]
        #print(cursor.fetchone()[0])
        #print(cursor)
        #result_id = cursor.fetchone()[0] 
        conn.commit()
        
        
    else:
        insert = "INSERT INTO "+field.upper()+"("+field.upper()+"_TERM,ONTOLOGY_ID) VALUES (NULL,NULL) RETURNING ID" 
        print (insert)
        cursor.execute(insert)
        result_id = "NULL"
        conn.commit()
    print ("here",result_id)
    return(result_id)
def returning_only2(string,field,last_ids,old_fields):
    result_id = ""
    if (string != 0 and not isNaN(string) and string ):
        columns = field.upper()+"_TERM,ONTOLOGY_ID"
        for i in old_fields:
            columns += ","+ i
        values = "'" + string+"',NULL"
        for i in last_ids:
            if i != "NULL":
                values += ",'"+str(i)+"'"
            else:
                values += ",NULL"
        insert = "INSERT INTO "+field.upper()+"("+columns+") VALUES ("+values+") RETURNING ID" 
        print (insert)
        cursor.execute(insert)
        result_id = cursor.fetchone()[0]
        conn.commit()

    else:
        columns = field.upper()+"_TERM,ONTOLOGY_ID"
        for i in old_fields:
            columns += ","+ i
        values = "NULL,NULL"
        for i in last_ids:
            if i != "NULL":
                values += ",'"+str(i)+"'"
            else:
                values += ",NULL"
        insert = "INSERT INTO "+field.upper()+"("+columns+") VALUES ("+values+") RETURNING ID" 
        print (insert)
        cursor.execute(insert)
        conn.commit()
        result_id = "NULL"
    return(result_id)
def returning_only3(table,old_fields,last_ids):
    columns = ""
    for i in old_fields:
        
        columns += i
        if i != old_fields[-1]:
            columns += ","
    values = "" 
    values = ",".join("'" + str(i) + "'" if i != "NULL" else "NULL" for i in last_ids)
    #for i in last_ids:
        
    #    if i != "NULL":
    #        values += "'"+str(i)+"'"
    #    else:
    #        values +="NULL"
    #    if i != last_ids[-1]:
    #        values += ","
    insert = "INSERT INTO "+table.upper()+"("+columns+") VALUES ("+values+") RETURNING ID"
    print (insert)
    cursor.execute(insert)
    result_id = cursor.fetchone()[0]
    conn.commit()
    return(result_id) 
conn = psycopg2.connect(
       database="metabaseappdb", user='gabriel', password='gaba1984', host='10.139.14.109', port= '5433'
    )
cursor = conn.cursor()

xls_file = "Baseline_Survey_Harmonized_Version_2022-04-22.xlsx"

fields = pd.read_excel(xls_file,sheet_name="Sample Collection & Processing",na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)

#print(fields)
for index, row in fields.iterrows():
    #for i in row.index:
    field ="alternative_sample_ID"
    last_id_alternative_sample_id = returning_only(row[field],field)
    field ="sample_collector_sample_ID"
    columns_extra = ["alternative_sample_ID"]
    ids_extra = [last_id_alternative_sample_id]
    last_id_sample_collector_samplee_id = returning_only2(row[field],field,ids_extra,columns_extra)
    
    field ="sample_collected_by_laboratory_name"
    value =row["collected_by_laboratory_name"]
    last_id_laboratory_name = returning_only(value,field)
    
    value=row["sample_collector_contact_email"]
    
    field = "sample_collector_contact_email"
    last_id_contact_email = returning_only(value,field)
    
    field = "sample_collector_contact_name"
    value = row["sample_collector_contact_name"]
    columns_extra = ["sample_collector_contact_email"]
    ids_extra = [last_id_contact_email]
    last_id_contact_name = returning_only2(value,field,ids_extra,columns_extra)


    field ="sample_collected_by"
    value = row["sample_collected_by"]
    columns_extra = ["sample_collector_contact_name","sample_collected_by_laboratory_name"]
    ids_extra = [last_id_contact_name,last_id_laboratory_name]
    last_id_sampled_by = returning_only2(value,field,ids_extra,columns_extra)

    
    field = "purpose_of_sampling"
    value = row["purpose_of_sampling"]
    last_id_purpose_sampling = returning_only(value,field)

    field = "presampling_activity_details"
    value = row["experimental_activity_details"]
    last_id_presampling_activity_details = returning_only(value,field)

    field = "presampling_activity"
    value = row["experimental_activity"]
    columns_extra = ["presampling_activity_details"]
    ids_extra = [last_id_presampling_activity_details]
    last_id_presampling_activity = returning_only2(value,field,ids_extra,columns_extra)

    field= "sample_collection_date_precision"
    value = "day"
    last_id_sample_collection_date_precision = returning_only(value,field)

    field ="sample_collection_date"
    value = row["sample_collection_date"]
    columns_extra = ["sample_collection_date_precision"]
    ids_extra =[last_id_sample_collection_date_precision]
    last_id_sample_collection_date=returning_only2(str(value),field,ids_extra,columns_extra)
    
    field="sample_collection_project_name"
    value = row["sample_collection_project_name "]
    last_id_sample_collection_project_name = returning_only(value,field)

    field ="sample_received_date"
    value = row["sample_received_date"]
    last_id_sample_received_date = returning_only(str(value),field)

    field ="original_Sample_description"
    value = row["original_sample_description"]
    last_id_sample_original_sample_description = returning_only(value,field)

    field = "specimen_processing"
    value = row["sample_processing"]
    last_id_specimen_processing = returning_only(value,field)

    table ="sample_terms"
    columns_extra = ["sample_collector_sample_id", "sample_collected_by", "sample_collection_project_name","presampling_activity","sample_collection_date", "sample_received_date","purpose_of_sampling","original_sample_description","specimen_processing"]
    ids_extra = [last_id_sample_collector_samplee_id,last_id_sampled_by,last_id_sample_collection_project_name, last_id_presampling_activity, last_id_sample_collection_date, last_id_sample_received_date, last_id_purpose_sampling, last_id_sample_original_sample_description,  last_id_specimen_processing  ]
    print(columns_extra)
    print(ids_extra)
    last_id_sample_terms = returning_only3(table,columns_extra,ids_extra)

    field ="geo_loc_name_country"
    value = row["geo_loc (country)"]
    last_id_geo_loc_name_country = returning_only(value,field)

    field= "geo_loc_name_state_province_region"
    value = row["geo_loc (state/province/region)"]
    last_id_geo_loc_name_state_province_region = returning_only(value,field)
    field="geo_loc_name_site"
    #print(row.keys())
    value = row["\nfood_product_origin geo_loc (country)\n"]
    last_id_geo_loc_name_site = returning_only(value,field)
    field = "geo_loc_name_host_origin_geo_loc_name_country"
    value = row["host_origin geo_loc (country)"]
    last_id_geo_loc_name_host_origin_geo_loc_name_country = returning_only(value,field)

    field ="geo_loc_latitude"
    value = row ["latitude_of_sample_collection"]
    last_id_geo_loc_latitude = returning_only(value,field)
    field ="geo_loc_longitude"
    value = row ["longitude_of_sample_collection"]
    last_id_geo_loc_longitude = returning_only(value,field)

    table = "geo_loc"
    columns_extra = ["geo_loc_name_country","geo_loc_name_state_province_region", "geo_loc_name_site", "geo_loc_name_host_origin_geo_loc_name_country", "geo_loc_latitude", "geo_loc_longitude"]
    
    ids_extra =[last_id_geo_loc_name_country, last_id_geo_loc_name_state_province_region, last_id_geo_loc_name_site, last_id_geo_loc_name_host_origin_geo_loc_name_country, last_id_geo_loc_latitude, last_id_geo_loc_longitude  ]
    last_id_geo_loc = returning_only3(table,columns_extra,ids_extra)
    
    field = "animal_or_plant_population"
    value = row ["animal_or_plant_population"]
    last_id_animal_or_plant_population = returning_only(value,field)
    field = "environmental_material"
    value= row ["environmental_material"]
    last_id_environmental_material = returning_only(value,field)
    field = "environmental_site"
    value= row ["environmental_site"]
    last_id_environmental_site = returning_only(value,field)
    field = "anatomical_material"
    value= row ["anatomical_material"]
    last_id_anatomical_material = returning_only(value,field)
    field = "body_product"
    value= row ["body_product"]
    last_id_body_product = returning_only(value,field)
    field = "anatomical_part"
    value= row ["anatomical_part"]
    last_id_anatomical_part = returning_only(value,field)
    
    table ="anatomical_data"
    columns_extra = ["anatomical_material","body_product","anatomical_part","anatomical_region"]
    ids_extra = [ last_id_anatomical_material,last_id_body_product, last_id_anatomical_part, "NULL"]
    last_id_anatomical_data = returning_only3(table,columns_extra,ids_extra)

    field = "food_product_properties"
    value= row ["food_product_properties"]
    last_id_food_product_properties = returning_only(value,field)
    field = "food_product"
    value= row ["food_product"]
    columns_extra = ["food_product_properties"]
    ids_extra = [last_id_food_product_properties]
    last_id_food_product = returning_only2(value,field,ids_extra,columns_extra)
    field = "food_packaging"
    value= row ["food_packaging"]
    last_id_food_packaging = returning_only(value,field)
    field = "animal_source_of_food"
    value= row ["animal_source_of_food"]
    last_id_animal_source_of_food = returning_only(value,field)
   

    table ="food_data"
    columns_extra = ["food_product","food_packaging","animal_source_of_food","food_product_production_method","food_packaging_date","food_quality_date"]
    ids_extra = [ last_id_food_product,last_id_food_packaging, last_id_animal_source_of_food, "NULL","NULL","NULL"]
    last_id_food_data = returning_only3(table,columns_extra,ids_extra)
    table ="environmental_data"
    columns_extra = ["environmental_material","environmental_site","weather_type","water_data","air_temperature","available_data_types","animal_or_plant_population"]
    ids_extra = [ last_id_environmental_material,last_id_environmental_site, "NULL","NULL","NULL","NULL",last_id_animal_or_plant_population ]
    last_id_environment_data = returning_only3(table,columns_extra,ids_extra)
    field = "collection_device"
    value= row ["collection_device"]
    last_id_collection_device = returning_only(value,field)
    field = "collection_method"
    value= row ["collection_method"]
    last_id_collection_method = returning_only(value,field)

    table ="collection"
    columns_extra = ["sample_storage_method","sample_storage_medium","collection_device","collection_method"]
    ids_extra=["NULL","NULL",last_id_collection_device,last_id_collection_method]
    last_id_collection = returning_only3(table,columns_extra,ids_extra)

    table= "sample_collection_and_processing"
    columns_extra = ["sample_terms","geo_loc","environmental_data","anatomical_data","food_data","collection"]
    ids_extra = [last_id_sample_terms,last_id_geo_loc,last_id_environment_data,last_id_anatomical_data,last_id_food_data,last_id_collection]
    last_id_sample_collection_and_processing = returning_only3(table,columns_extra,ids_extra)

    #sys.exit()
