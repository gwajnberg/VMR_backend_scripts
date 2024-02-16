

"""
    Create a dictionary of samples from the Harmonized Data "Merged Sheet".
    Each key for output dict is a new row from the sheet.
    If a term exists in the ontology, a valid value must be chosen, otherwise
    accept the text as a string.
"""
import pandas as pd
import sys
import datetime
import re
import copy



def create_dict_of_samples_one(xls, ontology_terms_and_values,antimicrobian_agent_names_ids):
    def isNaN(string):
        return string != string
    
    
    
    
    fields = pd.read_excel(xls,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)
    #print (fields[19])
    fields.fillna(0, inplace = True)
    sample_id = ""
    sample_flagged_list =[]
    for index, row in fields.iterrows():
        for i in row.index:
                        
            if (row[i] != 0 and not isNaN(row[i]) and row[i] ):

                key = i.strip()
                print(key)
        sys.exit()

    sys.exit()
    def reading_file(sheet):
        fields = pd.read_excel(xls,sheet_name=sheet,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)
        #fields_sheet_filtered = fields_sheet[fields_sheet["Ontology ID"].str.contains("GENEPIO")==True]
        if "AMR" not in sheet:
            fields_noNA=fields.dropna(axis=0, subset=['sample_collector_sample_ID'])
        else:
            fields_noNA=fields.dropna(axis=0, subset=['isolate_ID'])
        fields_sheet =fields_noNA
        fields_sheet.fillna(0, inplace = True)
        
        return(fields_sheet) 
    sample_sheet =reading_file("Sample Collection & Processing")
    isolate_sheet = reading_file("Strain and Isolate Information")
    sequence_sheet = reading_file("Sequence Information")
    amr_sheet = reading_file("AMR Phenotypic Test Information")
    risk_sheet = reading_file("Risk Assessment")
    #print (sample_sheet)
    xl = pd.ExcelFile(xls)
    new_ont_terms = copy.deepcopy(ontology_terms_and_values)
    dict_terms_file={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{}}
    terms_to_fix={}
    terms_accepting_multiple_values =["environmental_site","weather_type","available_data_types","animal_or_plant_population",
                                     "environmental_material","anatomical_material","body_product","anatomical_part","food_product",
                                     "food_product_properties","animal_source_of_food","food_packaging","purpose_of_sequencing","experimental_intervention",
                                     "pre_sampling_activity","purpose_of_sampling"]
    
    if len(xl.sheet_names) > 8:
        temp_dict={}
        
        #print (ontology_terms_and_values)
        #
        host_sheet = reading_file("Host Information")
        publicRep_sheet = reading_file("Public Repository Information")
        array_sheet = [sample_sheet,host_sheet,isolate_sheet,sequence_sheet,publicRep_sheet,amr_sheet,risk_sheet]
        #dict_terms_file={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{}}
        sample_id = ""
        sample_flagged_list =[]
        for index_sheet,sheet_from_array in enumerate(array_sheet):
            if(not sheet_from_array.empty):
                for index, row in sheet_from_array.iterrows():
                    for i in row.index:
                        
                        if (row[i] != 0 and not isNaN(row[i]) and row[i] ):

                            key = i.strip()
                            
                            key2 = key
                            print ("begin with",key2)
                            for abs in antimicrobian_agent_names_ids.keys():
                                if abs == "nalidixic acid":
                                    abs = "nalidixic_acid"
                                if abs == "oxolinic acid":
                                    abs = "oxolinic-acid"
                                if abs in key:
                                    substrL= re.match(abs+"_(.+)",key)
                                    #print (key)
                                    key2 = "antimicrobial_"+substrL.groups()[0]
                                    #print(key2)
                                    #sys.exit()
                            if (key == 'AMR_laboratory_typing_method'):
                                key2 = "antimicrobial_laboratory_typing_method"
                            if (key == 'production_stream'):
                                key2 ="food_product_production_stream"
                            cell=""
                            if key2 in terms_accepting_multiple_values:
                                print(row[i],"ready to split")
                                cell_prov=row[i].split(";")
                                print(cell_prov)
                                cell=[]
                                for sub in cell_prov:
                                    if isinstance(sub,str):
                                        cell_sub=sub.strip()
                                        cell.append(cell_sub)

                            else:
                                cell = row[i]

                                if isinstance(cell,str):
                                    cell=cell.strip()
                            print("Here_",cell)
                            if key2 == "sample_collector_sample_ID" :
                                sample_id = cell 
                            if key2 in ontology_terms_and_values.keys():
                                print("Here", key2)
                                if "terms" in ontology_terms_and_values[key2].keys():
                                    if key2 in terms_accepting_multiple_values:
                                        for index,cell_sub in enumerate(cell):
                                            flag = 0;
                                            pseudoid=""
                                            if(":" in cell_sub and "[" not in cell_sub):
                                                wanted = cell_sub.split(":")
                                                cell_sub = wanted[0]
                                                pseudoid = wanted[1]
                                   # print(ontology_terms_and_values[key]["terms"])
                                    
                                            for item in ontology_terms_and_values[key2]["terms"]:
                                                print(item)
                                                if type(item) != dict:
                                                    if cell_sub == item:
                                                        flag+=1;
                                                else:
                                                    for keyI in item.keys():
                                                        #print(type(keyI))
                                                        if cell_sub in keyI:
                                                        # print(cell,keyI)
                                                            flag+=1;
                                                            cell[index]= item[keyI]["term"]+"//"+item[keyI]["term_id"]
                                                            #print("added //",cell)
                                                            #sys.exit()
                                            if flag == 0:
                                                #print("diferent term: ",cell," with id: ",pseudoid," in field:",key)
                                                if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                                if ( cell_sub in terms_to_fix.keys()):
                                                    if (key in terms_to_fix[cell].keys()):
                                                        terms_to_fix[cell_sub][key] += 1
                                                else:
                                                    terms_to_fix[cell_sub] = {}
                                                    terms_to_fix[cell_sub] [key] = 1
                                                    ##Provisory adding terms to the ontology_terms
                                                    new_ont_terms[key]['terms'].append({cell_sub+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                                    #print(cell,ontology_terms_and_values[key])
                                                    
                                                    cell[index]= cell_sub+"//"+pseudoid
                                    else:
                                        flag = 0;
                                        pseudoid=""
                                        if(":" in cell and "[" not in cell):
                                            wanted = cell.split(":")
                                            cell = wanted[0]
                                            pseudoid = wanted[1]
                                    # print(ontology_terms_and_values[key]["terms"])
                                        
                                        for item in ontology_terms_and_values[key2]["terms"]:
                                    #print(item.keys())
                                            if type(item) != dict:
                                                if cell == item:
                                                    flag+=1;
                                            else:
                                                for keyI in item.keys():
                                                    #print(type(keyI))
                                                    if cell in keyI:
                                                    # print(cell,keyI)
                                                        flag+=1;
                                                        cell= item[keyI]["term"]+"//"+item[keyI]["term_id"]
                                                        #print("added //",cell)
                                                        #sys.exit()
                                        if flag == 0:
                                            if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                            #print("diferent term: ",cell," with id: ",pseudoid," in field:",key)
                                            if ( cell in terms_to_fix.keys()):
                                                if (key in terms_to_fix[cell].keys()):
                                                    terms_to_fix[cell][key] += 1
                                            else:
                                                terms_to_fix[cell] = {}
                                                terms_to_fix[cell] [key] = 1
                                                ##Provisory adding terms to the ontology_terms
                                                new_ont_terms[key]['terms'].append({cell+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                                #print(cell,ontology_terms_and_values[key])
                                                
                                                cell= cell+"//"+pseudoid
                            if 'date' in key:
                                last_part_of_key = key.split("_")[-1] 
                                if "date" in last_part_of_key:
                                
                                    #print (type(cell))
                                    print(cell,"before if")
                                    currentDateWithoutTime = ""
                                    
                                    if ("/" in cell):
                                        print("has /",cell)
                                        date_obj = datetime.datetime.strptime(cell, "%d/%m/%Y")
                                        currentDateWithoutTime = date_obj.strftime("%Y-%m-%d")
                                    elif("-" in cell):
                                        hyphen_count = cell.count("-")
                                        if hyphen_count == 1:
                                            datetime_object = datetime.datetime.strptime(cell, '%Y-%m')
                                            currentDateWithoutTime = datetime_object.strftime('%Y-%m')
                                        elif hyphen_count == 2:
                                            datetime_object = datetime.datetime.strptime(cell, '%Y-%m-%d')
                                            currentDateWithoutTime = datetime_object.strftime('%Y-%m-%d')
                                        
                                    else:
                                        print("int",cell)
                                        int_value = int(cell)
                                        currentDateWithoutTime = datetime.date(int_value, 1, 1)
                                        
                                    cell = currentDateWithoutTime
                                    #print('after',cell)
                            
                            print ("temp_creating",key,cell)
                            temp_dict[key]=cell    
                    #checking duplications
                    flag_dup =0
                    if index_sheet == 0:
                       # print ("checando...")
                        for index2 in dict_terms_file['sample']:
                           # print (index2,dict_terms_file['sample'][index2])
                           # print(temp_dict)
                            if dict_terms_file['sample'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID']:
                                print ("sample table duplicated:","in row:",index2,"term:",dict_terms_file['sample'][index2]['sample_collector_sample_ID']," and ","in row:",index,"term:",temp_dict['sample_collector_sample_ID'])
                                flag_dup =1
                       # print("come on:",flag_dup)
                        if (flag_dup == 0 ):
                           # print ("chegou aqui")
                            
                            dict_terms_file['sample'][index]=temp_dict
                    elif index_sheet == 1:
                        for index2 in dict_terms_file['host']:
                           # print (index2,dict_terms_file['sample'][index2])
                           # print(temp_dict)
                            if dict_terms_file['host'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID']:
                                print ("host table duplicated:","in row:",index2,"term:",dict_terms_file['host'][index2]['sample_collector_sample_ID']," and ","in row:",index,"term:",temp_dict['sample_collector_sample_ID'])
                                flag_dup =1
                       # print("come on:",flag_dup)
                        if (flag_dup == 0 ):
                           # print ("chegou aqui")
                            dict_terms_file['host'][index]=temp_dict
                    elif index_sheet == 2:
                        for index2 in dict_terms_file['isolate']:
                            if dict_terms_file['isolate'][index2]['isolate_ID'] == temp_dict['isolate_ID']:
                                print ("isolate table duplicated:","in row:",index2,"term:",dict_terms_file['isolate'][index2]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                                flag_dup =1
                        if (flag_dup == 0 ):
                            dict_terms_file['isolate'][index]=temp_dict
                    elif index_sheet == 3:
                        subflag_dup =0
                        index_save = "y"
                        for index2 in dict_terms_file['sequence']:
                            if dict_terms_file['sequence'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                                for keys_temp in temp_dict:
                                    if temp_dict[keys_temp] != dict_terms_file['sequence'][index2][keys_temp]:
                                        subflag_dup = 1
                                    else:
                                        flag_dup = 1
                                        index_save = index2
                        if subflag_dup == 1:
                            flag_dup =0
                        else:
                            if (index_save != "y"): 
                                print ("sequence table duplication:","in row:",index_save,"term:",dict_terms_file['sequence'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                        if flag_dup ==0:
                            dict_terms_file['sequence'][index]=temp_dict
                    elif index_sheet == 4:
                        subflag_dup =0
                        index_save = "y"
                        for index2 in dict_terms_file['publicRep']:
                            if dict_terms_file['publicRep'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                                for keys_temp in temp_dict:
                                    if temp_dict[keys_temp] != dict_terms_file['publicRep'][index2][keys_temp]:
                                        subflag_dup = 1
                                    else:
                                        flag_dup = 1
                                        index_save = index2
                        if subflag_dup == 1:
                            flag_dup =0
                        else:
                            if (index_save != "y"): 
                                print ("public rep table duplication:","in row:",index_save,"term:",dict_terms_file['publicRep'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                        if flag_dup ==0:
                            dict_terms_file['publicRep'][index]=temp_dict
                    elif index_sheet == 5:
                            subflag_dup =0
                            index_save = "y"
                            for index2 in dict_terms_file['AMR']:
                                if dict_terms_file['AMR'][index2]['isolate_ID'] == temp_dict['isolate_ID']:
                                    for keys_temp in temp_dict:
                                        if temp_dict[keys_temp] != dict_terms_file['AMR'][index2][keys_temp]:
                                            subflag_dup = 1
                                        else:
                                            flag_dup = 1
                                            index_save = index2
                            if subflag_dup == 1:
                                flag_dup =0
                            else:
                                if (index_save != "y"): 
                                    print ("AMR table duplication:","in row:",index_save,"term:",dict_terms_file['AMR'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                            if flag_dup ==0:
                                dict_terms_file['AMR'][index]=temp_dict
                            
                    elif index_sheet == 6:
                        subflag_dup =0
                        index_save = "y"
                        for index2 in dict_terms_file['risk']:
                            if dict_terms_file['risk'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                                for keys_temp in temp_dict:
                                    if temp_dict[keys_temp] != dict_terms_file['risk'][index2][keys_temp]:
                                        subflag_dup = 1
                                    else:
                                        flag_dup = 1
                                        index_save = index2
                        if subflag_dup == 1:
                            flag_dup =0
                        else:
                            if (index_save != "y"): 
                                print ("Risk table duplication:","in row:",index_save,"term:",dict_terms_file['risk'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                        if flag_dup ==0:
                            dict_terms_file['risk'][index]=temp_dict
                    print(temp_dict)
                    temp_dict ={}
        #print(dict_terms_file)
        #sys.exit()
    else:
        temp_dict={}
        #print("here")
        #sys.exit()
        array_sheet = [sample_sheet,isolate_sheet,sequence_sheet,amr_sheet,risk_sheet]
        #print (ontology_terms_and_values)
       # sys.exit()
        #={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{}}
        #dict_terms_file={'sample':{},'isolate':{},'sequence':{},'AMR':{},'risk':{}}
        sample_id = ""
        sample_flagged_list =[]
        for index_sheet,sheet_from_array in enumerate(array_sheet):
            if(not sheet_from_array.empty):
                
                for index, row in sheet_from_array.iterrows():
                    #print(index, "number row")
                    #print(row.index)
                    #sys.exit()
                    for i in row.index:
                        if (row[i] != 0 and not isNaN(row[i]) and row[i] ):
                            key = i.strip()
                            if ("geo_loc (country)" in key):
                                key = "geo_loc_name (country)"
                            if ("geo_loc (state/province/region)" in key):
                                key = "geo_loc_name (state/province/region)"  
                            if ("sample_processing" in key):
                                key = "specimen_processing"
                            key2 = key
                            for abs in antimicrobian_agent_names_ids.keys():
                                if abs == "nalidixic acid":
                                    abs = "nalidixic_acid"
                                if abs == "oxolinic acid":
                                    abs = "oxolinic-acid"
                                if abs in key:
                                    substrL= re.match(abs+"_(.+)",key)
                                    #print (key)
                                    key2 = "antimicrobial_"+substrL.groups()[0]
                                    #print(key2)
                                    #sys.exit()
                            if (key == 'AMR_laboratory_typing_method'):
                                key2 = "antimicrobial_laboratory_typing_method"
                            if (key == 'production_stream'):
                                key2 ="food_product_production_stream"

                            cell=""
                            #print("debugging_here")
                            #print (key,row[i])
                            if key2 in terms_accepting_multiple_values:
                                cell_prov=row[i].split(";")
                               # print(cell_prov)
                                cell=[]
                                for sub in cell_prov:
                                    if isinstance(sub,str):
                                        cell_sub=sub.strip()
                                        cell.append(cell_sub)

                            else:
                                cell = row[i]

                                if isinstance(cell,str):
                                    cell=cell.strip()
                            
                            
                            #print(cell,"here")
                            flag_to_discard = 0
                            #print (ontology_terms_and_values)
                            #sys.exit()
                            if key2 == "sample_collector_sample_ID" :
                                sample_id = cell
                            if key2 in ontology_terms_and_values.keys():
                                
                                if "terms" in ontology_terms_and_values[key2].keys():
                                    if key2 in terms_accepting_multiple_values:
                                        for index3,cell_sub in enumerate(cell):
                                            flag = 0;
                                            pseudoid=""
                                            if(":" in cell_sub and "[" not in cell_sub):
                                                wanted = cell_sub.split(":")
                                                cell_sub = wanted[0]
                                                pseudoid = wanted[1]
                                        # print(ontology_terms_and_values[key]["terms"])
                                            
                                            for item in ontology_terms_and_values[key2]["terms"]:
                                        #print(item.keys())
                                                
                                                if type(item) != dict:
                                                    if cell_sub == item:
                                                        flag+=1;
                                                else:
                                                    for keyI in item.keys():
                                                        #print(type(keyI))
                                                        if cell_sub in keyI:
                                                        # print(cell,keyI)
                                                            flag+=1;
                                                        #    print(item[keyI])
                                                            cell[index3]=item[keyI]["term"]+"//"+item[keyI]["term_id"]
                                                            #print("added //",cell)
                                                            #sys.exit()
                                            
                                            
                                            if flag == 0:
                                                flag2 = 0
                                                                            
                                                if flag2 == 0:
                                                    flag_to_discard += 1
                                                    if ( cell_sub in terms_to_fix.keys()):
                                                        if (key in terms_to_fix[cell_sub].keys()):
                                                            terms_to_fix[cell_sub][key] += 1
                                                            if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                                    else:
                                                        terms_to_fix[cell_sub] = {}
                                                        terms_to_fix[cell_sub] [key] = 1
                                                        if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                                        ##Provisory adding terms to the ontology_terms
                                                        new_ont_terms[key2]['terms'].append({cell_sub+"//"+pseudoid:{'term': cell_sub, 'term_id': pseudoid}})
                                                        #print(cell,ontology_terms_and_values[key])
                                                        
                                                        cell[index3]=cell_sub+"//"+pseudoid
                                    else:
                                        flag = 0;
                                        pseudoid=""
                                        if(":" in cell and "[" not in cell):
                                            wanted = cell.split(":")
                                            cell = wanted[0]
                                            pseudoid = wanted[1]
                                    # print(ontology_terms_and_values[key]["terms"])
                                        
                                        for item in ontology_terms_and_values[key2]["terms"]:
                                    #print(item.keys())
                                            
                                            if type(item) != dict:
                                                if cell == item:
                                                    flag+=1;
                                            else:
                                                for keyI in item.keys():
                                                    #print(type(keyI))
                                                    if cell in keyI:
                                                    # print(cell,keyI)
                                                        flag+=1;
                                                    #    print(item[keyI])
                                                        cell= item[keyI]["term"]+"//"+item[keyI]["term_id"]
                                                        #print("added //",cell)
                                                        #sys.exit()
                                        
                                        
                                        if flag == 0:
                                            flag2 = 0
                                                                        
                                            if flag2 == 0:
                                                flag_to_discard += 1
                                                if ( cell in terms_to_fix.keys()):
                                                    if (key in terms_to_fix[cell].keys()):
                                                        terms_to_fix[cell][key] += 1
                                                        if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                                else:
                                                    terms_to_fix[cell] = {}
                                                    terms_to_fix[cell] [key] = 1
                                                    if sample_id not in sample_flagged_list:
                                                                sample_flagged_list.append(sample_id)
                                                    ##Provisory adding terms to the ontology_terms
                                                    new_ont_terms[key2]['terms'].append({cell+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                                    #print(cell,ontology_terms_and_values[key])
                                                    
                                                    cell= cell+"//"+pseudoid
                            if 'date' in key:
                                
                                #print (type(cell))
                               # print(cell, "here?")
                                if 'precision' not in key:
                                    #print (cell)
                                    currentDateWithoutTime = cell.strftime('%Y-%m-%d')
                                   # print(cell)
                                    cell = currentDateWithoutTime
                                #print('after',cell)
                            
                            if flag_to_discard == 0:
                      #          print(cell)
                                temp_dict[key]=cell
                            #keeping also terms not in the voc.
                            else:
                                temp_dict[key]=cell     
                    #checking duplications
                    
                    flag_dup =0
                    if index_sheet == 0:
                       # print ("checando...")
                        for index2 in dict_terms_file['sample']:
                           # print (index2,dict_terms_file['sample'][index2])
                           # print(temp_dict)
                            if dict_terms_file['sample'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID']:
                                print ("sample table duplicated:","in row:",index2,"term:",dict_terms_file['sample'][index2]['sample_collector_sample_ID']," and ","in row:",index,"term:",temp_dict['sample_collector_sample_ID'])
                                flag_dup =1
                       # print("come on:",flag_dup)
                        if (flag_dup == 0 ):
                            #print ("chegou aqui",index)
                            dict_terms_file['sample'][index]=temp_dict
                            dict_terms_file['host'][index]=temp_dict
                    elif index_sheet == 1:
                        for index2 in dict_terms_file['isolate']:
                            if dict_terms_file['isolate'][index2]['isolate_ID'] == temp_dict['isolate_ID']:
                                print ("isolate table duplicated:","in row:",index2,"term:",dict_terms_file['isolate'][index2]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                                flag_dup =1
                        if (flag_dup == 0 ):
                            dict_terms_file['isolate'][index]=temp_dict
                    elif index_sheet == 2:
                        subflag_dup =0
                        index_save = "y"
                        for index2 in dict_terms_file['sequence']:
                            if dict_terms_file['sequence'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                                for keys_temp in temp_dict:
                                    if temp_dict[keys_temp] != dict_terms_file['sequence'][index2][keys_temp]:
                                        subflag_dup = 1
                                    else:
                                        flag_dup = 1
                                        index_save = index2
                        if subflag_dup == 1:
                            flag_dup =0
                        else:
                            if (index_save != "y"): 
                                print ("sequence table duplication:","in row:",index_save,"term:",dict_terms_file['sequence'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                        if flag_dup ==0:
                            dict_terms_file['sequence'][index]=temp_dict
                            dict_terms_file['publicRep'][index]=temp_dict
                            
                    elif index_sheet == 3:
                            subflag_dup =0
                            index_save = "y"
                            for index2 in dict_terms_file['AMR']:
                                if dict_terms_file['AMR'][index2]['isolate_ID'] == temp_dict['isolate_ID']:
                                    for keys_temp in temp_dict:
                                        if temp_dict[keys_temp] != dict_terms_file['AMR'][index2][keys_temp]:
                                            subflag_dup = 1
                                        else:
                                            flag_dup = 1
                                            index_save = index2
                            if subflag_dup == 1:
                                flag_dup =0
                            else:
                                if (index_save != "y"): 
                                    print ("AMR table duplication:","in row:",index_save,"term:",dict_terms_file['AMR'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
                            if flag_dup ==0:
                                dict_terms_file['AMR'][index]=temp_dict
                            
                    elif index_sheet == 4:
                        subflag_dup =0
                        index_save = "y"
                        for index2 in dict_terms_file['risk']:
                            if dict_terms_file['risk'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID'] :
                                for keys_temp in temp_dict:
                                    if temp_dict[keys_temp] != dict_terms_file['risk'][index2][keys_temp]:
                                        subflag_dup = 1
                                    else:
                                        flag_dup = 1
                                        index_save = index2
                        if subflag_dup == 1:
                            flag_dup =0
                        else:
                            if (index_save != "y"): 
                                print ("Risk table duplication:","in row:",index_save,"term:",dict_terms_file['risk'][index_save]['sample_collector_sample_ID']," and ","in row:",index,"term:",temp_dict['sample_collector_sample_ID'])
                        if flag_dup ==0:
                            dict_terms_file['risk'][index]=temp_dict
                    #if(dict_terms_file['AMR']):
  #                      print (dict_terms_file)
  #                      sys.exit()
                    temp_dict ={}
 
                            
                
            
        
    countEvents =0
    if terms_to_fix:
        for termE in terms_to_fix:
            for fieldE in terms_to_fix[termE]:
                print ("The term:",termE," in the field:",fieldE," is different from the vocabulary and appears ",terms_to_fix[termE][fieldE]," times")
                countEvents+=1
    print("A total of terms different from the vocabulary:",countEvents)
    print('done dict of terms')
    #print(dict_terms_file)
    #sys.exit()
    
    #print(dict_terms_file['sample'])
    #sys.exit()
    
    return(dict_terms_file,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list)


