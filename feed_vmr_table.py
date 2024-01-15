import sys
import datetime
import re
from psycopg2 import sql



def feed_vmr_table (dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,conn,cursor,new_ont_terms,terms_accepting_multiple_values):
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
    def valuesIns (values,term,count,length): 
       # print ('before',values)
        #print ('before',term)
        if (term == 'NULL'):
            value = "NULL"
        else:
            value = str(term)
      #  print ('after',values)
       # if (count +1 != length):
        #    values += ","
        
        return(value)
    def create_insert (row,fields,controlled_fields,table_name,length):
        column_ins = "("
        count=0
        values ="("
        list_terms = []
        for field in fields.keys():
            if field in row.keys():
          
                terms = getTermAndId(row[field])
              
                field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)

                if controlled_fields:
                    if field in controlled_fields.keys():
                        list_terms.append(terms)
                        values += "(SELECT id from "+controlled_fields[field]+" where "+controlled_fields[field].upper()+" = %s)"
                        if (count +1 != length):
                            values += ","
                    else:
                        list_terms.append(valuesIns(values,terms,count,length))
                        values += "%s"
                        if (count +1 != length):
                            values += ","
                else:
                        list_terms.append(valuesIns(values,terms,count,length))
                        values += "%s"
                        if (count +1 != length):
                            values += ","
                
            else:
               # print('before2',fields)
                field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)
                
                list_terms.append(valuesIns(values,"NULL",count,length))
                values += "%s"
                if (count +1 != length):
                    values += ","
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        print (values)
        insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values+"RETURNING id"
        print (insert,list_terms)
        cursor.execute(insert, list_terms)
        print(cursor)
        last_created_id = cursor.fetchone()[0]
        conn.commit()
        return(last_created_id)
    def check_exists_id(term,field,table):
        term = getTermAndId(term)
        command = "SELECT id from "+table+" where "+field.upper()+" = %s"
        print (command,term)
        cursor.execute(command,(term,))
        result = cursor.fetchone()
        print(result,"here")
        conn.commit()
        
        return(result)


    #print(dict_of_samples['sample'][index].keys())
    for index in dict_of_samples['sample']:
        print(dict_of_samples['sample'][index].keys())
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
        sample_table_fields["sample_collected_by_contact_name"]=["sample_collected_by_contact_name"]
        dict_sample_table["sample_collected_by_contact_name"]=contact_info_id 
        print (contact_info_id)
        
        for keys in controlled_samples:
            id=""
            
            if keys in dict_of_samples['sample'][index].keys():
                cor_field = controlled_samples[keys][0]
                sample_table_fields[keys]=cor_field
                id = check_exists_id(dict_of_samples['sample'][index][keys],controlled_samples[keys][0],controlled_samples[keys][0])[0]
                #dict_sample_table[keys]=id
            else:
                id = "NULL"
            dict_sample_table[keys]=id   

        print (controlled_samples)
        
        not_controlled_samples = {"sample_collector_sample_id":0,"alternative_sample_id":0,"sample_collection_project_name":0,"sample_collection_date":0,"presampling_activity_details":0,"sample_received_date":0,"original_sample_description":0}
        for keys in not_controlled_samples:
            if keys in dict_of_samples['sample'][index].keys():
                not_controlled_samples[keys] = dict_of_samples['sample'][index]
                dict_sample_table[keys] = not_controlled_samples[keys]
            else:
                not_controlled_samples[keys] = "NULL"
                dict_sample_table[keys] = not_controlled_samples[keys]
            
            
            sample_table_fields[keys]=keys
        print (dict_sample_table)
        sample_id = check_exists_id(dict_of_samples['sample'][index]["sample_collector_sample_id"],"sample_collector_sample_id","sample")
        if not sample_id:
            print ("doesnt exists")
            sample_id =create_insert(dict_sample_table,sample_table_fields,"","sample",10) 
        else:
            print (contact_info_id,"exists")
            sample_id = contact_info_id[0]
        print (sample_id)

        #create_insert(dict_of_samples['sample'][index],["sample_storage_method","sample_storage_medium"],{"collection_device":"collection_device", "collection_method": "collection_method"})
        
        sys.exit()
        #host_t insert
    
    