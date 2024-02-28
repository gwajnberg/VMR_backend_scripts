#!/usr/bin/env python

import pandas as pd

import command_line_parser


def create_ontology_dict(ref_file):
    """
    Take in the Reference Guide Field and Term sheets.
    Create a dictionary of allowable fields and terms.
    Return the dictionary.
    """

    # We only need Columns B:D, A is the Parent Class
    # Data starts on row 7, header is row 0
    field_ref = pd.read_excel(ref_file,
                            sheet_name='Field Reference Guide',
                            header=0,
                            index_col='Field',
                            usecols="B:D",
                            skiprows=[1,2,3,4,5])
    # Skip all the blank fields due to the way the sheet is formatted
    field_ref = field_ref[field_ref.index.notnull()]

    print(field_ref)
    print(field_ref.loc['antimicrobial_measurement'])


def main():
    """
    The VMR data parser and validator.
    General workflow is:
    1. Constructs a dictionary of allowable fields and terms based on the Reference Field and Term guide ontology (https://github.com/cidgoh/GRDI_AMR_One_Health)
    2. Takes an input sheet of user data from the GRDI_Harmonization-Template
    3. Identifies any fields or terms that are not part of the ontology
    4. Validates user data for duplication or other input errors
    5. Inserts the data that passes verification into the PostgreSQL VMR DB
    """

    args = command_line_parser.parse_command_line()
    ontology_dict = create_ontology_dict(args.reference)
    print(ontology_dict)

if __name__ == '__main__':
    try:
        main()
        print('Program finished')
    except Exception as e:
        print('Error : {}'.format(e))
