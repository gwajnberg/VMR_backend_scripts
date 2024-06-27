import pandas as pd
import json
import psycopg2
import sys

def connect_db():
    conn = psycopg2.connect(
       #server
       #database="metabaseappdb", user='gabriel', password='gaba1984', host='10.139.14.109', port= '5433'
        #local
        database="metabaseappdb", user='gwajnberg', password='gaba1984', host='localhost', port= '5432'
        

    )
    print("Connection to PostgreSQL established successfully")
    cursor = conn.cursor()
    return(conn,cursor)
    
    
def get_id(word,column,term,table,conn,cursor):
    sql_query = """
                     SELECT {}
                     FROM {} 
                     WHERE {} = %s;
                """.format(term,table, column.upper())
                    
                
    #print (sql_query,(word))
    cursor.execute(sql_query, (word,))
    result = cursor.fetchone()
    #print(result,"here")
    conn.commit()
    return(result[0])
def get_value(term,table,known_column,known_term,controlled_table,controlled_field,data_ont,conn,cursor):
    #print (term,table)
    
    if (controlled_table):
        sql_query=''
        if (data_ont == 'yes'):
            sql_query = """
                        SELECT {}, ONTOLOGY_ID
                        FROM {}
                        WHERE ID IN (SELECT {} FROM {} WHERE {} = %s);


                        """.format(controlled_field, controlled_table,term,table,known_column.upper())
        else:
           sql_query = """
                        SELECT {}
                        FROM {}
                        WHERE ID IN (SELECT {} FROM {} WHERE {} = %s);


                        """.format(controlled_field, controlled_table,term,table,known_column.upper())
        print (sql_query,(known_term,))
        cursor.execute(sql_query,(known_term,))
        print(cursor)
        result = cursor.fetchall()
        conn.commit()
        #print(result)
        #sys.exit()
        return(result)
    else:
        sql_query = """
                    SELECT {}
                    FROM {}
                    WHERE {} = %s;



                """.format(term,table,known_column.upper())
        #print (sql_query,(known_term,))
        cursor.execute(sql_query, (known_term,))
        result = cursor.fetchone()
        conn.commit()
        #print(result)
        return(result[0])
    



def read_json(file_path):
    with open(file_path, 'r') as file:
        data = json.load(file)
    return data

def two_fields(data,known_term,id,conn,cursor):
    value =''
    for db_keys in data:
        print (db_keys)
        query = get_value (db_keys,data[db_keys]["parent_table"],known_term,id,data[db_keys]["child_table"],data[db_keys]["field"],data[db_keys]["ont_id"],conn,cursor)
        if (value):
            value += "; "
        if len(query) == 1:
                if (len(query[0]) == 2):
                    value += query[0][0]+" ["+query[0][1]+"]"
                    #print (value)
                    
                else:
                    value += query[0][0]
                #print(value)
                
                #print(template)
        else:
            for inx,result in enumerate(query):
                if (len(result) == 2):
                    value += result[0]+" ["+result[1]+"]"
                    print (value)
                
                else:
                    value += result[0]
                if (inx != len(query)):
                    value +="; "
    return(value)

