
CREATE TABLE COUNTRIES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COUNTRY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE STATE_PROVINCE_REGIONS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    GEO_LOC_STATE_PROVINCE_REGION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE GEO_LOC_NAME_SITES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    GEO_LOC_NAME_SITE TEXT NOT NULL
    
);



CREATE TABLE AGENCIES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    AGENCY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE CONTACT_INFORMATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    LABORATORY_NAME VARCHAR(150),
    CONTACT_NAME VARCHAR(150),
    CONTACT_EMAIL VARCHAR(150)
);
CREATE TABLE PURPOSES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    PURPOSE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT 
);



CREATE TABLE ACTIVITIES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ACTIVITY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SAMPLE_COLLECTION_DATE_PRECISION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_COLLECTION_DATE_PRECISION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);




CREATE TABLE SPECIMEN_PROCESSING(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SPECIMEN_PROCESSING TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ALTERNATIVE_SAMPLE_IDS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ALTERNATIVE_SAMPLE_ID TEXT

);





CREATE TABLE WEATHER_TYPE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    WEATHER_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE ENVIRONMENTAL_MATERIAL(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ENVIRONMENTAL_MATERIAL TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE AVAILABLE_DATA_TYPE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    AVAILABLE_DATA_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANIMAL_OR_PLANT_POPULATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANIMAL_OR_PLANT_POPULATION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE ANATOMICAL_MATERIAL(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_MATERIAL TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ENVIRONMENTAL_SITE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ENVIRONMENTAL_SITE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE BODY_PRODUCT(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    BODY_PRODUCT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANATOMICAL_PART(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_PART TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANATOMICAL_REGION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_REGION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE FOOD_PRODUCT_PROPERTY(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    FOOD_PRODUCT_PROPERTY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE FOOD_PRODUCT(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    FOOD_PRODUCT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANIMAL_SOURCE_OF_FOOD(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANIMAL_SOURCE_OF_FOOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE FOOD_PRODUCT_PRODUCTION_STREAM(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    FOOD_PRODUCT_PRODUCTION_STREAM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE FOOD_PACKAGING(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    FOOD_PACKAGING TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE COLLECTION_DEVICES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COLLECTION_DEVICE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE COLLECTION_METHODS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COLLECTION_METHOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TYPE status AS ENUM ('curated', 'ok', 'flagged','not curated');
CREATE TABLE SAMPLES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_COLLECTOR_SAMPLE_ID TEXT NOT NULL,
    ALTERNATIVE_SAMPLE_ID INTEGER REFERENCES ALTERNATIVE_SAMPLE_IDS(id),
    VALIDATION_STATUS status


);
CREATE TABLE COLLECTION_INFORMATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    SAMPLE_COLLECTED_BY INTEGER REFERENCES AGENCIES(id),
    SAMPLE_COLLECTED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SAMPLE_COLLECTION_PROJECT_NAME TEXT,
    SAMPLE_COLLECTION_DATE DATE,
    SAMPLE_COLLECTION_DATE_PRECISION INTEGER REFERENCES SAMPLE_COLLECTION_DATE_PRECISION(id),
    PRESAMPLING_ACTIVITY_DETAILS TEXT,
    SAMPLE_RECEIVED_DATE DATE,
    ORIGINAL_SAMPLE_DESCRIPTION TEXT,
    SPECIMEN_PROCESSING INTEGER REFERENCES SPECIMEN_PROCESSING(id),
    SAMPLE_STORAGE_METHOD TEXT,
    SAMPLE_STORAGE_MEDIUM TEXT,
    COLLECTION_DEVICE INTEGER REFERENCES COLLECTION_DEVICES(id),
    COLLECTION_METHOD INTEGER REFERENCES COLLECTION_METHODS(id)
);


CREATE TABLE SAMPLE_PURPOSE(
    COLLECTION_INFORMATION integer REFERENCES COLLECTION_INFORMATION(id),
    PURPOSE_OF_SAMPLING integer REFERENCES PURPOSES(id),
    CONSTRAINT Sample_purposeSampling_pk PRIMARY KEY (COLLECTION_INFORMATION, PURPOSE_OF_SAMPLING)
);
CREATE TABLE SAMPLE_ACTIVITY(
    COLLECTION_INFORMATION integer REFERENCES COLLECTION_INFORMATION(id),
    PRESAMPLING_ACTIVITY integer REFERENCES ACTIVITIES(id),
    CONSTRAINT Sample_preSamplingActivity_pk PRIMARY KEY (COLLECTION_INFORMATION, PRESAMPLING_ACTIVITY)
);


CREATE TABLE GEO_LOC(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id), 
    GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRIES(id),
    GEO_LOC_NAME_STATE_PROVINCE_REGION INTEGER REFERENCES STATE_PROVINCE_REGIONS(id),
    GEO_LOC_NAME_SITE INTEGER REFERENCES GEO_LOC_NAME_SITES(id),
    GEO_LOC_LATITUDE point,
    GEO_LOC_LONGITUDE point
);

CREATE TABLE FOOD_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    FOOD_PRODUCT_PRODUCTION_STREAM INTEGER REFERENCES FOOD_PRODUCT_PRODUCTION_STREAM(id),
    FOOD_PACKAGING_DATE DATE,
    FOOD_QUALITY_DATE DATE
    


);
CREATE TABLE FOOD_DATA_PRODUCT(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    FOOD_PRODUCT integer REFERENCES FOOD_PRODUCT(id),
    CONSTRAINT FoodData_Product_pk PRIMARY KEY (FOOD_DATA, FOOD_PRODUCT)
);
CREATE TABLE FOOD_DATA_PRODUCT_PROPERTY(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    FOOD_PRODUCT_PROPERTY integer REFERENCES FOOD_PRODUCT_PROPERTY(id),
    CONSTRAINT FoodData_Property_pk PRIMARY KEY (FOOD_DATA, FOOD_PRODUCT_PROPERTY)
);
CREATE TABLE FOOD_DATA_SOURCE(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    ANIMAL_SOURCE_OF_FOOD integer REFERENCES ANIMAL_SOURCE_OF_FOOD(id),
    CONSTRAINT FoodData_Source_pk PRIMARY KEY (FOOD_DATA, ANIMAL_SOURCE_OF_FOOD)
);

CREATE TABLE FOOD_DATA_PACKAGING(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    FOOD_PACKAGING integer REFERENCES FOOD_PACKAGING(id),
    CONSTRAINT FoodData_Packaging_pk PRIMARY KEY (FOOD_DATA, FOOD_PACKAGING)
);

CREATE TABLE ANATOMICAL_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id), 
    ANATOMICAL_REGION INTEGER REFERENCES ANATOMICAL_REGION(id)


);
CREATE TABLE ANATOMICAL_DATA_BODY(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    BODY_PRODUCT integer REFERENCES BODY_PRODUCT(id),
    CONSTRAINT AnatomicalData_Body_pk PRIMARY KEY (ANATOMICAL_DATA, BODY_PRODUCT)
);
CREATE TABLE ANATOMICAL_DATA_PART(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    ANATOMICAL_PART integer REFERENCES ANATOMICAL_PART(id),
    CONSTRAINT AnatomicalData_Part_pk PRIMARY KEY (ANATOMICAL_DATA, ANATOMICAL_PART)
);
CREATE TABLE ANATOMICAL_DATA_MATERIAL(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    ANATOMICAL_MATERIAL integer REFERENCES ANATOMICAL_MATERIAL(id),
    CONSTRAINT AnatomicalData_Material_pk PRIMARY KEY (ANATOMICAL_DATA, ANATOMICAL_MATERIAL)
);


CREATE TABLE ENVIRONMENTAL_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id), 
    AIR_TEMPERATURE FLOAT,
    SENDIMENT_DEPTH FLOAT,
    WATER_DEPTH FLOAT,
    WATER_TEMPERATURE FLOAT

);
CREATE TABLE ENVIRONMENT_DATA_MATERIAL(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ENVIRONMENTAL_MATERIAL integer REFERENCES ENVIRONMENTAL_MATERIAL(id),
    CONSTRAINT EnvironmentData_Material_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ENVIRONMENTAL_MATERIAL)
);
CREATE TABLE ENVIRONMENT_DATA_SITE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ENVIRONMENTAL_SITE integer REFERENCES ENVIRONMENTAL_SITE(id),
    CONSTRAINT EnvironmentData_Site_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ENVIRONMENTAL_SITE)
);
CREATE TABLE ENVIRONMENT_DATA_WEATHER_TYPE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    WEATHER_TYPE integer REFERENCES WEATHER_TYPE(id),
    CONSTRAINT environmentData_WeatherType_pk PRIMARY KEY (ENVIRONMENTAL_DATA, WEATHER_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_AVAILABLE_DATA_TYPE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    AVAILABLE_DATA_TYPE integer REFERENCES AVAILABLE_DATA_TYPE(id),
    CONSTRAINT environmentData_availableDataType_pk PRIMARY KEY (ENVIRONMENTAL_DATA, AVAILABLE_DATA_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_ANIMAL_PLANT(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ANIMAL_OR_PLANT_POPULATION integer REFERENCES ANIMAL_OR_PLANT_POPULATION(id),
    CONSTRAINT environmentData_animalPlant_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ANIMAL_OR_PLANT_POPULATION)
);









--create view of total sample
CREATE VIEW combined_sample_table AS
SELECT

"public"."samples"."id" AS "id",
  "public"."samples"."sample_collector_sample_id" AS "sample_collector_sample_id",
  "public"."samples"."alternative_sample_id" AS "alternative_sample_id",
  "public"."samples"."validation_status" AS "validation_status",
  "Collection Information"."id" AS "Collection Information__id",
  "Collection Information"."sample_id" AS "Collection Information__sample_id",
  "Collection Information"."sample_collected_by" AS "Collection Information__sample_collected_by",
  "Collection Information"."sample_collected_by_contact_name" AS "Collection Information__sample_collected_by_contact_name",
  "Collection Information"."sample_collection_project_name" AS "Collection Information__sample_collection_project_name",
  "Collection Information"."sample_collection_date" AS "Collection Information__sample_collection_date",
  "Collection Information"."sample_collection_date_precision" AS "Collection Information__sample_collection_date_precision",
  "Collection Information"."presampling_activity_details" AS "Collection Information__presampling_activity_details",
  "Collection Information"."sample_received_date" AS "Collection Information__sample_received_date",
  "Collection Information"."original_sample_description" AS "Collection Information__original_sample_description",
  "Collection Information"."specimen_processing" AS "Collection Information__specimen_processing",
  "Collection Information"."sample_storage_method" AS "Collection Information__sample_storage_method",
  "Collection Information"."sample_storage_medium" AS "Collection Information__sample_storage_medium",
  "Collection Information"."collection_device" AS "Collection Information__collection_device",
  "Collection Information"."collection_method" AS "Collection Information__collection_method",
  "Sample Purpose"."collection_information" AS "Sample Purpose__collection_information",
  "Sample Purpose"."purpose_of_sampling" AS "Sample Purpose__purpose_of_sampling",
  "Purposes - Purpose Of Sampling"."id" AS "Purposes - Purpose Of Sampling__id",
  "Purposes - Purpose Of Sampling"."purpose" AS "Purposes - Purpose Of Sampling__purpose",
  "Purposes - Purpose Of Sampling"."ontology_id" AS "Purposes - Purpose Of Sampling__ontology_id",
  "Purposes - Purpose Of Sampling"."description" AS "Purposes - Purpose Of Sampling__description",
  "Sample Activity"."collection_information" AS "Sample Activity__collection_information",
  "Sample Activity"."presampling_activity" AS "Sample Activity__presampling_activity",
  "Activities - Presampling Activity"."id" AS "Activities - Presampling Activity__id",
  "Activities - Presampling Activity"."activity" AS "Activities - Presampling Activity__activity",
  "Activities - Presampling Activity"."ontology_id" AS "Activities - Presampling Activity__ontology_id",
  "Activities - Presampling Activity"."description" AS "Activities - Presampling Activity__description",
  "Contact Information - Sample Collected By Contact Name"."id" AS "Contact Information - Sample Collected By Contact Name__id",
  "Contact Information - Sample Collected By Contact Name"."laboratory_name" AS "Contact Information - Sample Collected By Contact N_a6bee8c0",
  "Contact Information - Sample Collected By Contact Name"."contact_name" AS "Contact Information - Sample Collected By Contact N_c7070a1d",
  "Contact Information - Sample Collected By Contact Name"."contact_email" AS "Contact Information - Sample Collected By Contact N_6d6e91ec",
  "Agencies - Sample Collected By"."id" AS "Agencies - Sample Collected By__id",
  "Agencies - Sample Collected By"."agency" AS "Agencies - Sample Collected By__agency",
  "Agencies - Sample Collected By"."ontology_id" AS "Agencies - Sample Collected By__ontology_id",
  "Agencies - Sample Collected By"."description" AS "Agencies - Sample Collected By__description",
  "Sample Collection Date Precision"."id" AS "Sample Collection Date Precision__id",
  "Sample Collection Date Precision"."sample_collection_date_precision" AS "Sample Collection Date Precision__sample_collection_fedbc862",
  "Sample Collection Date Precision"."ontology_id" AS "Sample Collection Date Precision__ontology_id",
  "Sample Collection Date Precision"."description" AS "Sample Collection Date Precision__description",
  "Specimen Processing"."id" AS "Specimen Processing__id",
  "Specimen Processing"."specimen_processing" AS "Specimen Processing__specimen_processing",
  "Specimen Processing"."ontology_id" AS "Specimen Processing__ontology_id",
  "Specimen Processing"."description" AS "Specimen Processing__description",
  "Collection Devices"."id" AS "Collection Devices__id",
  "Collection Devices"."collection_device" AS "Collection Devices__collection_device",
  "Collection Devices"."ontology_id" AS "Collection Devices__ontology_id",
  "Collection Devices"."description" AS "Collection Devices__description",
  "Collection Methods"."id" AS "Collection Methods__id",
  "Collection Methods"."collection_method" AS "Collection Methods__collection_method",
  "Collection Methods"."ontology_id" AS "Collection Methods__ontology_id",
  "Collection Methods"."description" AS "Collection Methods__description",
  "Geo Loc"."id" AS "Geo Loc__id",
  "Geo Loc"."sample_id" AS "Geo Loc__sample_id",
  "Geo Loc"."geo_loc_name_country" AS "Geo Loc__geo_loc_name_country",
  "Geo Loc"."geo_loc_name_state_province_region" AS "Geo Loc__geo_loc_name_state_province_region",
  "Geo Loc"."geo_loc_name_site" AS "Geo Loc__geo_loc_name_site",
  "Geo Loc"."geo_loc_latitude" AS "Geo Loc__geo_loc_latitude",
  "Geo Loc"."geo_loc_longitude" AS "Geo Loc__geo_loc_longitude",
  "Countries - Geo Loc Name Country"."id" AS "Countries - Geo Loc Name Country__id",
  "Countries - Geo Loc Name Country"."country" AS "Countries - Geo Loc Name Country__country",
  "Countries - Geo Loc Name Country"."ontology_id" AS "Countries - Geo Loc Name Country__ontology_id",
  "Countries - Geo Loc Name Country"."description" AS "Countries - Geo Loc Name Country__description",
  "State Province Regions - Geo Loc Name State Province Region"."id" AS "State Province Regions - Geo Loc Name State Provinc_2977140a",
  "State Province Regions - Geo Loc Name State Province Region"."geo_loc_state_province_region" AS "State Province Regions - Geo Loc Name State Provinc_bfc4a2b4",
  "State Province Regions - Geo Loc Name State Province Region"."ontology_id" AS "State Province Regions - Geo Loc Name State Provinc_c838a289",
  "State Province Regions - Geo Loc Name State Province Region"."description" AS "State Province Regions - Geo Loc Name State Provinc_774ce6c7",
  "Geo Loc Name Sites"."id" AS "Geo Loc Name Sites__id",
  "Geo Loc Name Sites"."geo_loc_name_site" AS "Geo Loc Name Sites__geo_loc_name_site",
  "Food Data"."id" AS "Food Data__id",
  "Food Data"."sample_id" AS "Food Data__sample_id",
  "Food Data"."food_product_production_stream" AS "Food Data__food_product_production_stream",
  "Food Data"."food_packaging_date" AS "Food Data__food_packaging_date",
  "Food Data"."food_quality_date" AS "Food Data__food_quality_date",
  "Food Product Production Stream"."id" AS "Food Product Production Stream__id",
  "Food Product Production Stream"."food_product_production_stream" AS "Food Product Production Stream__food_product_produc_060b416e",
  "Food Product Production Stream"."ontology_id" AS "Food Product Production Stream__ontology_id",
  "Food Product Production Stream"."description" AS "Food Product Production Stream__description",
  "Food Data Product"."food_data" AS "Food Data Product__food_data",
  "Food Data Product"."food_product" AS "Food Data Product__food_product",
  "Food Product"."id" AS "Food Product__id",
  "Food Product"."food_product" AS "Food Product__food_product",
  "Food Product"."ontology_id" AS "Food Product__ontology_id",
  "Food Product"."description" AS "Food Product__description",
  "Food Data Product Property"."food_data" AS "Food Data Product Property__food_data",
  "Food Data Product Property"."food_product_property" AS "Food Data Product Property__food_product_property",
  "Food Product Property"."id" AS "Food Product Property__id",
  "Food Product Property"."food_product_property" AS "Food Product Property__food_product_property",
  "Food Product Property"."ontology_id" AS "Food Product Property__ontology_id",
  "Food Product Property"."description" AS "Food Product Property__description",
  "Food Data Packaging"."food_data" AS "Food Data Packaging__food_data",
  "Food Data Packaging"."food_packaging" AS "Food Data Packaging__food_packaging",
  "Food Packaging"."id" AS "Food Packaging__id",
  "Food Packaging"."food_packaging" AS "Food Packaging__food_packaging",
  "Food Packaging"."ontology_id" AS "Food Packaging__ontology_id",
  "Food Packaging"."description" AS "Food Packaging__description",
  "Food Data Source"."food_data" AS "Food Data Source__food_data",
  "Food Data Source"."animal_source_of_food" AS "Food Data Source__animal_source_of_food",
  "Animal Source Of Food"."id" AS "Animal Source Of Food__id",
  "Animal Source Of Food"."animal_source_of_food" AS "Animal Source Of Food__animal_source_of_food",
  "Animal Source Of Food"."ontology_id" AS "Animal Source Of Food__ontology_id",
  "Animal Source Of Food"."description" AS "Animal Source Of Food__description",
  "Environmental Data"."id" AS "Environmental Data__id",
  "Environmental Data"."sample_id" AS "Environmental Data__sample_id",
  "Environmental Data"."air_temperature" AS "Environmental Data__air_temperature",
  "Environmental Data"."sendiment_depth" AS "Environmental Data__sendiment_depth",
  "Environmental Data"."water_depth" AS "Environmental Data__water_depth",
  "Environmental Data"."water_temperature" AS "Environmental Data__water_temperature",
  "Environment Data Material"."environmental_data" AS "Environment Data Material__environmental_data",
  "Environment Data Material"."environmental_material" AS "Environment Data Material__environmental_material",
  "Environmental Material"."id" AS "Environmental Material__id",
  "Environmental Material"."environmental_material" AS "Environmental Material__environmental_material",
  "Environmental Material"."ontology_id" AS "Environmental Material__ontology_id",
  "Environmental Material"."description" AS "Environmental Material__description",
  "Environment Data Animal Plant"."environmental_data" AS "Environment Data Animal Plant__environmental_data",
  "Environment Data Animal Plant"."animal_or_plant_population" AS "Environment Data Animal Plant__animal_or_plant_population",
  "Animal Or Plant Population"."id" AS "Animal Or Plant Population__id",
  "Animal Or Plant Population"."animal_or_plant_population" AS "Animal Or Plant Population__animal_or_plant_population",
  "Animal Or Plant Population"."ontology_id" AS "Animal Or Plant Population__ontology_id",
  "Animal Or Plant Population"."description" AS "Animal Or Plant Population__description",
  "Environment Data Available Data Type"."environmental_data" AS "Environment Data Available Data Type__environmental_data",
  "Environment Data Available Data Type"."available_data_type" AS "Environment Data Available Data Type__available_data_type",
  "Available Data Type"."id" AS "Available Data Type__id",
  "Available Data Type"."available_data_type" AS "Available Data Type__available_data_type",
  "Available Data Type"."ontology_id" AS "Available Data Type__ontology_id",
  "Available Data Type"."description" AS "Available Data Type__description",
  "Environment Data Site"."environmental_data" AS "Environment Data Site__environmental_data",
  "Environment Data Site"."environmental_site" AS "Environment Data Site__environmental_site",
  "Environmental Site"."id" AS "Environmental Site__id",
  "Environmental Site"."environmental_site" AS "Environmental Site__environmental_site",
  "Environmental Site"."ontology_id" AS "Environmental Site__ontology_id",
  "Environmental Site"."description" AS "Environmental Site__description",
  "Environment Data Weather Type"."environmental_data" AS "Environment Data Weather Type__environmental_data",
  "Environment Data Weather Type"."weather_type" AS "Environment Data Weather Type__weather_type",
  "Weather Type"."id" AS "Weather Type__id",
  "Weather Type"."weather_type" AS "Weather Type__weather_type",
  "Weather Type"."ontology_id" AS "Weather Type__ontology_id",
  "Weather Type"."description" AS "Weather Type__description",
  "Anatomical Data"."id" AS "Anatomical Data__id",
  "Anatomical Data"."sample_id" AS "Anatomical Data__sample_id",
  "Anatomical Data"."anatomical_region" AS "Anatomical Data__anatomical_region",
  "Anatomical Region"."id" AS "Anatomical Region__id",
  "Anatomical Region"."anatomical_region" AS "Anatomical Region__anatomical_region",
  "Anatomical Region"."ontology_id" AS "Anatomical Region__ontology_id",
  "Anatomical Region"."description" AS "Anatomical Region__description",
  "Anatomical Data Material"."anatomical_data" AS "Anatomical Data Material__anatomical_data",
  "Anatomical Data Material"."anatomical_material" AS "Anatomical Data Material__anatomical_material",
  "Anatomical Material"."id" AS "Anatomical Material__id",
  "Anatomical Material"."anatomical_material" AS "Anatomical Material__anatomical_material",
  "Anatomical Material"."ontology_id" AS "Anatomical Material__ontology_id",
  "Anatomical Material"."description" AS "Anatomical Material__description",
  "Anatomical Data Body"."anatomical_data" AS "Anatomical Data Body__anatomical_data",
  "Anatomical Data Body"."body_product" AS "Anatomical Data Body__body_product",
  "Body Product"."id" AS "Body Product__id",
  "Body Product"."body_product" AS "Body Product__body_product",
  "Body Product"."ontology_id" AS "Body Product__ontology_id",
  "Body Product"."description" AS "Body Product__description",
  "Anatomical Data Part"."anatomical_data" AS "Anatomical Data Part__anatomical_data",
  "Anatomical Data Part"."anatomical_part" AS "Anatomical Data Part__anatomical_part",
  "Anatomical Part"."id" AS "Anatomical Part__id",
  "Anatomical Part"."anatomical_part" AS "Anatomical Part__anatomical_part",
  "Anatomical Part"."ontology_id" AS "Anatomical Part__ontology_id",
  "Anatomical Part"."description" AS "Anatomical Part__description"
FROM
  "public"."samples"
 
LEFT JOIN "public"."collection_information" AS "Collection Information" ON "public"."samples"."id" = "Collection Information"."sample_id"
  LEFT JOIN "public"."sample_purpose" AS "Sample Purpose" ON "Collection Information"."id" = "Sample Purpose"."collection_information"
  LEFT JOIN "public"."purposes" AS "Purposes - Purpose Of Sampling" ON "Sample Purpose"."purpose_of_sampling" = "Purposes - Purpose Of Sampling"."id"
  LEFT JOIN "public"."sample_activity" AS "Sample Activity" ON "Collection Information"."id" = "Sample Activity"."collection_information"
  LEFT JOIN "public"."activities" AS "Activities - Presampling Activity" ON "Sample Activity"."presampling_activity" = "Activities - Presampling Activity"."id"
  LEFT JOIN "public"."contact_information" AS "Contact Information - Sample Collected By Contact Name" ON "Collection Information"."sample_collected_by_contact_name" = "Contact Information - Sample Collected By Contact Name"."id"
  LEFT JOIN "public"."agencies" AS "Agencies - Sample Collected By" ON "Collection Information"."sample_collected_by" = "Agencies - Sample Collected By"."id"
  LEFT JOIN "public"."sample_collection_date_precision" AS "Sample Collection Date Precision" ON "Collection Information"."sample_collection_date_precision" = "Sample Collection Date Precision"."id"
  LEFT JOIN "public"."specimen_processing" AS "Specimen Processing" ON "Collection Information"."specimen_processing" = "Specimen Processing"."id"
  LEFT JOIN "public"."collection_devices" AS "Collection Devices" ON "Collection Information"."collection_device" = "Collection Devices"."id"
  LEFT JOIN "public"."collection_methods" AS "Collection Methods" ON "Collection Information"."collection_method" = "Collection Methods"."id"
  LEFT JOIN "public"."geo_loc" AS "Geo Loc" ON "public"."samples"."id" = "Geo Loc"."sample_id"
  LEFT JOIN "public"."countries" AS "Countries - Geo Loc Name Country" ON "Geo Loc"."geo_loc_name_country" = "Countries - Geo Loc Name Country"."id"
  LEFT JOIN "public"."state_province_regions" AS "State Province Regions - Geo Loc Name State Province Region" ON "Geo Loc"."geo_loc_name_state_province_region" = "State Province Regions - Geo Loc Name State Province Region"."id"
  LEFT JOIN "public"."geo_loc_name_sites" AS "Geo Loc Name Sites" ON "Geo Loc"."geo_loc_name_site" = "Geo Loc Name Sites"."id"
  LEFT JOIN "public"."food_data" AS "Food Data" ON "public"."samples"."id" = "Food Data"."sample_id"
  LEFT JOIN "public"."food_product_production_stream" AS "Food Product Production Stream" ON "Food Data"."food_product_production_stream" = "Food Product Production Stream"."id"
  LEFT JOIN "public"."food_data_product" AS "Food Data Product" ON "Food Data"."id" = "Food Data Product"."food_data"
  LEFT JOIN "public"."food_product" AS "Food Product" ON "Food Data Product"."food_product" = "Food Product"."id"
  LEFT JOIN "public"."food_data_product_property" AS "Food Data Product Property" ON "Food Data"."id" = "Food Data Product Property"."food_data"
  LEFT JOIN "public"."food_product_property" AS "Food Product Property" ON "Food Data Product Property"."food_product_property" = "Food Product Property"."id"
  LEFT JOIN "public"."food_data_packaging" AS "Food Data Packaging" ON "Food Data"."id" = "Food Data Packaging"."food_data"
  LEFT JOIN "public"."food_packaging" AS "Food Packaging" ON "Food Data Packaging"."food_packaging" = "Food Packaging"."id"
  LEFT JOIN "public"."food_data_source" AS "Food Data Source" ON "Food Data"."id" = "Food Data Source"."food_data"
  LEFT JOIN "public"."animal_source_of_food" AS "Animal Source Of Food" ON "Food Data Source"."animal_source_of_food" = "Animal Source Of Food"."id"
  LEFT JOIN "public"."environmental_data" AS "Environmental Data" ON "public"."samples"."id" = "Environmental Data"."sample_id"
  LEFT JOIN "public"."environment_data_material" AS "Environment Data Material" ON "Environmental Data"."id" = "Environment Data Material"."environmental_data"
  LEFT JOIN "public"."environmental_material" AS "Environmental Material" ON "Environment Data Material"."environmental_material" = "Environmental Material"."id"
  LEFT JOIN "public"."environment_data_animal_plant" AS "Environment Data Animal Plant" ON "Environmental Data"."id" = "Environment Data Animal Plant"."environmental_data"
  LEFT JOIN "public"."animal_or_plant_population" AS "Animal Or Plant Population" ON "Environment Data Animal Plant"."animal_or_plant_population" = "Animal Or Plant Population"."id"
  LEFT JOIN "public"."environment_data_available_data_type" AS "Environment Data Available Data Type" ON "Environmental Data"."id" = "Environment Data Available Data Type"."environmental_data"
  LEFT JOIN "public"."available_data_type" AS "Available Data Type" ON "Environment Data Available Data Type"."available_data_type" = "Available Data Type"."id"
  LEFT JOIN "public"."environment_data_site" AS "Environment Data Site" ON "Environmental Data"."id" = "Environment Data Site"."environmental_data"
  LEFT JOIN "public"."environmental_site" AS "Environmental Site" ON "Environment Data Site"."environmental_site" = "Environmental Site"."id"
  LEFT JOIN "public"."environment_data_weather_type" AS "Environment Data Weather Type" ON "Environmental Data"."id" = "Environment Data Weather Type"."environmental_data"
  LEFT JOIN "public"."weather_type" AS "Weather Type" ON "Environment Data Weather Type"."weather_type" = "Weather Type"."id"
  LEFT JOIN "public"."anatomical_data" AS "Anatomical Data" ON "public"."samples"."id" = "Anatomical Data"."sample_id"
  LEFT JOIN "public"."anatomical_region" AS "Anatomical Region" ON "Anatomical Data"."anatomical_region" = "Anatomical Region"."id"
  LEFT JOIN "public"."anatomical_data_material" AS "Anatomical Data Material" ON "Anatomical Data"."id" = "Anatomical Data Material"."anatomical_data"
  LEFT JOIN "public"."anatomical_material" AS "Anatomical Material" ON "Anatomical Data Material"."anatomical_material" = "Anatomical Material"."id"
  LEFT JOIN "public"."anatomical_data_body" AS "Anatomical Data Body" ON "Anatomical Data"."id" = "Anatomical Data Body"."anatomical_data"
  LEFT JOIN "public"."body_product" AS "Body Product" ON "Anatomical Data Body"."body_product" = "Body Product"."id"
  LEFT JOIN "public"."anatomical_data_part" AS "Anatomical Data Part" ON "Anatomical Data"."id" = "Anatomical Data Part"."anatomical_data"
  LEFT JOIN "public"."anatomical_part" AS "Anatomical Part" ON "Anatomical Data Part"."anatomical_part" = "Anatomical Part"."id"
;


--host fields


CREATE TABLE HOST_COMMON_NAMES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_COMMON_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOST_SCIENTIFIC_NAMES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_SCIENTIFIC_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOST_FOOD_PRODUCTION_NAMES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_FOOD_PRODUCTION_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOST_AGE_BIN (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_AGE_BIN TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOSTS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_COMMON_NAME INTEGER REFERENCES HOST_COMMON_NAMES(id),
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    HOST_SCIENTIFIC_NAME INTEGER REFERENCES HOST_SCIENTIFIC_NAMES(id),
    HOST_ECOTYPE TEXT,
    HOST_BREED TEXT,
    HOST_FOOD_PRODUCTION_NAME INTEGER REFERENCES HOST_FOOD_PRODUCTION_NAMES(id),
    HOST_DISEASE TEXT,
    HOST_AGE_BIN INTEGER REFERENCES HOST_AGE_BIN(id),
    GEO_LOC_NAME_HOST_ORIGIN_GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRIES(id)

);

--create view
CREATE VIEW combined_host_table AS
SELECT
  "public"."host"."id" AS "id",
  "public"."host"."host_common_name" AS "host_common_name",
  "public"."host"."sample_id" AS "sample_id",
  "public"."host"."host_scientific_name" AS "host_scientific_name",
  "public"."host"."host_ecotype" AS "host_ecotype",
  "public"."host"."host_breed" AS "host_breed",
  "public"."host"."host_food_production_name" AS "host_food_production_name",
  "public"."host"."host_disease" AS "host_disease",
  "public"."host"."host_age_bin" AS "host_age_bin",
  "public"."host"."geo_loc_name_host_origin_geo_loc_name_country" AS "geo_loc_name_host_origin_geo_loc_name_country",
  "Host Age Bin"."id" AS "Host Age Bin__id",
  "Host Age Bin"."host_age_bin" AS "Host Age Bin__host_age_bin",
   "Host Food Production Name"."id" AS "Host Food Production Name__id",
  "Host Food Production Name"."host_food_production_name" AS "Host Food Production Name__host_food_production_name",
  "Host Common Name"."id" AS "Host Common Name__id",
  "Host Common Name"."host_common_name" AS "Host Common Name__host_common_name",
  "Host Scientific Name"."id" AS "Host Scientific Name__id",
  "Host Scientific Name"."host_scientific_name" AS "Host Scientific Name__host_scientific_name"
  
FROM
  "public"."host"
 
LEFT JOIN "public"."host_age_bin" AS "Host Age Bin" ON "public"."host"."host_age_bin" = "Host Age Bin"."id"
  LEFT JOIN "public"."host_food_production_name" AS "Host Food Production Name" ON "public"."host"."host_food_production_name" = "Host Food Production Name"."id"
  LEFT JOIN "public"."host_common_name" AS "Host Common Name" ON "public"."host"."host_common_name" = "Host Common Name"."id"
  LEFT JOIN "public"."host_scientific_name" AS "Host Scientific Name" ON "public"."host"."host_scientific_name" = "Host Scientific Name"."id"
;
--isolate fields
CREATE TABLE ORGANISMS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ORGANISM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE TAXONOMIC_IDENTIFICATION_PROCESSES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    TAXONOMIC_IDENTIFICATION_PROCESS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DETAILS TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE STRAINS (
   id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   STRAIN TEXT


);
CREATE TABLE ISOLATES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    ISOLATE_ID TEXT NOT NULL,
    ALNTERNATIVE_ISOLATE_ID TEXT,
    STRAIN INTEGER REFERENCES STRAINS(id),
    MICROBIOLOGICAL_METHOD TEXT,
    PROGENY_ISOLATE_ID TEXT,
    ISOLATED_BY INTEGER REFERENCES AGENCIES(id),
    ISOLATED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    ISOLATION_DATE DATE,
    ISOLATE_RECEIVED_DATE DATE,
    IRIDA_ISOLATE_ID TEXT,
    IRIDA_PROJECT_ID TEXT,
    ORGANISM INTEGER REFERENCES ORGANISMS(id),
    TAXONOMIC_IDENTIFICATION_PROCESS INTEGER REFERENCES TAXONOMIC_IDENTIFICATION_PROCESSES(id),
    SEROVAR TEXT,
    SEROTYPING_METHOD TEXT,
    PHAGETYPE TEXT
);

