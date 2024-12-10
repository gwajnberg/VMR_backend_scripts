from modules import reading_cathy_format, logger, modifying_original_spreadsheet




LOG = logger.create_logger()

   
def main():
    file_cathy = "~/vmr_back_end_grdi/VMR_backend_scripts/Sample_Metada_Frozem_Stonefruit_2024_WP4.2_EG.xlsx"
    dict_curated = reading_cathy_format.reading_cathy(file_cathy)
    file_to_modify = "~/vmr_back_end_grdi/VMR_backend_scripts/WP4.2_GRDI_Harmonization-Template_v9.0.0_v31Oct2024_updated.csv"
    new_df = modifying_original_spreadsheet.modify(file_to_modify,dict_curated)
    new_file = '~/vmr_back_end_grdi/VMR_backend_scripts/WP4.2_GRDI_Harmonization-Template_v9.0.0_v31Oct2024_updated_curated.xlsx'
    new_df.to_excel(new_file, index=False, engine='openpyxl')

    print(f"Modified XLS saved to {new_file}")







if __name__ == '__main__':
    try:
        main()
        LOG.info('Program finished')
    except Exception as e:
        LOG.error('Error : {}'.format(e))