def one_reg_field(data,keys_enteric,dict_ids,conn,cursor):
    key = data['key']
                    #print (key)
    for db_keys in data:
        if db_keys != 'controlled' and db_keys != 'key' and db_keys != 'ont_id' and db_keys != 'type':

            if (data[db_keys] == 'isolates'):
                key = 'id'
                dict_ids['id']=dict_ids['isolate_id']
            if (data[db_keys] == 'sequencing'):
                key = 'id'
                dict_ids['id']=dict_ids['sequencing_id']

            if (keys_enteric =='project_name'):
                key = 'id'
                dict_ids['id']=dict_ids['sample_plan_id']
            if (data['controlled']):
                print('Here_controlled')
                query = get_value (db_keys,data[db_keys],key,dict_ids[key],data['controlled']['table'],data['controlled']['field'],data["ont_id"],conn,cursor)
                print(query,"here")
                value = ''
                if len(query) == 1:
                    if (data["ont_id"] == "yes"):
                        value = query[0][0]+" ["+query[0][1]+"]"
                        print (value)
                        
                    else:
                        value = query[0][0]
                    print(value)
                    return(value)
                    
                else:
                    for inx,result in enumerate(query):
                        if (data['type']):
                            flag =0
                            for keys in data['type']:
                                if (result[0] in keys):
                                    flag =1
                            if flag == 1:
                            
                                if (data["ont_id"] == "yes"):
                                    value += result[0]+" ["+result[1]+"]"
                                    print (value)
                            
                                else:
                                    value += result[0]
                                if (inx != len(query)):
                                    value +="; "
                                print(value)
                                #return(value)
                            
                        else:
                            if (data["ont_id"] == "yes"):
                                value += result[0]+" ["+result[1]+"]"
                                print (value)
                            
                            else:
                                value += result[0]
                            if (inx != len(query)):
                                value +="; "
                            print(value)
                    return(value)
                        #print(template)
                    #sys.exit()
                #sys.exit()
            else:
                
                

                value = get_value (db_keys,data[db_keys],key,dict_ids[key],"","","",conn,cursor)
                return(value)
                    

