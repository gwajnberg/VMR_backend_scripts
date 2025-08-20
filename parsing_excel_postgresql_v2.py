import psycopg2
from psycopg2 import sql
from pathlib import Path
import pandas as pd
import sys
import os
import argparse
from fill_ontology_fields import fill_ontology_fields
from create_ontology_dict import create_ontology_dict
from create_dict_of_samples import create_dict_of_samples
from create_dict_of_samples_one import create_dict_of_samples_one
from gene_mode import parse, insert_data
from feed_vmr_table import feed_vmr_table

#function to check Nan strings

def connect_db():
    conn = psycopg2.connect(
    database=os.getenv("PGDATABASE", "vmrdb"),
    user=os.getenv("PGUSER", "vmr"),
    password=os.getenv("PGPASSWORD", "vmr"),
    host=os.getenv("PGHOST", "localhost"),
    port=os.getenv("PGPORT", "5433")
)
    
    
    print("Connection to PostgreSQL established successfully")
    cursor = conn.cursor()
    return(conn,cursor)

def main():
    """
    Execute main function for parsing / validation.
    General workflow is:
    1. Get the terms and values from the "Vocabulary" sheet in the Harmonized Data file.
    2. Process the merged sheet, store the values as a dictionary mimicking ontology
    3. Store data in Dgraph / SQL
    """
    parser = argparse.ArgumentParser(description='Parsing program for AMR database.')
    parser.add_argument("-f", "--fill_with_terms", help="Fill tables with template terms", default="F")
    parser.add_argument("-i", "--input_file", help="Input File to upload.", type=str)
    parser.add_argument("-o", "--one", help="input file is one sheet", default="F")
    parser.add_argument("-m", "--mode", help="For input sheet is metagenomics or wgs", default=str)
    parser.add_argument("-g", "--gene_mode",help= "Add rgi/mob_suite output file to the VMR", default="F")
    parser.add_argument("-F", "--field_name",help= "field name used for irida naming.Default='Isolate_ID'", default="isolate_id")
    parser.add_argument("--auto",help="Run without prompts, assuming 'yes' for all questions (for CI use)", action="store_true"
)
    args = parser.parse_args()

    
    
    conn,cursor = connect_db()
    if args.gene_mode == "T":
        json_file = args.input_file
        print("uploading file ", json_file)
        data = parse(json_file)
        print ('done')
        insert_data(data,args.field_name,conn,cursor,args.mode )

        sys.exit()    
    
    #sys.exit()
    xls_file = "GRDI_Harmonization-Template_v14.5.4.xlsm"
    reference_file ="GRDI_Master-Reference-Guide_v14.5.4.xlsx"
    #valid_ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms = create_ontology_as_dict(xls_file)
    
    if args.fill_with_terms == "T":
        fill_ontology_fields(conn,cursor,reference_file)
    if (args.input_file):
        
        valid_ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,extractionT_terms = create_ontology_dict(xls_file)
        
        xls_file2 = args.input_file
        print("uploading file ", xls_file2)
        #print (valid_ontology_terms_and_values)
        #sys.exit()
        dict_of_samples = {}
        new_ont_terms = {}
        terms_accepting_multiple_values = []
        sample_flagged_list = []
        if (args.one == "F"):
            dict_of_samples,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list = create_dict_of_samples(xls_file2, valid_ontology_terms_and_values, antimicrobian_agent_names_ids)
            
            
        else:
            dict_of_samples,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list = create_dict_of_samples_one(xls_file2, valid_ontology_terms_and_values, antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,extractionT_terms)
            
        mode =""
        if (args.mode == "wgs"):
            mode = 1
        elif (args.mode == "metagenomics"):
            mode = 2
        else:
            print ("Invalid response. Please enter 'wgs' or 'metagenomics'.")
            exit()
#        response = input("Report Finished. Do you want to proceed with a script? (yes/no): ")
#        if response.lower() == "yes":
#            print("Continuing with the script...")
#            print ("starting to feed vmr")
#            feed_vmr_table(dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,environmental_conditions_terms,bioinformatics_terms,taxonomic_information_terms,conn,cursor,new_ont_terms,terms_accepting_multiple_values,sample_flagged_list,mode)
#        elif response.lower() == "no":
#            print("Exiting the script.")
#        else:
#            print("Invalid response. Please enter 'yes' or 'no'.")
#            exit()
        if args.auto:
            response = "yes"
        else:
            response = input("Report Finished. Do you want to proceed with a script? (yes/no): ")

        if response.lower() == "yes":
            print("Continuing with the script...")
            print("starting to feed vmr")
            feed_vmr_table(
                dict_of_samples, antimicrobian_agent_names_ids, sampleT_terms, isolateT_terms,
                hostT_terms, sequenceT_terms, repositoryT_terms, riskT_terms, amrT_terms,
                antiT_terms, environmental_conditions_terms, bioinformatics_terms,
                taxonomic_information_terms, conn, cursor, new_ont_terms,
                terms_accepting_multiple_values, sample_flagged_list, mode
            )
        elif response.lower() == "no":
            print("Exiting the script.")
        else:
            print("Invalid response. Please enter 'yes' or 'no'.")
            exit()
        

   

    
if __name__ == '__main__':
    try:
        main()
        print('Program finished')
    except Exception as e:
        print('Error : {}'.format(e))