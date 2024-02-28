import pandas as pd


def create_ontology_dict(ref_file):
    """
    Take in the Reference Guide Field and Term sheets.
    Create a dictionary of allowable fields and terms.
    Return the dictionary.
    """

    # We only need Column B, A is the Parent Class
    # Data starts on row 7, header is row 0
    # We strip all whitespace from Excel cells
    field_ref = pd.read_excel(ref_file,
                              sheet_name='Field Reference Guide',
                              header=0,
                              index_col='Field',
                              usecols="B",
                              skiprows=[1, 2, 3, 4, 5],
                              converters={'Field': (lambda x: x.strip())})

    # Skip all the blank fields due to the way the sheet is formatted
    field_ref = field_ref[field_ref.index.notnull()]

    # Create our dictionary, those without terms are {'field_id':{}}
    ontology_dict = field_ref.to_dict('index')

    # We need Columns A:C, A is the repeated field name
    # B contains acceptable terms for A
    # A also contains a single line as a header with the field name
    # Data starts on row 3, header is row 0
    # Remove whitespace with converter function on Field, Term, OntologyID
    term_column_names = ['Field', 'Term', 'Ontology Identifier']
    term_ref = pd.read_excel(ref_file,
                             sheet_name='Term Reference Guide',
                             header=0,
                             index_col='Field',
                             usecols=term_column_names,
                             skiprows=[1, 2],
                             converters={col: (lambda x: x.strip()) for col in term_column_names})

    # All columns should have data, outside of the index header for a category
    term_ref = term_ref.dropna(how="any")

    # We need a dict based on field keys, which we will subsequently
    # combine with the Field dict. The field keys are duplicated at the index
    # so we will group by the index key
    # Creates: {'field_id1':[{}, {}, {}], 'field_id2':[{}, {}, {}]}
    term_dict = {k: g.to_dict(orient='records') for k, g in term_ref.groupby(level=0)}
   
    # Merge the two dictionaries, those without terms are 'field_id': {}
    return ontology_dict | term_dict