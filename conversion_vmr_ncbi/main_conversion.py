from modules import logger, one_health_enteric
import argparse



LOG = logger.create_logger()

   
def main():
    parser = argparse.ArgumentParser(description='Parsing program for AMR database.')
    parser.add_argument("-e", "--one_health_enteric", help="Generates an  One Health Enteric template", default="F")
    parser.add_argument("-i", "--input_file", help="Input File with Samples/Isolates list", type=str)
    parser.add_argument("-c","--category", choices=['food', 'environmental', 'animal'], 
                        help="The category to process. Choose from 'food', 'environmental', or 'animal'.")
    
    args = parser.parse_args()
    
    
    if (args.input_file):
        file = args.input_file
        if args.one_health_enteric == "T":
            onehalth_enteric_template = one_health_enteric.read_file(file,args.category)
            onehalth_enteric_template.to_excel('enteric_template_version.xlsx', sheet_name='MySheet', index=False, na_rep='NaN', float_format="%.2f")


            
    




if __name__ == '__main__':
    try:
        main()
        LOG.info('Program finished')
    except Exception as e:
        LOG.error('Error : {}'.format(e))