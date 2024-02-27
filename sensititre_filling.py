import pandas as pd
import sys
import re
from openpyxl import load_workbook

if len(sys.argv) != 3:
    print("Usage: python sensititre_filling.py <excel_template_path> <excel_sensititre_tab")
    sys.exit(1)

excel_file = sys.argv[1]
excel_sfile = sys.argv[2]

antibiotics = {
        "AUG":	"amoxicillin-clavulanic_acid",
        "AMP":	"ampicillin",
        "AZT":	"azithromycin",
        "FOX":	"cefoxitin",
        "CEF":	"ceftiofur",
        "AXO":	"ceftriaxone",
        "CHL":	"chloramphenicol",
        "CIP":	"ciprofloxacin",
        "GEN":	"gentamicin",
        "KAN": 	"kanamycin",
        "NAL":	"nalidixic_acid",
        "STR":	"streptomycin",
        "SSX":	"sulfisoxazole",
        "TET":	"tetracycline",
        "SXT": 	"trimethoprim-sulfamethoxazole"
}
pheno = {
        'S': 'Susceptible antimicrobial phenotype',
        'R': 'Resistant antimicrobial phenotype',
        'I': 'Intermediate antimicrobial phenotype'

    }

template = pd.read_excel(excel_file, sheet_name='AMR Phenotypic Test Information', header=1)
sensititre_tab = pd.read_excel(excel_sfile,keep_default_na=False, sheet_name="Sensititre_Raw_Data", header=0)
signs = { 
        '<': 'less than (<) [GENEPIO:0001002]',
        '>': 'greater than (>) [GENEPIO:0001006]',
        '≤': 'less than or equal to (<=) [GENEPIO:0001003]',
        '≥': 'greater than or equal to (>=) [GENEPIO:0001005]'


    }
pheno = {
        'S': 'Susceptible antimicrobial phenotype [ARO:3004302]',
        'R': 'Resistant antimicrobial phenotype [ARO:3004301]',
        'I': 'Intermediate antimicrobial phenotype [ARO:3004300]'

    }


for index, row in sensititre_tab.iterrows():
    new_data = {
    }
    
    for column_name, cell_value in row.items():
        if column_name == "Isolate_Tracker":
            new_data['isolate_ID'] = cell_value
        if column_name in antibiotics.keys():
                if cell_value != "NT" and cell_value != "-":
                  #  print (antibiotics[column_name])
                  #  print (cell_value)
                    pattern = r'([<>=≤≥])?(\d+(\.\d+)?)'
                    matches = re.findall(pattern, str(cell_value))
                    if (matches[0][0]):
                        sign = matches[0][0]
                        if (sign in signs.keys()):
                            new_data[antibiotics[column_name]+ "_measurement"] = matches[0][1]
                            new_data[antibiotics[column_name]+ "_measurement_units"] = signs[sign]

                    else:
                        
                        new_data[antibiotics[column_name]+ "_measurement"] = matches[0][1]
                        new_data[antibiotics[column_name]+ "_measurement_units"] = "equal to (==) [GENEPIO:0001004]"
        if column_name.upper() in antibiotics.keys() and cell_value in pheno.keys():
               # print ("pheno", antibiotics[column_name.upper()])
               # print (cell_value)
            if cell_value != 'NT' and cell_value != "NOMIC":
                new_data[antibiotics[column_name.upper()]+"_resistance_phenotype"] =pheno[cell_value]
    new_row_df = pd.DataFrame([new_data])
    template = pd.concat([template, new_row_df], ignore_index=True) 
 #   print(new_data)
  #  sys.exit()
   
   # new_row_df = pd.DataFrame([new_data])
   # template = pd.concat([template, new_row_df], ignore_index=True)            
   # print (template['amoxicillin-clavulanic_acid_measurement'])
    #sys.exit()                 
        




#new_row_df = pd.DataFrame([new_data])
#template = pd.concat([template, new_row_df], ignore_index=True)
print (template)

excel_file_path = 'amr_sheet_output.xls'

# Write the DataFrame to an Excel file
template.to_excel(excel_file_path, index=False, engine='openpyxl')