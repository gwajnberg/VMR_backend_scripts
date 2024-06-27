from modules import antibiogram, logger, sequencing_parser, modification
import argparse
import sys



LOG = logger.create_logger()

   
def main():
    parser = argparse.ArgumentParser(description='Parsing program for AMR database.')
    parser.add_argument("-a", "--antibiogram", help="Fill tables with template terms", default="F")
    parser.add_argument("-s", "--sequencing", help="Fill tables with template terms", default="F")
    parser.add_argument("-i", "--input_file", help="Input File to modify.", type=str)
    parser.add_argument("-o", "--output_file", help="Output File to modify.", type=str)

    args = parser.parse_args()

    data = {}
    if args.antibiogram != "F":
        file = args.antibiogram
        print (file)
        antibiogram_data = antibiogram.antibiogram(file)
        data ["antibiogram"] = antibiogram_data
    if args.sequencing != "F":
        file = args.sequencing
        print (file)
        sequencing_data = sequencing_parser.parser(file)
        data ["sequencing"] = sequencing_data
    if (args.input_file):
        input_file = args.input_file
        new_df= modification.modification(input_file,data)
        #print (new_df.at[4,'biosample_accession'])
        #sys.exit()  
        new_file = args.output_file
        new_df.to_excel(new_file, index=False, engine='openpyxl') 
    else:
        print ('Please type an input file -i argument')







if __name__ == '__main__':
    try:
        main()
        LOG.info('Program finished')
    except Exception as e:
        LOG.error('Error : {}'.format(e))