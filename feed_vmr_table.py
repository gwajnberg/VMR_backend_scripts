import sys
import datetime
import re
from psycopg2 import sql



def feed_vmr_table (dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,conn,cursor,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list,mode):
    def fix(fields):
        fields = fields.replace("\n", "")
        fields = fields.replace(" ", "_")
        fields = fields.replace("/", "_")
        fields = fields.replace("-", "_")
        fields = fields.replace("(", "")
        fields = fields.replace(")", "")
        return(fields)
    def getTermAndId (variable):
        
        term=""
        if ("//" in str(variable)):
            listF = re.split("//",variable)
            #print(listF.groups()[1])
            
            
            print(listF[0])
            term = listF[0]
        else:
            term= variable
        return (term)
    def getTermAndId2 (variable):
        
        term=""
        id=""
        if ("//" in str(variable)):
            listF = re.split("//",variable)
            #print(listF.groups()[1])
            
            
            print(listF[0])
            term = listF[0]
            id=listF[1]
        else:
            term= variable
            id=None

        return (term,id)
    def columnIns (column_ins,fields,count,length): 
       # print ('before',column_ins)
        column_ins += fields.upper()
       # print ('after',column_ins)
        if (count +1 != length):
            column_ins += ","
        
        return(column_ins)
    def valuesIns (term): 
       # print ('before',values)
        #print ('before',term)
        if (term == None):
            value = None
        else:
            value = str(term)
      #  print ('after',values)
       # if (count +1 != length):
        #    values += ","
        
        return(value)
    def check_exists_id(term,field,table):
        result=""
        if (isinstance(term, list)):
            print ("here before LIST",term)

            term1 = term[0]
            
            
            term2 = getTermAndId(term[1])
            print ("here ",term1,term2)
            sql_query = """
                     SELECT *
                     FROM """ + table + """ 
                     WHERE """+field[0]+""" = %s
                    AND """+field[1]+""" = (SELECT id from """+field[2]+""" where """+field[3].upper()+""" = %s);
                    """
            print (sql_query,(term1,term2))
            cursor.execute(sql_query, (term1, term2))
            result = cursor.fetchall()
            print(result,"come on")
            if (result):
                result = "yes"
            else:
                result = ""

        else:
            print ("here WRONGbefore")

            term = getTermAndId(term)
            command=""
            if (table == "metagenomics" or table == "wholegenomesequencing"):
                command = "SELECT sequencing_id from "+table+" where "+field.upper()+" = %s"    
            else:
                command = "SELECT id from "+table+" where "+field.upper()+" = %s"
            print (command,term)
            cursor.execute(command,(term,))
            result = cursor.fetchone()
            print(result,"here")
            conn.commit()
        
        return(result)
    def check_exists_id2(term,field,table):
        result=""
        if (isinstance(term, list)):
         #   print ("here before",term)

            term1 = term[0]
            
            
            term2 = term[1]
            print ("here ",term1,term2)
            sql_query = """
                     SELECT *
                     FROM """ + table + """ 
                     WHERE """+field[0]+""" = %s
                    AND """+field[1]+""" = %s;
                    """
            print (sql_query,(term2,term1))
            cursor.execute(sql_query, (term2, term1))
            result = cursor.fetchall()
           # print(result,"come on")
            if (result):
                result = "yes"
            else:
                result = ""
        return(result)
    def check_controlled_term(term,id,table,field):
        print (term,table,field,id)
        sql_query = """
        SELECT id
        FROM {}
        WHERE {} = %s
    """.format(table, field.upper())

        print(sql_query, (term))  # Print the query and parameters for debugging
        cursor.execute(sql_query, (term,))
        result = cursor.fetchone()
        #print (result[0],id)
        if not result:
            print ("Here not result")
            sql = "INSERT INTO "+str(table.upper())+"("+str(field.upper())+",ONTOLOGY_ID,DESCRIPTION) VALUES (%s,%s,%s)"
            description = "Term still not in the vocabulary, added temporary untill solving the problem"
            print(sql,(term,id,description))
            cursor.execute(sql,(term,id,description))
            conn.commit()
        else:
            print (result)
        


    def create_insert (row,fields,controlled_fields,table_name,length):
        print (fields,controlled_fields)
        #AMR_aid =create_insert(dict_of_samples['AMR'][index],AMR_afields,AMR_acontrolled,"amr_antibiotics_profile",len(AMR_afields))
        column_ins = "("
        count=0
        values ="("
        list_terms = []
        for field in fields.keys():
            
            if field in row.keys():
                #print (field)
                
                terms,id = getTermAndId2(row[field])
                print('here passed',terms,id)
              
                #field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)
                print (field, controlled_fields, 'COMPARACAO')
                if controlled_fields:
                    if field in controlled_fields.keys():
                        print (field,'controlled')
                        
                        list_terms.append(terms)
                        check_controlled_term(terms,id,controlled_fields[field][0],controlled_fields[field][1])
                        values += "(SELECT id from "+controlled_fields[field][0]+" where "+controlled_fields[field][1].upper()+" = %s)"
                        if (count +1 != length):
                            values += ","
                    else:
                        print (field,'not controlled')
                        
                        list_terms.append(valuesIns(terms))
                        values += "%s"
                        if (count +1 != length):
                            values += ","
                else:
                    
                    list_terms.append(valuesIns(terms))
                    values += "%s"
                    if (count +1 != length):
                        values += ","
                
            else:
                
               # print('before2',fields)
               # field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)
                
                list_terms.append(valuesIns(None))
                values += "%s"
                if (count +1 != length):
                    values += ","
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        print (values)
        last_created_id = ""
        tables_multi = ["sample_purpose","sample_activity","food_data_product","food_data_product_property","food_data_source", "food_data_packaging","anatomical_data_body","anatomical_data_part","anatomical_data_material","environment_data_material","environment_data_site","environment_Data_weather_type","environment_data_available_data_type","environment_data_animal_plant","risk_activity","sequencing_purpose","wholegenomesequencing","metagenomics"]
        if table_name in tables_multi:
            print (table_name,"here multi")
            insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values
            print (insert,list_terms)
            
            cursor.execute(insert, list_terms)
            conn.commit()
            print('inserted with success')
        else:
            insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values+" RETURNING id"
            print (insert,list_terms)
            
            cursor.execute(insert, list_terms)
            #print(cursor)
            last_created_id = cursor.fetchone()
            conn.commit()
            print('inserted with success')
        return(last_created_id)
    
    def multi (row,sfield,parent_field,parent_id,tfield,table_field,table_multi):
       if sfield in row.keys():
            terms = row[sfield]
           # print (spurposes)
            
            for term in terms:
              id = check_exists_id([parent_id,term],[parent_field,tfield,table_field,tfield],table_multi)
              if id  != "yes":
                print ("doesnt exists")
                create_insert({parent_field:parent_id,tfield:term},{parent_field:parent_field,tfield:tfield},{tfield:[table_field,tfield]},table_multi,2)
                #print ('DONE???HERE')
              else:
                print (parent_field,"exists and ",term," exists.")

    #print(dict_of_samples['sample'][index].keys())
    host_country={}
    #print ("size is ",len(dict_of_samples['sample']))
    #sys.exit()
    for index in dict_of_samples['sample']:
        print(dict_of_samples['sample'][index].keys())
        #print(dict_of_samples['sample'][index])
        #sys.exit()



        if "sample_plan_name" in dict_of_samples['sample'][index].keys() or "sample_plan_ID" in dict_of_samples['sample'][index].keys():
            sample_plan_table_id =""
            #sample_plan_fields = {};
            
            if "sample_plan_name" in dict_of_samples['sample'][index].keys():

                sample_plan_table_id = check_exists_id(dict_of_samples['sample'][index]["sample_plan_name"],"sample_plan_name",'sample_plan')
                #sample_plan_fields['sample_plan_name'] = dict_of_samples['sample'][index]["sample_plan_name"]
            else:
                sample_plan_table_id = check_exists_id(dict_of_samples['sample'][index]["sample_plan_ID"],"sample_plan_ID",'sample_plan')
               # sample_plan_fields['sample_plan_ID'] = dict_of_samples['sample'][index]["sample_plan_ID"]
            if not sample_plan_table_id:
               print("doesnt exist")
               sample_plan_table_id =create_insert(dict_of_samples['sample'][index],{'sample_plan_name':'sample_plan_name','sample_plan_ID':'sample_plan_id'},"","sample_plan",2)

            dict_of_samples['sample'][index]['sample_plan_table_id'] = sample_plan_table_id[0]
            
        
        dict_sample_table = dict_of_samples['sample'][index]
        sample_table_fields = {"sample_collector_sample_id":dict_of_samples['sample'][index]["sample_collector_sample_ID"]}
                
        if dict_of_samples['sample'][index]["sample_collector_sample_ID"] in sample_flagged_list:
            sample_table_fields["validation_status"]= "flagged"
        else:
            sample_table_fields["validation_status"]= "curated"
        if 'sample_plan_table_id' in dict_of_samples['sample'][index].keys():
            sample_table_fields["sample_plan_table_id"]=dict_of_samples['sample'][index]["sample_plan_table_id"]
        #sample_table_fields[keys]=keys
        print ("here")
        sample_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
        if not sample_id:
            print ("doesnt exists")
            print (dict_sample_table)
            print (sample_table_fields)
            sample_id =create_insert(sample_table_fields,{"sample_collector_sample_id":"sample_collector_sample_id","validation_status":"validation_status","sample_plan_table_id":"sample_plan"},"","samples",3) 
        
        sample_id = sample_id[0]
        dict_of_samples['sample'][index]["sample_id"] = sample_id
        #print ( 'inicio',sample_id,dict_of_samples['sample'][index]["sample_id"])
        #sys.exit()
       # sample_table_id =create_insert(dict_of_samples['sample'][index],{"sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},"","contact_information",3)
        print ("here samples")
        #sys.exit()
        #alt_id =""
        if ("alternative_sample_ID") in dict_of_samples['sample'][index].keys():
            dict_of_samples['sample'][index]["alternative_sample_ID"] = str(dict_of_samples['sample'][index]["alternative_sample_ID"])
            list_alt_ids =[]
            if ("|" in dict_of_samples['sample'][index]["alternative_sample_ID"]):
                list_alt = re.split("|",dict_of_samples['sample'][index]["alternative_sample_ID"])
                    
                for alt in list_alt:
                    alt_id = check_exists_id(alt,"alternative_sample_id","alternative_sample_ids")
                    if not alt_id:
                        alt_id =create_insert({"alternative_sample_id":alt,"sample_id":sample_id},{"alternative_sample_id":"alternative_sample_id","sample_id":"sample_id"},"","alternative_sample_ids",2) 
                    list_alt_ids.append(alt_id)
            elif (";" in dict_of_samples['sample'][index]["alternative_sample_ID"]):
                list_alt = re.split(";",dict_of_samples['sample'][index]["alternative_sample_ID"])
                for alt in list_alt:
                    alt_id = check_exists_id(alt,"alternative_sample_id","alternative_sample_ids")
                    if not alt_id:
                        alt_id =create_insert({"alternative_sample_id":alt,"sample_id":sample_id},{"alternative_sample_id":"alternative_sample_id","sample_id":"sample_id"},"","alternative_sample_ids",2) 
                    list_alt_ids.append(alt_id)
                        
            elif ("," in dict_of_samples['sample'][index]["alternative_sample_ID"]):
                list_alt = re.split(",",dict_of_samples['sample'][index]["alternative_sample_ID"])
                for alt in list_alt:
                    alt_id = check_exists_id(alt,"alternative_sample_id","alternative_sample_ids")
                    if not alt_id:
                        alt_id =create_insert({"alternative_sample_id":alt,"sample_id":sample_id},{"alternative_sample_id":"alternative_sample_id","sample_id":"sample_id"},"","alternative_sample_ids",2) 
                    list_alt_ids.append(alt_id)
            else:
                alt = dict_of_samples['sample'][index]["alternative_sample_ID"]    
                alt_id = check_exists_id(alt,"alternative_sample_id","alternative_sample_ids")
                if not alt_id:
                    alt_id =create_insert({"alternative_sample_id":alt,"sample_id":sample_id},{"alternative_sample_id":"alternative_sample_id","sample_id":"sample_id"},"","alternative_sample_ids",2) 
                list_alt_ids.append(alt_id)         
        else:
            sample_table_fields["alternative_sample_id"]=None
        
        contact_info_id=""
        if "sample_collector_contact_name" in dict_of_samples['sample'][index].keys(): 
            contact_info_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_contact_name"],"contact_name","contact_information")
            print ("done checking")
            if not contact_info_id:
                print ("doesnt exists")
                contact_info_id =create_insert(dict_of_samples['sample'][index],{"sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},"","contact_information",3)
                #contact_info_id = contact_info_id[0]
            else:
                print (contact_info_id,"exists")
                
            contact_info_id = contact_info_id[0]
        print ("done alternative_ids")    
           
        if contact_info_id:
            dict_of_samples['sample'][index]["contact_information"] = contact_info_id
        else:
            dict_of_samples['sample'][index]["contact_information"] = None
        #    print (contact_info_id, " contact info")
        print ("testing", sample_id,dict_of_samples['sample'][index]["sample_id"],dict_of_samples['sample'][index]["contact_information"] ) 
        collection_fields = {"sample_id":"sample_id","sample_collected_by":"sample_collected_by","contact_information":"contact_information","sample_collection_project_name":"sample_collection_project_name",
 "sample_collection_date":"sample_collection_date","sample_collection_date_precision":"sample_collection_date_precision",  "presampling_activity_details":"presampling_activity_details",
 "sample_received_date":"sample_received_date","original_sample_description":"original_sample_description","specimen_processing":"specimen_processing","sample_storage_method":"sample_storage_method","sample_storage_medium":"sample_storage_medium",
 "collection_device":"collection_device","collection_method":"collection_method"}
        
        collection_controlled = {"sample_collected_by":["agencies","agency"],"sample_collection_date_precision":["sample_collection_date_precision","sample_collection_date_precision"],"specimen_processing":["specimen_processing","specimen_processing"],"collection_device":["collection_devices","collection_device"],"collection_method":["collection_methods","collection_method"]}
        collection_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","collection_information")
        if not collection_id:
            print ("doesnt exists")
            collection_id =create_insert(dict_of_samples['sample'][index],collection_fields,collection_controlled,"collection_information",len(collection_fields))
        else:
            print (collection_id,"exists")
        
        print (collection_id[0],"ready")
        collection_id = collection_id[0]
        dict_of_samples['sample'][index]["collection_information"] = collection_id

        extraction_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","extraction_information")
        extraction_fields = {
            "sample_id":"sample_id", 
            'experimental_protocol_field':'experimental_protocol_field',
            'experimental_specimen_role_type':'experimental_specimen_role_type',
            "nucleic_acid_extraction_method":"nucleic_acid_extraction_method",
            "nucleic_acid_extraction_kit":"nucleic_acid_extraction_kit",
            "sample_volume_measurement_value":"sample_volume_measurement_value",
            "sample_volume_measurement_unit":"sample_volume_measurement_unit",
            "residual_sample_status":"residual_sample_status",
            "sample_storage_duration_value":"sample_storage_duration_value",
            "sample_storage_duration_unit":"sample_storage_duration_unit",
            "nucleic_acid_storage_duration_value":"nucleic_acid_storage_duration_value",
            "nucleic_acid_storage_duration_unit":"nucleic_acid_storage_duration_unit"
            }
        extraction_controlled_fields = {
            'experimental_specimen_role_type':['experimental_specimen_role_types','experimental_specimen_role_type'],
            'sample_volume_meaturement_unit':['volume_measurement_units','volume_measurement_unit'],
            'residual_sample_status':['residual_sample_status','residual_sample_status'],
            'sample_storage_duration_unit':['duration_units','duration_unit'],
            'nucleic_acid_storage_duration_unit':['duration_units','duration_unit']
        }
        if not extraction_id:
            print ("doesnt exists")
            extraction_id =create_insert(dict_of_samples['sample'][index],extraction_fields,extraction_controlled_fields,"extraction_information",len(extraction_fields))
        else:
            print (collection_id,"exists")

        if "purpose_of_sampling" in dict_of_samples['sample'][index].keys():
            print ("trying to check")
            spurposes = dict_of_samples['sample'][index]["purpose_of_sampling"]
           # print (spurposes)
            
            for purpose in spurposes:
              purpose_sampling_id = check_exists_id([collection_id,purpose],["collection_information","purpose_of_sampling","purposes","purpose"],"sample_purpose")
              if purpose_sampling_id != "yes":
                print ("doesnt exists")
                purpose_sampling_id =create_insert({"collection_information":collection_id,"purpose_of_sampling":purpose},{"collection_information":"collection_information","purpose_of_sampling":"purpose_of_sampling"},{"purpose_of_sampling":["purposes","purpose"]},"sample_purpose",2)
              else:
                print (purpose_sampling_id,"exists")
        
        if "presampling_activity" in dict_of_samples['sample'][index].keys():
            print ("trying to check")
            sactivities = dict_of_samples['sample'][index]["presampling_activity"]
           # print (spurposes)
            
            for activity in sactivities:
              psampling_activity_id = check_exists_id([collection_id,activity],["collection_information","presampling_activity","activities","activity"],"sample_activity")
              if psampling_activity_id != "yes":
                print ("doesnt exists")
                psampling_activity_id =create_insert({"collection_information":collection_id,"presampling_activity":activity},{"collection_information":"collection_information","presampling_activity":"presampling_activity"},{"presampling_activity":["activities","activity"]},"sample_activity",2)
              else:
                print (psampling_activity_id,"exists")
            

       

        if "geo_loc_name (site)" in dict_of_samples['sample'][index].keys():
            geo_loc_site_id = check_exists_id(dict_of_samples['sample'][index]["geo_loc_name (site)"],"geo_loc_name_site","geo_loc_name_sites")
            if not geo_loc_site_id:
                print ("doesnt exists")
                geo_loc_site_id =create_insert(dict_of_samples['sample'][index],{"geo_loc_name (site)":"geo_loc_name_site" },"","geo_loc_name_sites",1)
            else:
                print (geo_loc_site_id,"exists")
            dict_of_samples['sample'][index]["geo_loc_name_site_id"] = geo_loc_site_id[0]
        else:
             dict_of_samples['sample'][index]["geo_loc_name_site_id"] = None
        geo_loc_fields = {"sample_id":"sample_id","geo_loc_name (country)":"geo_loc_name_country","geo_loc_name (state/province/region)":"geo_loc_name_state_province_region","geo_loc_name_site_id":"geo_loc_name_site","geo_loc latitude":"geo_loc_latitude","geo_loc longitude":"geo_loc_longitude"}
        geo_loc_controlled={"geo_loc_name (country)":["countries","country"],"geo_loc_name (state/province/region)":["state_province_regions","geo_loc_state_province_region"]}
        geo_loc_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","geo_loc")
        if not geo_loc_id:
            print ("doesnt exists")
            geo_loc_id =create_insert(dict_of_samples['sample'][index],geo_loc_fields,geo_loc_controlled,"geo_loc",len(geo_loc_fields))
        else:
            print (geo_loc_id,"exists")
        

  
        
        
    
        food_data_fields = {"sample_id":"sample_id","food_product_production_stream":"food_product_production_stream","food_product_origin geo_loc (country)":"food_product_origin_country","food_packaging_date":"food_packaging_date","food_quality_date":"food_quality_date"}
        food_controlled = {"food_product_production_stream":["food_product_production_stream","food_product_production_stream"],"food_product_origin geo_loc (country)":["countries","country"]}
        food_data_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","food_data")
        if not food_data_id:
            print ("doesnt exists")
            food_data_id =create_insert(dict_of_samples['sample'][index],food_data_fields,food_controlled,"food_data",len(food_data_fields))
        else:
            print (food_data_id,"exists")

        food_data_id = food_data_id[0]
        
        
        multi(dict_of_samples['sample'][index],"food_product","food_data",food_data_id,"food_product","food_products","food_data_product")
        multi(dict_of_samples['sample'][index],"food_product_properties","food_data",food_data_id,"food_product_property","food_product_properties","food_data_product_property")
        multi(dict_of_samples['sample'][index],"animal_source_of_food","food_data",food_data_id,"animal_source_of_food","animal_source_of_food","food_data_source") 
        multi(dict_of_samples['sample'][index],"food_packaging","food_data",food_data_id,"food_packaging","food_packaging","food_data_packaging")
        
        anatomical_data_fields = {"sample_id":"sample_id","anatomical_region":"anatomical_region"}
        anatomical_controlled = {"anatomical_region":["anatomical_regions","anatomical_region"]}
        anatomical_data_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","anatomical_data")
        if not anatomical_data_id:
            print ("doesnt exists")
            anatomical_data_id =create_insert(dict_of_samples['sample'][index],anatomical_data_fields,anatomical_controlled,"anatomical_data",len(anatomical_data_fields))
        else:
            print (anatomical_data_id,"exists")
        
        anatomical_data_id= anatomical_data_id[0]
        
        
        multi(dict_of_samples['sample'][index],"body_product","anatomical_data",anatomical_data_id,"body_product","body_products","anatomical_data_body")
        multi(dict_of_samples['sample'][index],"anatomical_part","anatomical_data",anatomical_data_id,"anatomical_part","anatomical_parts","anatomical_data_part")
        multi(dict_of_samples['sample'][index],"anatomical_material","anatomical_data",anatomical_data_id,"anatomical_material","anatomical_materials","anatomical_data_material")

        environmental_data_fields = {"sample_id":"sample_id","air_temperature":"air_temperature","sediment_depth":"sediment_depth","water_depth":"water_depth","water_temperature":"water_temperature"}
        #environmental_controlled = {}
        if (dict_of_samples['environment']):
            for indexes in dict_of_samples['environment']:
                if dict_of_samples['environment'][indexes]['sample_collector_sample_ID'] == dict_of_samples['sample'][index]['sample_collector_sample_ID']:
                    for fields_env in dict_of_samples['environment'][indexes]:
                        if fields_env != dict_of_samples['sample'][index].keys():
                            dict_of_samples['sample'][index][fields_env] = dict_of_samples['environment'][indexes][fields_env]

        
        environmental_data_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","environmental_data")
        if not environmental_data_id:
            print ("doesnt exists")
            environmental_data_id =create_insert(dict_of_samples['sample'][index],environmental_data_fields,"","environmental_data",len(environmental_data_fields))
        else:
            print (environmental_data_id,"exists")
        
        environmental_data_id= environmental_data_id[0]
        multi(dict_of_samples['sample'][index],"weather_type","environmental_data",environmental_data_id,"weather_type","weather_types","environment_data_weather_type")
        
        multi(dict_of_samples['sample'][index],"envrionmental_material","environmental_data",environmental_data_id,"envrionmental_material","envrionmental_materials","environment_data_material")
        multi(dict_of_samples['sample'][index],"environmental_site","environmental_data",environmental_data_id,"environmental_site","environmental_sites","environment_data_site")
        
        multi(dict_of_samples['sample'][index],"available_data_types","environmental_data",environmental_data_id,"available_data_type","available_data_types","environment_data_available_data_type")
        print("DONE???")
        multi(dict_of_samples['sample'][index],"animal_or_plant_population","environmental_data",environmental_data_id,"animal_or_plant_population","animal_or_plant_populations","environment_data_animal_plant")
        print ('DONE_POPULATION')
        if "host_origin geo_loc (country)" in dict_of_samples['sample'][index].keys():
            print ("STARTING HOSTCOUNTYR")
            host_country[dict_of_samples['sample'][index][sample_id]] = dict_of_samples['sample'][index]["host_origin geo_loc (country)"]
            print ("DONE HCOUNTRY")
                
        
    print ("FINISHED SAMPLE KEY")
    print (dict_of_samples['host'])
    for index in dict_of_samples['host']: 
        print  (dict_of_samples['host'][index])  
        if "host (breed)" in dict_of_samples['host'][index].keys():
            host_breed_id = check_exists_id(dict_of_samples['host'][index]["host (breed)"],"host_breed","host_breeds")
            if not host_breed_id:
                print ("doesnt exists")
                host_breed_id =create_insert(dict_of_samples['host'][index],{"host (breed)":"host_breed" },"","host_breeds",1)
            else:
                print (host_breed_id,"exists")
            dict_of_samples['host'][index]["host_breed_id"] = host_breed_id[0]
        else:
             dict_of_samples['host'][index]["geo_loc_name_site_id"] = None
        if "host_disease" in dict_of_samples['host'][index].keys():
            host_disease_id = check_exists_id(dict_of_samples['host'][index]["host_disease"],"host_disease","host_diseases")
            if not host_disease_id:
                print ("doesnt exists")
                host_disease_id =create_insert(dict_of_samples['host'][index],{"host_disease":"host_disease" },"","host_diseases",1)
            else:
                print (host_disease_id,"exists")
            dict_of_samples['host'][index]["host_disease_id"] = host_disease_id[0]
        else:
             dict_of_samples['host'][index]["geo_loc_name_site_id"] = None
        print('failed_here?')
        sample_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
        print ('maybe_not')
        sample_id = sample_id[0]
        #print (host_country)
        #if host_country:
        if sample_id in host_country.keys():
            dict_of_samples['sample'][index]["host_origin geo_loc (country)"] = host_country[sample_id]
        dict_of_samples['host'][index]["sample_id"] = sample_id

        host_fields = {"sample_id":"sample_id","host (common name)":"host_common_name","host (scientific name)":"host_scientific_name","host (food production name)":"host_food_production_name","host_origin geo_loc (country)":"host_origin_geo_loc_name_country","host (ecotype)":"host_ecotype","host_disease_id":"host_disease","host_breed_id":"host_breed","host_age_bin":"host_age_bin"}
        host_controlled = {"host (common name)":["host_common_names","host_common_name"],"host (scientific name)":["host_scientific_names","host_scientific_name"],"host (food production name)":["host_food_production_names","host_food_production_name"],"host_origin geo_loc (country)":["countries","country"]}  
        host_id = check_exists_id(dict_of_samples['host'][index]["sample_id"],"sample_id","hosts")
        if not host_id:
            print ("doesnt exists")
            host_id =create_insert(dict_of_samples['host'][index],host_fields,host_controlled,"hosts",len(host_fields))
        else:
            print (host_id,"exists")
        
        
        """
        CREATE TABLE ISOLATES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    ISOLATE_ID TEXT NOT NULL,
    STRAIN INTEGER REFERENCES STRAINS(id),
    MICROBIOLOGICAL_METHOD TEXT,
    PROGENY_ISOLATE_ID TEXT,
    ISOLATED_BY INTEGER REFERENCES AGENCIES(id),
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    ISOLATION_DATE DATE,
    ISOLATE_RECEIVED_DATE DATE,
    IRIDA_ISOLATE_ID TEXT,
    IRIDA_PROJECT_ID TEXT,
    ORGANISM INTEGER REFERENCES ORGANISMS(id),
    TAXONOMIC_IDENTIFICATION_PROCESS INTEGER REFERENCES TAXONOMIC_IDENTIFICATION_PROCESSES(id),
    SEROVAR TEXT,
    SEROTYPING_METHOD TEXT,
    PHAGETYPE TEXT
);
        """
    print ("FINISHED HOST")
    for index in dict_of_samples['isolate']:
        print (dict_of_samples['isolate'][index])    
        isolate_id = ""
        
        if "isolate_ID" in dict_of_samples['isolate'][index].keys():
            
            sample_id = check_exists_id(dict_of_samples['isolate'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
            sample_id = sample_id[0]
            dict_of_samples['isolate'][index]["sample_id"] = sample_id
            print(dict_of_samples['isolate'][index])
            if "strain" in dict_of_samples['isolate'][index].keys():
                strain_id = check_exists_id(dict_of_samples['isolate'][index]["strain"],"strain","strains")
                if not strain_id:
                    print ("doesnt exists")
                    strain_id =create_insert(dict_of_samples['isolate'][index],{"strain":"strain" },"","strains",1)
                else:
                    print (strain_id,"exists")
                dict_of_samples['isolate'][index]["strain_id"] = strain_id[0]
            else:
                dict_of_samples['isolate'][index]["strain_id"] = None
            
            
            contact_info_id =""
            if "isolated_by_contact_name" in dict_of_samples['isolate'][index].keys(): 
                contact_info_id = check_exists_id(dict_of_samples['isolate'][index]["isolated_by_contact_name"],"contact_name","contact_information")
                print ("done checking")
                if not contact_info_id:
                    print ("doesnt exists")
                    contact_info_id =create_insert(dict_of_samples['isolate'][index],{"isolated_by_contact_name":"contact_name","isolated_by_laboratory_name":"laboratory_name","isolated_by_contact_email":"contact_email"},"","contact_information",3)
                else:
                    print (contact_info_id,"exists")
                
                contact_info_id = contact_info_id[0]
        
            if contact_info_id:
                dict_of_samples['isolate'][index]["contact_information"] = contact_info_id
                print (contact_info_id, " contact info")
            else:
                dict_of_samples['isolate'][index]["contact_information"] = None
            isolate_fields = {"sample_id":"sample_id","isolate_ID":"isolate_id","strain_id":"strain","microbiological_method":"microbiological_method","progeny_isolate_id":"progeny_isolate_id","isolated_by":"isolated_by","contact_information":"contact_information","isolation_date":"isolation_date","isolate_received_date":"isolate_received_date","irida_project_id":"irida_project_id","irida_isolate_id":"irida_isolate_id","organism":"organism","taxonomic_identification_process":"taxonomic_identification_process","serovar":"serovar","serotyping_method":"serotyping_method","phagetype":"phagetype"}
            isolate_controlled = {"isolated_by":["agencies","agency"],"organism":["organisms","organism"],"taxonomic_identification_process":["taxonomic_identification_processes","taxonomic_identification_process"]}  
            isolate_id = check_exists_id(dict_of_samples['isolate'][index]["isolate_ID"],"isolate_id","isolates")
            if not isolate_id:
                print ("doesnt exists")
                isolate_id =create_insert(dict_of_samples['isolate'][index],isolate_fields,isolate_controlled,"isolates",len(isolate_fields))
            else:
                print (isolate_id,"exists")
            
            isolate_id= isolate_id[0]
           # if ( dict_of_samples['isolate'][index]['isolate_ID'] == "CC-MBS0564R"):
               ## print (dict_of_samples['isolate'][index])
              #  print(isolate_id)
               # sys.exit()
            if ("alternative_isolate_ID") in dict_of_samples['isolate'][index].keys():
            
                list_alt_ids =[]
                dict_of_samples['isolate'][index]["alternative_isolate_ID"] = str(dict_of_samples['isolate'][index]["alternative_isolate_ID"])
                if ("|" in dict_of_samples['isolate'][index]["alternative_isolate_ID"]):
                    list_alt = dict_of_samples['isolate'][index]["alternative_isolate_ID"].split("|")
                    print (list_alt)
                    
                        
                    for alt in list_alt:
                        alt = alt.strip()
                        
                        alt_id = check_exists_id(alt,"alternative_isolate_ID","alternative_isolate_ids")
                        if not alt_id:
                            alt_id =create_insert({"alternative_isolate_ID":alt,"isolate_id":isolate_id},{"alternative_isolate_ID":"alternative_isolate_id","isolate_id":"isolate_id"},"","alternative_isolate_ids",2) 
                        list_alt_ids.append(alt_id)
                elif (";" in dict_of_samples['isolate'][index]["alternative_isolate_ID"]):
                    list_alt = dict_of_samples['isolate'][index]["alternative_isolate_ID"].split(";")
                    for alt in list_alt:
                        alt_id = check_exists_id(alt,"alternative_isolate_ID","alternative_isolate_ids")
                        if not alt_id:
                            alt_id =create_insert({"alternative_isolate_ID":alt,"isolate_id":isolate_id},{"alternative_isolate_ID":"alternative_isolate_id","isolate_id":"isolate_id"},"","alternative_isolate_ids",2) 
                        list_alt_ids.append(alt_id)
                            
                elif ("," in dict_of_samples['isolate'][index]["alternative_isolate_ID"]):
                    list_alt = dict_of_samples['isolate'][index]["alternative_isolate_ID"].split(",")
                    for alt in list_alt:
                        alt_id = check_exists_id(alt,"alternative_isolate_ID","alternative_isolate_ids")
                        if not alt_id:
                            alt_id =create_insert({"alternative_isolate_ID":alt,"isolate_id":isolate_id},{"alternative_isolate_ID":"alternative_isolate_id","isolate_id":"isolate_id"},"","alternative_isolate_ids",2) 
                        list_alt_ids.append(alt_id)
                else:
                    alt = dict_of_samples['isolate'][index]["alternative_isolate_ID"]    
                    alt_id = check_exists_id(alt,"alternative_isolate_id","alternative_isolate_ids")
                    if not alt_id:
                        alt_id =create_insert({"alternative_isolate_ID":alt,"isolate_id":isolate_id},{"alternative_isolate_ID":"alternative_isolate_id","isolate_id":"isolate_id"},"","alternative_isolate_ids",2) 
                    list_alt_ids.append(alt_id)         
            else:
                sample_table_fields["alternative_isolate_id"]=None
    
    
    ##sequneces
    
    for index in dict_of_samples['sequence']:
        #print (dict_of_samples['sequence'][index])
        #sys.exit()
        print("died sequence")
        flag_continue =0 
        if (mode == 1):
            if 'isolate_ID' in dict_of_samples['sequence'][index].keys():
                isolate_id = check_exists_id(dict_of_samples['sequence'][index]["isolate_ID"],"isolate_id","isolates")
                isolate_id = isolate_id[0]
                dict_of_samples['sequence'][index]["isolate_id"] = isolate_id
                flag_continue=1
        else:
            if 'sample_collector_sample_ID' in dict_of_samples['sequence'][index].keys():
                sample_id = check_exists_id(dict_of_samples['sequence'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
                sample_id = sample_id[0]
                dict_of_samples['sequence'][index]["sample_id"] = sample_id
                flag_continue = 1
            

        
        contact_info_id =""
        
        if flag_continue == 1:    
            if "sequenced_by_contact_name" in dict_of_samples['sequence'][index].keys(): 
                    contact_info_id = check_exists_id(dict_of_samples['sequence'][index]["sequenced_by_contact_name"],"contact_name","contact_information")
                    print ("done checking")
                    if not contact_info_id:
                        print ("doesnt exists")
                        contact_info_id =create_insert(dict_of_samples['sequence'][index],{"sequenced_by_contact_name":"contact_name","sequenced_by_laboratory_name":"laboratory_name","sequenced_by_contact_email":"contact_email"},"","contact_information",3)
                    else:
                        print (contact_info_id,"exists")
                        
                    contact_info_id = contact_info_id[0]
                
                    if contact_info_id:
                        dict_of_samples['sequence'][index]["contact_information"] = contact_info_id
                        print (contact_info_id, " contact info")
                    else:
                        dict_of_samples['sequence'][index]["contact_information"] = None
            """CREATE TABLE SEQUENCING (
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        SAMPLE_ID INTEGER REFERENCES SAMPLES(id), 
        ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
        LIBRARY_ID TEXT,
        CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
        SEQUENCED_BY INTEGER REFERENCES AGENCIES(id),
        SEQUENCING_PROJECT_NAME TEXT,
        SEQUENCING_PLATFORM INTEGER REFERENCES SEQUENCING_PLATFORMS(id),
        SEQUENCING_INSTRUMENT INTEGER REFERENCES SEQUENCING_INSTRUMENTS(id),
        LIBRARY_PREPARATION_KIT TEXT,
        SEQUENCING_PROTOCOL TEXT,
        R1_FASTQ_FILENAME TEXT,
        R2_FASTQ_FILENAME TEXT,
        FAST5_FILENAME TEXT,
        ASSEMBLY_FILENAME TEXT
        


    """     
            
            sequence_fields = {"sequenced_by":"sequenced_by","contact_information":"contact_information","library_ID":"library_id","sequencing_project_name":"sequencing_project_name","assembly_filename":"assembly_filename","sequencing_platform":"sequencing_platform","sequencing_instrument":"sequencing_instrument",
                            "library_preparation_kit":"library_preparation_kit","sequencing_protocol":"sequencing_protocol","r1_fastq_filename":"r1_fastq_filename","r2_fastq_filename":"r2_fastq_filename","fast5_filename":"fast5_filename","sequencing_assay_type":"sequencing_assay_type","dna_fragment_length":"dna_fragment_length",
                                "genomic_target_enrichment_method":"genomic_target_enrichment_method",
                                "genomic_target_enrichment_method_details":"genomic_target_enrichment_method_details",
                                "amplicon_pcr_primer_scheme":"amplicon_pcr_primer_scheme",
                                "amplicon_size":"amplicon_size",
                                "sequencing_flow_cell":"sequencing_flow_cell"}
            
            sequence_controlled = {"sequenced_by":["agencies","agency"],
                                "sequencing_platform":["sequencing_platforms","sequencing_platform"],
                                "sequencing_instrument":["sequencing_instruments","sequencing_instrument"],
                                "sequencing_assay_type" :["sequencing_assay_types","sequencing_assay_type"],
                                    "genomic_target_enrichment_method":["genomic_target_enrichment_methods","genomic_target_enrichment_method"]
                                }  
            
            sequence_id=""
            print ('PASSED HERE FIRST CHEQUING SEQUENCE')
            if (mode == 1):
                sequence_id = check_exists_id(dict_of_samples['sequence'][index]["isolate_id"],"isolate_id","wholegenomesequencing")
            else:
                sequence_id = check_exists_id(dict_of_samples['sequence'][index]["sample_id"],"sample_id","metagenomics")
                
            if not sequence_id:
                    print ("doesnt exists")
                    sequence_id =create_insert(dict_of_samples['sequence'][index],sequence_fields,sequence_controlled,"sequencing",len(sequence_fields))
            else:
                    print (sequence_id,"exists")
            sequence_id = sequence_id[0]
            if "purpose_of_sequencing" in dict_of_samples['sequence'][index].keys():
                print ("trying to check")
                spurposes = dict_of_samples['sequence'][index]["purpose_of_sequencing"]
            # print (spurposes)
                
                for purpose in spurposes:
                    purpose_of_sequencing_id = check_exists_id([sequence_id,purpose],["sequencing_id","purpose_of_sequencing","purposes","purpose"],"sequencing_purpose")
                    print (purpose_of_sequencing_id)
                    if purpose_of_sequencing_id != "yes":
                        print ("doesnt exists")
                        purpose_of_sequencing_id =create_insert({"sequencing_id":sequence_id,"purpose_of_sequencing":purpose},{"sequencing_id":"sequencing_id","purpose_of_sequencing":"purpose_of_sequencing"},{"purpose_of_sequencing":["purposes","purpose"]},"sequencing_purpose",2)
                    else:
                        print (purpose_of_sequencing_id,"exists")
            print ('ADDING TO WGS OR METAGENOMICS TABLE')
            if (mode == 1):
                print (  ' ADDING ',dict_of_samples['sequence'][index]["isolate_ID"],dict_of_samples['sequence'][index]["isolate_id"])
                wgs_id = check_exists_id2([sequence_id,dict_of_samples['sequence'][index]["isolate_id"]],["isolate_id","sequencing_id"],"wholegenomesequencing")
                print (wgs_id, "HERE ID ")
                if wgs_id != "yes":
                    create_insert({"sequencing_id":sequence_id,"isolate_id":dict_of_samples['sequence'][index]["isolate_id"]},{"sequencing_id":"sequencing_id","isolate_id":"isolate_id"},"","wholegenomesequencing",2)
                    print (  ' ADDED ',dict_of_samples['sequence'][index]["isolate_ID"],dict_of_samples['sequence'][index]["isolate_id"])
                else:
                    print (  ' NOT ADDEDD ',dict_of_samples['sequence'][index]["isolate_ID"],dict_of_samples['sequence'][index]["isolate_id"])
                
            else:
                metagenomics_id = check_exists_id2([sequence_id,dict_of_samples['sequence'][index]["sample_id"]],["sample_id","sequencing_id"],"metagenomics")
                if metagenomics_id != "yes":
                    create_insert({"sequencing_id":sequence_id,"isolate_id":dict_of_samples['sequence'][index]["sample_id"]},{"sequencing_id":"sequencing_id","sample_id":"sample_id"},"","metagenomics",2)
                    print (metagenomics_id,"exists")
                #sys.exit()
                    
    for index in dict_of_samples['bioinformatics']:
        if (mode == 1):
                isolate_id = check_exists_id(dict_of_samples['sequence'][index]["isolate_ID"],"isolate_id","isolates")
                isolate_id = isolate_id[0]
                dict_of_samples['bioinformatics'][index]["isolate_id"] = isolate_id
                sequence_id = check_exists_id(dict_of_samples['bioinformatics'][index]["isolate_id"],"isolate_id","wholegenomesequencing")
                dict_of_samples['bioinformatics'][index]["sequencing_id"] = sequence_id[0]
        else:
            sample_id = check_exists_id(dict_of_samples['sequence'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
            sample_id = sample_id[0]
            dict_of_samples['bioinformatics'][index]["sample_id"] = sample_id
            sequence_id = check_exists_id(dict_of_samples['bioinformatics'][index]["sample_id"],"sample_id","metagenomics")
            dict_of_samples['bioinformatics'][index]["sequencing_id"] = sequence_id[0]
        bioinformatics_fields = {
                                "sequencing_id":"sequencing_id",
                                "quality_control_method_name":"quality_control_method_name",
                                "quality_control_method_version":"quality_control_method_version",
                                "quality_control_determination":"quality_control_determination",
                                "quality_control_issues":"quality_control_issues",
                                "quality_control_details":"quality_control_details",
                                "raw_sequence_data_processing_method":"raw_sequence_data_processing_method",
                                "dehosting_method":"dehosting_method",
                                "sequence_assembly_software":"sequence_assembly_software",
                                "sequence_assembly_software_versiont":"sequence_assembly_software_versiont",
                                "breadth_of_coverage_value":"breadth_of_coverage_value",
                                "depth_of_coverage_value":"depth_of_coverage_value",
                                "depth_of_coverage_threshold":"depth_of_coverage_threshold",
                                "genome_completness":"genome_completness",
                                "number_of_base_pairs_sequenced":"number_of_base_pairs_sequenced",
                                "number_of_totalreads":"number_of_totalreads",
                                "number_of_unique_reads":"number_of_unique_reads",
                                "minimum_post_trimming_read_length":"minimum_post_trimming_read_length",
                                "number_of_contigs":"number_of_contigs",
                                "ns_per_100_kbp":"ns_per_100_kbp",
                                "n50":"n50",
                                "percent_read_contamination":"percent_read_contamination",
                                "sequence_assembly_length":"sequence_assembly_length",
                                "consensus_genome_length":"consensus_genome_length",
                                "reference_genome_accession":"reference_genome_accession",
                                "deduplication_method":"deduplication_method",
                                "bioinformatics_protocol":"bioinformatics_protocol",
                                "read_mapping_software_name":"read_mapping_software_name",
                                "read_mapping_software_version":"read_mapping_software_version"



                                }
        bioinformatics_controlled = {
                                    "quality_control_determination":["quality_control_determinations","quality_control_determination"],
                                    "quality_control_issues":["quality_control_issues","quality_control_issues"],
                                    "sequence_assembly_software":["sequence_assembly_software","sequence_assembly_software"],
                                    "reference_genome_accession":["reference_genome_accessions","reference_genome_accession"],
                                    "read_mapping_software_name":["read_mapping_software_names","read_mapping_software_name"]


                                    }
        bioinformatics_id = check_exists_id(dict_of_samples['bioinformatics'][index]["sequencing_id"],"sequencing_id","bioinformatics_analysis")
        if not bioinformatics_id:
            print ("doesnt exists")
            publicRep_id =create_insert(dict_of_samples['bioinformatics'][index],bioinformatics_fields,bioinformatics_controlled,"bioinformatics_analysis",len(bioinformatics_fields))
        else:
            print (bioinformatics_id,"exists")
    for index in dict_of_samples['taxonomics']:
        if (mode == 1):
                isolate_id = check_exists_id(dict_of_samples['sequence'][index]["isolate_ID"],"isolate_id","isolates")
                isolate_id = isolate_id[0]
                dict_of_samples['taxonomics'][index]["isolate_id"] = isolate_id
                sequence_id = check_exists_id(dict_of_samples['taxonomics'][index]["isolate_id"],"isolate_id","wholegenomesequencing")
                dict_of_samples['taxonomics'][index]["sequencing_id"] = sequence_id[0]
        else:
            sample_id = check_exists_id(dict_of_samples['sequence'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
            sample_id = sample_id[0]
            dict_of_samples['taxonomics'][index]["sample_id"] = sample_id
            sequence_id = check_exists_id(dict_of_samples['taxonomics'][index]["sample_id"],"sample_id","metagenomics")
        taxonomics_fields = {
            "sequencing_id":"sequencing_id",
            "taxonomic_reference_database_name":"taxonomic_reference_database_name",
            "taxonomic_reference_database_version":"taxonomic_reference_database_version",
            "taxonomic_analysis_report_filename":"taxonomic_analysis_report_filename",
            "read_mapping_criteria":"read_mapping_criteria"
        }
        taxonomics_id = check_exists_id(dict_of_samples['taxonomics'][index]["sequencing_id"],"sequencing_id","taxonomic_information")
        if not taxonomics_id:
            print ("doesnt exists")
            taxonomics_id =create_insert(dict_of_samples['taxonomics'][index],taxonomics_fields,"","taxonomic_information",len(taxonomics_fields))
        else:
            print (taxonomics_id,"exists")
    print ('ADDING PLBLIC_REP')
    for index in dict_of_samples['publicRep']:
            print (dict_of_samples['publicRep'][index])
            if (mode == 1):
                print ("MODE1",index)
                #print (dict_of_samples['sequence'])
                isolate_id = check_exists_id(dict_of_samples['sequence'][index]["isolate_ID"],"isolate_id","isolates")
                

                isolate_id = isolate_id[0]
                print ("isolate_id")
                dict_of_samples['publicRep'][index]["isolate_id"] = isolate_id
                sequence_id = check_exists_id(dict_of_samples['publicRep'][index]["isolate_id"],"isolate_id","wholegenomesequencing")
                dict_of_samples['publicRep'][index]["sequencing_id"] = sequence_id[0]
            else:
                sample_id = check_exists_id(dict_of_samples['sequence'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
                sample_id = sample_id[0]
                dict_of_samples['publicRep'][index]["sample_id"] = sample_id
                sequence_id = check_exists_id(dict_of_samples['publicRep'][index]["sample_id"],"sample_id","metagenomics")
                dict_of_samples['publicRep'][index]["sequencing_id"] = sequence_id[0]
            
            print ("it is here")
            contact_info_id =""
            
            if "sequence_submitted_by_contact_name" in dict_of_samples['publicRep'][index].keys(): 
                contact_info_id = check_exists_id(dict_of_samples['publicRep'][index]["sequence_submitted_by_contact_name"],"contact_name","contact_information")
                print ("done checking")
                if not contact_info_id:
                    print ("doesnt exists")
                    contact_info_id =create_insert(dict_of_samples['publicRep'][index],{"sequence_submitted_by_contact_name":"contact_name","sequence_submitted_by_laboratory_name":"laboratory_name","sequence_submitted_by_contact_email":"contact_email"},"","contact_information",3)
                else:
                    print (contact_info_id,"exists")
                    
                contact_info_id = contact_info_id[0]
            
                if contact_info_id:
                    dict_of_samples['publicRep'][index]["contact_information"] = contact_info_id
                    print (contact_info_id, " contact info")
                else:
                    dict_of_samples['publicRep'][index]["contact_information"] = None
                
        
    
            
                        
            publicRep_fields = {"sequencing_id":"sequencing_id","sequence_submitted_by":"sequence_submitted_by","contact_information":"contact_information","publication_ID":"publication_id","bioproject_accession":"bioproject_accession","biosample_accession":"biosample_accession","sra_accession":"SRA_accession","GenBank_accession":"genbank_accession","attribute_package":"attribute_package"}
            publicRep_controlled = {"sequence_submitted_by":["agencies","agency"],"attribute_package":["attribute_packages","attribute_package"]}  
            publicRep_id = check_exists_id(dict_of_samples['publicRep'][index]["sequencing_id"],"sequencing_id","public_repository_information")
            if not publicRep_id:
                print ("doesnt exists")
                publicRep_id =create_insert(dict_of_samples['publicRep'][index],publicRep_fields,publicRep_controlled,"public_repository_information",len(publicRep_fields))
            else:
                print (publicRep_id,"exists")
        


    print ("done REP PUBLIC")
    if (dict_of_samples['risk']): 
        for index in dict_of_samples['risk']:
                print("died risk")
                sample_id = check_exists_id(dict_of_samples['risk'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
                sample_id = sample_id[0]
                dict_of_samples['risk'][index]["sample_id"] = sample_id
                isolate_id= None
                risk_id=""
                if ("isolate_ID" in dict_of_samples['risk'][index].keys() ):
                    isolate_id = check_exists_id(dict_of_samples['risk'][index]["isolate_ID"],"isolate_id","isolates")
                    isolate_id = isolate_id[0]
                    dict_of_samples['risk'][index]["isolate_id"] = isolate_id
                    risk_id=check_exists_id(dict_of_samples['risk'][index]["isolate_id"],"isolate_id","risk_assessment")
                else:
                    risk_id=check_exists_id(dict_of_samples['risk'][index]["sample_id"],"sample_id","risk_assessment")
            
                risk_fields = {"sample_id":"sample_id","isolate_id":"isolate_id","sequence_ID":"sequence_id","prevalence_metrics":"prevalence_metrics","prevalence_metrics_details":"prevalence_metrics_details","stage_of_production":"stage_of_production","experimental_intervention_details":"experimental_intervention_details"}
                risk_controlled = {"prevalence_metrics":["prevalence_metrics","prevalence_metrics"],"stage_of_production":["stage_of_production","stage_of_production"]}  
                #risk_id = check_exists_id(dict_of_samples['publicRep'][index]["sample_id"],"sample_id","public_repository_information]")
                
                if not risk_id:
                        print ("doesnt exists")
                        risk_id =create_insert(dict_of_samples['risk'][index],risk_fields,risk_controlled,"risk_assessment",len(risk_fields))
                else:
                        print (risk_id,"exists")
                
                
                if "experimental_intervention" in dict_of_samples['risk'][index].keys():
                    print ("trying to check")
                    sactivities = dict_of_samples['risk'][index]["experimental_intervention"]
                # print (spurposes)
                    
                    for activity in sactivities:
                        psampling_activity_id = check_exists_id([risk_id,activity],["risk_id","experimental_intervention","activities","activity"],"risk_activity")
                        if psampling_activity_id != "yes":
                            print ("doesnt exists")
                            psampling_activity_id =create_insert({"risk_id":risk_id,"experimental_intervention":activity},{"risk_id":"risk_id","experimental_intervention":"experimental_intervention"},{"experimental_intervention":["activities","activity"]},"risk_activity",2)
                        else:
                            print (psampling_activity_id,"exists")
            
            #print(dict_of_samples['AMR'][0])
            
        # print (len(dict_of_samples['AMR']),"tamanho total")
            #sys.exit()
        print ("DONE RISK")
    if dict_of_samples['AMR']:
        for index in dict_of_samples['AMR']:
                #if dict_of_samples['AMR'][index]["isolate_ID"] == "CJ-MBS0172R":


                isolate_id = check_exists_id(dict_of_samples['AMR'][index]["isolate_ID"],"isolate_id","isolates")
                

                isolate_id = isolate_id[0]
                dict_of_samples['AMR'][index]["isolate_id"] = isolate_id
                """
                CREATE TABLE AMR_INFO(
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
        ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
        AMR_TESTED_BY INTEGER REFERENCES AGENCIES(id),
        CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
        AMR_TESTING_DATE DATE


    );
    """
                contact_info_id =""
                
                if "AMR_testing_by_contact_name" in dict_of_samples['AMR'][index].keys(): 
                    contact_info_id = check_exists_id(dict_of_samples['AMR'][index]["AMR_testing_by_contact_name"],"contact_name","contact_information")
                    print ("done checking")
                    if not contact_info_id:
                        print ("doesnt exists")
                        contact_info_id =create_insert(dict_of_samples['AMR'][index],{"AMR_testing_by_contact_name":"contact_name","AMR_testing_by_laboratory_name":"laboratory_name","AMR_testing_by_contact_email":"contact_email"},"","contact_information",3)
                    else:
                        print (contact_info_id,"exists")
                        
                    contact_info_id = contact_info_id[0]
                
                    if contact_info_id:
                        dict_of_samples['AMR'][index]["contact_information"] = contact_info_id
                        print (contact_info_id, " contact info")
                    else:
                        dict_of_samples['AMR'][index]["contact_information"] = None
                

                AMR_fields = {"isolate_id":"isolate_id","AMR_testing_by":"AMR_testing_by","contact_information":"contact_information","AMR_testing_date":"amr_testing_date"}
                AMR_controlled = {"AMR_testing_by":["agencies","agency"]}  
                AMR_id = check_exists_id(dict_of_samples['AMR'][index]["isolate_id"],"isolate_id","amr_info")
                if not AMR_id:
                        print ("doesnt exists")
                        AMR_id =create_insert(dict_of_samples['AMR'][index],AMR_fields,AMR_controlled,"amr_info",len(AMR_fields))
                else:
                        print (AMR_id,"exists")
                
                #amr_antibiotics_terms=['resistance_phenotype','measurement','measurement_units','measurement_sign','laboratory_typing_method','laboratory_typing_platform','laboratory_typing_platform_version','vendor_name','testing_standard','testing_standard_version','testing_standard_details','testing_susceptible_breakpoint','testing_intermediate_breakpoint','testing_resistance_breakpoint']
            # print(dict_of_samples['AMR'][index])
                #print(antimicrobian_agent_names_ids)
                #sys.exit()
                for antibiotics in antimicrobian_agent_names_ids:
                    res = [val for key, val in dict_of_samples['AMR'][index].items() if antibiotics in key]

                    if (res):
                        print(antibiotics,res)
                        #print(dict_of_samples['AMR'][index])
                        #sys.exit()
                        """
                        CREATE TABLE AMR_ANTIBIOTICS_PROFILE(
        id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
        ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
        ANTIMICROBIAL_AGENT INTEGER REFERENCES ANTIMICROBIAL_AGENTS(id),
        ANTIMICROBIAL_PHENOTYPE INTEGER REFERENCES ANTIMICROBIAL_PHENOTYPES(id),
        MEASUREMENT FLOAT(4),
        MEASUREMENT_UNITS INTEGER REFERENCES MEASUREMENT_UNITS(id),
        MEASUREMENT_SIGN INTEGER REFERENCES MEASUREMENT_SIGN(id),
        LABORATORY_TYPING_METHOD INTEGER REFERENCES LABORATORY_TYPING_METHODS(id),
        LABORATORY_TYPING_PLATFORM INTEGER REFERENCES LABORATORY_TYPING_PLATFORMS(id),
        LABORATORY_TYPING_PLATFORM_VERSION TEXT,
        TESTING_SUSCEPTIBLE_BREAKPOINT FLOAT(4),
        TESTING_INTERMEDIATE_BREAKPOINT FLOAT(4),
        TESTING_RESISTANCE_BREAKPOINT FLOAT(4),
        TESTING_STANDARD INTEGER REFERENCES TESTING_STANDARD(id),
        TESTING_STANDARD_VERSION TEXT,
        TESTING_STANDARD_DETAILS TEXT,
        VENDOR_NAME INTEGER REFERENCES VENDOR_NAMES(id)  
        
        

    );
                        """
                        
                        
                        dict_of_samples['AMR'][index]['antimicrobial_agent']= antibiotics.capitalize()
                                
                        AMR_afields = ""
                        AMR_acontrolled =""

                        if "AMR_measurement_units" in dict_of_samples['AMR'][index] or "AMR_laboratory_typing_platform" in dict_of_samples['AMR'][index]:                                                                                                                               
                            AMR_afields = {"isolate_id":"isolate_id","antimicrobial_agent":"antimicrobial_agent",antibiotics+"_resistance_phenotype":"antimicrobial_phenotype",antibiotics+"_measurement":"measurement","AMR_measurement_units":"measurement_units",antibiotics+'_measurement_sign':"measurement_sign",'AMR_laboratory_typing_method':"laboratory_typing_method",
                                                'AMR_laboratory_typing_platform': "laboratory_typing_platform",'AMR_laboratory_typing_platform_version': "laboratory_typing_platform_version",antibiotics+'_vendor_name':"vendor_name",antibiotics+'_testing_standard':'testing_standard',antibiotics+'_testing_standard_version':'testing_standard_version',antibiotics+'_testing_standard_details':'testing_standard_details'
                                                ,antibiotics+'_testing_susceptible_breakpoint':'testing_susceptible_breakpoint',antibiotics+'_testing_intermediate_breakpoint':'testing_intermediate_breakpoint',antibiotics+'_testing_resistance_breakpoint':'testing_resistance_breakpoint'}
                            AMR_acontrolled = {"antimicrobial_agent":["antimicrobial_agents","antimicrobial_agent"],antibiotics+"_resistance_phenotype":["antimicrobial_phenotypes","antimicrobial_phenotype"],"AMR_measurement_units":["measurement_units","measurement_units"],antibiotics+'_measurement_sign':["measurement_sign","measurement_sign"],'AMR_laboratory_typing_method':["laboratory_typing_methods","laboratory_typing_method"],
                                                    'AMR_laboratory_typing_platform':["laboratory_typing_platforms","laboratory_typing_platform"], antibiotics+'_testing_standard':["testing_standard","testing_standard"],antibiotics+'_vendor_name':["vendor_names","vendor_name"]}  
                        else:
                            AMR_afields = {"isolate_id":"isolate_id","antimicrobial_agent":"antimicrobial_agent",antibiotics+"_resistance_phenotype":"antimicrobial_phenotype",antibiotics+"_measurement":"measurement",antibiotics+"_measurement_units":"measurement_units",antibiotics+'_measurement_sign':"measurement_sign",antibiotics+'_laboratory_typing_method':"laboratory_typing_method",
                                                antibiotics+'_laboratory_typing_platform': "laboratory_typing_platform",antibiotics+'_laboratory_typing_platform_version': "laboratory_typing_platform_version",antibiotics+'_vendor_name':"vendor_name",antibiotics+'_testing_standard':'testing_standard',antibiotics+'_testing_standard_version':'testing_standard_version',antibiotics+'_testing_standard_details':'testing_standard_details'
                                                ,antibiotics+'_testing_susceptible_breakpoint':'testing_susceptible_breakpoint',antibiotics+'_testing_intermediate_breakpoint':'testing_intermediate_breakpoint',antibiotics+'testing_resistance_breakpoint':'testing_resistance_breakpoint'}
                            AMR_acontrolled = {"antimicrobial_agent":["antimicrobial_agents","antimicrobial_agent"],antibiotics+"_resistance_phenotype":["antimicrobial_phenotypes","antimicrobial_phenotype"],antibiotics+"_measurement_units":["measurement_units","measurement_units"],antibiotics+'_measurement_sign':["measurement_sign","measurement_sign"],antibiotics+'_laboratory_typing_method':["laboratory_typing_methods","laboratory_typing_method"],
                                                    antibiotics+'_laboratory_typing_platform':["laboratory_typing_platforms","laboratory_typing_platform"], antibiotics+'_testing_standard':["testing_standard","testing_standard"],antibiotics+'_vendor_name':["vendor_names","vendor_name"]}  
                            AMR_aid = ""
                                
                        command = "SELECT id from AMR_ANTIBIOTICS_PROFILE where ISOLATE_ID = %s AND ANTIMICROBIAL_AGENT = (SELECT id from ANTIMICROBIAL_AGENTS where ANTIMICROBIAL_AGENT = %s)"
                        print (command,(dict_of_samples['AMR'][index]["isolate_id"],antibiotics))
                        cursor.execute(command,(dict_of_samples['AMR'][index]["isolate_id"],antibiotics.capitalize()))
                        AMR_aid = cursor.fetchone()
                                
                        conn.commit()
                        if not AMR_aid:
                            print ("doesnt exists")
                            print(dict_of_samples['AMR'][index])
                            AMR_aid =create_insert(dict_of_samples['AMR'][index],AMR_afields,AMR_acontrolled,"amr_antibiotics_profile",len(AMR_afields))
                        else:
                            print (AMR_aid,"exists")
                    # sys.exit()        
            

                        #sys.exit()

        
    
    