--view isolate
CREATE VIEW combined_isolate_table AS
SELECT
  "public"."isolate"."id" AS "id",
  "public"."isolate"."sample_id" AS "sample_id",
  "public"."isolate"."isolate_id" AS "isolate_id",
  "public"."isolate"."alnternative_isolate_id" AS "alnternative_isolate_id",
  "public"."isolate"."strain" AS "strain",
  "public"."isolate"."microbiological_method" AS "microbiological_method",
  "public"."isolate"."progeny_isolate_id" AS "progeny_isolate_id",
  "public"."isolate"."isolated_by" AS "isolated_by",
  "public"."isolate"."isolated_by_contact_name" AS "isolated_by_contact_name",
  "public"."isolate"."isolation_date" AS "isolation_date",
  "public"."isolate"."isolate_received_date" AS "isolate_received_date",
  "public"."isolate"."irida_isolate_id" AS "irida_isolate_id",
  "public"."isolate"."irida_project_id" AS "irida_project_id",
  "public"."isolate"."organism_data" AS "organism_data",
  "Organism Data"."id" AS "Organism Data__id",
  "Organism Data"."organism" AS "Organism Data__organism",
  "Organism Data"."taxonomic_identification_process" AS "Organism Data__taxonomic_identification_process",
  "Organism Data"."serovar" AS "Organism Data__serovar",
  "Organism Data"."serotyping_method" AS "Organism Data__serotyping_method",
  "Organism Data"."phagetype" AS "Organism Data__phagetype",
  "Organism"."id" AS "Organism__id",
  "Organism"."organism" AS "Organism__organism",
  "Taxonomic Identification Process"."id" AS "Taxonomic Identification Process__id",
  "Taxonomic Identification Process"."taxonomic_identification_process" AS "Taxonomic Identification Process__taxonomic_identification_process",
  "Taxonomic Identification Process"."details" AS "Taxonomic Identification Process__details",
  "Contact Information - Isolated By Contact Name"."id" AS "Contact Information - Isolated By Contact Name__id",
  "Contact Information - Isolated By Contact Name"."laboratory_name" AS "Contact Information - Isolated By Contact Name__laboratory_name",
  "Contact Information - Isolated By Contact Name"."contact_name" AS "Contact Information - Isolated By Contact Name__contact_name",
  "Contact Information - Isolated By Contact Name"."contact_email" AS "Contact Information - Isolated By Contact Name__contact_email",
  "Agency - Isolated By"."id" AS "Agency - Isolated By__id",
  "Agency - Isolated By"."agency" AS "Agency - Isolated By__agency"
  
