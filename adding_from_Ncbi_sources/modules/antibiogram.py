import pandas as pd
import sys

def antibiogram(file):
    
    df = pd.read_excel(file, header=17)
    
    df.columns = df.columns.str.replace('*', '', regex=False)
    
    resistance_phenotype = [
        "Antibiotic resistance not defined [GENEPIO:0002040]",
        "Intermediate antimicrobial phenotype [ARO:3004300]",
      "Indeterminate antimicrobial phenotype [GENEPIO:0100585]",
    "Nonsusceptible antimicrobial phenotype [ARO:3004303]",
    "Resistant antimicrobial phenotype [ARO:3004301]",
    "Susceptible antimicrobial phenotype [ARO:3004302]",
    "Susceptible dose dependent antimicrobial phenotype [ARO:3004304]",
    "Not Applicable [GENEPIO:0001619]",
    "Not Collected [GENEPIO:0001620]",
    "Not Provided [GENEPIO:0001668]",
    "Missing [GENEPIO:0001618]",
    "Restricted Access [GENEPIO:0001810]"


    ]
    measurement_units= [
        "mg/L [UO:0000273]",
    "mm [UO:0000016]",
"ug/mL [UO:0000274]",
"Not Applicable [GENEPIO:0001619]",
"Not Collected [GENEPIO:0001620]",
"Not Provided [GENEPIO:0001668]",
"Missing [GENEPIO:0001618]",
"Restricted Access [GENEPIO:0001810]"

    ]

    measurement_sign= [
        "less than (<) [GENEPIO:0001002]",
"less than or equal to (<=) [GENEPIO:0001003]",
"equal to (==) [GENEPIO:0001004]",
"greater than (>) [GENEPIO:0001006]",
"greater than or equal to (>=) [GENEPIO:0001005]",
"Not Applicable [GENEPIO:0001619]",
"Not Collected [GENEPIO:0001620]",
"Not Provided [GENEPIO:0001668]",
"Missing [GENEPIO:0001618]",
"Restricted Access [GENEPIO:0001810]"


    ]

    laboratory_typing_method=[
        "Agar diffusion [NCIT:85595]",
      "Antimicrobial gradient (E-test) [NCIT:85596]",
"Agar dilution [ARO:3004411]",
"Broth dilution [ARO:3004397]",
"Not Applicable [GENEPIO:0001619]",
"Not Collected [GENEPIO:0001620]",
"Not Provided [GENEPIO:0001668]",
"Missing [GENEPIO:0001618]",
"Restricted Access [GENEPIO:0001810]",

    ]

    laboratory_typing_platform =[
        "BIOMIC Microbiology System [ARO:3007569]",
"Microscan [ARO:3004400]",
"Phoenix [ARO:3004401]",
"Sensititre [ARO:3004402]",
"Vitek System [ARO:3004403]",
"Not Applicable [GENEPIO:0001619]",
"Not Collected [GENEPIO:0001620]",
"Not Provided [GENEPIO:0001668]",
"Missing [GENEPIO:0001618]",
"Restricted Access [GENEPIO:0001810]",

    ]

    vendor_name =[
        "Becton Dickinson [ARO:3004405]",
    "bioMérieux [ARO:3004406]",
    "Omron [ARO:3004408]",
    "Siemens [ARO:3004407]",
    "Trek [ARO:3004409]",
    "Not Applicable [GENEPIO:0001619]",
    "Not Collected [GENEPIO:0001620]",
    "Not Provided [GENEPIO:0001668]",
    "Missing [GENEPIO:0001618]",
    "Restricted Access [GENEPIO:0001810]",

    ]

    testing_standard =[
    "British Society for Antimicrobial Chemotherapy (BSAC) [ARO:3004365]",
    "Clinical Laboratory and Standards Institute (CLSI) [ARO:3004366]",
    "Deutsches Institut für Normung (DIN) [ARO:3004367]",
    "European Committee on Antimicrobial Susceptibility Testing (EUCAST) [ARO:3004368]",
    "National Antimicrobial Resistance Monitoring System (NARMS) [ARO:3007195]",
    "National Committee for Clinical Laboratory Standards (NCCLS) [ARO:3007193]",
    "Société Française de Microbiologie (SFM) [ARO:3004369]",
    "Swedish Reference Group for Antibiotics (SIR) [ARO:3007397]",
    "Werkgroep Richtlijnen Gevoeligheidsbepalingen (WRG) [ARO:3007398]",
    "Not Applicable [GENEPIO:0001619]",
    "Not Collected [GENEPIO:0001620]",
    "Not Provided [GENEPIO:0001668]",
    "Missing [GENEPIO:0001618]",
    "Restricted Access [GENEPIO:0001810]"

    ]
    dictionary_antibiogram = {}
    for index, row in df.iterrows():
        temp={}
        flag =0
        if row['antibiotic'] == 'amoxicillin-clavulanic acid':
            row['antibiotic'] = 'amoxicillin-clavulanic_acid'
        if row['antibiotic'] == 'nalidixic acid':
            row['antibiotic'] = 'nalidixic_acid'
        res_field =  row["antibiotic"] +"_"+ "resistance_phenotype"
        if (row["resistance_phenotype"].lower() == 'susceptible'):
            temp[res_field] =  "Susceptible antimicrobial phenotype [ARO:3004302]"
            flag =1
        else:
            for item in resistance_phenotype:
                if (row["resistance_phenotype"].lower() in item.lower()):
                    temp[res_field] = item
                    flag = 1

        if flag == 0 :
            temp[res_field] = row["resistance_phenotype"]
        

        flag =0
        res_field =  row["antibiotic"] +"_"+ "measurement_sign"
        
        for item in measurement_sign:
            if (row["measurement_sign"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["measurement_sign"]

        flag =0
        res_field =  row["antibiotic"] +"_"+ "vendor_name"
        for item in vendor_name:
            if (row["vendor"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["vendor"]
        
        res_field =  row["antibiotic"]  +"_"+ "measurement"
        temp[res_field] = row["measurement"]
        

        flag =0
        res_field =  row["antibiotic"]  +"_"+ "measurement_units"
        for item in measurement_units:
            if (row["measurement_units"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["measurement_units"]
        
        flag =0
        res_field =  row["antibiotic"] +"_"+ "laboratory_typing_method"
        for item in laboratory_typing_method:
            if (row["laboratory_typing_method"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["laboratory_typing_method"]
        
        flag =0
        res_field =  row["antibiotic"] +"_"+ "laboratory_typing_platform"
        for item in laboratory_typing_platform:
            if (row["laboratory_typing_platform"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["laboratory_typing_platform"]

        
        flag =0
        res_field =  row["antibiotic"] +"_"+ "testing_standard"
        for item in testing_standard:
            if (row["testing_standard"].lower() in item.lower()):
                temp[res_field] = item
                flag = 1

        if flag ==0 :
            temp[res_field] = row["testing_standard"]
        

        
        res_field =  row["antibiotic"] +"_"+ "laboratory_typing_platform_version"
        temp[res_field] = row["laboratory_typing_method_version_or_reagent"]
        isolate_id = row["sample_name/biosample_accession"]
        
        if row["sample_name/biosample_accession"] not in dictionary_antibiogram.keys():
            dictionary_antibiogram[isolate_id] =[]
            dictionary_antibiogram[isolate_id].append(temp)
        else:
            dictionary_antibiogram[isolate_id].append(temp)

    return(dictionary_antibiogram)