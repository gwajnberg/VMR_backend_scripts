import psycopg2
from psycopg2 import sql
from pathlib import Path
import pandas as pd
import sys
import datetime
import re
import copy
import argparse
from fill_ontology_fields import fill_ontology_fields
from create_ontology_dict import create_ontology_dict
from create_dict_of_samples import create_dict_of_samples
from feed_vmr_table import feed_vmr_table

#function to check Nan strings

def connect_db():
    conn = psycopg2.connect(
       database="metabaseappdb", user='gabriel', password='gaba1984', host='10.139.14.109', port= '5433'
    )
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
    parser.add_argument("-d", "--drop_off_table_add_sql", help="Drop off tables and re-add sql", default="F")
    parser.add_argument("-i", "--input_file", help="Input File to upload.", type=str)
    args = parser.parse_args()

    
    
    conn,cursor = connect_db()    
    
    #sys.exit()
    xls_file = "GRDI_Harmonization-Template_v8.9.8.xlsm"
    reference_file ="GRDI_Master-Reference-Guide_v8.9.8.xlsx"
    #valid_ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms = create_ontology_as_dict(xls_file)
    if args.drop_off_table_add_sql == "T":
        cursor.execute("SELECT table_name FROM information_schema.tables WHERE table_schema='public';")
        tables_to_drop = cursor.fetchall()

        for table in tables_to_drop:
            table_name = table[0]
            drop_table_query = sql.SQL("DROP TABLE IF EXISTS {} CASCADE;").format(sql.Identifier(table_name))
            cursor.execute(drop_table_query)
            conn.commit()
        schema_file_path = Path("schema/grdi-amr2_schema_latest_version01042024.sql")
        with open(schema_file_path, 'r') as file:
            sql_script = file.read()
            cursor.execute(sql_script)
        conn.commit()
    if args.fill_with_terms == "T":
        fill_ontology_fields(conn,cursor,reference_file)
    if (args.input_file):
        valid_ontology_terms_and_values,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms = create_ontology_dict(xls_file)
        xls_file2 = args.input_file
        print("uploading file ", xls_file2)
        dict_of_samples,new_ont_terms = create_dict_of_samples(xls_file2, valid_ontology_terms_and_values, antimicrobian_agent_names_ids)
        print ("starting to feed vmr")
        feed_vmr_table(dict_of_samples,antimicrobian_agent_names_ids,sampleT_terms,isolateT_terms,hostT_terms,sequenceT_terms,repositoryT_terms,riskT_terms,amrT_terms,antiT_terms,conn,cursor,new_ont_terms)

   

    
if __name__ == '__main__':
    try:
        main()
        print('Program finished')
    except Exception as e:
        print('Error : {}'.format(e))