import json
import psycopg2
import sys
import math




def parse(json_file):
    with open(json_file, 'r') as f:
        data = json.load(f)
    return data

def escape_quotes(value):
    """
    Safely escape single quotes in a string for SQL.
    Converts None to None and escapes ' characters.
    """
    if value is None:
        return None
    if isinstance(value, str):
        return value.replace("'", "''")
    return value

def print_inserts(insert_string, values):
    formatted_insert = insert_string
    formatted_insert = formatted_insert.replace(" RETURNING id", "")
    if values:
        for term in values:
            if term is None or (isinstance(term, float) and math.isnan(term)):
                term_str = 'NULL'
            elif isinstance(term, str):
                term_str = f"'{term}'"
            else:
                term_str = str(term)
            formatted_insert = formatted_insert.replace('%s', term_str, 1)

    output_file = "formatted_sql_command_genes.txt"
    with open(output_file, "a") as file:
        file.write(formatted_insert + ";\n")

def check_exists_id(isolate_id, table, table_ex, cursor):
    sql_query = """
            SELECT id
            FROM {}
            WHERE sequencing_id
            IN (SELECT id
                FROM sequencing
                WHERE extraction_id IN (SELECT extraction_id
                                        FROM {}
                                        WHERE isolate_id = %s
                                        )
                )
            """.format(table, table_ex)
    print(sql_query, (isolate_id,))
    cursor.execute(sql_query, (isolate_id,))
    result = cursor.fetchall()
    if result:
        return "yes"
    return ""

def print_delete(sql, value):
    formatted = sql
    if value is not None:
        formatted = formatted.replace('%s', f"'{value}'" if isinstance(value, str) else str(value), 1)
    output_file = "formatted_sql_command_genes.txt"
    with open(output_file, "a") as file:
        file.write(formatted.strip() + ";\n")

def delete_existing(isolate_id, table, table_ex, cursor):
    sql = """
        DELETE FROM {}
        WHERE sequencing_id IN (
            SELECT s.id FROM sequencing s
            JOIN {} we ON s.extraction_id = we.extraction_id
            WHERE we.isolate_id = %s
        )
    """.format(table, table_ex)
    print_delete(sql, isolate_id)
    cursor.execute(sql, (isolate_id,))
    print(f"  -> Deleted existing rows from {table} for isolate {isolate_id}")

