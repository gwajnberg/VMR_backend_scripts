#!/usr/bin/env python
from collections import defaultdict
import pandas as pd
# import VMR modules
from modules import command_line_parser, create_ontology_dict, create_dict_of_samples, logger



LOG = logger.create_logger()




def main():
    """
    The VMR data parser and validator.
    General workflow is:
    1. Constructs a dictionary of allowable fields and terms base on the
    #     Reference Field and Term guide ontology (https://github.com/cidgoh/GRDI_AMR_One_Health)
    2. Takes an input sheet of user data from the GRDI_Harmonization-Template
    3. Identifies any fields or terms that are not part of the ontology
    4. Validates user data for duplication or other input errors
    5. Inserts the data that passes verification into the PostgreSQL VMR DB
    """

    args = command_line_parser.parse_command_line()
    
    ontology_dict = create_ontology_dict.create_ontology_dict(args.reference)
    
    
    #LOG.debug(ontology_dict)
    samples_dict = create_dict_of_samples.create_dict_of_samples(args.input, ontology_dict)

if __name__ == '__main__':
    try:
        main()
        LOG.info('Program finished')
    except Exception as e:
        LOG.error('Error : {}'.format(e))
