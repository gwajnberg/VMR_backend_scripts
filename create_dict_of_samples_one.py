

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



def create_dict_of_samples_one(xls, ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,extractionT_terms):
    def isNaN(string):
        return string != string
    
    
    
    
    fields = pd.read_excel(xls,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],keep_default_na=False, header=1)
    #print (fields[19])
    fields.fillna(0, inplace = True)
    #print(fields)
    #sys.exit()
    sample_id = ""
    sample_flagged_list =[]
    terms_accepting_multiple_values =["environmental_site","weather_type","available_data_types","animal_or_plant_population",
                                     "environmental_material","anatomical_material","body_product","anatomical_part","food_product",
                                     "food_product_properties","animal_source_of_food","food_packaging","purpose_of_sequencing","experimental_intervention",
                                     "pre_sampling_activity","purpose_of_sampling"]
    temp_dict={}
    terms_to_fix={}
    new_ont_terms = copy.deepcopy(ontology_terms_and_values)
    dict_terms_file={'sample':{},'host':{},'isolate':{},'sequence':{},'publicRep':{},'AMR':{},'risk':{},'environment':{},'bioinformatics':{},'taxonomics':{},'extractions':{}}
    amr_antibiotics_terms=['resistance_phenotype','measurement','measurement_units','measurement_sign','laboratory_typing_method','laboratory_typing_platform','laboratory_typing_platform_version','vendor_name','testing_standard','testing_standard_version','testing_standard_details','susceptible_breakpoint','intermediate_breakpoint','resistant_breakpoint']
    
    for index, row in fields.iterrows():
        print ("Checking INDEX", index)
        for i in row.index:
        
                        
            if (row[i] != 0 and not isNaN(row[i]) and row[i] ):

                #print(i)
                key = i.strip()
                key2 = key
                print ("begin with",key2," and ", row[i])
                key_ab=""
                
                for ab_terms in amr_antibiotics_terms:
                    if ab_terms in key:
                        key_ab = key.split("_"+ab_terms)
                        

                for abs in antimicrobian_agent_names_ids.keys():
                    if abs == "nalidixic acid":
                        abs = "nalidixic_acid"
                    if abs == "oxolinic acid":
                        abs = "oxolinic-acid"
                    if key_ab:
                        if key_ab[0] == abs:

                            substrL= re.match(abs+"_(.+)",key)
                           # print ("tem abs",key,abs)
                            key2 = "antimicrobial_"+substrL.groups()[0]
                        #print(key2)
                        #sys.exit()
                if (key == 'AMR_laboratory_typing_method'):
                    key2 = "antimicrobial_laboratory_typing_method"
                if (key == 'production_stream'):
                    key2 ="food_product_production_stream"
                cell=""
                print ("NOW HERE",key2)
                if key2 in terms_accepting_multiple_values:
                   # print(row[i],"ready to split")
                    cell_prov=row[i].split(";")
                    #print(cell_prov)
                    cell=[]
                    for sub in cell_prov:
                        if isinstance(sub,str):
                            cell_sub=sub.strip()
                            cell.append(cell_sub)

                else:
                   # print ("UPDATE",row[i])
                    cell = row[i]

                    if isinstance(cell,str):
                        cell=cell.strip()
                print("Here_",cell)
                if key2 == "sample_collector_sample_ID" :
                    sample_id = cell 
                
                if key2 in ontology_terms_and_values.keys():
                    print(key2, "ta aqui provavel")
                    if "terms" in ontology_terms_and_values[key2].keys():
                        
                        #print(ontology_terms_and_values[key2])
                        #sys.exit()
                        if key2 in terms_accepting_multiple_values:
                            for index3,cell_sub in enumerate(cell):
                                flag = 0;
                                pseudoid=""
                                realid=""
                                if(":" in cell_sub and "[" not in cell_sub):
                                    wanted = cell_sub.split(":")
                                    cell_sub = wanted[0]
                                    pseudoid = wanted[1]
                                elif (":" in cell and "[" in cell):
                                    print (cell,":[]")
                                    #sys.exit()
                                    if ( re.match("(.+)\s+\[(\w+\:\d+)\]",cell)):
                                        result_match = re.match("(.+)\s+\[(\w+\:\w+)\]",cell)
                                        cell = result_match.groups()[0]
                                        realid = result_match.groups()[1]
                                    else:
                                        if ( cell_sub in terms_to_fix.keys()):
                                          #  print ("entrou nesse if")
                                        #    print ("aqui:",terms_to_fix[cell_sub].keys())
                                            if (key in terms_to_fix[cell_sub].keys()):
                                               # print ("entrou nesse if2")        
                                                terms_to_fix[cell_sub][key] += 1
                                              #  print ("adicionou")
                                        else:
                                            #print ("foi no else")
                                            terms_to_fix[cell_sub] = {}
                                            terms_to_fix[cell_sub] [key] = 1
                                    #print(result_match.groups())
                                
                                for item in ontology_terms_and_values[key2]["terms"]:
                                  #  print(item, "to achando que o problema é aqui")
                                    if type(item) != dict:
                                        if cell_sub == item:
                                            flag+=1;
                                    else:
                                        for keyI in item.keys():
                                                        #print(type(keyI))
                                            if cell_sub in keyI:
                                                        # print(cell,keyI)
                                                flag+=1;
                                                   
                                                cell[index3]= item[keyI]["term"]+"//"+item[keyI]["term_id"]
                              #  print ("passou por aqui")
                                if flag == 0:
                                                #print("diferent term: ",cell," with id: ",pseudoid," in field:",key)
                                    if sample_id not in sample_flagged_list:
                                        sample_flagged_list.append(sample_id)
                                       # print ("adicionou ufa")
                                        if ( cell_sub in terms_to_fix.keys()):
                                          #  print ("entrou nesse if")
                                        #    print ("aqui:",terms_to_fix[cell_sub].keys())
                                            if (key in terms_to_fix[cell_sub].keys()):
                                               # print ("entrou nesse if2")        
                                                terms_to_fix[cell_sub][key] += 1
                                              #  print ("adicionou")
                                        else:
                                            #print ("foi no else")
                                            terms_to_fix[cell_sub] = {}
                                            terms_to_fix[cell_sub] [key] = 1
                                                    ##Provisory adding terms to the ontology_terms
                                            new_ont_terms[key2]['terms'].append({cell_sub+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                                    #print(cell,ontology_terms_and_values[key])
                                                    
                                            cell[index3]= cell_sub+"//"+pseudoid
                                #print ("foi multiple")
                        else:
                            flag = 0;
                            pseudoid=""
                            realid=""
                            if(":" in cell and "[" not in cell):
                                wanted = cell.split(":")
                                cell = wanted[0]
                                pseudoid = wanted[1]
                                
                                
                            elif (":" in cell and "[" in cell):
                                
                                
                                print (cell,":[] not multiple")
                                result_match = re.match("(.+)\s+\[(\w+\:\w+)\]",cell)
                                
                                
                                #print(result_match.groups())
                                cell = result_match.groups()[0]
                                pseudoid = result_match.groups()[1]
                                
                                
                                #sys.exit()

                        # print(ontology_terms_and_values[key]["terms"])
                           # print (cell,key2,"ta aqui mano")    
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
                                   # print( "ëntrou nesse if aqui a")
                                    if (key in terms_to_fix[cell].keys()):
                                        terms_to_fix[cell][key] += 1
                                        if (pseudoid):
                                            cell= cell+"//"+pseudoid

                                else:
                                   # print( "Foi pro else doido")
                                    terms_to_fix[cell] = {}
                                    terms_to_fix[cell] [key] = 1
                                    ##Provisory adding terms to the ontology_terms
                                    
                                    new_ont_terms[key2]['terms'].append({cell+"//"+pseudoid:{'term': cell, 'term_id': pseudoid}})
                                    #print(cell,ontology_terms_and_values[key])
                                    
                                    cell= cell+"//"+pseudoid
                                      
                
                #check of date
                
                if 'date' in key:
                    last_part_of_key = key.split("_")[-1] 
                    if "date" in last_part_of_key:
                    
                        #print (type(cell))
                       # print(cell,"before if")
                        currentDateWithoutTime = ""
                        
                        if (isinstance(cell, int)):
                         #   print ("come on")
                            #int_value = int(cell)
                            currentDateWithoutTime = datetime.date(cell, 1, 1)

                        elif ("/" in cell):
                           # print("has /",cell)
                            date_obj = datetime.datetime.strptime(cell, "%d/%m/%Y")
                            currentDateWithoutTime = date_obj.strftime("%Y-%m-%d")
                        elif("-" in cell):
                           # print ("has -")
                            hyphen_count = cell.count("-")
                            if hyphen_count == 1:
                                #print("one -")
                                if re.match("\d{4}-\d{2}$", cell):
                                    #print ("yeahs!")
                                    datetime_object = datetime.datetime.strptime(cell, '%Y-%m')
                                    currentDateWithoutTime = datetime_object.strftime('%Y-%m')
                                else:
                                    #print ("got here else!")
                                    if ( cell in terms_to_fix.keys()):
                                   # print( "ëntrou nesse if aqui a")
                                        if (key in terms_to_fix[cell].keys()):
                                            terms_to_fix[cell][key] += 1
                                    else:
                                # print( "Foi pro else doido")
                                        terms_to_fix[cell] = {}
                                        terms_to_fix[cell] [key] = 1
                            elif hyphen_count == 2:
                                if re.match("\d{4}-\d{2}-\d{2}$", cell):
                                    
                                    datetime_object = datetime.datetime.strptime(cell, '%Y-%m-%d')
                                    currentDateWithoutTime = datetime_object.strftime('%Y-%m-%d')
                                else:
                                    #print ("got here else!")
                                    if ( cell in terms_to_fix.keys()):
                                   # print( "ëntrou nesse if aqui a")
                                        if (key in terms_to_fix[cell].keys()):
                                            terms_to_fix[cell][key] += 1
                                    else:
                                    # print( "Foi pro else doido")
                                        terms_to_fix[cell] = {}
                                        terms_to_fix[cell] [key] = 1    
                        else:
                            
                            if ( cell in terms_to_fix.keys()):
                            # print( "ëntrou nesse if aqui a")
                                if (key in terms_to_fix[cell].keys()):
                                    terms_to_fix[cell][key] += 1
                            else:
                            # print( "Foi pro else doido")
                                terms_to_fix[cell] = {}
                                terms_to_fix[cell] [key] = 1
                    
                        cell = currentDateWithoutTime
                        #print('after',cell)
                #print ("temp_creating",key,cell)
                temp_dict[key]=cell    
                    #checking duplications
        flag_dup =0
        print(temp_dict)

       # print ("Starting checking each category......")
        sample_temp = {}
        #adding sample terms
        for sample_terms in sampleT_terms:
            if sample_terms in temp_dict.keys():
                sample_temp[sample_terms] = temp_dict[sample_terms]
       # print (sample_temp)
        #sys.exit()
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
            
            dict_terms_file['sample'][index]=sample_temp
       # print ("Done Sample......")
        #adding host terms
        host_temp={}
        for terms in hostT_terms:
            if terms in temp_dict.keys():
                host_temp[terms] = temp_dict[terms]
        
        print (host_temp)
        flag_empty =0
        for key_temp in host_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            subflag_dup =0
            index_save = "y"
            for index2 in dict_terms_file['host']:
                if ("sample_collector_sample_ID" in temp_dict.keys()):
                    if dict_terms_file['host'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID'] :
                        for keys_temp in host_temp:
                            if host_temp[keys_temp] != dict_terms_file['host'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
                

            #print("cabou o flagging e ai ???")
            if subflag_dup == 1:
                flag_dup =0
            #else:
                #if (index_save != "y"): 
                # print ("sequence table duplication:","in row:",index_save,"term:",dict_terms_file['sequence'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
            if flag_dup ==0:
                dict_terms_file['host'][index]=host_temp
        print ("Done Host......")
        if ("isolate_ID" in temp_dict.keys()):
            isolate_temp={}
            for isolate_terms in isolateT_terms:
                if isolate_terms in temp_dict.keys():
                    isolate_temp[isolate_terms] = temp_dict[isolate_terms]
            #print (isolate_temp)

            dict_terms_file['isolate'][index]=isolate_temp
        print ("Done Isolates......")
        #adding sequencing terms
        sequencing_temp={}
        for sequencing_terms in sequenceT_terms:
            if sequencing_terms in temp_dict.keys():
                sequencing_temp[sequencing_terms] = temp_dict[sequencing_terms]
        print (sequencing_temp)
        
        subflag_dup =0
        index_save = "y"
        dict_terms_file['sequence'][index]=sequencing_temp
        
        print ("Done Sequencing......")
        #adding environmental
        environmental_temp={}
        for environmental_terms in environmental_conditions_terms:
            if environmental_terms in temp_dict.keys():
                environmental_temp[environmental_terms] = temp_dict[environmental_terms]
        
        print (environmental_temp)
        flag_empty =0
        for key_temp in environmental_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            subflag_dup =0
            index_save = "y"
            for index2 in dict_terms_file['environment']:
                if ("sample_collector_sample_ID" in temp_dict.keys()):
                    if dict_terms_file['environment'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID'] :
                        for keys_temp in environmental_temp:
                            if environmental_temp[keys_temp] != dict_terms_file['environment'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
                

            #print("cabou o flagging e ai ???")
            if subflag_dup == 1:
                flag_dup =0
            #else:
                #if (index_save != "y"): 
                # print ("sequence table duplication:","in row:",index_save,"term:",dict_terms_file['sequence'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
            if flag_dup ==0:
                dict_terms_file['environment'][index]=environmental_temp

        print ("Done Environment......")
        #adding bioinformatics
        bioinformatics_temp={}

        for terms in bioinformatics_terms:
            if terms in temp_dict.keys():
                bioinformatics_temp[terms] = temp_dict[terms]
        
        #print(bioinformatics_terms)
        #sys.exit()
        flag_empty =0
        for key_temp in bioinformatics_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            subflag_dup =0
            index_save = "y"
            for index2 in dict_terms_file['bioinformatics']:
                if ("isolate_ID" in temp_dict.keys()):
                    if dict_terms_file['bioinformatics'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                        for keys_temp in bioinformatics_temp:
                            if bioinformatics_temp[keys_temp] != dict_terms_file['bioinformatics'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
                else:
                    if dict_terms_file['bioinformatics'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID'] :
                        for keys_temp in bioinformatics_temp:
                            if bioinformatics_temp[keys_temp] != dict_terms_file['bioinformatics'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
                

            #print("cabou o flagging e ai ???")
            if subflag_dup == 1:
                flag_dup =0
            #else:
                #if (index_save != "y"): 
                # print ("sequence table duplication:","in row:",index_save,"term:",dict_terms_file['sequence'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
            if flag_dup ==0:
                dict_terms_file['bioinformatics'][index]=bioinformatics_temp
        print ("Done Bioinformatics......")
        #adding taxonomics
        taxonomics_temp={}
        for terms in taxonomic_information_terms:
            if terms in temp_dict.keys():
                taxonomics_temp[terms] = temp_dict[terms]
        
        print (taxonomics_temp)
        flag_empty =0
        for key_temp in taxonomics_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            for keys in taxonomics_temp:
                if(keys not in dict_terms_file['bioinformatics'][index].keys()):
                    dict_terms_file['bioinformatics'][index][keys]=taxonomics_temp[keys]
            
        print ("Done Taxonomics......")
        extraction_temp={}
        for terms in extractionT_terms:
            if terms in temp_dict.keys():
                extraction_temp[terms] = temp_dict[terms]
        
        #print (extraction_temp)
        #sys.exit()
        flag_empty =0
        
        for key_temp in extraction_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            dict_terms_file['extractions'][index]=extraction_temp
        print ("Done Taxonomics......")

        
        #adding public rep
        public_rep_temp={}
        for public_rep_terms in repositoryT_terms:
            if public_rep_terms in temp_dict.keys():
                public_rep_temp[public_rep_terms] = temp_dict[public_rep_terms]
        print (public_rep_temp)
        flag_empty =0
        for key_temp in public_rep_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        print ("checking")
        if (flag_empty == 1):
        
            dict_terms_file['publicRep'][index]=public_rep_temp
        print ("Done Repository......")
        #adding risk terms
        risk_temp = {}
        
        for risk_terms in riskT_terms:
            if risk_terms in temp_dict.keys():
                risk_temp[risk_terms] = temp_dict[risk_terms]
        flag_empty =0
        for key_temp in risk_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):
            subflag_dup =0
            index_save = "y"
            for index2 in dict_terms_file['risk']:
                if ("isolate_ID" in temp_dict.keys()):
                    if dict_terms_file['risk'][index2]['isolate_ID'] == temp_dict['isolate_ID'] :
                        for keys_temp in risk_temp:
                            if risk_temp[keys_temp] != dict_terms_file['risk'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
                else:
                     if dict_terms_file['risk'][index2]['sample_collector_sample_ID'] == temp_dict['sample_collector_sample_ID'] :
                        for keys_temp in risk_temp:
                            if risk_temp[keys_temp] != dict_terms_file['risk'][index2][keys_temp]:
                                subflag_dup = 1
                            else:
                                flag_dup = 1
                                index_save = index2
            if subflag_dup == 1:
                flag_dup =0
        #    else:
              #  if (index_save != "y"): 
                  #  print ("Risk table duplication:","in row:",index_save,"term:",dict_terms_file['risk'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
            if flag_dup ==0:
                dict_terms_file['risk'][index]=risk_temp
        
        #print(amrT_terms)
        print ("Done Risk......")
        #adding amr terms
        amr_temp = {}
        for amr_terms in amrT_terms:
            if amr_terms in temp_dict.keys():
                amr_temp[amr_terms] = temp_dict[amr_terms]
        for amr_keys in temp_dict.keys():
            for anti_terms in antiT_terms:
                if anti_terms in amr_keys:
                    amr_temp[amr_keys] = temp_dict[amr_keys]
        flag_empty =0
        for key_temp in amr_temp.keys():
            if 'sample_ID' not in key_temp and 'isolate_ID' not in key_temp:
                flag_empty =1
        if (flag_empty == 1):            
            subflag_dup =0
            index_save = "y"
            for index2 in dict_terms_file['AMR']:
            # print (dict_terms_file['AMR'][index2], "checking")
                if dict_terms_file['AMR'][index2]['isolate_ID'] == temp_dict['isolate_ID']:
                    for keys_temp in amr_temp:
                        if amr_temp[keys_temp] != dict_terms_file['AMR'][index2][keys_temp]:
                            subflag_dup = 1
                        else:
                            flag_dup = 1
                            index_save = index2
            if subflag_dup == 1:
                flag_dup =0
            #else:
            # if (index_save != "y"): 
                #  print ("AMR table duplication:","in row:",index_save,"term:",dict_terms_file['AMR'][index_save]['isolate_ID']," and ","in row:",index,"term:",temp_dict['isolate_ID'])
            if flag_dup ==0:
                dict_terms_file['AMR'][index]=amr_temp
        
        print(temp_dict)
        temp_dict ={}
        print ("Done AMR......")  
    print ("starting counting")                
    countEvents =0
    if terms_to_fix:
        for termE in terms_to_fix:
            for fieldE in terms_to_fix[termE]:
                print ("The term:",termE," in the field:",fieldE," is different from the vocabulary and appears ",terms_to_fix[termE][fieldE]," times")
                countEvents+=1
    print("A total of terms different from the vocabulary:",countEvents)
    print('done dict of terms')
    #rint(dict_terms_file['extractions'])
    #sys.exit()
    
    
    
    return(dict_terms_file,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list)                                  
        