FROM
  "public"."isolate"
 
LEFT JOIN "public"."organism_data" AS "Organism Data" ON "public"."isolate"."organism_data" = "Organism Data"."id"
LEFT JOIN "public"."organism" AS "Organism" ON "Organism Data"."id" = "Organism"."id"
LEFT JOIN "public"."taxonomic_identification_process" AS "Taxonomic Identification Process" ON "Organism Data"."id" = "Taxonomic Identification Process"."id"
LEFT JOIN "public"."contact_information" AS "Contact Information - Isolated By Contact Name" ON "public"."isolate"."isolated_by_contact_name" = "Contact Information - Isolated By Contact Name"."id"
LEFT JOIN "public"."agency" AS "Agency - Isolated By" ON "public"."isolate"."isolated_by" = "Agency - Isolated By"."id"
;
--sequencing fields
CREATE TABLE SEQUENCING_PLATFORMS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_PLATFORM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEQUENCING_INSTRUMENTS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_INSTRUMENT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEQUENCING (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    LIBRARY_ID TEXT,
    SEQUENCED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCED_BY INTEGER REFERENCES AGENCIES(id),
    SEQUENCING_PROJECT_NAME TEXT,
    SEQUENCING_PLATFORM INTEGER REFERENCES SEQUENCING_PLATFORMS(id),
    SEQUENCING_INSTRUMENT INTEGER REFERENCES SEQUENCING_INSTRUMENTS(id),
    LIBRARY_PREPARATION_KIT TEXT,
    SEQUENCING_PROTOCOL TEXT,
    R1_FASTQ_FILENAME TEXT,
    R2_FASTQ_FILENAME TEXT,
    FAST5_FILENAME TEXT,
    ASSEMBLY_FILENAME TEXT
    



);
CREATE TABLE SEQUENCING_PURPOSE(
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    PURPOSE_OF_SEQUENCING integer REFERENCES PURPOSES(id),
    CONSTRAINT Sequencing_purposeSequencing_pk PRIMARY KEY (SEQUENCING_ID, PURPOSE_OF_SEQUENCING)
);
--create view
CREATE VIEW combined_sequence_table AS
SELECT
  "public"."sequencing"."id" AS "id",
  "public"."sequencing"."isolate_id" AS "isolate_id",
  "public"."sequencing"."library_id" AS "library_id",
  "public"."sequencing"."sequenced_by" AS "sequenced_by",
  "public"."sequencing"."sequenced_by_contact_name" AS "sequenced_by_contact_name",
  "Sequencing Purpose"."sequencing_id" AS "Sequencing Purpose__sequencing_id",
  "Sequencing Purpose"."purpose_of_sequencing" AS "Sequencing Purpose__purpose_of_sequencing",
  "Purpose - Purpose Of Sequencing"."id" AS "Purpose - Purpose Of Sequencing__id",
  "Purpose - Purpose Of Sequencing"."purpose" AS "Purpose - Purpose Of Sequencing__purpose",
  "public"."sequencing"."sequencing_project_name" AS "sequencing_project_name",
  "public"."sequencing"."sequencing_platform" AS "sequencing_platform",
  "public"."sequencing"."sequencing_instrument" AS "sequencing_instrument",
  "public"."sequencing"."library_preparation_kit" AS "library_preparation_kit",
  "public"."sequencing"."sequencing_protocol" AS "sequencing_protocol",
  "public"."sequencing"."r1_fastq_filename" AS "r1_fastq_filename",
  "public"."sequencing"."r2_fastq_filename" AS "r2_fastq_filename",
  "public"."sequencing"."fast5_filename" AS "fast5_filename",
  "public"."sequencing"."assembly_filename" AS "assembly_filename",
  "Contact Information - Sequenced By Contact Name"."id" AS "Contact Information - Sequenced By Contact Name__id",
  "Contact Information - Sequenced By Contact Name"."laboratory_name" AS "Contact Information - Sequenced By Contact Name__laboratory_name",
  "Contact Information - Sequenced By Contact Name"."contact_name" AS "Contact Information - Sequenced By Contact Name__contact_name",
  "Contact Information - Sequenced By Contact Name"."contact_email" AS "Contact Information - Sequenced By Contact Name__contact_email",
  "Agency - Sequenced By"."id" AS "Agency - Sequenced By__id",
  "Agency - Sequenced By"."agency" AS "Agency - Sequenced By__agency",
  "Sequencing Instrument"."id" AS "Sequencing Instrument__id",
  "Sequencing Instrument"."sequencing_instrument" AS "Sequencing Instrument__sequencing_instrument",
  "Sequencing Platform"."id" AS "Sequencing Platform__id",
  "Sequencing Platform"."sequencing_platform" AS "Sequencing Platform__sequencing_platform"
  
