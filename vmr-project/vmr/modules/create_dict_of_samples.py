import pandas as pd
import sys
import datetime
import re
import copy
import json



#function to process data frame replacing the old column names per new ones
#also replace a single column that it is repeated by every antimicrobial agent
#also replacing names antimicrobial names
def preprocess_dataframe(df, column_mapping, ontology_dict):
    
    #new list of sheets to be added
    new_df_list = []
    #read each name of sheet
    for sheet_name in df:
        #don't consider empty sheets
        if not df[sheet_name].empty:
            #scanning old_column fields and new column fields
            for old_column, new_column in column_mapping.items():
                #if the old_column is AMR_laboratory_typing_method and found in a column, 
                #it needs to be duplicated for each antimicrobial_agent_name
                if old_column == "AMR_laboratory_typing_method" and old_column in df[sheet_name].columns:
                    #loop to get all antimicrobial_agent_Names
                    for entry in ontology_dict["antimicrobial_agent_name"]:
                        #Only retrieve the Term value
                        term_value = entry["Term"]
                        #edit the name which is antibiotics + "_laboratory_typing_method"
                        new_column_name = f"{term_value}_laboratory_typing_method"
                        #add the new column and add the rows from the old version
                        df[sheet_name][new_column_name] = df[sheet_name][old_column]
                    #delete the old column since it was duplicated
                    del df[sheet_name][old_column]
                #antimicrobial_agent_name in the ontology dictionary is different found in most of the templates
                #in the arm spread sheet, the fields with nalidixic_acid should be renamed by "nalidixic acid" for example
                # and oxolinic-acid needs to be renamed for oxolinic acid
                elif(old_column in ["nalidixic_acid", "oxolinic-acid"]):
                    for column_name in df[sheet_name].columns:
                        #if these antibiotics are in a column execute:
                        if old_column in column_name:
                            #substitution of old string by new string in every column name using regular expression
                            #and renaming with the new column name
                            new_column_name = re.sub(r'{}'.format(old_column), new_column, column_name)
                            df[sheet_name].rename(columns={column_name: new_column_name}, inplace=True)
                #other old column names just replace by new column name
                else:
                    #if found in the columns
                    if old_column in df[sheet_name].columns:
                        #replace old name by new name
                        df[sheet_name].rename(columns={old_column: new_column}, inplace=True)
                        
            #just append the sheet to the new list.           
            new_df_list.append(df[sheet_name])

    
    
    return new_df_list

def create_dict_of_samples(xls, ontology_terms_and_values):
    """  Creates a dictionary of user-input, compared against the allowable fields and terms
        checks duplicated rows, dates, etc. as well
        Prints out error where things don't match
        A validated dictionary to insert into DB
    """
    #sheets to be excluded to be stored
    exclude_sheets = ["Reference Guide", "Merged Sheet", "Vocabulary"]
    
    #load json with converting old terms
    with open("/home/gabriel/new_grdi-amr2/grdi-amr2/vmr-project/data/Terms_conversion.json") as f:
        column_mapping = json.load(f)
    
    
    #creating the converter to remove empty spaces first creating the lambda function to strip whitespaces in cells
    strip_converter = lambda x: x.strip() if isinstance(x, str) else x
    #defining the dictionary
    converters = {col: strip_converter for col in range(0, len(pd.ExcelFile(xls).sheet_names))}
    #loading the sheet removing sheets that won't be used, adding the header line 1, excluding some na values
    sheets = pd.read_excel(xls, sheet_name=[sheet for sheet in 
                                                       pd.ExcelFile(xls).sheet_names 
                                                       if sheet not in exclude_sheets],
                                                       header=1,
                                                       na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"],
                                                       converters=converters
                                                       
                                                       )
    #uses preprocess function to correct some 
    sheets = preprocess_dataframe(sheets,column_mapping,ontology_terms_and_values)
    print(sheets)