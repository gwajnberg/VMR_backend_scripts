import json
import psycopg2
import sys
import math






def parse(json_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    return data
def print_inserts(insert_string,values):
        formatted_insert = insert_string
        formatted_insert = formatted_insert.replace(" RETURNING id", "")
        if values:
            for term in values:
                
                if term is None:
                    term_str = 'NULL'
                elif isinstance(term, str):
                    term_str = f"'{term}'"
                else:
                    term_str = str(term)
        
                formatted_insert = formatted_insert.replace('%s', term_str, 1)
                

        output_file = "formatted_sql_command_genes.txt"
        with open(output_file, "a") as file:  # 'a' mode opens the file for appending
            file.write(formatted_insert + ";\n")
def insert_data(data,field_name,conn,cursor,mode):
    table_ex = ""
    if (mode == "wgs"):
            table_ex= "wgs_extractions"
    elif (mode == "metagenomics"):
            table_ex = "metagenomic_extractions"
    else:
        print ("Invalid response. Please enter 'wgs' or 'metagenomics'.")
        exit()
    
    for irida_id in data:
        
        
        first_element = data[irida_id]
        
        id_search = first_element.get('isolate_id', 'N/A')
    
        if (field_name == 'strain'):
            cursor.execute("SELECT id FROM strains WHERE strain = %s", (id_search,))
            result = cursor.fetchone()
            id_search = result[0]
        #  print(id_search)
        if first_element['staramr']['resfinder_genes']:
            resfinder_genes = first_element.get('staramr', {}).get('resfinder_genes', [])
        # print (resfinder_genes)
            for gene_resfinder in resfinder_genes:
                
                insert = """
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.{} = %s
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, %s
                        FROM sequencing_info
                        RETURNING id

                        """.format(table_ex,field_name)
            # print ('here')
                if isinstance(gene_resfinder['gene'], float) and math.isnan(gene_resfinder['gene']):  # Check for NaN
                    gene_resfinder['gene'] = None
            # print('ehre1')
                print_inserts(insert,(id_search,gene_resfinder['gene'],))
                cursor.execute(insert, (id_search,gene_resfinder['gene'],))
                
                resfinder_id = cursor.fetchone()[0]
                conn.commit()
                
                for phenotype in gene_resfinder['phenotypes']:
                    
                    insert_phenotype_query = """
                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (%s, %s);
                                            """
                    print_inserts(insert_phenotype_query, (resfinder_id, phenotype,))
                    cursor.execute(insert_phenotype_query, (resfinder_id, phenotype,))
                    conn.commit()
        print ('MLST')       
        if first_element['staramr']['mlst_result']:
            mlst_sequence = first_element.get('staramr', {}).get('mlst_result', {}).get('mlst_sequence', 'N/A')
            mlst_scheme = first_element.get('staramr', {}).get('mlst_result', {}).get('mlst_scheme', 'N/A')
            insert = """
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.{} = %s
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, %s, %s
                        FROM sequencing_info
                        

                        """.format(table_ex,field_name)
            print_inserts(insert,(id_search,mlst_sequence,mlst_scheme,))
            cursor.execute(insert, (id_search,mlst_sequence,mlst_scheme,))
            
        print ('Plasmid Finder')
        if first_element['staramr']['plasmid_finder']:

            
            plasmid_finder = first_element.get('staramr', {}).get('plasmid_finder', [])
            print (plasmid_finder)
            
            for plasmid_finder_gene in plasmid_finder:
                print (plasmid_finder_gene)    
                if not (isinstance(plasmid_finder_gene, (int, float)) and math.isnan(plasmid_finder_gene)) and isinstance(plasmid_finder_gene, str):
                    insert = """
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.{} = %s
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, %s
                        FROM sequencing_info
                        

                        """.format(table_ex,field_name)
                
                
                    print_inserts(insert,(id_search,plasmid_finder_gene,))
                    cursor.execute(insert, (id_search,plasmid_finder_gene,))
        print ('ABRICATE')
        print(first_element['abricate'])
        if first_element['abricate']:
            abricate_genes = first_element.get('abricate', [])
            for abricate_gene in abricate_genes:
                insert = """
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.{} = %s
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, %s, %s
                        FROM sequencing_info
                        

                        """.format(table_ex,field_name)
                print_inserts(insert,(id_search,abricate_gene['gene'],abricate_gene['product_resistance'],))
                
                cursor.execute(insert, (id_search,abricate_gene['gene'],abricate_gene['product_resistance'],))
        print ('mob_rgi_results') 
        if first_element['mob_rgi_results']:
            mob_rgi_results = first_element.get('mob_rgi_results', [])
            #print (mob_rgi_results)
            for results in  mob_rgi_results:
                
                insert = """
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {} we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.{} = %s
                        )
                        INSERT INTO bioinf.amr_genes_profiles (SEQUENCING_ID, cut_off,best_hit_aro,model_type)
                        SELECT id, %s, %s, %s
                        FROM sequencing_info
                        RETURNING id

                        """.format(table_ex,field_name)
                #print('here')
                print_inserts(insert,(id_search,results['cut_off'],results['best_hit_aro'],results['model_type'],))
                #print('here')
                cursor.execute(insert, (id_search,results['cut_off'],results['best_hit_aro'],results['model_type'],))
                
                amr_profiles_id = cursor.fetchone()[0]
                conn.commit()
                for drug in results['drug_class']:
                    if "''" in drug: 
                        drug = drug.replace("''", "''''")
                    elif "'" in drug: 
                        drug = drug.replace("'", "''")
                    insert_drugs_query = """
                                            INSERT INTO bioinf.amr_genes_drugs (amr_genes_id, drug_id)
                                            VALUES (%s, %s);
                                            """
                    print_inserts(insert_drugs_query, (amr_profiles_id, drug,))
                    cursor.execute(insert_drugs_query, (amr_profiles_id, drug,))
                    conn.commit()
                for element in results['resistance_mechanism']:
                    if "''" in element: 
                        element = element.replace("''", "''''")
                    elif "'" in element: 
                        element = element.replace("'", "''")
                    insert_resistance_query = """
                                            INSERT INTO bioinf.amr_genes_resistance_mechanism (amr_genes_id, resistance_mechanism_id )
                                            VALUES (%s, %s);
                                            """
                    print_inserts(insert_resistance_query, (amr_profiles_id, element,))
                    cursor.execute(insert_resistance_query, (amr_profiles_id, element,))
                for families in results['amr_gene_families']:
                    if "''" in families: 
                        families = families.replace("''", "''''")
                    elif "'" in families: 
                        families = families.replace("'", "''")
                    insert_families_query = """
                                            INSERT INTO bioinf.amr_genes_families (amr_genes_id, amr_gene_family_id )
                                            VALUES (%s, %s);
                                            """
                    print_inserts(insert_families_query, (amr_profiles_id, families,))
                    cursor.execute(insert_families_query, (amr_profiles_id, families,))
            
                if results['mob_suite_results']:
                
                    mob_suite_results = results.get('mob_suite_results', {})
                    
                    insert_amr_mob_suite_query = """
                                            INSERT INTO bioinf.amr_mob_suite (amr_genes_id, molecule_type,primary_cluster_id,secondary_cluster_id )
                                            VALUES (%s, %s,%s,%s);
                                            """
                    #sys.exit()
                    primary_cluster_id = mob_suite_results['primary_cluster_id']
                    secondary_cluster_id = mob_suite_results['secondary_cluster_id']
                    if(primary_cluster_id == '-'):
                        primary_cluster_id = None
                    if (secondary_cluster_id == '-'):
                        secondary_cluster_id = None
                    print_inserts(insert_amr_mob_suite_query, (amr_profiles_id, mob_suite_results['molecule_type'],primary_cluster_id,secondary_cluster_id,))
                    cursor.execute(insert_amr_mob_suite_query,  (amr_profiles_id, mob_suite_results['molecule_type'],primary_cluster_id,secondary_cluster_id,))

                    if mob_suite_results['amr_relaxase_type'][0] != '-':
                        for relaxase in mob_suite_results['amr_relaxase_type']:
                            query = """
                                    SELECT 1 FROM bioinf.amr_relaxase_type 
                                    WHERE amr_genes_id = %s AND relaxase_type = %s;
                                    """
                            cursor.execute(query, (amr_profiles_id, relaxase))
                            exists = cursor.fetchone()

                            if not exists:
                                insert_relaxase_query = """
                                                INSERT INTO bioinf.amr_relaxase_type  (amr_genes_id, relaxase_type )
                                                VALUES (%s, %s);
                                                """
                                print_inserts(insert_relaxase_query, (amr_profiles_id, relaxase,))
                                cursor.execute(insert_relaxase_query, (amr_profiles_id, relaxase,))
                    if mob_suite_results['amr_mpf_type'][0] != '-':
                        for mpf in mob_suite_results['amr_mpf_type']:
                            query = """
                                    SELECT 1 FROM bioinf.amr_mpf_type 
                                    WHERE amr_genes_id = %s AND mpf_type = %s;
                                    """
                            cursor.execute(query, (amr_profiles_id, mpf))
                            exists = cursor.fetchone()

                            if not exists:
                                insert_mpf_query = """
                                                INSERT INTO bioinf.amr_mpf_type  (amr_genes_id, mpf_type )
                                                VALUES (%s, %s);
                                                """
                                print_inserts(insert_mpf_query, (amr_profiles_id, mpf,))
                                cursor.execute(insert_mpf_query, (amr_profiles_id, mpf,))
                    if mob_suite_results['amr_orit_type'][0] != '-':
                        for orit in mob_suite_results['amr_orit_type']:
                            insert_orit_query = """
                                            INSERT INTO bioinf.mr_orit_types  (amr_genes_id, orit_type )
                                            VALUES (%s, %s);
                                            """
                            print_inserts(insert_orit_query, (amr_profiles_id, orit,))
                            cursor.execute(insert_orit_query, (amr_profiles_id, orit,))
                    if mob_suite_results['amr_orit_type'][0] != '-':
                        for orit in mob_suite_results['amr_orit_type']:
                            insert_orit_query = """
                                            INSERT INTO bioinf.mr_orit_types  (amr_genes_id, orit_type )
                                            VALUES (%s, %s);
                                            """
                            print_inserts(insert_orit_query, (amr_profiles_id, orit,))
                            cursor.execute(insert_orit_query, (amr_profiles_id, orit,))
                    if mob_suite_results['amr_predicted_mobility'][0] != '-':
                        for mobility in mob_suite_results['amr_predicted_mobility']:
                            insert_mobility_query = """
                                            INSERT INTO bioinf.amr_predicted_mobility  (amr_genes_id, predicted_mobility )
                                            VALUES (%s, %s);
                                            """
                            print_inserts(insert_mobility_query, (amr_profiles_id, mobility,))
                            cursor.execute(insert_mobility_query, (amr_profiles_id, mobility,))
                    if mob_suite_results['amr_ref_type'][0] != '-':
                        for ref in mob_suite_results['amr_ref_type']:
                            insert_ref_query = """
                                            INSERT INTO bioinf.amr_ref_type  (amr_genes_id, rep_type )
                                            VALUES (%s, %s);
                                            """
                            print_inserts(insert_ref_query, (amr_profiles_id, ref,))
                            cursor.execute(insert_ref_query, (amr_profiles_id, ref,))
                    










                     
                 