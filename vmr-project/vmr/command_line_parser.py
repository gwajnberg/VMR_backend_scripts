#!/usr/bin/env python

import argparse

# parser = argparse.ArgumentParser(description='Parsing program for AMR database.')
# parser.add_argument("-f", "--fill_with_terms", help="Fill tables with template terms", default="F")
# parser.add_argument("-d", "--drop_off_table_add_sql", help="Drop off tables and re-add sql", default="F")
# parser.add_argument("-i", "--input_file", help="Input File to upload.", type=str)
# parser.add_argument("-o", "--one", help="input file is one sheet", default="F")
# parser.add_argument("-m", "--mode", help="For input sheet is metagenomics or wgs", default=str)
# args = parser.parse_args()

def parse_command_line(args=None):
    """
    Options for VMR parsing.

    Args:
        args: Optional args to be passed to argparse.parse_args()

    Returns:
        The populated argparse Namespace
    """

    parser = argparse.ArgumentParser(
        description='The Virtual Microbial Resource.'
    )

    parser.add_argument(
        "-i",
        "--input",
        help="The GRDI_Harmonization-Template of user collected data",
        required=True
    )

    parser.add_argument(
        "-r",
        "--reference",
        help="Reference Field and Term Guide ontology (https://github.com/cidgoh/GRDI_AMR_One_Health)",
        required=True
    )

    if args is None:
        return parser.parse_args()
    else:
        return parser.parse_args(args)