FROM
  "public"."sequencing"
 
LEFT JOIN "public"."contact_information" AS "Contact Information - Sequenced By Contact Name" ON "public"."sequencing"."sequenced_by_contact_name" = "Contact Information - Sequenced By Contact Name"."id"
  LEFT JOIN "public"."agency" AS "Agency - Sequenced By" ON "public"."sequencing"."sequenced_by" = "Agency - Sequenced By"."id"
  LEFT JOIN "public"."sequencing_instrument" AS "Sequencing Instrument" ON "public"."sequencing"."sequencing_instrument" = "Sequencing Instrument"."id"
  LEFT JOIN "public"."sequencing_platform" AS "Sequencing Platform" ON "public"."sequencing"."sequencing_platform" = "Sequencing Platform"."id"
  LEFT JOIN "public"."sequencing_purpose" AS "Sequencing Purpose" ON "public"."sequencing"."id" = "Sequencing Purpose"."sequencing_id"
  LEFT JOIN "public"."purpose" AS "Purpose - Purpose Of Sequencing" ON "Sequencing Purpose"."purpose_of_sequencing" = "Purpose - Purpose Of Sequencing"."id"
;

CREATE TABLE ATTRIBUTE_PACKAGES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ATTRIBUTE_PACKAGE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE PUBLIC_REPOSITORY_INFORMATION (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    SEQUENCE_SUBMITED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCE_SUBMITED_BY INTEGER REFERENCES AGENCIES(id),
    PUBLICATION_ID TEXT,
    BIOPROJECT_ACCESSION TEXT,
    BIOSAMPLE_ACCESSION TEXT,
    SRA_ACCESSION TEXT,
    GENBANK_ACCESSION TEXT,
    ATTRIBUTE_PACKAGE INTEGER REFERENCES ATTRIBUTE_PACKAGES(id)
    


);

