import json

json_file_path = "card.json"

def card_parsing():
    with open(json_file_path, "r") as json_file:
        card_data = json.load(json_file)


    #print(card_data)
    terms_card ={}
    for idx, entry in card_data.items():
        #print (entry)
        if 'ARO_name' in entry:
            
            terms_card[entry['ARO_name']] =0
            for idx2,sub_entries in entry['ARO_category'].items():
                #print(sub_entries)
                if sub_entries['category_aro_class_name'] == 'AMR Gene Family':
                    terms_card[sub_entries['category_aro_name']] =0
                    
                    #print (sub_entries['category_aro_name'])
                elif sub_entries['category_aro_class_name'] == 'Drug Class':
                    terms_card[sub_entries['category_aro_name']] =0
                # print (sub_entries['category_aro_name'])
                elif sub_entries['category_aro_class_name'] == 'Resistance Mechanism':
                    terms_card[sub_entries['category_aro_name']] =0
                # print (sub_entries['category_aro_name'])
    return(terms_card)                