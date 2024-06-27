from modules import reading_cathy_format, logger, modifying_original_spreadsheet




LOG = logger.create_logger()

   
def main():
    file_cathy = "~/vmr_old_project/grdi-amr2/Sample_Metada_Frozem_Stonefruit_2024_WP4.2_EG.xlsx"
    dict_curated = reading_cathy_format.reading_cathy(file_cathy)
    file_to_modify = "~/vmr_old_project/grdi-amr2/WP4.2_GRDI_Harmonization-Template_v9.0.0_GW.csv"
    new_df = modifying_original_spreadsheet.modify(file_to_modify,dict_curated)
    new_file = '~/vmr_old_project/grdi-amr2/WP4.2_GRDI_Harmonization-Template_v9.0.0_after_curation.xlsx'
    new_df.to_excel(new_file, index=False, engine='openpyxl')

    print(f"Modified XLS saved to {new_file}")







if __name__ == '__main__':
    try:
        main()
        LOG.info('Program finished')
    except Exception as e:
        LOG.error('Error : {}'.format(e))