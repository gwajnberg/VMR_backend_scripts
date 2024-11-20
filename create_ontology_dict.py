"""
    Create a dictionary of the ontology terms.
    Looking at having the terms defined here, with possible sets of values.
    In the current sheet, the terms are in row 2, with samples in following rows.
    We will add actual data based on this dictionary from a separate function.
    Possibil
"""
import pandas as pd
import sys
import datetime
import re




def create_ontology_dict(xls):
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
    
    ##adding moved isolate terms
    isolateT_terms.extend(['biosample_accession', 'bioproject_accession'])
 
    
    hostT_terms = reading_file("Host Information")
    sequenceT_terms = reading_file("Sequence Information")
    
    repositoryT_terms = reading_file("Public Repository Information")
    #removing from repository_T

    #repositoryT_terms.remove('biosample_accession')
    #repositoryT_terms.remove('bioproject_accession')
    riskT_terms = reading_file("Risk Assessment")
    amrTotal_terms= reading_file("AMR Phenotypic Test Information")
    environmental_conditions_terms = reading_file("Environmental conditions")
    bioinformatics_terms = reading_file("Bioinformatics and QC")
    taxonomic_information_terms = reading_file("Taxonomic Information")
    #print(sampleT_terms)
    extractionT_terms = []

    # Add the first item of `sampleT_terms` to `extractionT_terms`
    extractionT_terms.append(sampleT_terms[0])

    # Add "isolate_ID" to `extractionT_terms`
    extractionT_terms.append("isolate_ID")

    # Patterns to search for
    patterns = ['experimental', 'nucleic_acid', 'sample_volume', 'residual_sample', 'sample_storage']

    # Add terms that start with any of the specified patterns to `extractionT_terms`
    # and remove them from `sampleT_terms`
    extractionT_terms.extend([term for term in sampleT_terms if any(term.startswith(pattern) for pattern in patterns)])
    sampleT_terms = [term for term in sampleT_terms if not any(term.startswith(pattern) for pattern in patterns)]
    
    #print(sampleT_terms)
    #print(extractionT_terms)
    #sys.exit()
    

    
    
    antiT_terms=amrTotal_terms[9:]
    

    amrT_terms=amrTotal_terms[:9]
    print ("done elements")
    
    
            
    
    vocab_sheet = pd.read_excel(xls,keep_default_na=False,converters={column: lambda x: x.strip() for column in list(range(20))}, sheet_name="Vocabulary", header=1)
    
    ontology_dict = vocab_sheet.to_dict(orient='list')
    ontology_dict = {key.strip(): value for key, value in ontology_dict.items()}
    fields_sheet = pd.read_excel(xls,keep_default_na=False, sheet_name="Reference Guide", header=4)
    #fields_sheet_filtered = fields_sheet[fields_sheet["Ontology ID"].str.contains("GENEPIO")==True]
    fields_sheet_filtered = fields_sheet[(fields_sheet["Ontology ID"].str.contains("GENEPIO")) | (fields_sheet.iloc[:, 0].str.startswith("antimicrobial"))]
    
    dict_fields={}
    for index, row in fields_sheet_filtered.iterrows():
        sample_key = row["Sample collection and processing"]
        dict_fields[sample_key] = {}
    new_merged_ontology_dict = {}
    
    for key in dict_fields:
        
        keypr = ""
        if (key == "antimicrobial_resistance_phenotype"):
            keypr = "antimicrobial_phenotype"
        elif (key == "food_product_origin geo_loc_name (country)"):
            keypr = "food_product_origin geo_loc (country)"
        else:
            keypr = key
        if keypr in ontology_dict.keys():
            
            str_list = list(filter(None, ontology_dict[keypr]))
            
            temp_list=[];
            for i in str_list:
                newstr = i.strip()
                #print (newstr)
                
                if re.match(".+\[\w",newstr):
                    #print("HERE")
                    substrL= re.match("(.+)\s+\[(\S+)\]",newstr)
                    
                    #print("NOW",substrL)
                    temp_list.append({newstr:{"term":substrL.groups()[0],"term_id":substrL.groups()[1]}})
                    #print("AFTER")

                        
                else:
                 
                    temp_list.append(newstr)
                   
            new_merged_ontology_dict [key] = {"field_id":key,"terms":temp_list}
                    
        else:
                         
        
            new_merged_ontology_dict [key] = {"field_id":key}
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
    
    #print(new_merged_ontology_dict['food_product_origin geo_loc_name (country)'])
    #sys.exit()
    #sys.exit()
    #taxonomic_identification_process
    
    return (new_merged_ontology_dict,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,extractionT_terms)   
 