def read_file(file, category):
    print (file)
    df = pd.read_csv(file, sep='\s+', header=None, engine='python')
    
    template = pd.read_csv("/home/gwajnberg/vmr_old_project/grdi-amr2/conversion_vmr_ncbi/data/OneHealthEnteric.1.0.tsv", sep='\t',header=10)
    template.columns = template.columns.str.replace('*', '', regex=False)
    #print(template)

    
    # Check the number of columns
    num_columns = df.shape[1]
    data = read_json("/home/gwajnberg/vmr_old_project/grdi-amr2/conversion_vmr_ncbi/data/schema_one_health_enteric.json")
    conn,cursor = connect_db()
    for index, row in df.iterrows():
       
        if num_columns == 2:
            dict_ids={
            'isolate_id':'',
            'sample_id':'',
            'sequencing_id':''
            }
            template.at[index, 'source_type'] = category
            for keys_enteric in data:
                if (keys_enteric == 'sample_name'):
                    sample_name = row[0]+"-"+row[1]
                    template.at[index, 'sample_name'] = sample_name
                    dict_ids['isolate_id']=get_id(row[1],'isolate_ID','id','isolates',conn,cursor)
                    dict_ids['sample_id'] = get_id(row[0],'sample_collector_sample_ID','id','samples',conn,cursor)
                    dict_ids['sequencing_id'] = get_id(dict_ids['isolate_id'],'isolate_id','sequencing_id','wholegenomesequencing',conn,cursor)
                    dict_ids['food_data'] = get_id(dict_ids['sample_id'],'sample_id','id','food_data',conn,cursor)
                   # print ('HEREEEE')
                    dict_ids['sample_plan_id'] = get_id(row[0],'sample_collector_sample_ID','sample_plan','samples',conn,cursor)
                    dict_ids['collection_information'] = get_id(dict_ids['sample_id'],'sample_id','id','collection_information',conn,cursor)
                    #print ('ferro')
                    #print (sample_id)
                    #print (sequencing_id)
                    #sys.exit()

                   # sys.exit()
                
                elif (keys_enteric == 'geo_loc_name'):
                    list_of_terms=[]
                    for db_keys in data[keys_enteric]:
                        query = get_value (db_keys,data[keys_enteric][db_keys]["parent_table"],'sample_id',dict_ids['sample_id'],data[keys_enteric][db_keys]["child_table"],data[keys_enteric][db_keys]["field"],data[keys_enteric][db_keys]["ont_id"],conn,cursor)
                        
                        list_of_terms.append(query[0][0])
                    value = ""
                    print(list_of_terms)
                    
                    if (len(list_of_terms) > 1):
                        value = ':'.join(list_of_terms)
                    else:
                        value = list_of_terms[0]
                    
                    template.at[index, keys_enteric] = value
                    print(template)
                    #sys.exit()
                elif (keys_enteric  == "isolation_source"):
                    if (category == 'food'):
                        value = two_fields(data[keys_enteric]['food'],'food_data',dict_ids['food_data'],conn,cursor)
                        '''
                        value =''
                        for db_keys in data[keys_enteric]['food']:
                            print (db_keys)
                            query = get_value (db_keys,data[keys_enteric]['food'][db_keys]["parent_table"],'food_data',dict_ids['food_data_id'],data[keys_enteric]['food'][db_keys]["child_table"],data[keys_enteric]['food'][db_keys]["field"],conn,cursor)
                            if (value):
                                value += "; "
                            if len(query) == 1:
                                    if (len(query[0]) == 2):
                                        value += query[0][0]+" ["+query[0][1]+"]"
                                        #print (value)
                                        
                                    else:
                                        value += query[0][0]
                                    #print(value)
                                    
                                    #print(template)
                            else:
                                for inx,result in enumerate(query):
                                    if (len(result) == 2):
                                        value += result[0]+" ["+result[1]+"]"
                                        print (value)
                                    
                                    else:
                                        value += result[0]
                                    if (inx != len(query)):
                                        value +="; "
                                    #print(value)
                                    
                                    #print(template)
                            #print (query,"here")
                        #print(value)
                        '''
                        template.at[index, keys_enteric] = value
                        #print(template)
                        #sys.exit()    
                elif (keys_enteric != 'specific_data'):
                    template.at[index, keys_enteric]  = one_reg_field(data[keys_enteric],keys_enteric,dict_ids,conn,cursor)
                    '''
                    key = data[keys_enteric]['key']
                    #print (key)
                    for db_keys in data[keys_enteric]:
                        if db_keys != 'controlled' and db_keys != 'key' and db_keys != 'ont_id':

                            if (data[keys_enteric][db_keys] == 'isolates'):
                                key = 'id'
                                dict_ids['id']=dict_ids['isolate_id']
                            if (data[keys_enteric][db_keys] == 'sequencing'):
                                key = 'id'
                                dict_ids['id']=dict_ids['sequencing_id']

                            if (keys_enteric =='project_name'):
                                key = 'id'
                                dict_ids['id']=dict_ids['sample_plan_id']
                            if (data[keys_enteric]['controlled']):
                                print('Here_controlled')
                                query = get_value (db_keys,data[keys_enteric][db_keys],key,dict_ids[key],data[keys_enteric]['controlled']['table'],data[keys_enteric]['controlled']['field'],conn,cursor)
                                print(query,"here")
                                value = ''
                                if len(query) == 1:
                                    if (data[keys_enteric]["ont_id"] == "yes"):
                                        value = query[0][0]+" ["+query[0][1]+"]"
                                        print (value)
                                        
                                    else:
                                        value = query[0][0]
                                    print(value)
                                    template.at[index, keys_enteric] = value
                                    print(template)
                                else:
                                    for inx,result in enumerate(query):
                                        if (data[keys_enteric]["ont_id"] == "yes"):
                                            value += result[0]+" ["+result[1]+"]"
                                            print (value)
                                        
                                        else:
                                            value += result[0]
                                        if (inx != len(query)):
                                            value +="; "
                                        print(value)
                                        template.at[index, keys_enteric] = value
                                        print(template)
                                
                                #sys.exit()
                            else:
                                
                                    value = get_value (db_keys,data[keys_enteric][db_keys],key,dict_ids[key],"","",conn,cursor)
                                    template.at[index, keys_enteric] = value
                                    print(template)
                    '''
                    
                else:
                    
                    if (category == 'food'):
                        for key_enteric_true in data[keys_enteric]['food']:
                            print(key_enteric_true)
                            if (key_enteric_true  == "food_product_type"):
                                template.at[index, key_enteric_true] = two_fields(data[keys_enteric]['food']['food_product_type'],'food_data',dict_ids['food_data'],conn,cursor)
                                 
                            else:
                                template.at[index, key_enteric_true]  = one_reg_field(data[keys_enteric]['food'][key_enteric_true],key_enteric_true,dict_ids,conn,cursor)
                            
                            print (key_enteric_true)
                        
                                #sys.exit()
    return(template)              
        

    #print (num_columns)