# -*- coding: utf-8 -*-
"""
Created on Thu Nov 10 09:48:07 2022

@author: wajnbergg
"""

#from azure.cosmos import CosmosClient, PartitionKey
import psycopg2
import pandas as pd
import sys
import datetime
import re
import copy
import argparse
from parsing_owl import owl_parsing
from parsing_card_json import card_parsing
from parsing_rgimob_output import parse,insert_data
from sensititre import sensititre


#function to check Nan strings
def isNaN(string):
    return string != string
"""
def get_file():
    
    if len(sys.argv) > 1:
        return sys.argv[1]
    else:
        #return "Baseline Survey Harmonized Version 2022-04-22.xlsx"
        #return "GRDI_Harmonization-Template_v3.1.0.xlsx"
        return ("Baseline Survey Harmonized Version 2022-04-22.xlsx")
"""
def create_ontology_as_dict(xls):
    """
    Create a dictionary of the ontology terms.
    Looking at having the terms defined here, with possible sets of values.
    In the current sheet, the terms are in row 2, with samples in following rows.
    We will add actual data based on this dictionary from a separate function.
    Possibility to read this from a curated file of terms, or the xls sheet.
    """
    #print("here")
    def isNaN(string):
        return string != string
    def reading_file(sheet):
        fields = pd.read_excel(xls,sheet_name=sheet,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)
        #fields_sheet_filtered = fields_sheet[fields_sheet["Ontology ID"].str.contains("GENEPIO")==True]
        array_terms =[]
        if "AMR" not in sheet:
            fields_noNA=fields.dropna(axis=0, subset=['sample_collector_sample_ID'])
        else:
            fields_noNA=fields.dropna(axis=0, subset=['isolate_ID'])
        fields_sheet =fields_noNA
        columns = list(fields_sheet.columns.values)
        for terms in columns:
            array_terms.append(terms)
        return(array_terms)
    
    sampleT_terms = reading_file("Sample Collection & Processing")
    isolateT_terms = reading_file("Strain and Isolate Information")
    hostT_terms = reading_file("Host Information")
    sequenceT_terms = reading_file("Sequence Information")
    repositoryT_terms = reading_file("Public Repository Information")
    riskT_terms = reading_file("Risk Assessment")
    amrTotal_terms= reading_file("AMR Phenotypic Test Information")
   
    antiT_terms=amrTotal_terms[9:]

    amrT_terms=amrTotal_terms[:9]
    
    
    
            
    
    vocab_sheet = pd.read_excel(xls,keep_default_na=False,converters={column: lambda x: x.strip() for column in list(range(20))}, sheet_name="Vocabulary", header=1)
    #vocab_sheet_noNA=vocab_sheet.dropna()
    #print(vocab_sheet)
    #sys.exit()
    
    #vocab_sheet2=[ v.dropna().to_dict() for k,v in vocab_sheet.iterrows() ]
    #print(vocab_sheet2)
    ontology_dict = vocab_sheet.to_dict(orient='list')
    #adding columns that differentiate later on
    #ontology_dict['food_product_origin geo_loc_name (country)'] = ontology_dict['food_product_origin geo_loc (country)']
    #ontology_dict['host_origin geo_loc_name (country)'] = ontology_dict['host_origin geo_loc (country)']
    #for keys in ontology_dict:
       # print (keys)
    #sys.exit()
    fields_sheet = pd.read_excel(xls,keep_default_na=False, sheet_name="Reference Guide", header=4)
    #fields_sheet_filtered = fields_sheet[fields_sheet["Ontology ID"].str.contains("GENEPIO")==True]
    fields_sheet_filtered = fields_sheet[(fields_sheet["Ontology ID"].str.contains("GENEPIO")) | (fields_sheet.iloc[:, 0].str.startswith("antimicrobial"))]
    #fields_sheet_filtered2 = fields_sheet[fields_sheet['Sample collection and processing'].str.contains("antibiotic")==True]
   # print(fields_sheet_filtered2['Sample collection and processing'] )
   # sys.exit()
    #print(fields_sheet_filtered['Sample collection and processing'])
    #sys.exit()
    dict_fields={}
    print(type(fields_sheet_filtered))
    for index, row in fields_sheet_filtered.iterrows():
        sample_key = row["Sample collection and processing"]
        dict_fields[sample_key] = {
        "Ontology ID": row["Ontology ID"],
        "Definition": row["Definition"],
        "Guidance": row["Guidance"],
        "Examples": row["Examples"]
        }

    #dict_fields = dict (zip(fields_sheet_filtered['Sample collection and processing'], fields_sheet_filtered['Ontology ID']))
   # print(dict_fields)
    #sys.exit()
    new_merged_ontology_dict = {}
    dict_foodon = owl_parsing()
    card_terms = card_parsing()
                
   # print (dict_fields)
    #sys.exit()
    #for element in fields_sheet_filtered2['Sample collection and processing']:
    #    dict_fields[element.replace("antimicrobial","AMR")] = "none"
    for key in dict_fields:
        print ("general",key)
        keypr = ""
        if (key == "antimicrobial_resistance_phenotype"):
            keypr = "antimicrobial_phenotype"
        else:
            keypr = key
        if keypr in ontology_dict.keys():
            str_list = list(filter(None, ontology_dict[keypr]))
            print("in hash", key)
            #if("urement_units" in key):
            #    print (str_list)
             #   sys.exit()
            temp_list=[];
            for i in str_list:
                newstr = i.strip()
                if re.match(".+\[\w",newstr):
                    
                    substrL= re.match("(.+)\s+\[(\S+)\]",newstr)
                    
                    
                    temp_list.append({newstr:{"term":substrL.groups()[0],"term_id":substrL.groups()[1]}})
                   

                        #sys.exit()
                    #print("append",newstr)
                else:
                 #   print("append",newstr)
                    temp_list.append(newstr)
                    #print (newstr)
            #if("measurement_units" in key):
                #print (str_list)
              #  sys.exit()
            #print(temp_list)
            new_merged_ontology_dict [key] = {"field_id":dict_fields[key]['Ontology ID'],"Definition": dict_fields[key]['Definition'],"Guidance": dict_fields[key]['Guidance'],"Examples": dict_fields[key]['Examples'],"terms":temp_list}
                    
        else:
            #if (key == "food_product_origin geo_loc_name (country)"):
                #food_product_origin geo_loc_name (country)
                #food_product_origin geo_loc (country)
                #print (ontology_dict.keys())
                #sys.exit()
            new_merged_ontology_dict [key] = {"field_id":dict_fields[key]['Ontology ID'],"Definition": dict_fields[key]['Definition'],"Guidance": dict_fields[key]['Guidance'],"Examples": dict_fields[key]['Examples']}
    #print(new_merged_ontology_dict)
    #sys.exit()
    new_merged_ontology_dict['foodon_terms'] = []
    for food_ids in dict_foodon:
        master_str = dict_foodon[food_ids] +" ["+food_ids+"]"
        new_merged_ontology_dict['foodon_terms'].append({master_str:{"terms":dict_foodon[food_ids],"term_id":food_ids}})
    new_merged_ontology_dict['card_terms'] = []
    for cardterms in card_terms.keys():
        flag = 0
        for elements in new_merged_ontology_dict["antimicrobial_agent_name"]["terms"]:
            for keys in elements:
                antibiotics = elements[keys]['term'].lower()
                if cardterms == antibiotics:
                    
                    flag=1
        if flag ==0:
            new_merged_ontology_dict['card_terms'].append({cardterms:{"terms":cardterms}})
    #sys.exit()
   # print(new_merged_ontology_dict)
    #sys.exit()
    # We need to curate some of the lists for now
    # This curation is below
    #ontology_dict['purpose_of_sampling'] = [i.replace('Cluster/Outbreak','Cluster') for i in ontology_dict['purpose_of_sampling']]
   # ontology_dict['purpose_of_sequencing'] = [i.replace('Cluster/Outbreak','Cluster') for i in ontology_dict['purpose_of_sequencing']]
    #ontology_dict['geo_loc (country)'] = ontology_dict['geo_loc_name (country)']
    
    #ontology_dict['host_origin geo_loc (country)'] = ontology_dict['geo_loc_name (country)']
    #ontology_dict['sample_processing'] = ontology_dict['specimen_processing']
    #ontology_dict['geo_loc (state/province/region)'] = ontology_dict['geo_loc_name (state/province/region)']
    
    # For example, check a specific country
   # print('Canada' in ontology_dict['food_product_origin geo_loc (country)'])
    #sys.exit()
    
    antimicrobian_agent_names_ids = {}
    for elements in new_merged_ontology_dict["antimicrobial_agent_name"]["terms"]:
        for keys in elements:
            antibiotics = elements[keys]['term'].lower()
            if(antibiotics == 'amoxicillin-clavulanic'):
                antibiotics = 'amoxicillin-clavulanic_acid'
            antimicrobian_agent_names_ids [antibiotics]= elements[keys]['term_id']
            
    #adding extra antibiotics that aren't in the vocabulary
    antimicrobian_agent_names_ids ['amikacin']= 'CHEBI:2637'
    antimicrobian_agent_names_ids ['kanamycin']= 'CHEBI:6104'
    
   
    #sys.exit()
    return (new_merged_ontology_dict,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms)

