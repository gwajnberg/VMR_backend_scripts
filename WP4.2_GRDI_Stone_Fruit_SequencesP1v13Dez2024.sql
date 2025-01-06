
                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 380
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (1, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 380
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 380
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 444
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaL1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (2, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 444
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 444
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 444
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilG', '(pilG) twitching motility protein PilG [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 256
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (3, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 256
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 256
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 332
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (4, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 332
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 332
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 282
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aph(3'')-IIc'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (5, 'kanamycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 282
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (6, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroB', '(iroB) glucosyltransferase IroB [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroC', '(iroC) ATP binding cassette transporter [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroD', '(iroD) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroE', '(iroE) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroN', '(iroN) salmochelin receptor IroN [IroN (VF0230)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 318
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 215
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-421'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (7, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 215
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST119', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 526
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'qnrE1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (8, 'unknown[qnrE1_1_KY073238]');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 526
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 526
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 526
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 526
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 116
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (9, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 116
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 116
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 206
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (10, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 206
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', '-'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 206
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'ARR-3'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (11, 'rifampicin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aac(6'')-Ib-cr'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (12, 'unknown[aac(6'')-Ib-cr_1_DQ303918]');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aac(6'')-Ib3'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (13, 'amikacin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (13, 'tobramycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'ant(3'''')-Ia'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (14, 'spectinomycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-2'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (15, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (15, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (15, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (15, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaNDM-1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (16, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (16, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (16, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (16, 'ceftriaxone');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (16, 'meropenem');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-10'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (17, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'mph(A)'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (18, 'erythromycin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (18, 'azithromycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'qacE'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (19, 'unknown[qacE_1_X68232]');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'qnrVC1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (20, 'ciprofloxacin I/R');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'sul1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (21, 'sulfisoxazole');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncC'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 475
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 309
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (22, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 309
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-7'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (23, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (23, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (23, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (23, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroB', '(iroB) glucosyltransferase IroB [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroC', '(iroC) ATP binding cassette transporter [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroD', '(iroD) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroE', '(iroE) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroN', '(iroN) salmochelin receptor IroN [IroN (VF0230)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 161
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 187
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aac(6'')-Iz'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (24, 'gentamicin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 187
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 588
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (25, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 588
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', '-'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 588
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliG', '(fliG) flagellar motor switch protein G [Flagella (VF0394)] [Yersinia enterocolitica subsp. enterocolitica 8081]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 588
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliM', '(fliM) flagellar motor switch protein FliM [Flagella (VF0394)] [Yersinia enterocolitica subsp. enterocolitica 8081]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 588
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliP', '(fliP) flagellar biosynthetic protein FliP [Flagella (VF0394)] [Yersinia enterocolitica subsp. enterocolitica 8081]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 425
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaRAHN-2'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (26, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (26, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 425
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', '-'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-5'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (27, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (27, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (27, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (27, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFII(pECLA)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 134
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-10'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (28, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (28, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (28, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (28, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'mcr-9'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (29, 'Colistin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncN'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 573
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 255
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (30, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 255
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 255
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 126
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (31, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 126
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 150
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-5'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (32, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (32, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (32, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (32, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 150
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST102', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 150
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 150
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 150
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 566
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (33, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 566
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST788', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 566
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 139
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aph(3'')-IIc'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (34, 'kanamycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 139
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST212', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 432
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-121'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (35, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 432
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST444', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 247
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-6'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (36, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (36, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (36, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (36, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 247
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 247
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 247
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 247
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 280
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aph(3'')-IIc'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (37, 'kanamycin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 280
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 189
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'aac(6'')-Iz'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (38, 'gentamicin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 189
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 148
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-5'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (39, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (39, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (39, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (39, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 148
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 148
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 148
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 148
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 217
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-421'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (40, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 217
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST119', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-7'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (41, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (41, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (41, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (41, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroB', '(iroB) glucosyltransferase IroB [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroC', '(iroC) ATP binding cassette transporter [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroD', '(iroD) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroE', '(iroE) esterase [Salmochelin (IA013)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'iroN', '(iroN) salmochelin receptor IroN [IroN (VF0230)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 518
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-9'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (42, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (42, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (42, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (42, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST125', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFII(Yp)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncHI2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncHI2A'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 196
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 165
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaCMH-3'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (43, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 165
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST850', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 165
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 165
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 275
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (44, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 275
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-6'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (45, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (45, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (45, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (45, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncI1-I(Alpha)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 244
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 183
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaL1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (46, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 183
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 183
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 183
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilG', '(pilG) twitching motility protein PilG [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 213
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-421'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (47, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 213
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST119', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 545
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (48, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 545
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 310
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (49, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 310
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-6'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (50, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (50, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (50, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (50, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'mcr-10'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (51, 'unknown[mcr-10_1_MN179494]');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST523', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 551
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'POM-1'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (52, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (52, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (52, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (52, 'ceftriaxone');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (52, 'meropenem');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', '-'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'xcpQ', '(xcpQ) general secretion pathway protein D [xcp secretion system (VF0084)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'xcpR', '(xcpR) general secretion pathway protein E [xcp secretion system (VF0084)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'xcpS', '(xcpS) general secretion pathway protein F [xcp secretion system (VF0084)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'xcpT', '(xcpT) general secretion pathway protein G [xcp secretion system (VF0084)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgC', '(flgC) flagellar basal-body rod protein FlgC [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgF', '(flgF) flagellar basal-body rod protein FlgF [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgG', '(flgG) flagellar basal-body rod protein FlgG [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgH', '(flgH) flagellar L-ring protein precursor FlgH [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgI', '(flgI) flagellar P-ring protein precursor FlgI [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fleQ', '(fleQ) transcriptional regulator FleQ [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliE', '(fliE) flagellar hook-basal body complex protein FliE [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliF', '(fliF) flagellar M-ring protein FliF [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliG', '(fliG) flagellar motor switch protein G [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliI', '(fliI) flagellum-specific ATP synthase FliI [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliM', '(fliM) flagellar motor switch protein FliM [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliN', '(fliN) flagellar motor switch protein FliN [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliP', '(fliP) flagellar biosynthetic protein FliP [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliQ', '(fliQ) flagellar biosynthetic protein FliQ [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flhA', '(flhA) flagellar biosynthesis protein FlhA [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fleN', '(fleN) flagellar synthesis regulator FleN [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliA', '(fliA) flagellar biosynthesis sigma factor FliA [Deoxyhexose linking sugar 209 Da capping structure (AI138)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'waaF', '(waaF) heptosyltransferase I [LPS (VF0085)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'waaC', '(waaC) 3-deoxy-D-manno-octulosonic-acid (KDO) transferase [LPS (VF0085)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'waaG', '(waaG) B-band O-antigen polymerase [LPS (VF0085)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'waaA', '(waaA) lipopolysaccharide core biosynthesis protein WaaP [LPS (VF0085)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdS', '(pvdS) extracytoplasmic-function sigma-70 factor  [Pyoverdine (VF0094)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'mbtH-like', '(mbtH-like) MbtH-like protein from the pyoverdine cluster [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdL', '(pvdL) peptide synthase PvdL [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'xcpA/pilD', '(xcpA/pilD) type 4 prepilin peptidase PilD [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilR', '(pilR) two-component response regulator PilR [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algW', '(algW) AlgW protein [Alginate regulation (CVF523)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algR', '(algR) alginate biosynthesis regulatory protein AlgR [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algC', '(algC) phosphomannomutase AlgC [Alginate biosynthesis (CVF522)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algB', '(algB) two-component response regulator AlgB [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'icmF1/tssM1', '(icmF1/tssM1) type VI secretion system protein IcmF1 [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'dotU1', '(dotU1) type VI secretion system protein DotU [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hsiJ1', '(hsiJ1) type VI secretion system hcp secretion island protein HsiJ1 [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hsiB1/vipA', '(hsiB1/vipA) type VI secretion system tubule-forming protein VipA [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hsiC1/vipB', '(hsiC1/vipB) type VI secretion system tubule-forming protein VipB [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hcp1', '(hcp1) type VI secretion system substrate Hcp1 [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hsiF1', '(hsiF1) type VI secretion system hcp secretion island protein HsiF1 a gp25-like protein but not exhibit lysozyme activity [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'hsiG1', '(hsiG1) type VI secretion system hcp secretion island protein HsiG1 [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'clpV1', '(clpV1) type VI secretion system AAA+ family ATPase [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'vgrG1a', '(vgrG1a) type VI secretion system substrate VgrG1 [HSI-I (VF0334)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'vgrG1b', '(vgrG1b) type VI secretion system substrate VgrG1b [HSI-1 (Hcp-secretion island 1) (SS178)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilJ', '(pilJ) twitching motility protein PilJ [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilI', '(pilI) twitching motility protein PilI [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilH', '(pilH) twitching motility protein PilH [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilG', '(pilG) twitching motility protein PilG [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilU', '(pilU) twitching motility protein PilU [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algU', '(algU) alginate biosynthesis protein AlgZ/FimS [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdO', '(pvdO) pyoverdine biosynthesis protein PvdO [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdM', '(pvdM) dipeptidase precursor [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algA', '(algA) phosphomannose isomerase / guanosine 5''-diphospho-D-mannose pyrophosphorylase [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algF', '(algF) alginate o-acetyltransferase AlgF [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algI', '(algI) alginate o-acetyltransferase AlgI [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algX', '(algX) alginate biosynthesis protein AlgX [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'alg8', '(alg8) alginate-c5-mannuronan-epimerase AlgG [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algD', '(algD) GDP-mannose 6-dehydrogenase AlgD [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdA', '(pvdA) L-ornithine N5-oxygenase PvdA [Pyoverdine (VF0094)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 373
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdH', '(pvdH) diaminobutyrate-2-oxoglutarate aminotransferase PvdH [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 383
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (53, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 383
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST210', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 383
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pilT', '(pilT) twitching motility protein PilT [Type IV pili (VF0082)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (54, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'pputida'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algU', '(algU) alginate biosynthesis protein AlgZ/FimS [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'alg8', '(alg8) alginate-c5-mannuronan-epimerase AlgG [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algI', '(algI) alginate o-acetyltransferase AlgI [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'algA', '(algA) phosphomannose isomerase / guanosine 5''-diphospho-D-mannose pyrophosphorylase [Alginate (VF0091)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgC', '(flgC) flagellar basal-body rod protein FlgC [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgG', '(flgG) flagellar basal-body rod protein FlgG [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgH', '(flgH) flagellar L-ring protein precursor FlgH [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flgI', '(flgI) flagellar P-ring protein precursor FlgI [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fleQ', '(fleQ) transcriptional regulator FleQ [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliG', '(fliG) flagellar motor switch protein G [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliI', '(fliI) flagellum-specific ATP synthase FliI [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliM', '(fliM) flagellar motor switch protein FliM [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliP', '(fliP) flagellar biosynthetic protein FliP [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'flhA', '(flhA) flagellar biosynthesis protein FlhA [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fleN', '(fleN) flagellar synthesis regulator FleN [Flagella (VF0273)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'fliA', '(fliA) flagellar biosynthesis sigma factor FliA [Deoxyhexose linking sugar 209 Da capping structure (AI138)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'motC', '(motC) flagellar motor protein [Deoxyhexose linking sugar 209 Da capping structure (AI138)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdS', '(pvdS) extracytoplasmic-function sigma-70 factor  [Pyoverdine (VF0094)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'pvdH', '(pvdH) diaminobutyrate-2-oxoglutarate aminotransferase PvdH [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'waaF', '(waaF) heptosyltransferase I [LPS (VF0085)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 284
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'mbtH-like', '(mbtH-like) MbtH-like protein from the pyoverdine cluster [pyoverdine (IA001)] [Pseudomonas aeruginosa PAO1]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 377
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-339'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (55, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 377
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST2116', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 407
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (56, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 407
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST1401', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 634
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaOXA-430'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (57, 'ampicillin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 634
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'abaumannii_2'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 146
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-5'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (58, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (58, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (58, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (58, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 146
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 146
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 146
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 146
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-9'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (59, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (59, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (59, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (59, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFIB(K)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFII(Yp)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 195
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 104
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, NULL
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (60, 'Susceptible');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 104
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'smaltophilia'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaMIR-5'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (61, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (61, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (61, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (61, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'mcr-9'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (62, 'Colistin');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST-', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFIB(pECLA)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFII(pECLA)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 312
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.resfinder (SEQUENCING_ID, resfinder_gene)
                        SELECT id, 'blaACT-6'
                        FROM sequencing_info
                       

                        ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (63, 'ampicillin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (63, 'amoxicillin/clavulanic acid');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (63, 'cefoxitin');
                                            ;

                                            INSERT INTO bioinf.resfinder_predicted_phenotypes (resfinder_id, predicted_phenotype)
                                            VALUES (63, 'ceftriaxone');
                                            ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.mlst (SEQUENCING_ID, mlst_sequence,mlst_scheme)
                        SELECT id, 'ST25', 'ecloacae'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncFIB(pECLA)'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.plasmid_finder (SEQUENCING_ID, plasmid)
                        SELECT id, 'IncN'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'ompA', '(ompA) outer membrane protein A [OmpA (VF0236)] [Escherichia coli O18:K1:H7 str. RS218]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'csgG', '(csgG) curli production assembly/transport protein CsgG [Agf (VF0103)] [Salmonella enterica subsp. enterica serovar Typhimurium str. LT2]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entB', '(entB) isochorismatase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;

                        WITH sequencing_info AS (
                            SELECT s.id
                            FROM sequencing s
                            JOIN wgs_extractions we ON s.extraction_id = we.extraction_id
                            JOIN isolates i ON we.isolate_id = i.id
                            WHERE i.strain = 291
                        )
                        INSERT INTO bioinf.virulence_VFDB (SEQUENCING_ID, gene_accession,product_resistance)
                        SELECT id, 'entA', '(entA) 23-dihydro-23-dihydroxybenzoate dehydrogenase [Enterobactin (VF0228)] [Escherichia coli CFT073]'
                        FROM sequencing_info
                        

                        ;
