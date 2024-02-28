import pandas as pd
import sys
import datetime
import re
import copy


def create_dict_of_samples(xls, ontology_terms_and_values):
    """  Creates a dictionary of user-input, compared against the allowable fields and terms
        checks duplicated rows, dates, etc. as well
        Prints out error where things don't match
        A validated dictionary to insert into DB
    """
    #sheets to be excluded to be stored
    exclude_sheets = ["Reference Guide", "Merged Sheet", "Vocabulary"]
    
    #loading the sheet removing sheets that won't be used, adding the header line 1, excluding some na values
    sheets_dict = pd.read_excel(xls, sheet_name=[sheet for sheet in 
                                                       pd.ExcelFile(xls).sheet_names 
                                                       if sheet not in exclude_sheets],header=1,na_values=[datetime.time(0, 0),"1900-01-00","Missing","missing","Not Applicable [GENEPIO:0001619]"])
    print(sheets_dict)