import sys
import datetime
import re


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
            values += "NULL"
        else:
            values += "'"+str(term)+"'"
      #  print ('after',values)
        if (count +1 != length):
            values += ","
        
        return(values)
    def create_insert (row,fields,controlled_fields,table_name,length):
        column_ins = "("
        count=0
        values ="("
        for field in fields.keys():
            if field in row.keys():
          
                terms = getTermAndId(row[field])
              
                field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)
                if field in controlled_fields.keys():
                    values += "(SELECT id from "+controlled_fields[field]+" where "+field.upper()+" = '"+row[field]+"')"
                    if (count +1 != length):
                        values += ","
                else:
                    values += valuesIns(values,terms,count,length)
                
            else:
               # print('before2',fields)
                field = fix(field)
               # print(fields)
                column_ins = columnIns(column_ins,fields[field],count,length)
                values = valuesIns(values,"NULL",count,length)
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        insert = "INSERT INTO "+table_name.upper()+column_ins+" VALUES "+values
        print (insert)
    #print(dict_of_samples['sample'][index].keys())
    for index in dict_of_samples['sample']:
        print(dict_of_samples['sample'][index].keys())
        #sys.exit()
        create_insert(dict_of_samples['sample'][index],{"sample_collected_by":"agency","sample_collector_contact_name":"contact_name","sample_collected_by_laboratory_name":"laboratory_name","sample_collector_contact_email":"contact_email"},{"sample_collected_by":"agency"},"contact_information",4)
        #create_insert(dict_of_samples['sample'][index],["sample_storage_method","sample_storage_medium"],{"collection_device":"collection_device", "collection_method": "collection_method"})
        
        sys.exit()
        #host_t insert
    
    