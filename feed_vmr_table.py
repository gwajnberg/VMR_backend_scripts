import sys
import datetime
import re
from psycopg2 import sql



def feed_vmr_table (dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,conn,cursor,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list):
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
    def create_insert (row,fields,controlled_fields,table_name,length):
        print (fields,controlled_fields)
        column_ins = "("
        count=0
        values ="("
        list_terms = []
        for field in fields.keys():
            if field in row.keys():
                #print (field)
          
                terms = getTermAndId(row[field])
                #print(terms)
              
                #field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)

                if controlled_fields:
                    if field in controlled_fields.keys():
                        list_terms.append(terms)
                        values += "(SELECT id from "+controlled_fields[field][0]+" where "+controlled_fields[field][1].upper()+" = %s)"
                        if (count +1 != length):
                            values += ","
                    else:
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
        tables_multi = ["sample_purpose","sample_activity","food_data_product","food_data_product_property","food_data_source", "food_data_packaging","anatomical_data_body","anatomical_data_part","anatomical_data_material","environment_data_material","environment_data_site","environment_Data_weather_type","environment_data_available_data_type","environment_data_animal_plant"]
        if table_name in tables_multi:
            print (table_name,"here multi")
            insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values
            print (insert,list_terms)
            
            cursor.execute(insert, list_terms)
            conn.commit()
        else:
            insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values+" RETURNING id"
            print (insert,list_terms)
            cursor.execute(insert, list_terms)
            #print(cursor)
            last_created_id = cursor.fetchone()
            conn.commit()
        return(last_created_id)
    def check_exists_id(term,field,table):
        result=""
        if (isinstance(term, list)):
         #   print ("here before",term)

            term1 = term[0]
            
            
            term2 = getTermAndId(term[1])
         #   print ("here ",term1,term2)
            sql_query = """
                     SELECT *
                     FROM """ + table + """ 
                     WHERE """+field[0]+""" = %s
                    AND """+field[1]+""" = (SELECT id from """+field[2]+""" where """+field[3].upper()+""" = %s);
                    """
         #   print (sql_query,(term1,term2))
            cursor.execute(sql_query, (term1, term2))
            result = cursor.fetchall()
           # print(result,"come on")
            if (result):
                result = "yes"
            else:
                result = ""

        else:
            print ("here WRONGbefore")

            term = getTermAndId(term)
            command = "SELECT id from "+table+" where "+field.upper()+" = %s"
            print (command,term)
            cursor.execute(command,(term,))
            result = cursor.fetchone()
            print(result,"here")
            conn.commit()
        
        return(result)
    def multi (row,sfield,parent_field,parent_id,tfield,table_field,table_multi):
       if sfield in row.keys():
            terms = row[sfield]
           # print (spurposes)
            
            for term in terms:
              id = check_exists_id([parent_id,term],[parent_field,sfield,table_field,tfield],table_multi)
              if id  != "yes":
                print ("doesnt exists")
                create_insert({parent_field:parent_id,tfield:term},{parent_field:parent_field,tfield:tfield},{tfield:[table_field,tfield]},table_multi,2)
              else:
                print (parent_field,"exists and ",term," exists.")

    #print(dict_of_samples['sample'][index].keys())
    for index in dict_of_samples['sample']:
        print(dict_of_samples['sample'][index].keys())
        dict_sample_table = dict_of_samples['sample'][index]
        sample_table_fields = {"sample_collector_sample_id":dict_of_samples['sample'][index]["sample_collector_sample_ID"]}
                
        if dict_of_samples['sample'][index]["sample_collector_sample_ID"] in sample_flagged_list:
            sample_table_fields["validation_status"]= "flagged"
        else:
            sample_table_fields["validation_status"]= "curated"
        #sample_table_fields[keys]=keys
        print ("here")
        sample_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","samples")
        if not sample_id:
            print ("doesnt exists")
            print (dict_sample_table)
            print (sample_table_fields)
            sample_id =create_insert(sample_table_fields,{"sample_collector_sample_id":"sample_collector_sample_id","validation_status":"validation_status"},"","samples",2) 
        else:
            #print (contact_info_id,"exists")
            sample_id = sample_id
        sample_id = sample_id[0]
       # sample_table_id =create_insert(dict_of_samples['sample'][index],{"sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},"","contact_information",3)
        print ("here samples")
        #sys.exit()
        #alt_id =""
        if ("alternative_sample_ID") in dict_of_samples['sample'][index].keys():
            
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
        
        
        
        contact_info_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_contact_name"],"contact_name","contact_information")
        print ("done checking")
        if not contact_info_id:
            print ("doesnt exists")
            contact_info_id =create_insert(dict_of_samples['sample'][index],{"sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},"","contact_information",3)
        else:
            print (contact_info_id,"exists")
            
        contact_info_id = contact_info_id[0]
        dict_of_samples['sample'][index]["sample_id"] = sample_id
        dict_of_samples['isolate'][index]["sample_id"] = sample_id
        if contact_info_id:
            dict_of_samples['sample'][index]["contact_information"] = contact_info_id
        print (contact_info_id, " contact info")
        
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
        multi(dict_of_samples['sample'][index],"food_product_properties","food_data",food_data_id,"food_product_property","food_product_properties","food_data_food_product_property")
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
        environmental_data_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","environmental_data")
        if not environmental_data_id:
            print ("doesnt exists")
            environmental_data_id =create_insert(dict_of_samples['sample'][index],environmental_data_fields,"","environmental_data",len(environmental_data_fields))
        else:
            print (environmental_data_id,"exists")
        
        environmental_data_id= environmental_data_id[0]
        
        multi(dict_of_samples['sample'][index],"envrionmental_material","environmental_data",environmental_data_id,"envrionmental_material","envrionmental_materials","environment_data_material")
        multi(dict_of_samples['sample'][index],"environmental_site","environmental_data",environmental_data_id,"environmental_site","environmental_sites","environment_data_site")
        multi(dict_of_samples['sample'][index],"weather_type","environmental_data",environmental_data_id,"weather_type","weather_types","environment_data_weather_type")
        multi(dict_of_samples['sample'][index],"available_data_types","environmental_data",environmental_data_id,"available_data_type","available_data_types","environment_data_available_data_type")
        multi(dict_of_samples['sample'][index],"animal_or_plant_population","environmental_data",environmental_data_id,"animal_or_plant_population","animal_or_plant_populations","environment_data_animal_plant")
            
        if "host (breed)" in dict_of_samples['sample'][index].keys():
            host_breed_id = check_exists_id(dict_of_samples['sample'][index]["host (breed)"],"host_breed","host_breeds")
            if not host_breed_id:
                print ("doesnt exists")
                host_breed_id =create_insert(dict_of_samples['sample'][index],{"host (breed)":"host_breed" },"","host_breeds",1)
            else:
                print (host_breed_id,"exists")
            dict_of_samples['sample'][index]["host_breed_id"] = host_breed_id[0]
        else:
             dict_of_samples['sample'][index]["geo_loc_name_site_id"] = None
        if "host_disease" in dict_of_samples['sample'][index].keys():
            host_disease_id = check_exists_id(dict_of_samples['sample'][index]["host_disease"],"host_disease","host_diseases")
            if not host_disease_id:
                print ("doesnt exists")
                host_disease_id =create_insert(dict_of_samples['sample'][index],{"host_disease":"host_disease" },"","host_diseases",1)
            else:
                print (host_disease_id,"exists")
            dict_of_samples['sample'][index]["host_disease_id"] = host_disease_id[0]
        else:
             dict_of_samples['sample'][index]["geo_loc_name_site_id"] = None
        
        host_fields = {"sample_id":"sample_id","host (common name)":"host_common_name","host (scientific name)":"host_scientific_name","host (food production name)":"host_food_production_name","host_origin geo_loc (country)":"host_origin_geo_loc_name_country","host (ecotype)":"host_ecotype","host_disease_id":"host_disease","host_breed_id":"host_breed","host_age_bin":"host_age_bin"}
        host_controlled = {"host (common name)":["host_common_names","host_common_name"],"host (scientific name)":["host_scientific_names","host_scientific_name"],"host (food production name)":["host_food_production_names","host_food_production_name"],"host_origin geo_loc (country)":["countries","country"]}  
        host_id = check_exists_id(dict_of_samples['sample'][index]["sample_id"],"sample_id","hosts")
        if not host_id:
            print ("doesnt exists")
            host_id =create_insert(dict_of_samples['sample'][index],host_fields,host_controlled,"hosts",len(host_fields))
        else:
            print (host_id,"exists")
        
        host_id= host_id[0]
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
        
        isolate_id = ""
        
        if "isolate_ID" in dict_of_samples['isolate'][index].keys():
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
            isolate_id = check_exists_id(dict_of_samples['isolate'][index]["sample_id"],"sample_id","isolates")
            if not isolate_id:
                print ("doesnt exists")
                isolate_id =create_insert(dict_of_samples['isolate'][index],isolate_fields,isolate_controlled,"isolates",len(isolate_fields))
            else:
                print (isolate_id,"exists")
            
            isolate_id= isolate_id[0]
            if ("alternative_isolate_ID") in dict_of_samples['isolate'][index].keys():
            
                list_alt_ids =[]
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


        sys.exit()
        sampled_by_id = check_exists_id(dict_of_samples['sample'][index]["sample_collected_by"],"agency","agencies")
        sampled_by_id = sampled_by_id[0]
        print (sampled_by_id,"agency")
        sys.exit()
        controlled_samples = {"sample_collected_by":["agency",0],"sample_collection_date_precision":["sample_collection_date_precision",0],"specimen_processing":["specimen_processing",0]}
        #sys.exit()
        print ("beginning checking")
        dict_sample_table = {}
        sample_table_fields ={}
        contact_info_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_contact_name"],"contact_name","contact_information")
        print ("done checking")
        if not contact_info_id:
            print ("doesnt exists")
            contact_info_id =create_insert(dict_of_samples['sample'][index],{"sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},"","contact_information",3)
        else:
            print (contact_info_id,"exists")
            contact_info_id = contact_info_id[0]
        sample_table_fields["sample_collected_by_contact_name"]="sample_collected_by_contact_name"
        dict_sample_table["sample_collected_by_contact_name"]=contact_info_id 
        print (contact_info_id)
        
        for keys in controlled_samples:
            id=""
            
            if keys in dict_of_samples['sample'][index].keys():
                #cor_field = controlled_samples[keys][0]
                sample_table_fields[keys]=keys
                id = check_exists_id(dict_of_samples['sample'][index][keys],controlled_samples[keys][0],controlled_samples[keys][0])[0]
                #dict_sample_table[keys]=id
            else:
                id = None
            dict_sample_table[keys]=id   

        print (dict_sample_table," here after controlled")
        
        not_controlled_samples = {"sample_collector_sample_ID":0,"alternative_sample_id":0,"sample_collection_project_name":0,"sample_collection_date":0,"presampling_activity_details":0,"sample_received_date":0,"original_sample_description":0}
        for keys in not_controlled_samples:
            if keys in dict_of_samples['sample'][index].keys():
                not_controlled_samples[keys] = dict_of_samples['sample'][index][keys]
                dict_sample_table[keys] = not_controlled_samples[keys]
            else:
                not_controlled_samples[keys] = None
                dict_sample_table[keys] = not_controlled_samples[keys]
            
            
            sample_table_fields[keys]=keys
        print (dict_sample_table)
        print(sample_table_fields)

        sample_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_sample_ID"],"sample_collector_sample_id","sample")
        if not sample_id:
            print ("doesnt exists")
            sample_id =create_insert(dict_sample_table,sample_table_fields,"","sample",10) 
        else:
            print (contact_info_id,"exists")
            sample_id = sample_id[0]
        print (sample_id)

        #create_insert(dict_of_samples['sample'][index],["sample_storage_method","sample_storage_medium"],{"collection_device":"collection_device", "collection_method": "collection_method"})
        
        sys.exit()
        #host_t insert
    
    