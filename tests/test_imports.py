import sys
import os
sys.path.insert(0, os.path.abspath(os.path.join(os.path.dirname(__file__), "..")))
def test_imports():
    from fill_ontology_fields import fill_ontology_fields
    from create_ontology_dict import create_ontology_dict
    from create_dict_of_samples import create_dict_of_samples
    from create_dict_of_samples_one import create_dict_of_samples_one
    from gene_mode import parse, insert_data
    from feed_vmr_table import feed_vmr_table