--create view
CREATE VIEW combined_public_repository_table AS
SELECT
  "public"."public_repository_information"."id" AS "id",
  "public"."public_repository_information"."isolate_id" AS "isolate_id",
  "public"."public_repository_information"."sequence_submited_by_contact_name" AS "sequence_submited_by_contact_name",
  "public"."public_repository_information"."sequence_submited_by" AS "sequence_submited_by",
  "public"."public_repository_information"."publication_id" AS "publication_id",
  "public"."public_repository_information"."bioproject_accession" AS "bioproject_accession",
  "public"."public_repository_information"."biosample_accession" AS "biosample_accession",
  "public"."public_repository_information"."sra_accession" AS "sra_accession",
  "public"."public_repository_information"."genbank_accession" AS "genbank_accession",
  "public"."public_repository_information"."attribute_package" AS "attribute_package",
"Contact Information - Sequence Submited By Contact Name"."id" AS "Contact Information - Sequence Submited By Contact Name__id",
  "Contact Information - Sequence Submited By Contact Name"."laboratory_name" AS "Contact Information - Sequence Submited By Contact _68bfa7b0",
  "Contact Information - Sequence Submited By Contact Name"."contact_name" AS "Contact Information - Sequence Submited By Contact _a700ee48",
  "Contact Information - Sequence Submited By Contact Name"."contact_email" AS "Contact Information - Sequence Submited By Contact _760f3373",
  "Agency - Sequence Submited By"."id" AS "Agency - Sequence Submited By__id",
  "Agency - Sequence Submited By"."agency" AS "Agency - Sequence Submited By__agency",
  "Attribute Package"."id" AS "Attribute Package__id",
  "Attribute Package"."attribute_package" AS "Attribute Package__attribute_package"
  