def create_dict_of_samples(xls, ontology_terms_and_values,antimicrobian_agent_names_ids):
    """
    Create a dictionary of samples from the Harmonized Data "Merged Sheet".
    Each key for output dict is a new row from the sheet.
    If a term exists in the ontology, a valid value must be chosen, otherwise
    accept the text as a string.
    """

    # The merged sheet has categories in row 0, we need the column heading in row 1
    #old merged_sheet
    #merged_sheet = pd.read_excel(xls, sheet_name="Merged Sheet",na_values=["1900-01-01","Missing","missing"],keep_default_na=False,converters={'sample_collection_date': lambda x: x.strftime('%Y-%m-%d'),'isolation_date': lambda x: x.strftime('%Y-%m-%d'),'sample_received_date':lambda x: x.strftime('%Y-%m-%d'),'isolate_received_date':lambda x: x.strftime('%Y-%m-%d')}, header=1)
    #cathy sheet has some 0 and NaN if we use the dropna we lose data
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
    #print("COME ON")
    #print(xl.sheet_names)
    
    new_ont_terms = copy.deepcopy(ontology_terms_and_values)
    dict_terms_file={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{}}
    terms_to_fix={}
    if len(xl.sheet_names) > 8:
        temp_dict={}
        
        #print (ontology_terms_and_values)
        #
        host_sheet = reading_file("Host Information")
        publicRep_sheet = reading_file("Public Repository Information")
        array_sheet = [sample_sheet,host_sheet,isolate_sheet,sequence_sheet,publicRep_sheet,amr_sheet,risk_sheet]
        #dict_terms_file={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{}}
        for index_sheet,sheet_from_array in enumerate(array_sheet):
            if(not sheet_from_array.empty):
                for index, row in sheet_from_array.iterrows():
                    for i in row.index:
                        
                        if (row[i] != 0 and not isNaN(row[i]) and row[i] ):
                            key = i.strip()
                            
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
                            cell=row[i]
                            print(cell)
                            if isinstance(cell,str):
                                cell=cell.strip()
                            if key2 in ontology_terms_and_values.keys():
                                if "terms" in ontology_terms_and_values[key2].keys():
                           
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
                                    #print(cell)
                                    currentDateWithoutTime = ""
                                    if (int(cell)):
                                        currentDateWithoutTime = datetime.date(cell, 1, 1)
                                    elif ("/" in cell):
                                        date_obj = datetime.datetime.strptime(cell, "%d/%m/%Y")
                                        currentDateWithoutTime = date_obj.strftime("%Y-%m-%d")
                                    else:
                                        currentDateWithoutTime = cell.strftime('%Y-%m-%d')
                                    cell = currentDateWithoutTime
                                    #print('after',cell)
                            
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
        for index_sheet,sheet_from_array in enumerate(array_sheet):
            if(not sheet_from_array.empty):
                
                for index, row in sheet_from_array.iterrows():
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

                            
                            cell=row[i]
                            
                            if isinstance(cell,str):
                                cell=cell.strip()
                            flag_to_discard = 0
                            #print (ontology_terms_and_values)
                            #sys.exit()
                           
                            if key2 in ontology_terms_and_values.keys():
                                
                                if "terms" in ontology_terms_and_values[key2].keys():
                           
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
                                        for item in ontology_terms_and_values['foodon_terms']:
                                            for keyF in item.keys():
                                                if cell in keyF:
                                                    flag2+=1;
                                                    #print('here',item[keyF])
                                                    cell = item[keyF]["terms"]+"//"+item[keyF]["term_id"]
                                        #print("diferent term: ",cell," with id: ",pseudoid," in field:",key)
                                        if flag2 == 0:
                                            flag_to_discard += 1
                                            if ( cell in terms_to_fix.keys()):
                                                if (key in terms_to_fix[cell].keys()):
                                                    terms_to_fix[cell][key] += 1
                                            else:
                                                terms_to_fix[cell] = {}
                                                terms_to_fix[cell] [key] = 1
                                                ##Provisory adding terms to the ontology_terms
                                                new_ont_terms[key2]['terms'].append({cell+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                                #print(cell,ontology_terms_and_values[key])
                                                
                                                cell= cell+"//"+pseudoid
                            if 'date' in key:
                                
                                #print (type(cell))
                                #print(cell)
                                currentDateWithoutTime = cell.strftime('%Y-%m-%d')
                                cell = currentDateWithoutTime
                                #print('after',cell)
                            
                            if flag_to_discard == 0:
                      #          print(cell)
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
    return(dict_terms_file,new_ont_terms)
    
    

def connect_db():
    conn = psycopg2.connect(
       database="metabaseappdb", user='gabriel', password='gaba1984', host='10.139.14.109', port= '5433'
    )
    cursor = conn.cursor()
    return(conn,cursor)
   
def fix(fields):
    fields = fields.replace("\n", "")
    fields = fields.replace(" ", "_")
    fields = fields.replace("/", "_")
    fields = fields.replace("-", "_")
    fields = fields.replace("(", "")
    fields = fields.replace(")", "")
    return(fields)
def sql_add(sql,fields):
    if "by" in fields:
        sql += fields.upper() + " integer REFERENCES AGENCY_TERMS(id)"
    elif "country" in fields:
        sql += fields.upper() + " integer REFERENCES COUNTRY_PURPOSE(id)"
    elif "purpose" in fields:
        sql += fields.upper() + " integer REFERENCES PURPOSE_TERMS(id)"
    else:
        sql += fields.upper() + " integer REFERENCES "+fields.upper()+"_TERMS(id)"
    return(sql)
def sql_add2(sql,fields):
    if ('date' in fields and 'precision' not in fields):
        sql += fields.upper() + " DATE"
    elif(re.search('measurement$',fields)):
        sql += fields.upper() + " FLOAT(4)"
    elif ("breakpoint" in fields):
        sql += fields.upper() + " FLOAT(4)"
    else:
        sql += fields.upper() + " VARCHAR(150)"
    
    return(sql)
def schema_creator(xls_file,cursor,conn,antimicrobian_agent_names_ids,valid_ontology_terms_and_values):
    def isNaN(string):
        return string != string
    def reading_file(sheet):
        fields = pd.read_excel(xls_file,sheet_name=sheet,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)
        #fields_sheet_filtered = fields_sheet[fields_sheet["Ontology ID"].str.contains("GENEPIO")==True]
        if "AMR" not in sheet:
            fields_noNA=fields.dropna(axis=0, subset=['sample_collector_sample_ID'])
        else:
            fields_noNA=fields.dropna(axis=0, subset=['isolate_ID'])
        fields_sheet =fields_noNA
        columns = list(fields_sheet.columns.values)
        return(columns)
    def fields_terms_not_repeated():
        list_no_red = []
        list_red= []
        for keys in valid_ontology_terms_and_values:
        #print (valid_ontology_terms_and_values[keys])
        #print (keys)
            if "_terms" not in keys and  'terms' in valid_ontology_terms_and_values[keys].keys():
                if "by" not in keys and "country" not in keys and "purpose" not in keys:
                    list_no_red.append(keys)
                list_red.append(keys)
        return(list_no_red,list_red)
        
    
    
    columns_samples = reading_file("Sample Collection & Processing")
    
    #print(antimicrobian_agent_names_ids)
    #sys.exit()
           
    list_fields_no_redundancy,list_fields_redundant=fields_terms_not_repeated()
   # print(list_fields_redundant)
    #sys.exit()
    
    cursor.execute("DROP TABLE IF EXISTS AMR_ANTIBIOTICS_PROFILE")
    cursor.execute("DROP TABLE IF EXISTS AMR_GENES_DRUGS")
    cursor.execute("DROP TABLE IF EXISTS AMR_GENES_RESISTANCE_MECHANISM")
    cursor.execute("DROP TABLE IF EXISTS AMR_GENES_FAMILY")
    cursor.execute("DROP TABLE IF EXISTS AMR_PREDICTED_MOBILITY")
    cursor.execute("DROP TABLE IF EXISTS AMR_ORIT_TYPE")
    cursor.execute("DROP TABLE IF EXISTS AMR_MPF_TYPE")
    cursor.execute("DROP TABLE IF EXISTS AMR_RELAXASE_TYPE")
    cursor.execute("DROP TABLE IF EXISTS AMR_REF_TYPE")
    cursor.execute("DROP TABLE IF EXISTS AMR_MOB_SUITE")
    cursor.execute("DROP TABLE IF EXISTS AMR_GENES_PROFILE")
    cursor.execute("DROP TABLE IF EXISTS CATHY")
    cursor.execute("DROP TABLE IF EXISTS AMR_INFO")
    cursor.execute("DROP TABLE IF EXISTS HOSTS")
    cursor.execute("DROP TABLE IF EXISTS SEQUENCE")
    cursor.execute("DROP TABLE IF EXISTS RISK_ASSESSMENT")
    cursor.execute("DROP TABLE IF EXISTS REPOSITORY")
    cursor.execute("DROP TABLE IF EXISTS ISOLATES")
    cursor.execute("DROP TABLE IF EXISTS SAMPLES")
    cursor.execute("DROP TABLE IF EXISTS ONTOLOGY_FIELDS_ITEM")
    for fields in list_fields_no_redundancy:
        fields = fix(fields)
        cursor.execute("DROP TABLE IF EXISTS "+fields.upper()+"_TERMS")
    cursor.execute("DROP TABLE IF EXISTS COUNTRY_TERMS")
    cursor.execute("DROP TABLE IF EXISTS PURPOSE_TERMS")
    cursor.execute("DROP TABLE IF EXISTS AGENCY_TERMS")
    cursor.execute("DROP TABLE IF EXISTS TERM_LIST")

    sql ="CREATE TABLE TERM_LIST(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,TERM VARCHAR(150) UNIQUE,TERM_ID VARCHAR(50), STATUS VARCHAR(300))"
    cursor.execute(sql)
    conn.commit()
    #print (valid_ontology_terms_and_values)
    #Creating look up tables

    for fields in list_fields_no_redundancy:
        fields = fix(fields)
        sql = "CREATE TABLE "+fields.upper()+"_TERMS(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,TERM integer REFERENCES TERM_LIST(id))"
        cursor.execute(sql)
        conn.commit()
    sql = "CREATE TABLE COUNTRY_TERMS(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,TERM integer REFERENCES TERM_LIST(id))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AGENCY_TERMS(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,TERM integer REFERENCES TERM_LIST(id))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE PURPOSE_TERMS(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,TERM integer REFERENCES TERM_LIST(id))"
    cursor.execute(sql)
    conn.commit()
    
    #creating fields ontology id table
    sql = "CREATE TABLE ONTOLOGY_FIELDS_ITEM(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,ONTOLOGY_ID VARCHAR(50), DEFINITION TEXT, GUIDANCE TEXT,  EXAMPLES TEXT)"
    cursor.execute(sql)
    conn.commit()

        #if 'terms' in valid_ontology_terms_and_values[keys].keys() and  keys != "foodon_terms":
            #print(keys)
            #sys.exit()
    #sys.exit()
    
   # sys.exit()INT GENERATED ALWAYS AS IDENTITY
    sql ="CREATE TABLE SAMPLES(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,"
    count=1
    sampleT_terms = []
    constraint_list=[]
    for fields in columns_samples:
        sampleT_terms.append(fields)
        fields2 = fix(fields)
        print (fields2)
        sql = sql_add(sql,fields2)
        print ("here")
        if (fields in valid_ontology_terms_and_values.keys()):
            
            if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                cons = "ALTER TABLE SAMPLES ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                constraint_list.append(cons)
                
        
        if (count != len(columns_samples)):
            sql += ","
        count +=1
    sql += ")"
    print(sql)
    sys.exit()
    cursor.execute(sql)
    conn.commit()
   #print(constraint_list)
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
   
    #sys.exit()
    columns_isolates = reading_file("Strain and Isolate Information")
    

    isolateT_terms = []
    constraint_list=[]
    sql ="CREATE TABLE ISOLATES(id serial PRIMARY KEY,"
    count=1
    #print (columns_isolates)
    for fields in columns_isolates:
        isolateT_terms.append(fields)
        if (fields == "sample_collector_sample_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE ISOLATES ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
                    
            if (count != len(columns_isolates)):
                sql += ","
        count +=1
    sql += ")"
    #print(sql)
    #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE ISOLATES ADD CONSTRAINT ISOLATE_SAMPLE FOREIGN KEY (SAMPLE_COLLECTOR_SAMPLE_ID) REFERENCES SAMPLES(id)")
    conn.commit()
    #print(constraint_list)
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    #sys.exit()
    columns_hosts = reading_file("Host Information")
    

    hostT_terms =[]
    constraint_list=[]
    sql ="CREATE TABLE HOSTS(id serial PRIMARY KEY,"
    count=1
   # print (columns_hosts)
    for fields in columns_hosts:
        hostT_terms.append(fields)
        if (fields == "sample_collector_sample_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE HOSTS ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
            if (count != len(columns_hosts)):
                sql += ","
        count +=1
    sql += ")"
    #print(sql)
    #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE HOSTS ADD CONSTRAINT HOST_SAMPLE FOREIGN KEY (SAMPLE_COLLECTOR_SAMPLE_ID) REFERENCES SAMPLES(id)")
    conn.commit()
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    #sys.exit()
    #Sequence Information
    sequenceT_terms=[]
    constraint_list=[]
    columns_sequence = reading_file("Sequence Information")
   # print (columns_sequence)
    sql ="CREATE TABLE SEQUENCE(id serial PRIMARY KEY,"
    count=1
   # print (columns_hosts)
    for fields in columns_sequence:
        sequenceT_terms.append(fields)
        if (fields == "isolate_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE SEQUENCE ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
            if (count != len(columns_sequence)):
                sql += ","
        count +=1
    sql += ")"
    #print(sql)
   # sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE SEQUENCE ADD CONSTRAINT SEQUENCE_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    #Public Repository Information 
    columns_rep = reading_file("Public Repository Information")
    #print (columns_sequence)
    repositoryT_terms =[]
    constraint_list=[]
    sql ="CREATE TABLE REPOSITORY(id serial PRIMARY KEY,"
    count=1
    #print (columns_rep)
    for fields in columns_rep:
        repositoryT_terms.append(fields)
        if (fields == "isolate_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE REPOSITORY ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
            if (count != len(columns_rep)):
                sql += ","
        
        count +=1
    sql += ")"
    #print(sql)
    #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE REPOSITORY ADD CONSTRAINT REPOSITORY_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    #Risk Assessment
    columns_risk = reading_file("Risk Assessment")
    #print (columns_risk)
    riskT_terms=[]
    constraint_list=[]
    sql ="CREATE TABLE RISK_ASSESSMENT(id serial PRIMARY KEY,"
    count=1
   # print (columns_hosts)
    for fields in columns_risk:
        riskT_terms.append(fields)
        if (fields == "isolate_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE RISK_ASSESSMENT ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
            if (count != len(columns_risk)):
                sql += ","
        count +=1
    sql += ")"
    #print(sql)
    #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE RISK_ASSESSMENT ADD CONSTRAINT RISK_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    columns_amr = reading_file("AMR Phenotypic Test Information")
    #print (columns_sequence)
    sql ="CREATE TABLE AMR_INFO(id serial PRIMARY KEY,"
    count=1
    
    columns_amr_red = columns_amr[:9]
    #print(columns_amr_red)

    #sys.exit()
    amrT_terms=[]
    constraint_list=[]
    antiT_terms=columns_amr[9:]
    #print(columns_amr_red)
    #sys.exit()
    for fields in columns_amr_red:
        amrT_terms.append(fields)
        if (fields == "isolate_ID"):
            sql += fields.upper() + " INTEGER,"
        elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID" and fields != "IRIDA_isolate_ID" and fields != "IRIDA_project_ID"):
            fields2 = fix(fields)
            sql = sql_add(sql,fields2)
            if (fields in valid_ontology_terms_and_values.keys()):
                if ('terms' in valid_ontology_terms_and_values[fields].keys() ):
                    cons = "ALTER TABLE AMR_INFO ADD CONSTRAINT "+fields2.upper()+"_TERM FOREIGN KEY ("+fields2.upper()+") REFERENCES TERM_LIST(TERM)"
                    constraint_list.append(cons)
            if (count != len(columns_amr_red)):
                sql += ","
        count +=1
    sql += ")"
    #print(sql)
    #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE AMR_INFO ADD CONSTRAINT AMR_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    for constraint in constraint_list:
        #print(constraint)
        cursor.execute(constraint)
        conn.commit()
    
    
    
    
    sql ="CREATE TABLE AMR_ANTIBIOTICS_PROFILE(id serial PRIMARY KEY,ISOLATE_ID INTEGER,"
    sql += "ANTIMICROBIAL_AGENT VARCHAR(50),"
    sql += "RESISTANCE_PHENOTYPE VARCHAR(150),"
    sql += "MEASUREMENT FLOAT(4),"
    sql += "MEASUREMENT_UNITS VARCHAR(150),"
    sql += "MEASUREMENT_SIGN VARCHAR(150),"
    sql += "LABORATORY_TYPING_METHOD VARCHAR(150),"
    sql += "LABORATORY_TYPING_PLATFORM VARCHAR(150),"
    sql += "LABORATORY_TYPING_PLATFORM_VERSION VARCHAR(150),"
    sql += "VENDOR_NAME VARCHAR(150),"
    sql += "TESTING_STANDARD VARCHAR(150),"
    sql += "TESTING_STANDARD_VERSION VARCHAR(150),"
    sql += "TESTING_STANDARD_DETAILS VARCHAR(150),"
    sql += "TESTING_SUSCEPTIBLE_BREAKPOINT FLOAT(4),"
    sql += "TESTING_INTERMEDIATE_BREAKPOINT FLOAT(4),"
    sql += "TESTING_RESISTANCE_BREAKPOINT FLOAT(4))"
    #print(sql)
   #sys.exit()
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT AMR_ANTIBIOTICS_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT AMR_ANTIBIOTICS_ANTIBIOTICS_LIST FOREIGN KEY (ANTIMICROBIAL_AGENT) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT RESISTANCE_PHENOTYPE_METHOD_TERM FOREIGN KEY (RESISTANCE_PHENOTYPE) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT MEASUREMENT_UNITS_TERM FOREIGN KEY (MEASUREMENT_UNITS) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT MEASUREMENT_SIGN_TERM FOREIGN KEY (MEASUREMENT_SIGN) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT LABORATORY_TYPING_METHOD_TERM FOREIGN KEY (LABORATORY_TYPING_METHOD) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT LABORATORY_TYPING_PLATFORM_TERM FOREIGN KEY (LABORATORY_TYPING_PLATFORM) REFERENCES TERM_LIST(TERM)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_ANTIBIOTICS_PROFILE ADD CONSTRAINT TESTING_STANDARD_TERM FOREIGN KEY (TESTING_STANDARD) REFERENCES TERM_LIST(TERM)")
    conn.commit()

    #creating AMR_gene
    sql ="CREATE TABLE AMR_GENES_PROFILE(id serial PRIMARY KEY,ISOLATE_ID INTEGER,"
    sql += "CUT_OFF VARCHAR(50),"
    sql += "BEST_HIT_ARO VARCHAR(150),"
    sql += "MODEL_TYPE VARCHAR(150))"
    
    
    
    cursor.execute(sql)
    conn.commit()
    cursor.execute("ALTER TABLE AMR_GENES_PROFILE ADD CONSTRAINT AMR_GENES_ISOLATE FOREIGN KEY (ISOLATE_ID) REFERENCES ISOLATES(id)")
    conn.commit()
    cursor.execute("ALTER TABLE AMR_GENES_PROFILE ADD CONSTRAINT BEST_HIT_ARO_TERM FOREIGN KEY (BEST_HIT_ARO) REFERENCES TERM_LIST(TERM)")
    conn.commit()

    #creating amr_mod_suite
    sql = "CREATE TABLE AMR_MOB_SUITE(id serial PRIMARY KEY,"
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "MOLECULE_TYPE VARCHAR(150),"
    sql += "PRIMARY_CLUSTER_ID VARCHAR(150),"
    sql += "SECONDARY_CLUSTER_ID VARCHAR(150))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AMR_REF_TYPE("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "REP_TYPE VARCHAR(150),"
    sql += "PRIMARY KEY (AMR_GENES_ID, REP_TYPE))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AMR_RELAXASE_TYPE("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "RELAXASE_TYPE VARCHAR(150),"
    sql += "PRIMARY KEY (AMR_GENES_ID, RELAXASE_TYPE))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AMR_MPF_TYPE("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "MPF_TYPE VARCHAR(150),"
    sql += "PRIMARY KEY (AMR_GENES_ID, MPF_TYPE))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AMR_ORIT_TYPE("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "ORIT_TYPE VARCHAR(150),"
    sql += "PRIMARY KEY (AMR_GENES_ID, ORIT_TYPE))"
    cursor.execute(sql)
    conn.commit()
    sql = "CREATE TABLE AMR_PREDICTED_MOBILITY("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "PREDICTED_MOBILITY VARCHAR(150),"
    sql += "PRIMARY KEY (AMR_GENES_ID, PREDICTED_MOBILITY))"
    

    
    
    cursor.execute(sql)
    conn.commit()
    
    #creating amr_gene_DRUG

    sql = "CREATE TABLE AMR_GENES_DRUGS("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "DRUG_ID integer REFERENCES TERM_LIST(id),"
    sql += "PRIMARY KEY (AMR_GENES_ID, DRUG_ID))"
    cursor.execute(sql)
    conn.commit()

    #creating amr_gene_Resistance_mechanism
    sql = "CREATE TABLE AMR_GENES_RESISTANCE_MECHANISM("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "RESISTANCE_MECHANISM_ID integer REFERENCES TERM_LIST(id),"
    sql += "PRIMARY KEY (AMR_GENES_ID, RESISTANCE_MECHANISM_ID))"
    cursor.execute(sql)
    conn.commit()

    #creating amr_gene_Family
    sql = "CREATE TABLE AMR_GENES_FAMILY("
    sql += "AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),"
    sql += "AMR_GENE_FAMILY_ID integer REFERENCES TERM_LIST(id),"
    sql += "PRIMARY KEY (AMR_GENES_ID, AMR_GENE_FAMILY_ID))"
    cursor.execute(sql)
    conn.commit()


   # sys.exit()
    #return(sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms)
    
def schema_opener():
    return open("schema.dql")


def types_to_dict(schema_file):
    lines = schema_file.readlines()
    count = 0
    flag=0
    types_dict={}
    type_name=""
    list_predicates=[]
    for line in lines:
        count += 1
        type_s = re.compile(r'^type\s+(\w+)');
        if( flag ==1):
            if (re.search('\w+',line)):
                list_predicates.append(line.strip())
                
            else:
                flag =0
                types_dict[type_name]=list_predicates
                list_predicates=[]
                
        if ( re.search('^type',line)):
            
            type_name = type_s.search(line).group(1)
            
            flag =1
    return(types_dict)

#function to convert dict to json based in the schema
"""
def connect_database():
    endpoint = "https://amrdb2.documents.azure.com:443/"
    key = "RbnFAX90yeKxOngJNlYdOQCOm4W0HheLWI4BEXTgrbvjDBS3ku8dAIvku7tZUvj0hKOMQKs0H9vVACDbUrpAFw=="

    client = CosmosClient(url=endpoint, credential=key)


    database = client.create_database_if_not_exists(id="amrdb")
    partitionKeyPath = PartitionKey(path="/pk")

    database.delete_container("amr-db",partitionKeyPath)
    container = database.create_container_if_not_exists(
        id="amr-db", partition_key=partitionKeyPath
    )
    return(container)
"""
def create_term_list_table (valid_ontology_terms_and_values,antimicrobian_agent_names_ids,conn,cursor):
    unique_dict_for_table_term_list={}
    termsids_unique={}

    #print(valid_ontology_terms_and_values)
   # sys.exit()
    #print("STARTING HERE")
    for fields in valid_ontology_terms_and_values:
      #  print(fields,"TOP")
        if ('foodon_terms' not in fields and 'card_terms' not in fields):
            if ('terms' in valid_ontology_terms_and_values[fields].keys() and 'antimicrobial_agent_name' not in fields ):
               # print(fields)
                #print(fields,valid_ontology_terms_and_values[fields]['terms'])
                for index_term in valid_ontology_terms_and_values[fields]['terms']:
                    #print('indexterm',index_term)
                                
                    if (type(index_term) == str):
                        
                        index_term = index_term.replace("\'", "\'\'")
                        #print (index_term)
                        if index_term not in unique_dict_for_table_term_list.keys():
                            
                            
                            
                            insert = "INSERT INTO TERM_LIST(TERM,TERM_ID) VALUES ('" + index_term+"',NULL)" 
                        # terms_for_excel.append(index_term)
                            #terms_ids_excel.append('NULL')
                           # print(insert)
                            cursor.execute(insert)
                            
                            unique_dict_for_table_term_list[index_term]=0
                    else:
                        for full_term in index_term:
                            #print(full_term)
                            
                            pterm = index_term[full_term]['term']
                            pterm = pterm.replace("\'", "\'\'")
                            #print(pterm)
                            if pterm not in unique_dict_for_table_term_list.keys():
                                
                                ptermid = index_term[full_term]['term_id']
                                termsids_unique[ptermid]=0
                                
                                
                                insert = "INSERT INTO TERM_LIST(TERM,TERM_ID) VALUES ('" + pterm+"','"+ptermid+"')" 
                            #   terms_for_excel.append(pterm)
                            #   terms_ids_excel.append(ptermid)
                                #print(insert)
                                cursor.execute(insert)
                            
                                unique_dict_for_table_term_list[pterm]=0
                
                                #sys.exit()
                    

                    
                    
                        #print(valid_ontology_terms_and_values[fields]['terms'][full_term]['term'],valid_ontology_terms_and_values[fields]['terms'][full_term]['term_id'])
                    #sys.exit()
                # insert = "INSERT INTO TERM_LIST("+valid_ontology_terms_and_values[fields]['terms'] + " VALUES " + values
        elif ('foodon_terms' in fields):
            #print(fields,"HERE")
            #print (valid_ontology_terms_and_values['foodon_terms'])
            for index_term in valid_ontology_terms_and_values[fields]:
                for full_term in index_term.keys():
                    pterm = index_term[full_term]['terms']
                    pterm = pterm.replace("\'", "\'\'")
                    ptermid = index_term[full_term]['term_id']
                    if ptermid not in termsids_unique.keys() and pterm not in unique_dict_for_table_term_list.keys() :
                    
                                
                        
                        termsids_unique[ptermid]=0
                        unique_dict_for_table_term_list[pterm]=0
                                
                                
                        insert = "INSERT INTO TERM_LIST(TERM,TERM_ID) VALUES ('" + pterm+"','"+ptermid+"')" 
                            #   terms_for_excel.append(pterm)
                            #   terms_ids_excel.append(ptermid)
                        print(insert)
                        cursor.execute(insert)
        elif ('card_terms' in fields):
             for index_term in valid_ontology_terms_and_values[fields]:
                for full_term in index_term.keys():
                    pterm = index_term[full_term]['terms']
                    pterm = pterm.replace("\'", "\'\'")                    
                    insert = "INSERT INTO TERM_LIST(TERM,TERM_ID) VALUES ('" + pterm+"',NULL)" 
                            #   terms_for_excel.append(pterm)
                            #   terms_ids_excel.append(ptermid)
                    print(insert)
                    cursor.execute(insert)    
                    
                   # sys.exit()

        #print (antimicrobian_agent_names_ids)
        
    for antibiotics in antimicrobian_agent_names_ids:
        insert = "INSERT INTO TERM_LIST(TERM,TERM_ID) VALUES ('" + antibiotics+"','"+antimicrobian_agent_names_ids[antibiotics]+"')" 
       # terms_for_excel.append(antibiotics)
       # terms_ids_excel.append(antimicrobian_agent_names_ids[antibiotics])
        #print(insert)
        cursor.execute(insert)
    conn.commit()
def json_maker(dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,conn,cursor,valid_ontology_terms_and_values):
    def getTermAndId (variable):
        term_id=""
        term=""
        if ("//" in str(variable)):
            listF = re.split("//",variable)
            #print(listF.groups()[1])
            
            term_id = listF[1]
            
            term = listF[0]
        else:
            term= variable
        return (term,term_id)
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
    #build json tree using schema
 
    
    #flag_table_terms+=1
        
    #print (antimicrobian_agent_names_ids)
    #print(len(terms_ids_excel),len(terms_for_excel))
   # d = {'Terms':terms_for_excel,'Terms_ids':terms_ids_excel}
   # print(d)
   # pdf_excel = pd.DataFrame(d)
    #print(pdf_excel)
    #pdf_excel.to_excel('Harmonized_terms.xlsx')
    # print('here')
   # conn.commit()
   # print('there')
   
    #sampleT insert
    
    #+ column_ins+ " VALUES " + values
    
    #print(dict_of_samples)
    #sys.exit()
    #print(hostT_terms)
   # sys.exit()
    for index in dict_of_samples['sample']:
        column_ins = "("
        count=0
        values ="("
        for fields in sampleT_terms:
            if fields in dict_of_samples['sample'][index].keys():
                #print (dict_of_samples['sample'][index])
                #sys.exit()
                
                    
                terms,terms_id= getTermAndId(dict_of_samples['sample'][index][fields])
               # print(terms)
                #if fields == 'sample_collector_sample_ID':
                   # print(terms)
               # print('before',fields)
                fields = fix(fields)
               # print(fields)
                column_ins = columnIns(column_ins,fields,count,len(sampleT_terms))
                values = valuesIns(values,terms,count,len(sampleT_terms))
                #  print(column_ins)
                #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                #cursor.execute(insertS)
                #sql = sql_add(sql,fields,count,columns_samples)
                #sys.exit()
            else:
               # print('before2',fields)
                fields = fix(fields)
               # print(fields)
                column_ins = columnIns(column_ins,fields,count,len(sampleT_terms))
                values = valuesIns(values,"NULL",count,len(sampleT_terms))
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        insert = "INSERT INTO SAMPLES"+column_ins+" VALUES "+values
        cursor.execute(insert)
        conn.commit()
        #host_t insert
    for index in dict_of_samples['host']:
        column_ins = "("
        count=0
        values ="("
        for fields in hostT_terms :
            
            
            
            if (fields == "sample_collector_sample_ID"):
                column_ins += fields.upper()+","
                values += "(SELECT id from SAMPLES where "+fields.upper()+" = '"+dict_of_samples['host'][index][fields]+"'),"
            elif (fields != "alternative_sample_ID"):
              #  print('here',dict_of_samples['sample'][index])
                if fields in dict_of_samples['host'][index].keys():
                 #   print('here',dict_of_samples['sample'][index][fields])
                    #sys.exit()
                    
                    terms,terms_id= getTermAndId(dict_of_samples['host'][index][fields])
                   # print('before',fields)
                    
                  #  print('after id',terms)
                    fields = fix(fields)
                    column_ins = columnIns(column_ins,fields,count,len(hostT_terms))
                    values = valuesIns(values,terms,count,len(hostT_terms))
                    #  print(column_ins)
                    #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                    #cursor.execute(insertS)
                    #sql = sql_add(sql,fields,count,columns_samples)
                    #sys.exit()
                else:
                   # print('before2',fields)
                    
                   # print(fields)
                    fields = fix(fields)
                    column_ins = columnIns(column_ins,fields,count,len(hostT_terms))
                    values = valuesIns(values,"NULL",count,len(hostT_terms))
                    
                    
           
                
                #print(column_ins)
            count += 1
            
        column_ins += ")"
        values += ")"
       # print (column_ins,values)
        #sys.exit()
        insert = "INSERT INTO HOSTS"+column_ins+" VALUES "+values
        cursor.execute(insert)
        conn.commit()
        #isolateT insert
       
   # print(isolateT_terms)
    #sys.exit()
    for index in dict_of_samples['isolate']:
        column_ins = "("
        count=0
        values ="("
        for fields in isolateT_terms:
            
            
            if (fields == "sample_collector_sample_ID"):
                column_ins += fields.upper()+","
                values += "(SELECT id from SAMPLES where "+fields.upper()+" = '"+dict_of_samples['isolate'][index][fields]+"'),"
            elif (fields != "alternative_sample_ID"):
                if fields in dict_of_samples['isolate'][index].keys():
                   # print('here',dict_of_samples[fields])
                    terms,terms_id= getTermAndId(dict_of_samples['isolate'][index][fields])
                   # print('before',fields)
                    
                  #  print('after id',terms)
                    fields = fix(fields) 
                    column_ins = columnIns(column_ins,fields,count,len(isolateT_terms))
                    values = valuesIns(values,terms,count,len(isolateT_terms))
                    #  print(column_ins)
                    #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                    #cursor.execute(insertS)
                    #sql = sql_add(sql,fields,count,columns_samples)
                    #sys.exit()
                else:
                   # print('before2',fields)
                    
                   # print(fields)
                   fields = fix(fields)
                   column_ins = columnIns(column_ins,fields,count,len(isolateT_terms))
                   values = valuesIns(values,"NULL",count,len(isolateT_terms))
                    
                    
           
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        #print(column_ins)
        insert = "INSERT INTO ISOLATES"+column_ins+" VALUES "+values
        cursor.execute(insert)
        conn.commit()
    #sequenceT_terms
    for index in dict_of_samples['sequence']:
        column_ins = "("
        count=0
        values ="("
        for fields in sequenceT_terms:
            
            
            if (fields == "isolate_ID"):
                column_ins += fields.upper()+","
                values += "(SELECT id from ISOLATES where "+fields.upper()+" = '"+dict_of_samples['sequence'][index][fields]+"'),"
            elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID"):
                if fields in dict_of_samples['sequence'][index].keys():
                   # print('here',dict_of_samples[fields])
                    terms,terms_id= getTermAndId(dict_of_samples['sequence'][index][fields])
                   # print('before',fields)
                    
                  #  print('after id',terms)
                    fields = fix(fields) 
                    column_ins = columnIns(column_ins,fields,count,len(sequenceT_terms))
                    values = valuesIns(values,terms,count,len(sequenceT_terms))
                    #  print(column_ins)
                    #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                    #cursor.execute(insertS)
                    #sql = sql_add(sql,fields,count,columns_samples)
                    #sys.exit()
                else:
                   # print('before2',fields)
                    
                   # print(fields)
                   fields = fix(fields)
                   column_ins = columnIns(column_ins,fields,count,len(sequenceT_terms))
                   values = valuesIns(values,"NULL",count,len(sequenceT_terms))
                    
                    
           
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        #print(column_ins)
        insert = "INSERT INTO SEQUENCE"+column_ins+" VALUES "+values
        cursor.execute(insert)
        
        #repositoryT_terms
        
    for index in dict_of_samples['publicRep']:
        column_ins = "("
        count=0
        values ="("
        for fields in repositoryT_terms:
            
            
            if (fields == "isolate_ID"):
                column_ins += fields.upper()+","
                values += "(SELECT id from ISOLATES where "+fields.upper()+" = '"+dict_of_samples['publicRep'][index][fields]+"'),"
            elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID"):
                if fields in dict_of_samples['publicRep'][index].keys():
                   # print('here',dict_of_samples[fields])
                    terms,terms_id= getTermAndId(dict_of_samples['publicRep'][index][fields])
                   # print('before',fields)
                    
                  #  print('after id',terms)
                    fields = fix(fields) 
                    column_ins = columnIns(column_ins,fields,count,len(repositoryT_terms))
                    values = valuesIns(values,terms,count,len(repositoryT_terms))
                    #  print(column_ins)
                    #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                    #cursor.execute(insertS)
                    #sql = sql_add(sql,fields,count,columns_samples)
                    #sys.exit()
                else:
                   # print('before2',fields)
                    
                   # print(fields)
                   fields = fix(fields)
                   column_ins = columnIns(column_ins,fields,count,len(repositoryT_terms))
                   values = valuesIns(values,"NULL",count,len(repositoryT_terms))
                    
                    
           
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        #print(column_ins)
        insert = "INSERT INTO REPOSITORY"+column_ins+" VALUES "+values
        
        #antibiotics
        
        cursor.execute(insert)
        
    #amrT_terms
    for index in dict_of_samples['AMR']:
        column_ins = "("
        count=0
        values ="("
        #print(amrT_terms)
        #sys.exit()
        for fields in amrT_terms:
            if (fields == "isolate_ID"):
                column_ins += fields.upper()+","
                values += "(SELECT id from ISOLATES where "+fields.upper()+" = '"+dict_of_samples['AMR'][index][fields]+"'),"
            elif (fields != "alternative_sample_ID" and fields != "alternative_isolate_ID" and fields != "sample_collector_sample_ID" and fields != "IRIDA_isolate_ID" and fields != "IRIDA_project_ID"):
                if fields in dict_of_samples['AMR'][index].keys():
                   # print('here',dict_of_samples[fields])
                    terms,terms_id= getTermAndId(dict_of_samples['AMR'][index][fields])
                   # print('before',fields)
                    
                  #  print('after id',terms)
                    fields = fix(fields) 
                    column_ins = columnIns(column_ins,fields,count,len(amrT_terms))
                    values = valuesIns(values,terms,count,len(amrT_terms))
                    #  print(column_ins)
                    #insertS = "INSERT INTO SAMPLES " + fields.upper() + " VALUES " + terms
                    #cursor.execute(insertS)
                    #sql = sql_add(sql,fields,count,columns_samples)
                    #sys.exit()
                else:
                   # print('before2',fields)
                    
                   # print(fields)
                   fields = fix(fields)
                   column_ins = columnIns(column_ins,fields,count,len(amrT_terms))
                   values = valuesIns(values,"NULL",count,len(amrT_terms))
                    
                    
           
                
                #print(column_ins)
            count += 1
        #conn.commit()
        column_ins += ")"
        values += ")"
        
        insert = "INSERT INTO AMR_INFO"+column_ins+" VALUES "+values
        cursor.execute(insert)
       # print ("done AMR")
       #amikacin_resistance_phenotype	amikacin_measurement	amikacin_measurement_units	amikacin_measurement_sign	amikacin_laboratory_typing_method	amikacin_laboratory_typing_platform	amikacin_laboratory_typing_platform_version	amikacin_vendor_name	amikacin_testing_standard	amikacin_testing_standard_version	amikacin_testing_standard_details	amikacin_susceptible_breakpoint	amikacin_intermediate_breakpoint	amikacin_resistant_breakpoint
        amr_antibiotics_terms=['resistance_phenotype','measurement','measurement_units','measurement_sign','laboratory_typing_method','laboratory_typing_platform','laboratory_typing_platform_version','vendor_name','testing_standard','testing_standard_version','testing_standard_details','testing_susceptible_breakpoint','testing_intermediate_breakpoint','testing_resistance_breakpoint']
        for antibiotics in antimicrobian_agent_names_ids:
            print(antibiotics)
            
            res = [val for key, val in dict_of_samples['AMR'][index].items() if antibiotics in key]
            if (res):
                
               # print("found")
                column_ins = "("
                count=0
                values ="("
                column_ins += "ISOLATE_ID,"
                #isolate_ID
                values += "(SELECT id from ISOLATES where ISOLATE_ID = '"+dict_of_samples['AMR'][index]['isolate_ID']+"'),"
                column_ins += "ANTIMICROBIAL_AGENT,"
                values += "'"+antibiotics+"',"
               # print ("here")
                #print(dict_of_samples['AMR'][index])
                #sys.exit()
                #print(dict_of_samples['AMR'][index])
                #sys.exit()
                for in_abterms,abterms in enumerate(amr_antibiotics_terms):
                    #print (in_abterms,abterms)
                    #sys.exit()
                    subfield = antibiotics+"_"+abterms 
                    if subfield in dict_of_samples['AMR'][index]:
                                             
                        value_to_add = dict_of_samples['AMR'][index][subfield]
                        terms,terms_id= getTermAndId(str(value_to_add))
                        
                        
                            
                        
                        column_ins += abterms.upper()
                        values += "'"+str(terms)+"'"
                    else:
                        if "AMR_"+abterms in dict_of_samples['AMR'][index]:
                            #print (here)
                            value_to_add = dict_of_samples['AMR'][index]["AMR_"+abterms]
                            terms,terms_id= getTermAndId(str(value_to_add))
                            column_ins += abterms.upper()
                            values += "'"+str(terms)+"'"
                        else:
                            column_ins += abterms.upper()
                            values += "NULL"
                    if in_abterms < 13:
                        column_ins += ","
                        values += ","
                
                
                column_ins += ")"
                values += ")"
                print(column_ins)
                print(values)
                #sys.exit()
                insert = "INSERT INTO AMR_ANTIBIOTICS_PROFILE"+column_ins+" VALUES "+values
                cursor.execute(insert)
            
        #print(dict_of_samples['AMR'][index])
        #sys.exit()        
        conn.commit()
        #print(amrT_terms)
        #sys.exit()
    sys.exit()
   
    #return(flag_table_terms)
    
def main():
    """
    Execute main function for parsing / validation.
    General workflow is:
    1. Get the terms and values from the "Vocabulary" sheet in the Harmonized Data file.
    2. Process the merged sheet, store the values as a dictionary mimicking ontology
    3. Store data in Dgraph / SQL
    """
    parser = argparse.ArgumentParser(description='Parsing program for AMR database.')
    parser.add_argument("-s", "--schema_creator", help="Create the schema mode, exit after creating it.", default="F")
    parser.add_argument("-i", "--input_file", help="Input File to upload.", type=str)
    parser.add_argument("-g", "--gene_mode",help= "Add rgi/mob_suite output file to the VMR", default="F")
    parser.add_argument("-sensititre", "--sensititre_mode",help= "Add sensititre_output", default="F")
    args = parser.parse_args()

    
    
    conn,cursor = connect_db()    
    if args.gene_mode == "T":
        xls_file2 = args.input_file
        print("uploading file ", xls_file2)
        parsed_dict = parse(xls_file2)
        insert_data(parsed_dict,conn,cursor)

        sys.exit()
    if args.sensititre_mode == "T":
        xls_file2 = args.input_file
        print("uploading file ", xls_file2)
        sensititre(xls_file2,conn,cursor)
        sys.exit()
    #sys.exit()
    xls_file = "GRDI_Harmonization-Template_v8.8.7.xlsm"
    valid_ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms = create_ontology_as_dict(xls_file)
   # print ( valid_ontology_terms_and_values)
    #sys.exit()
    
    #print(antimicrobian_agent_names_ids)
    #sys.exit()
      #provisory new_ont_terms with more terms
    dict_of_samples={}
    new_ont_terms={}
    
    
    if args.schema_creator == "T":
        print ("creating schema")
        
        schema_creator(xls_file,cursor,conn,antimicrobian_agent_names_ids,valid_ontology_terms_and_values)
        #create_term_list_table(valid_ontology_terms_and_values,antimicrobian_agent_names_ids,conn,cursor)
        print ("Done schema")
        sys.exit()
    else:
        xls_file2 = args.input_file
        print("uploading file ", xls_file2)
        
        dict_of_samples,new_ont_terms = create_dict_of_samples(xls_file2, valid_ontology_terms_and_values, antimicrobian_agent_names_ids)
    #print(dict_of_samples)
   # sys.exit()
   # print(dict_of_samples)
    #schema_file = schema_opener()
    #print('here after schema_file')
    #types_dict = types_to_dict(schema_file)
    #print(dict_of_samples)
   ## container = connect_database()
    #isolates=[]
    
    json_maker(dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,conn,cursor,new_ont_terms)
        #isolates.append(isolate)
        #original_stdout = sys.stdout # Save a reference to the original standard output
    """
        filename = isolate+"out.json"
        with open(filename, 'w') as f:
            sys.stdout = f # Change the standard output to the file we created.
            print(json_for_mutation)
        sys.stdout = original_stdout # Reset the standard outp
    """
    ##    container.create_item(json_for_mutation)    
   
    #print(json_for_mutation)
    
   # mutate(json_for_mutation)
    
    # Example, print the first entry. The dict is {0: {sample1_dict}, 1:{sample2_dict} ...}
   # print(dict_of_samples)

    
if __name__ == '__main__':
    try:
        main()
        print('Program finished')
    except Exception as e:
        print('Error : {}'.format(e))




















#container.create_item(newItem)
