import pandas as pd
import sys



def parser(file):
    
    df = pd.read_excel(file, header=0, sheet_name='SRA_data')
    
    dictionary_sequencing = {}

    sequencing_platform =[
        'Illumina [GENEPIO:0001923]',
'Pacific Biosciences [GENEPIO:0001927]',
'Ion Torrent [GENEPIO:0002683]',
'Oxford Nanopore Technologies [OBI:0002755]',
'BGI Genomics [GENEPIO:0004324]',
'MGI [GENEPIO:0004325]',
'Not Applicable [GENEPIO:0001619]',
'Not Collected [GENEPIO:0001620]',
'Not Provided [GENEPIO:0001668]',
'Missing [GENEPIO:0001618]',
'Restricted Access [GENEPIO:0001810]'

    ]
    sequencing_assay_type = {
        'GENOMIC' : 'Whole genome sequencing assay [OBI:0002117]',
        'METAGENOMIC': 'Whole metagenome sequencing assay [OBI:0002623]'

    }
    sequencing_instrument =[
        'Illumina [GENEPIO:0100105]',
     'Illumina Genome Analyzer [GENEPIO:0100106]',
     'Illumina Genome Analyzer II [OBI:0000703]',
     'Illumina Genome Analyzer IIx [OBI:0002000]',
     'Illumina HiScanSQ [GENEPIO:0100109]',
     'Illumina HiSeq [GENEPIO:0100110]',
     'Illumina HiSeq X [GENEPIO:0100111]',
     'Illumina HiSeq X Five [GENEPIO:0100112]',
     'Illumina HiSeq X Ten [GENEPIO:0100113]',
     'Illumina HiSeq 1000 [OBI:0002022]',
     'Illumina HiSeq 1500 [GENEPIO:0100115]',
     'Illumina HiSeq 2000 [OBI:0002001]',
     'Illumina HiSeq 2500 [OBI:0002002]',
     'Illumina HiSeq 3000 [OBI:0002048]',
     'Illumina HiSeq 4000 [OBI:0002049]',
     'Illumina iSeq [GENEPIO:0100120]',
     'Illumina iSeq 100 [GENEPIO:0100121]',
     'Illumina NovaSeq [GENEPIO:0100122]',
     'Illumina NovaSeq 6000 [GENEPIO:0100123]',
          'Illumina MiniSeq [GENEPIO:0100124]',
          'Illumina MiSeq [OBI:0002003]',
          'Illumina NextSeq [GENEPIO:0100126]',
          'Illumina NextSeq 500 [OBI:0002021]',
          'Illumina NextSeq 550 [GENEPIO:0100128]',
          'Illumina NextSeq 1000 [GENEPIO:0004432]',
     'Illumina NextSeq 2000 [GENEPIO:0100129]',
'PacBio [GENEPIO:0100130]',
     'PacBio RS [GENEPIO:0100131]',
     'PacBio RS II [OBI:0002012]',
     'PacBio Sequel [GENEPIO:0100133]',
     'PacBio Sequel II [GENEPIO:0100134]',
'Ion Torrent [GENEPIO:0100135]',
     'Ion Torrent PGM [GENEPIO:0100136]',
     'Ion Torrent Proton [GENEPIO:0100137]',
     'Ion Torrent S5 XL [GENEPIO:0100138]',
     'Ion Torrent S5 [GENEPIO:0100139]',
'Oxford Nanopore [GENEPIO:0100140]',
     'Oxford Nanopore Flongle [GENEPIO:0004433]',
     'Oxford Nanopore GridION [GENEPIO:0100141]',
     'Oxford Nanopore MinION [GENEPIO:0100142]',
     'Oxford Nanopore PromethION [GENEPIO:0100143]',
'BGISEQ [GENEPIO:0100144]',
     'BGISEQ-500 [GENEPIO:0100145]',
'DNBSEQ [GENEPIO:0100146]',
     'DNBSEQ-T7 [GENEPIO:0100147]',
     'DNBSEQ-G400 [GENEPIO:0100148]',
     'DNBSEQ-G400 FAST [GENEPIO:0100149]',
     'DNBSEQ-G50 [GENEPIO:0100150]',
'Not Applicable [GENEPIO:0001619]',
'Not Collected [GENEPIO:0001620]',
'Not Provided [GENEPIO:0001668]',
'Missing [GENEPIO:0001618]',
'Restricted Access [GENEPIO:0001810]'

    ]

    for index, row in df.iterrows():
        isolate = row['title']
        temp={}
        if (row['biosample_accession']):
            temp['biosample_accession'] = row['biosample_accession']
        if (row['library_ID']):
            temp['library_ID'] = row['library_ID']
        
        if (row['library_source']):
            if row['library_source'] in sequencing_assay_type.keys():
                temp['sequencing_assay_type'] = sequencing_assay_type[row['library_source']]
        flag =0
        
        
        for item in sequencing_platform:
            if (row["platform"].lower() in item.lower()):
                temp['sequencing_platform'] = item
                flag = 1

        if flag == 0 :
            temp['sequencing_platform'] = row["platform"]
        flag =0
        
        
        for item in sequencing_instrument:
            if (row["instrument_model"].lower() in item.lower()):
                
                temp['sequencing_instrument'] = item
                flag = 1

        if flag == 0 :
            temp['sequencing_instrument'] = row["instrument_model"]
        
        if row['filename']:
            temp['r1_fastq_filename'] = row['filename']
        if row['filename2']:
            temp['r2_fastq_filename'] = row['filename2']
        if isolate not in dictionary_sequencing.keys():
            dictionary_sequencing[isolate] =[]
            dictionary_sequencing[isolate].append(temp)
        else:
            dictionary_sequencing[isolate].append(temp)
    #print(dictionary_sequencing)
    return(dictionary_sequencing)
      