FROM
  "public"."public_repository_information"
 
LEFT JOIN "public"."contact_information" AS "Contact Information - Sequence Submited By Contact Name" ON "public"."public_repository_information"."sequence_submited_by_contact_name" = "Contact Information - Sequence Submited By Contact Name"."id"
  LEFT JOIN "public"."agency" AS "Agency - Sequence Submited By" ON "public"."public_repository_information"."sequence_submited_by" = "Agency - Sequence Submited By"."id"
  LEFT JOIN "public"."attribute_package" AS "Attribute Package" ON "public"."public_repository_information"."attribute_package" = "Attribute Package"."id"
;




--risk assessment
CREATE TABLE STAGE_OF_PRODUCTION (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    STAGE_OF_PRODUCTION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE PREVALENCE_METRICS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    PREVALENCE_METRICS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE RISK_ASSESSMENT (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    SEQUENCE_ID TEXT,
    PREVALENCE_METRICS INTEGER REFERENCES PREVALENCE_METRICS(id),
    PREVALENCE_METRICS_DETAILS TEXT,
    STAGE_OF_PRODUCTION INTEGER REFERENCES STAGE_OF_PRODUCTION(id),
    EXPERIMENTAL_INTERVENTION_DETAILS TEXT
    

);
CREATE TABLE RISK_ACTIVITY(
    RISK_ID integer REFERENCES RISK_ASSESSMENT(id),
    EXPERIMENTAL_INTERVENTION integer REFERENCES ACTIVITIES(id),
    CONSTRAINT Risk_ExperimentalIntervation_pk PRIMARY KEY (RISK_ID, EXPERIMENTAL_INTERVENTION)
);
-- create view
CREATE VIEW combined_risk_assessment AS
SELECT
  "public"."risk_assessment"."id" AS "id",
  "public"."risk_assessment"."isolate_id" AS "isolate_id",
  "public"."risk_assessment"."sequence_id" AS "sequence_id",
  "public"."risk_assessment"."prevalence_metrics" AS "prevalence_metrics",
  "public"."risk_assessment"."prevalence_metrics_details" AS "prevalence_metrics_details",
  "public"."risk_assessment"."stage_of_production" AS "stage_of_production",
  "public"."risk_assessment"."experimental_intervention_details" AS "experimental_intervention_details",
  "Risk Activity"."risk_id" AS "Risk Activity__risk_id",
  "Risk Activity"."experimental_intervention" AS "Risk Activity__experimental_intervention",
  "Activity - Experimental Intervention"."id" AS "Activity - Experimental Intervention__id",
  "Activity - Experimental Intervention"."activity" AS "Activity - Experimental Intervention__activity",
  "Stage Of Production"."id" AS "Stage Of Production__id",
  "Stage Of Production"."stage_of_production" AS "Stage Of Production__stage_of_production",
  "Prevalence Metrics"."id" AS "Prevalence Metrics__id",
  "Prevalence Metrics"."prevalence_metrics" AS "Prevalence Metrics__prevalence_metrics"
  
FROM
  "public"."risk_assessment"
 
LEFT JOIN "public"."stage_of_production" AS "Stage Of Production" ON "public"."risk_assessment"."stage_of_production" = "Stage Of Production"."id"
LEFT JOIN "public"."prevalence_metrics" AS "Prevalence Metrics" ON "public"."risk_assessment"."prevalence_metrics" = "Prevalence Metrics"."id"
LEFT JOIN "public"."risk_activity" AS "Risk Activity" ON "public"."risk_assessment"."id" = "Risk Activity"."risk_id"
LEFT JOIN "public"."activity" AS "Activity - Experimental Intervention" ON "Risk Activity"."experimental_intervention" = "Activity - Experimental Intervention"."id"
;
--AMR_info
CREATE TABLE AMR_INFO(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    AMR_TESTED_BY INTEGER REFERENCES AGENCIES(id),
    AMR_TESTED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    AMR_TESTING_DATE DATE


);

--create view
CREATE VIEW combined_amr_info AS

SELECT
  "public"."amr_info"."id" AS "id",
  "public"."amr_info"."isolate_id" AS "isolate_id",
  "public"."amr_info"."amr_tested_by" AS "amr_tested_by",
  "public"."amr_info"."amr_tested_by_contact_name" AS "amr_tested_by_contact_name",
  "public"."amr_info"."amr_testing_date" AS "amr_testing_date",
  "Contact Information - Amr Tested By Contact Name"."id" AS "Contact Information - Amr Tested By Contact Name__id",
  "Contact Information - Amr Tested By Contact Name"."laboratory_name" AS "Contact Information - Amr Tested By Contact Name__laboratory_name",
  "Contact Information - Amr Tested By Contact Name"."contact_name" AS "Contact Information - Amr Tested By Contact Name__contact_name",
  "Contact Information - Amr Tested By Contact Name"."contact_email" AS "Contact Information - Amr Tested By Contact Name__contact_email",
  "Agency - Amr Tested By"."id" AS "Agency - Amr Tested By__id",
  "Agency - Amr Tested By"."agency" AS "Agency - Amr Tested By__agency"
 
FROM
  "public"."amr_info"
 
LEFT JOIN "public"."contact_information" AS "Contact Information - Amr Tested By Contact Name" ON "public"."amr_info"."amr_tested_by_contact_name" = "Contact Information - Amr Tested By Contact Name"."id"
LEFT JOIN "public"."agency" AS "Agency - Amr Tested By" ON "public"."amr_info"."amr_tested_by" = "Agency - Amr Tested By"."id"
;

CREATE TABLE MEASUREMENT_UNITS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    MEASUREMENT_UNITS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE MEASUREMENT_SIGN (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    MEASUREMENT_SIGN TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE MEASUREMENT_DATA (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    MEASUREMENT FLOAT(4),
    MEASUREMENT_UNITS INTEGER REFERENCES MEASUREMENT_UNITS(id),
    MEASUREMENT_SIGN INTEGER REFERENCES MEASUREMENT_SIGN(id) 
);

CREATE TABLE LABORATORY_TYPING_METHOD (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    LABORATORY_TYPING_METHOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE LABORATORY_TYPING_PLATFORM (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    LABORATORY_TYPING_PLATFORM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE VENDOR_NAME (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    VENDOR_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE LABORATORY_TYPING_DATA (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    LABORATORY_TYPING_METHOD INTEGER REFERENCES LABORATORY_TYPING_METHOD(id),
    LABORATORY_TYPING_PLATFORM INTEGER REFERENCES LABORATORY_TYPING_PLATFORM(id),
    LABORATORY_TYPING_PLATFORM_VERSION TEXT,
    VENDOR_NAME INTEGER REFERENCES VENDOR_NAME(id) 
);
CREATE TABLE TESTING_STANDARD (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    TESTING_STANDARD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE TESTING_STANDARD_DATA (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TESTING_STANDARD INTEGER REFERENCES TESTING_STANDARD(id),
    TESTING_STANDARD_VERSION TEXT,
    TESTING_STANDARD_DETAILS TEXT
    
);

CREATE TABLE TESTING_BREAKPOINT_DATA (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    TESTING_SUSCEPTIBLE_BREAKPOINT FLOAT(4),
    TESTING_INTERMEDIATE_BREAKPOINT FLOAT(4),
    TESTING_RESISTANCE_BREAKPOINT FLOAT(4)
    
);
CREATE TABLE ANTIMICROBIAL_AGENTS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANTIMICROBIAL_AGENT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE ANTIMICROBIAL_PHENOTYPES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANTIMICROBIAL_PHENOTYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE AMR_ANTIBIOTICS_PROFILE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    ANTIMICROBIAL_AGENT INTEGER REFERENCES ANTIMICROBIAL_AGENTS(id),
    ANTIMICROBIAL_PHENOTYPE INTEGER REFERENCES ANTIMICROBIAL_PHENOTYPES(id),
    MEASUREMENT_DATA INTEGER REFERENCES MEASUREMENT_DATA(id),
    LABORATORY_TYPING_DATA INTEGER REFERENCES LABORATORY_TYPING_DATA(id),
    TESTING_STANDARD_DATA INTEGER REFERENCES TESTING_STANDARD_DATA(id),
    TESTING_BREAKPOINT_DATA INTEGER REFERENCES TESTING_BREAKPOINT_DATA(id)
    

);

CREATE VIEW combined_amr_antibiotics_profile AS
SELECT
  "public"."amr_antibiotics_profile"."id" AS "id",
  "public"."amr_antibiotics_profile"."isolate_id" AS "isolate_id",
  "public"."amr_antibiotics_profile"."antimicrobial_agent" AS "antimicrobial_agent",
  "public"."amr_antibiotics_profile"."antimicrobial_phenotype" AS "antimicrobial_phenotype",
  "public"."amr_antibiotics_profile"."measurement_data" AS "measurement_data",
  "public"."amr_antibiotics_profile"."laboratory_typing_data" AS "laboratory_typing_data",
  "public"."amr_antibiotics_profile"."testing_standard_data" AS "testing_standard_data",
  "public"."amr_antibiotics_profile"."testing_breakpoint_data" AS "testing_breakpoint_data",
  "Antimicrobial Agent"."id" AS "Antimicrobial Agent__id",
  "Antimicrobial Agent"."antimicrobial_agent" AS "Antimicrobial Agent__antimicrobial_agent",
  "Antimicrobial Phenotype"."id" AS "Antimicrobial Phenotype__id",
  "Antimicrobial Phenotype"."antimicrobial_phenotype" AS "Antimicrobial Phenotype__antimicrobial_phenotype",
  "Testing Breakpoint Data"."id" AS "Testing Breakpoint Data__id",
  "Testing Breakpoint Data"."testing_susceptible_breakpoint" AS "Testing Breakpoint Data__testing_susceptible_breakpoint",
  "Testing Breakpoint Data"."testing_intermediate_breakpoint" AS "Testing Breakpoint Data__testing_intermediate_breakpoint",
  "Testing Breakpoint Data"."testing_resistance_breakpoint" AS "Testing Breakpoint Data__testing_resistance_breakpoint",
  "Testing Standard Data"."id" AS "Testing Standard Data__id",
  "Testing Standard Data"."testing_standard" AS "Testing Standard Data__testing_standard",
  "Testing Standard Data"."testing_standard_version" AS "Testing Standard Data__testing_standard_version",
  "Testing Standard Data"."testing_standard_details" AS "Testing Standard Data__testing_standard_details",
  "Testing Standard"."id" AS "Testing Standard__id",
  "Testing Standard"."testing_standard" AS "Testing Standard__testing_standard",
   "Measurement Data"."id" AS "Measurement Data__id",
  "Measurement Data"."measurement" AS "Measurement Data__measurement",
  "Measurement Data"."measurement_units" AS "Measurement Data__measurement_units",
  "Measurement Data"."measurement_sign" AS "Measurement Data__measurement_sign",
  "Measurement Sign"."id" AS "Measurement Sign__id",
  "Measurement Sign"."measurement_sign" AS "Measurement Sign__measurement_sign",
    "Measurement Units"."id" AS "Measurement Units__id",
  "Measurement Units"."measurement_units" AS "Measurement Units__measurement_units",
   "Laboratory Typing Data"."id" AS "Laboratory Typing Data__id",
  "Laboratory Typing Data"."laboratory_typing_method" AS "Laboratory Typing Data__laboratory_typing_method",
  "Laboratory Typing Data"."laboratory_typing_platform" AS "Laboratory Typing Data__laboratory_typing_platform",
  "Laboratory Typing Data"."laboratory_typing_platform_version" AS "Laboratory Typing Data__laboratory_typing_platform_version",
  "Laboratory Typing Data"."vendor_name" AS "Laboratory Typing Data__vendor_name",
  "Laboratory Typing Method"."id" AS "Laboratory Typing Method__id",
  "Laboratory Typing Method"."laboratory_typing_method" AS "Laboratory Typing Method__laboratory_typing_method",
   "Laboratory Typing Platform"."id" AS "Laboratory Typing Platform__id",
  "Laboratory Typing Platform"."laboratory_typing_platform" AS "Laboratory Typing Platform__laboratory_typing_platform",
  "Vendor Name"."id" AS "Vendor Name__id",
  "Vendor Name"."vendor_name" AS "Vendor Name__vendor_name"
  
FROM
  "public"."amr_antibiotics_profile"
 
LEFT JOIN "public"."antimicrobial_agent" AS "Antimicrobial Agent" ON "public"."amr_antibiotics_profile"."antimicrobial_agent" = "Antimicrobial Agent"."id"
  LEFT JOIN "public"."antimicrobial_phenotype" AS "Antimicrobial Phenotype" ON "public"."amr_antibiotics_profile"."antimicrobial_phenotype" = "Antimicrobial Phenotype"."id"
  LEFT JOIN "public"."testing_breakpoint_data" AS "Testing Breakpoint Data" ON "public"."amr_antibiotics_profile"."testing_breakpoint_data" = "Testing Breakpoint Data"."id"
  LEFT JOIN "public"."testing_standard_data" AS "Testing Standard Data" ON "public"."amr_antibiotics_profile"."testing_standard_data" = "Testing Standard Data"."id"
  LEFT JOIN "public"."testing_standard" AS "Testing Standard" ON "Testing Standard Data"."testing_standard" = "Testing Standard"."id"
  LEFT JOIN "public"."measurement_data" AS "Measurement Data" ON "public"."amr_antibiotics_profile"."measurement_data" = "Measurement Data"."id"
  LEFT JOIN "public"."measurement_sign" AS "Measurement Sign" ON "Measurement Data"."measurement_sign" = "Measurement Sign"."id"
  LEFT JOIN "public"."measurement_units" AS "Measurement Units" ON "Measurement Data"."measurement_units" = "Measurement Units"."id"
  LEFT JOIN "public"."laboratory_typing_data" AS "Laboratory Typing Data" ON "public"."amr_antibiotics_profile"."laboratory_typing_data" = "Laboratory Typing Data"."id"
  LEFT JOIN "public"."laboratory_typing_method" AS "Laboratory Typing Method" ON "Laboratory Typing Data"."laboratory_typing_method" = "Laboratory Typing Method"."id"
  LEFT JOIN "public"."laboratory_typing_platform" AS "Laboratory Typing Platform" ON "Laboratory Typing Data"."laboratory_typing_platform" = "Laboratory Typing Platform"."id"
  LEFT JOIN "public"."vendor_name" AS "Vendor Name" ON "Laboratory Typing Data"."vendor_name" = "Vendor Name"."id"
  ;


--Card tables AMR

CREATE TABLE AMR_GENES_PROFILES(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    CUT_OFF TEXT,
    BEST_HIT_ARO TEXT,
    MODEL_TYPE TEXT
    );

CREATE TABLE AMR_MOB_SUITE(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    MOLECULE_TYPE TEXT,
    PRIMARY_CLUSTER_ID TEXT,
    SECONDARY_CLUSTER_ID TEXT
    );

    CREATE TABLE AMR_REF_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    REP_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, REP_TYPE)
    );
    CREATE TABLE AMR_RELAXASE_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    RELAXASE_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, RELAXASE_TYPE)
    );
    
    CREATE TABLE AMR_MPF_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    MPF_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, MPF_TYPE)
    );

    CREATE TABLE AMR_ORIT_TYPES(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    ORIT_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, ORIT_TYPE)
    );
    
    CREATE TABLE AMR_PREDICTED_MOBILITY(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    PREDICTED_MOBILITY TEXT,
    PRIMARY KEY (AMR_GENES_ID, PREDICTED_MOBILITY)
    );

    CREATE TABLE AMR_GENES_DRUGS(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    DRUG_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, DRUG_ID)
    );
    

    --creating amr_gene_Resistance_mechanism
    CREATE TABLE AMR_GENES_RESISTANCE_MECHANISM(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    RESISTANCE_MECHANISM_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, RESISTANCE_MECHANISM_ID)
    );
    
    --creating amr_gene_Family
    CREATE TABLE AMR_GENES_FAMILIES(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILES(id),
    AMR_GENE_FAMILY_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, AMR_GENE_FAMILY_ID)
    );
--ONTOLOGY_REFERENCE TABLE

CREATE TABLE ONTOLOGY_REFERENCES(
	NAME text PRIMARY KEY,
	BASE_ONTOLOGY_NAME text NOT NULL,
	BASE_ONTOLOGY_IDENTIFIER text NOT NULL,
	DEFINITION text NOT NULL,
	GUIDENCE text,
	EXAMPLE text
);

