def insert_data(data, field_name, conn, cursor, mode, replace_mode=False):
    table_ex = ""
    if mode == "wgs":
        table_ex = "wgs_extractions"
    elif mode == "metagenomics":
        table_ex = "metagenomic_extractions"
    else:
        print("Invalid response. Please enter 'wgs' or 'metagenomics'.")
        exit()

    for irida_id in data:

        first_element = data[irida_id]

        id_search = first_element.get('isolate_id', 'N/A')
        print('new id:', id_search)
        if field_name == 'strain':
            cursor.execute("SELECT id FROM isolates WHERE strain IN ( select id FROM strains WHERE strain = %s)", (id_search,))
            result = cursor.fetchone()
            id_search = result[0]
        if field_name == 'irida_sample_id':
            cursor.execute("SELECT id from isolates WHERE irida_sample_id= %s", (id_search,))
            result = cursor.fetchone()
            id_search = result[0]
        if field_name == 'isolate_id':
            cursor.execute("SELECT id from isolates WHERE isolate_id= %s", (id_search,))
            result = cursor.fetchone()
            id_search = result[0]

        print('current_id:', id_search, field_name)

        # ------------------------------------------------------------------ #
        print('Resfinder')
        if first_element['staramr']['resfinder_genes']:
            resfinder_genes = first_element.get('staramr', {}).get('resfinder_genes', [])
            result = check_exists_id(id_search, "bioinf.resfinder", table_ex, cursor)
            if result and replace_mode:
                # Delete child table first (no ON DELETE CASCADE on this FK)
                phenotype_del_sql = """
                    DELETE FROM bioinf.resfinder_predicted_phenotypes
                    WHERE resfinder_id IN (
                        SELECT r.id FROM bioinf.resfinder r
                        JOIN sequencing s ON r.sequencing_id = s.id
                        JOIN {} we ON s.extraction_id = we.extraction_id
                        WHERE we.isolate_id = %s
                    )
                """.format(table_ex)
                print_delete(phenotype_del_sql, id_search)
                cursor.execute(phenotype_del_sql, (id_search,))
                print(f"  -> Deleted existing rows from bioinf.resfinder_predicted_phenotypes for isolate {id_search}")
                delete_existing(id_search, "bioinf.resfinder", table_ex, cursor)
                conn.commit()
                result = ""
            if not result:
                for gene_resfinder in resfinder_genes:
                    insert = """
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                            SELECT id, %s
                            FROM sequencing_info
                            RETURNING id

                            """.format(table_ex)

                    if isinstance(gene_resfinder['gene'], float) and math.isnan(gene_resfinder['gene']):
                        gene_resfinder['gene'] = None
                    gene_resf = gene_resfinder['gene']
                    if gene_resf:
                        if "'" in gene_resf:
                            gene_resf = gene_resf.replace("'", "''")
                            print(gene_resf, gene_resfinder['gene'])

                    print_inserts(insert, (id_search, gene_resf,))
                    cursor.execute(insert, (id_search, gene_resf,))
                    print('')
                    row = cursor.fetchone()
                    if row is None:
                        print(f"  Warning: resfinder INSERT returned no rows for isolate {id_search}, gene {gene_resf} — skipping phenotypes")
                        continue
                    resfinder_id = row[0]
                    conn.commit()
                    print('here2')

                    for phenotype in gene_resfinder['phenotypes']:
                        insert_phenotype_query = """
                                                INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                                VALUES (%s, %s)
                                                ON CONFLICT DO NOTHING;
                                                """
                        if phenotype:
                            if "''" in phenotype:
                                phenotype = phenotype.replace("''", "''''")
                            elif "'" in phenotype:
                                phenotype = phenotype.replace("'", "''")

                        # Use a subquery for the SQL file so it doesn't rely on
                        # server-specific auto-generated IDs
                        insert_phenotype_file_sql = f"""
                                                INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                                SELECT r.id, %s
                                                FROM bioinf.resfinder r
                                                WHERE r.resfinder_gene = %s
                                                AND r.sequencing_id IN (
                                                    SELECT s.id FROM sequencing s
                                                    JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                                    WHERE we.isolate_id = %s
                                                )
                                                ON CONFLICT DO NOTHING
                                                """
                        print_inserts(insert_phenotype_file_sql, (phenotype, gene_resf, id_search))
                        cursor.execute(insert_phenotype_query, (resfinder_id, phenotype,))
                        conn.commit()

        # ------------------------------------------------------------------ #
        print('MLST')
        if first_element['staramr']['mlst_result']:
            result = check_exists_id(id_search, "bioinf.mlst", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.mlst", table_ex, cursor)
                result = ""
            if not result:
                mlst_sequence = first_element.get('staramr', {}).get('mlst_result', {}).get('mlst_sequence', 'N/A')
                mlst_scheme = first_element.get('staramr', {}).get('mlst_result', {}).get('mlst_scheme', 'N/A')
                insert = """
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                            SELECT id, %s, %s
                            FROM sequencing_info

                            """.format(table_ex)
                print_inserts(insert, (id_search, mlst_sequence, mlst_scheme,))
                cursor.execute(insert, (id_search, mlst_sequence, mlst_scheme,))
                conn.commit()

        # ------------------------------------------------------------------ #
        print('Plasmid Finder')
        if first_element['staramr']['plasmid_finder']:
            result = check_exists_id(id_search, "bioinf.plasmid_finder", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.plasmid_finder", table_ex, cursor)
                result = ""
            if not result:
                plasmid_finder = first_element.get('staramr', {}).get('plasmid_finder', [])
                for plasmid_finder_gene in plasmid_finder:
                    if not (isinstance(plasmid_finder_gene, (int, float)) and math.isnan(plasmid_finder_gene)) and isinstance(plasmid_finder_gene, str):
                        insert = """
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                            SELECT id, %s
                            FROM sequencing_info

                            """.format(table_ex)
                        print_inserts(insert, (id_search, plasmid_finder_gene,))
                        cursor.execute(insert, (id_search, plasmid_finder_gene,))
                conn.commit()

        # ------------------------------------------------------------------ #
        print('ABRICATE')
        if first_element['abricate']:
            result = check_exists_id(id_search, "bioinf.virulence_VFDB", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.virulence_VFDB", table_ex, cursor)
                result = ""
            if not result:
                abricate_genes = first_element.get('abricate', [])
                for abricate_gene in abricate_genes:
                    columns = []
                    placeholders = []
                    values = []
                    for key, value in abricate_gene.items():
                        if isinstance(value, float) and math.isnan(value):
                            value = None
                        if isinstance(value, str):
                            if "''" in value:
                                value = value.replace("''", "''''")
                            elif "'" in value:
                                value = value.replace("'", "''")
                        columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('ectyper')
        if first_element['ectyper']:
            result = check_exists_id(id_search, "bioinf.ecoli_serotyping", table_ex, cursor)
            ectyper = first_element.get('ectyper', {})
            if "serotype" in ectyper:
                ectyper["ecoli_serotype"] = ectyper.pop("serotype")

            def normalize(v):
                if isinstance(v, list):
                    v = ";".join(str(x) for x in v)
                if v is None:
                    return None
                v = str(v)
                v = v.replace("''", "''''")
                v = v.replace("'", "''")
                return v

            if result and replace_mode:
                delete_existing(id_search, "bioinf.ecoli_serotyping", table_ex, cursor)
                result = ""

            if not result:
                columns = ["sequencing_id"]
                placeholders = ["sequencing_info.id"]
                params = [id_search]

                for col, value in ectyper.items():
                    columns.append(col)
                    placeholders.append("%s")
                    params.append(normalize(value))

                column_list = ", ".join(columns)
                placeholder_list = ", ".join(placeholders)

                insert_sql = f"""
                    WITH sequencing_info AS (
                        SELECT s.id
                        FROM sequencing s
                        JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                        WHERE we.isolate_id = %s
                    )
                    INSERT INTO bioinf.ecoli_serotyping ({column_list})
                    SELECT {placeholder_list}
                    FROM sequencing_info
                """
                print_inserts(insert_sql, params)
                cursor.execute(insert_sql, params)
                conn.commit()
            else:
                # Exists and replace_mode is False — do partial UPDATE
                sql_query = """
                    SELECT id, pathotype
                    FROM bioinf.ecoli_serotyping
                    WHERE sequencing_id IN (
                        SELECT id
                        FROM sequencing
                        WHERE extraction_id IN (
                            SELECT extraction_id
                            FROM wgs_extractions
                            WHERE isolate_id = %s
                        )
                    )
                """
                cursor.execute(sql_query, (id_search,))
                row = cursor.fetchone()

                if row:
                    existing_id = row[0]
                    set_clauses = []
                    params = []

                    for k, v in ectyper.items():
                        if k in ['serotype', 'htype', 'otype']:
                            continue
                        if isinstance(v, list):
                            v = ";".join(str(item) for item in v)
                        if v is None:
                            v = None
                        else:
                            v = str(v)
                        if v is not None:
                            v = v.replace("''", "''''")
                            v = v.replace("'", "''")
                        set_clauses.append(f"{k} = %s")
                        params.append(v)

                    if set_clauses:
                        set_str = ", ".join(set_clauses)
                        update_sql = f"UPDATE bioinf.ecoli_serotyping SET {set_str} WHERE id = %s"
                        params.append(existing_id)
                        cursor.execute(update_sql, params)
                        print_inserts(update_sql, params)
                        conn.commit()

        # ------------------------------------------------------------------ #
        print('refseq_masher')
        if first_element['refseq_masher']:
            result = check_exists_id(id_search, "bioinf.refseq_masher", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.refseq_masher", table_ex, cursor)
                result = ""
            if not result:
                refseq_species = first_element.get('refseq_masher', [])
                for masher_result in refseq_species:
                    insert = """
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.refseq_masher (SEQUENCING_ID, sample,top_taxonomy_name,distance,pvalue,matching,full_taxonomy,taxonomic_species,taxonomic_genus,taxonomic_family,taxonomic_order,taxonomic_class, taxonomic_phylum, taxonomic_superkingdom,subspecies,serovar,plasmid,bioproject,biosample,taxid,assembly_accession,match_id)
                            SELECT id, %s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s,%s, %s, %s
                            FROM sequencing_info

                            """.format(table_ex)
                    if "''" in masher_result['full_taxonomy']:
                        masher_result['full_taxonomy'] = masher_result['full_taxonomy'].replace("''", "''''")
                    elif "'" in masher_result['full_taxonomy']:
                        masher_result['full_taxonomy'] = masher_result['full_taxonomy'].replace("'", "''")
                    if "''" in masher_result['taxonomic_species']:
                        masher_result['taxonomic_species'] = masher_result['taxonomic_species'].replace("''", "''''")
                    elif "'" in masher_result['taxonomic_species']:
                        masher_result['taxonomic_species'] = masher_result['taxonomic_species'].replace("'", "''")
                    if "''" in masher_result['top_taxonomy_name']:
                        masher_result['top_taxonomy_name'] = masher_result['top_taxonomy_name'].replace("''", "''''")
                    elif "'" in masher_result['top_taxonomy_name']:
                        masher_result['top_taxonomy_name'] = masher_result['top_taxonomy_name'].replace("'", "''")
                    print_inserts(insert, (id_search, masher_result['sample'], masher_result['top_taxonomy_name'], masher_result['distance'], masher_result['pvalue'], masher_result['matching'], masher_result['full_taxonomy'], masher_result['taxonomic_species'], masher_result['taxonomic_genus'], masher_result['taxonomic_family'], masher_result['taxonomic_order'], masher_result['taxonomic_class'], masher_result['taxonomic_phylum'], masher_result['taxonomic_superkingdom'], masher_result['subspecies'], masher_result['serovar'], masher_result['plasmid'], masher_result['bioproject'], masher_result['biosample'], masher_result['taxid'], masher_result['assembly_accession'], masher_result['match_id'],))
                    cursor.execute(insert, (id_search, masher_result['sample'], masher_result['top_taxonomy_name'], masher_result['distance'], masher_result['pvalue'], masher_result['matching'], masher_result['full_taxonomy'], masher_result['taxonomic_species'], masher_result['taxonomic_genus'], masher_result['taxonomic_family'], masher_result['taxonomic_order'], masher_result['taxonomic_class'], masher_result['taxonomic_phylum'], masher_result['taxonomic_superkingdom'], masher_result['subspecies'], masher_result['serovar'], masher_result['plasmid'], masher_result['bioproject'], masher_result['biosample'], masher_result['taxid'], masher_result['assembly_accession'], masher_result['match_id'],))
                conn.commit()

        # ------------------------------------------------------------------ #
        print('virulence_vf')
        if first_element['virulence_vf']:
            result = check_exists_id(id_search, "bioinf.virulence_vf", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.virulence_vf", table_ex, cursor)
                result = ""
            if not result:
                virulence_genes = first_element.get('virulence_vf', [])
                for vfgene in virulence_genes:
                    insert = """
                             WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.virulence_vf (SEQUENCING_ID, vf_gene,vf_protein_function)
                            SELECT id, %s, %s
                            FROM sequencing_info

                            """.format(table_ex)
                    if vfgene['vf_gene']:
                        if "''" in vfgene['vf_gene']:
                            vfgene['vf_gene'] = vfgene['vf_gene'].replace("''", "''''")
                        elif "'" in vfgene['vf_gene']:
                            vfgene['vf_gene'] = vfgene['vf_gene'].replace("'", "''")
                    if vfgene['vf_protein_function']:
                        if "''" in vfgene['vf_protein_function']:
                            vfgene['vf_protein_function'] = vfgene['vf_protein_function'].replace("''", "''''")
                        elif "'" in vfgene['vf_protein_function']:
                            vfgene['vf_protein_function'] = vfgene['vf_protein_function'].replace("'", "''")
                    print_inserts(insert, (id_search, vfgene['vf_gene'], vfgene['vf_protein_function'],))
                    cursor.execute(insert, (id_search, vfgene['vf_gene'], vfgene['vf_protein_function'],))
                conn.commit()

        # ------------------------------------------------------------------ #
        print('mob_rgi_results')
        if first_element['mob_rgi_results']:
            result = check_exists_id(id_search, "bioinf.mob_rgi", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.mob_rgi", table_ex, cursor)
                result = ""
            if not result:
                mob_rgi_results = first_element.get('mob_rgi_results', [])
                for results in mob_rgi_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        if 'sample' not in key:
                            value = results[key]
                            if key == 'amr_relaxase_type':
                                key = 'relaxase_type'
                            if key == 'amr_mpf_type':
                                key = 'mpf_type'
                            if key == 'amr_orit_type':
                                key = 'orit_type'
                            if key == 'amr_ref_type':
                                key = 'rep_type'
                            if key == 'perc_len_ref_seq':
                                key = 'percentage_length_of_reference_sequence'
                            if key == 'drug_class':
                                if isinstance(value, list):
                                    value = ",".join(map(str, value))
                                else:
                                    value = str(value)
                            if isinstance(value, str):
                                if "'" in value:
                                    value = value.replace("'", "''")
                            if isinstance(value, float) and math.isnan(value):
                                value = None
                            print(key, value)
                            columns.append(key)
                            placeholders.append("%s")
                            values.append(value)
                    print(columns)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.mob_rgi (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values,)
                    cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('iceberg')
        if first_element['iceberg']:
            print('blastn')
            iceberg_results = first_element.get('iceberg', [])
            result = check_exists_id(id_search, "bioinf.iceberg_blastn_genome", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.iceberg_blastn_genome", table_ex, cursor)
                result = ""
            if not result:
                blastn_results = iceberg_results.get('blastn', [])
                for results in blastn_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        print(key, value)
                        if key.lower() == "end":
                            columns.append(f'"{key}"')
                        else:
                            columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.iceberg_blastn_genome (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values,)
                conn.commit()

            result = check_exists_id(id_search, "bioinf.iceberg_blastp_genes", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.iceberg_blastp_genes", table_ex, cursor)
                result = ""
            if not result:
                blastp_results = iceberg_results.get('blastp', [])
                for results in blastp_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        if isinstance(value, str):
                            if "''" in value:
                                value = value.replace("''", "''''")
                            elif "'" in value:
                                value = value.replace("'", "''")
                        print(key, value)
                        if key.lower() == "end":
                            columns.append(f'"{key}"')
                        else:
                            columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.iceberg_blastp_genes (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('island_path')
        if first_element['island_path']:
            result = check_exists_id(id_search, "bioinf.island_path", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.island_path", table_ex, cursor)
                result = ""
            if not result:
                island_path_results = first_element.get('island_path', [])
                for results in island_path_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        if key == 'start':
                            key = 'start_position'
                        elif key == 'end':
                            key = 'end_position'
                        columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.island_path (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('integron_finder')
        if first_element['integron_finder']:
            result = check_exists_id(id_search, "bioinf.integron_finder", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.integron_finder", table_ex, cursor)
                result = ""
            if not result:
                integron_finder_results = first_element.get('integron_finder', [])
                for results in integron_finder_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.integron_finder (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('digis_elements')
        if first_element['digis']:
            result = check_exists_id(id_search, "bioinf.digis_elements", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.digis_elements", table_ex, cursor)
                result = ""
            if not result:
                digis_results = first_element.get('digis', [])
                for results in digis_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        if key.lower() == "end":
                            columns.append(f'"{key}"')
                        else:
                            columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.digis_elements (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('bacmet')
        if first_element.get('bacmet'):
            result = check_exists_id(id_search, "bioinf.bacmet", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.bacmet", table_ex, cursor)
                result = ""
            if not result:
                bacmet_results = first_element.get('bacmet', [])
                for results in bacmet_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key in results:
                        value = results[key]
                        if key == 'start':
                            key = 'start_pos'
                        elif key == 'end':
                            key = 'end_pos'
                        if isinstance(value, float) and math.isnan(value):
                            value = None
                        if isinstance(value, str):
                            if "''" in value:
                                value = value.replace("''", "''''")
                            elif "'" in value:
                                value = value.replace("'", "''")
                        columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.bacmet (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            RETURNING id
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('kleborate')
        if first_element['kleborate']:
            result = check_exists_id(id_search, "bioinf.kleborate", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.kleborate", table_ex, cursor)
                result = ""
            if not result:
                kleborate_results = first_element.get('kleborate', [])
                cursor.execute("""
                    SELECT column_name
                    FROM information_schema.columns
                    WHERE table_schema = 'bioinf'
                    AND table_name   = 'kleborate'
                    ORDER BY ordinal_position;
                """)
                columns2 = [row[0] for row in cursor.fetchall()]
                columns = []
                placeholders = []
                values = []
                for key in kleborate_results:
                    if 'strain' not in key:
                        value = kleborate_results[key]
                        if key.lower() == 'st':
                            key = 'mlst_st'
                        if isinstance(value, str):
                            if "''" in value:
                                value = value.replace("''", "''''")
                            elif "'" in value:
                                value = value.replace("'", "''")
                        columns.append(key.lower())
                        placeholders.append("%s")
                        values.append(value)

                for column in columns2:
                    if column not in ['id', 'sequencing_id']:
                        if column.lower() not in columns:
                            columns.append(column)
                            placeholders.append("%s")
                            values.append(None)

                column_str = ", ".join(columns)
                placeholder_str = ", ".join(placeholders)
                print(column_str)
                print(placeholder_str)
                insert = f"""
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                            WHERE we.isolate_id = %s
                        )
                        INSERT INTO bioinf.kleborate (SEQUENCING_ID, {column_str})
                        SELECT id, {placeholder_str}
                        FROM sequencing_info
                        RETURNING id
                        """
                all_values = [id_search] + values
                print_inserts(insert, all_values)
                cursor.execute(insert, all_values,)
                conn.commit()

        # ------------------------------------------------------------------ #
        print('phaster')
        if first_element.get('phaster'):
            result = check_exists_id(id_search, "bioinf.phaster_blastp_hits", table_ex, cursor)
            if result and replace_mode:
                delete_existing(id_search, "bioinf.phaster_blastp_hits", table_ex, cursor)
                result = ""
            if not result:
                phaster_results = first_element.get('phaster', [])
                for phaster_hit in phaster_results:
                    columns = []
                    placeholders = []
                    values = []
                    for key, value in phaster_hit.items():
                        if isinstance(value, float) and math.isnan(value):
                            value = None
                        if isinstance(value, str):
                            if "''" in value:
                                value = value.replace("''", "''''")
                            elif "'" in value:
                                value = value.replace("'", "''")
                        columns.append(key)
                        placeholders.append("%s")
                        values.append(value)
                    column_str = ", ".join(columns)
                    placeholder_str = ", ".join(placeholders)
                    insert = f"""
                            WITH sequencing_info AS (
                                SELECT s.id
                                FROM sequencing s
                                JOIN {table_ex} we ON s.extraction_id = we.extraction_id
                                WHERE we.isolate_id = %s
                            )
                            INSERT INTO bioinf.phaster_blastp_hits (SEQUENCING_ID, {column_str})
                            SELECT id, {placeholder_str}
                            FROM sequencing_info
                            """
                    all_values = [id_search] + values
                    print_inserts(insert, all_values)
                    cursor.execute(insert, all_values)
                conn.commit()
