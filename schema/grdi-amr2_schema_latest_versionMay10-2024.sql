
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







CREATE TABLE WEATHER_TYPES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    WEATHER_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE ENVIRONMENTAL_MATERIALS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ENVIRONMENTAL_MATERIAL TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE AVAILABLE_DATA_TYPES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    AVAILABLE_DATA_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANIMAL_OR_PLANT_POPULATIONS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANIMAL_OR_PLANT_POPULATION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE ANATOMICAL_MATERIALS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_MATERIAL TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ENVIRONMENTAL_SITES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ENVIRONMENTAL_SITE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE BODY_PRODUCTS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    BODY_PRODUCT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANATOMICAL_PARTS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_PART TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ANATOMICAL_REGIONS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANATOMICAL_REGION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE FOOD_PRODUCT_PROPERTIES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    FOOD_PRODUCT_PROPERTY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE FOOD_PRODUCTS(
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

/* New table that was forgotten*/
CREATE TABLE SAMPLE_PLAN(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_PLAN_ID TEXT,
    SAMPLE_PLAN_NAME TEXT
);

DROP TYPE IF EXISTS status;
CREATE TYPE status AS ENUM ('curated', 'ok', 'flagged','not curated');
CREATE TABLE SAMPLES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_COLLECTOR_SAMPLE_ID TEXT NOT NULL,
    SAMPLE_PLAN INTEGER REFERENCES SAMPLE_PLAN(id),
    VALIDATION_STATUS status


);



CREATE TABLE ALTERNATIVE_SAMPLE_IDS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    ALTERNATIVE_SAMPLE_ID TEXT

);
CREATE TABLE COLLECTION_INFORMATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id),
    SAMPLE_COLLECTED_BY INTEGER REFERENCES AGENCIES(id),
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    SAMPLE_COLLECTION_PROJECT_NAME TEXT,
    SAMPLE_COLLECTION_DATE TEXT,
    SAMPLE_COLLECTION_DATE_PRECISION INTEGER REFERENCES SAMPLE_COLLECTION_DATE_PRECISION(id),
    PRESAMPLING_ACTIVITY_DETAILS TEXT,
    SAMPLE_RECEIVED_DATE TEXT,
    ORIGINAL_SAMPLE_DESCRIPTION TEXT,
    SPECIMEN_PROCESSING INTEGER REFERENCES SPECIMEN_PROCESSING(id),
    SAMPLE_STORAGE_METHOD TEXT,
    SAMPLE_STORAGE_MEDIUM TEXT,
    COLLECTION_DEVICE INTEGER REFERENCES COLLECTION_DEVICES(id),
    COLLECTION_METHOD INTEGER REFERENCES COLLECTION_METHODS(id)
);


/* New table EXTRACTION INFORMATION PLUS PICK LIST TABLES*/
CREATE TABLE EXPERIMENTAL_SPECIMEN_ROLE_TYPES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    EXPERIMENTAL_SPECIMEN_ROLE_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT

);
CREATE TABLE VOLUME_MEASUREMENT_UNITS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    VOLUME_MEASUREMENT_UNIT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE RESIDUAL_SAMPLE_STATUS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    RESIDUAL_SAMPLE_STATUS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE DURATION_UNITS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    DURATION_UNIT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


CREATE TABLE EXTRACTION_INFORMATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
    EXPERIMENTAL_PROTOCOL_FIELD TEXT,
    EXPERIMENTAL_SPECIMEN_ROLE_TYPE INTEGER REFERENCES EXPERIMENTAL_SPECIMEN_ROLE_TYPES(id),
    NUCLEIC_ACID_EXTRACTION_METHOD TEXT,
    NUCLEIC_ACID_EXTRACTION_KIT TEXT,
    SAMPLE_VOLUME_MEASUREMENT_VALUE FLOAT,
    SAMPLE_VOLUME_MEASUREMENT_UNIT INTEGER REFERENCES VOLUME_MEASUREMENT_UNITS(id),
    RESIDUAL_SAMPLE_STATUS INTEGER REFERENCES RESIDUAL_SAMPLE_STATUS(id),
    SAMPLE_STORAGE_DURATION_VALUE FLOAT,
    SAMPLE_STORAGE_DURATION_UNIT INTEGER REFERENCES DURATION_UNITS(id),
    NUCLEIC_ACID_STORAGE_DURATION_VALUE FLOAT,
    NUCLEIC_ACID_STORAGE_DURATION_UNIT INTEGER REFERENCES DURATION_UNITS(id)

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
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id), 
    GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRIES(id),
    GEO_LOC_NAME_STATE_PROVINCE_REGION INTEGER REFERENCES STATE_PROVINCE_REGIONS(id),
    GEO_LOC_NAME_SITE INTEGER REFERENCES GEO_LOC_NAME_SITES(id),
    GEO_LOC_LATITUDE decimal(8,6),
    GEO_LOC_LONGITUDE decimal(9,6)
);

CREATE TABLE FOOD_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id),
    FOOD_PRODUCT_PRODUCTION_STREAM INTEGER REFERENCES FOOD_PRODUCT_PRODUCTION_STREAM(id),
    FOOD_PRODUCT_ORIGIN_COUNTRY INTEGER REFERENCES COUNTRIES(id),
    FOOD_PACKAGING_DATE TEXT,
    FOOD_QUALITY_DATE TEXT
    


);
CREATE TABLE FOOD_DATA_PRODUCT(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    FOOD_PRODUCT integer REFERENCES FOOD_PRODUCTS(id),
    CONSTRAINT FoodData_Product_pk PRIMARY KEY (FOOD_DATA, FOOD_PRODUCT)
);
CREATE TABLE FOOD_DATA_PRODUCT_PROPERTY(
    FOOD_DATA integer REFERENCES FOOD_DATA(id),
    FOOD_PRODUCT_PROPERTY integer REFERENCES FOOD_PRODUCT_PROPERTIES(id),
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
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id), 
    ANATOMICAL_REGION INTEGER REFERENCES ANATOMICAL_REGIONS(id)


);
CREATE TABLE ANATOMICAL_DATA_BODY(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    BODY_PRODUCT integer REFERENCES BODY_PRODUCTS(id),
    CONSTRAINT AnatomicalData_Body_pk PRIMARY KEY (ANATOMICAL_DATA, BODY_PRODUCT)
);
CREATE TABLE ANATOMICAL_DATA_PART(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    ANATOMICAL_PART integer REFERENCES ANATOMICAL_PARTS(id),
    CONSTRAINT AnatomicalData_Part_pk PRIMARY KEY (ANATOMICAL_DATA, ANATOMICAL_PART)
);
CREATE TABLE ANATOMICAL_DATA_MATERIAL(
    ANATOMICAL_DATA integer REFERENCES ANATOMICAL_DATA(id),
    ANATOMICAL_MATERIAL integer REFERENCES ANATOMICAL_MATERIALS(id),
    CONSTRAINT AnatomicalData_Material_pk PRIMARY KEY (ANATOMICAL_DATA, ANATOMICAL_MATERIAL)
);

CREATE TABLE TEMPERATURE_UNITS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    TEMPERATURE_UNIT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEDIMENT_DEPTH_UNITS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEDIMENT_DEPTH_UNITS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE WATER_DEPTH_UNITS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    WATER_DEPTH_UNITS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE ENVIRONMENTAL_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id), 
    AIR_TEMPERATURE FLOAT,
    AIR_TEMPERATURE_UNITS INTEGER REFERENCES TEMPERATURE_UNITS(id),
    SEDIMENT_DEPTH FLOAT,
    SEDIMENT_DEPTH_UNITS INTEGER REFERENCES SEDIMENT_DEPTH_UNITS(id),
    WATER_DEPTH FLOAT,
    WATER_DEPTH_UNITS INTEGER REFERENCES WATER_DEPTH_UNITS(id),
    WATER_TEMPERATURE FLOAT,
    WATER_TEMPERATURE_UNITS INTEGER REFERENCES TEMPERATURE_UNITS(id)

);
CREATE TABLE ENVIRONMENT_DATA_MATERIAL(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ENVIRONMENTAL_MATERIAL integer REFERENCES ENVIRONMENTAL_MATERIALS(id),
    CONSTRAINT EnvironmentData_Material_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ENVIRONMENTAL_MATERIAL)
);
CREATE TABLE ENVIRONMENT_DATA_SITE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ENVIRONMENTAL_SITE integer REFERENCES ENVIRONMENTAL_SITES(id),
    CONSTRAINT EnvironmentData_Site_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ENVIRONMENTAL_SITE)
);
CREATE TABLE ENVIRONMENT_DATA_WEATHER_TYPE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    WEATHER_TYPE integer REFERENCES WEATHER_TYPES(id),
    CONSTRAINT environmentData_WeatherType_pk PRIMARY KEY (ENVIRONMENTAL_DATA, WEATHER_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_AVAILABLE_DATA_TYPE(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    AVAILABLE_DATA_TYPE integer REFERENCES AVAILABLE_DATA_TYPES(id),
    CONSTRAINT environmentData_availableDataType_pk PRIMARY KEY (ENVIRONMENTAL_DATA, AVAILABLE_DATA_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_ANIMAL_PLANT(
    ENVIRONMENTAL_DATA integer REFERENCES ENVIRONMENTAL_DATA(id),
    ANIMAL_OR_PLANT_POPULATION integer REFERENCES ANIMAL_OR_PLANT_POPULATIONS(id),
    CONSTRAINT environmentData_animalPlant_pk PRIMARY KEY (ENVIRONMENTAL_DATA, ANIMAL_OR_PLANT_POPULATION)
);









--create view of total sample
CREATE VIEW combined_sample_table AS
SELECT

"public"."samples"."id" AS "id",
  "public"."samples"."sample_collector_sample_id" AS "sample_collector_sample_id",
  "public"."samples"."validation_status" AS "validation_status",
  "public"."samples"."sample_plan" AS "sample_plan",
  "Collection Information"."id" AS "Collection Information__id",
  "Collection Information"."sample_id" AS "Collection Information__sample_id",
  "Collection Information"."sample_collected_by" AS "Collection Information__sample_collected_by",
  "Collection Information"."contact_information" AS "Collection Information__contact_information",
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
  "Alternative Sample Ids"."sample_id" AS "Alternative Sample Ids__sample_id",
  "Alternative Sample Ids"."alternative_sample_id" AS "Alternative Sample Ids_alternative__sample_id",
  "Sample Plan"."id" AS "Sample Plan__id",
  "Sample Plan"."sample_plan_name" AS "Sample Plan__sample_plan_name",
  "Sample Purpose"."collection_information" AS "Sample Purpose__collection_information",
  "Sample Purpose"."purpose_of_sampling" AS "Sample Purpose__purpose_of_sampling",
  "Extraction Information"."id" AS "Extraction Information__id",
  "Extraction Information"."experimental_protocol_field" AS "Extraction Information__experimental_protocol_field",
  "Extraction Information"."experimental_specimen_role_type" AS "Extraction Information__experimental_specimen_role_type",
  "Extraction Information"."nucleic_acid_extraction_method" AS "Extraction Information__nucleic_acid_extraction_method",
  "Extraction Information"."nucleic_acid_extraction_kit" AS "Extraction Information__nucleic_acid_extraction_kit",
  "Extraction Information"."sample_volume_measurement_value" AS "Extraction Information__sample_volume_measurement_value",
  "Extraction Information"."sample_volume_measurement_unit" AS "Extraction Information__sample_volume_measurement_unit",
  "Extraction Information"."residual_sample_status" AS "Extraction Information__residual_sample_status",
  "Extraction Information"."sample_storage_duration_value" AS "Extraction Information__sample_storage_duration_value",
  "Extraction Information"."sample_storage_duration_unit" AS "Extraction Information__sample_storage_duration_unit",
  "Extraction Information"."nucleic_acid_storage_duration_value" AS "Extraction Information__nucleic_acid_storage_duration_value",
  "Extraction Information"."nucleic_acid_storage_duration_unit" AS "Extraction Information__nucleic_acid_storage_duration_unit",
  "Purposes - Purpose Of Sampling"."id" AS "Purposes - Purpose Of Sampling__id",
  "Purposes - Purpose Of Sampling"."purpose" AS "Purposes - Purpose Of Sampling__purpose",
  "Sample Activity"."collection_information" AS "Sample Activity__collection_information",
  "Sample Activity"."presampling_activity" AS "Sample Activity__presampling_activity",
  "Activities - Presampling Activity"."id" AS "Activities - Presampling Activity__id",
  "Activities - Presampling Activity"."activity" AS "Activities - Presampling Activity__activity",
  "Contact Information - Contact Information"."id" AS "Contact Information - Contact Information__id",
  "Contact Information - Contact Information"."laboratory_name" AS "Contact Information - Contact Information_a6bee8c0",
  "Contact Information - Contact Information"."contact_name" AS "Contact Information - Contact Information_c7070a1d",
  "Contact Information - Contact Information"."contact_email" AS "Contact Information - Contact Information_6d6e91ec",
  "Agencies - Sample Collected By"."id" AS "Agencies - Sample Collected By__id",
  "Agencies - Sample Collected By"."agency" AS "Agencies - Sample Collected By__agency",
  "Sample Collection Date Precision"."id" AS "Sample Collection Date Precision__id",
  "Sample Collection Date Precision"."sample_collection_date_precision" AS "Sample Collection Date Precision__sample_collection_fedbc862",
  "Specimen Processing"."id" AS "Specimen Processing__id",
  "Specimen Processing"."specimen_processing" AS "Specimen Processing__specimen_processing",
  "Collection Devices"."id" AS "Collection Devices__id",
  "Collection Devices"."collection_device" AS "Collection Devices__collection_device",
  "Collection Methods"."id" AS "Collection Methods__id",
  "Collection Methods"."collection_method" AS "Collection Methods__collection_method",
  "Geo Loc"."id" AS "Geo Loc__id",
  "Geo Loc"."sample_id" AS "Geo Loc__sample_id",
  "Geo Loc"."geo_loc_name_country" AS "Geo Loc__geo_loc_name_country",
  "Geo Loc"."geo_loc_name_state_province_region" AS "Geo Loc__geo_loc_name_state_province_region",
  "Geo Loc"."geo_loc_name_site" AS "Geo Loc__geo_loc_name_site",
  "Geo Loc"."geo_loc_latitude" AS "Geo Loc__geo_loc_latitude",
  "Geo Loc"."geo_loc_longitude" AS "Geo Loc__geo_loc_longitude",
  "Countries - Geo Loc Name Country"."id" AS "Countries - Geo Loc Name Country__id",
  "Countries - Geo Loc Name Country"."country" AS "Countries - Geo Loc Name Country__country",
  "State Province Regions - Geo Loc Name State Province Region"."id" AS "State Province Regions - Geo Loc Name State Provinc_2977140a",
  "State Province Regions - Geo Loc Name State Province Region"."geo_loc_state_province_region" AS "State Province Regions - Geo Loc Name State Provinc_bfc4a2b4",
  "Geo Loc Name Sites"."id" AS "Geo Loc Name Sites__id",
  "Geo Loc Name Sites"."geo_loc_name_site" AS "Geo Loc Name Sites__geo_loc_name_site",
  "Food Data"."id" AS "Food Data__id",
  "Food Data"."sample_id" AS "Food Data__sample_id",
  "Food Data"."food_product_origin_country" AS "Food Data__food_product_origin_country",
  "Countries - Food Product Origin Country"."id" AS "Countries - Food Product Origin Country__id",
  "Countries - Food Product Origin Country"."country" AS "Countries - Food Product Origin Country__country",
  "Food Data"."food_product_production_stream" AS "Food Data__food_product_production_stream",
  "Food Data"."food_packaging_date" AS "Food Data__food_packaging_date",
  "Food Data"."food_quality_date" AS "Food Data__food_quality_date",
  "Food Product Production Stream"."id" AS "Food Product Production Stream__id",
  "Food Product Production Stream"."food_product_production_stream" AS "Food Product Production Stream__food_product_produc_060b416e",
  "Food Data Product"."food_data" AS "Food Data Product__food_data",
  "Food Data Product"."food_product" AS "Food Data Product__food_product",
  "Food Products"."id" AS "Food Products__id",
  "Food Products"."food_product" AS "Food Products__food_product",
  "Food Data Product Property"."food_data" AS "Food Data Product Property__food_data",
  "Food Data Product Property"."food_product_property" AS "Food Data Product Property__food_product_property",
  "Food Product Properties"."id" AS "Food Product Properties__id",
  "Food Product Properties"."food_product_property" AS "Food Product Properties__food_product_property",
  "Food Data Packaging"."food_data" AS "Food Data Packaging__food_data",
  "Food Data Packaging"."food_packaging" AS "Food Data Packaging__food_packaging",
  "Food Packaging"."id" AS "Food Packaging__id",
  "Food Packaging"."food_packaging" AS "Food Packaging__food_packaging",
  "Food Data Source"."food_data" AS "Food Data Source__food_data",
  "Food Data Source"."animal_source_of_food" AS "Food Data Source__animal_source_of_food",
  "Animal Source Of Food"."id" AS "Animal Source Of Food__id",
  "Animal Source Of Food"."animal_source_of_food" AS "Animal Source Of Food__animal_source_of_food",
  "Environmental Data"."id" AS "Environmental Data__id",
  "Environmental Data"."sample_id" AS "Environmental Data__sample_id",
  "Environmental Data"."air_temperature" AS "Environmental Data__air_temperature",
  "Environmental Data"."sediment_depth" AS "Environmental Data__sediment_depth",
  "Environmental Data"."water_depth" AS "Environmental Data__water_depth",
  "Environmental Data"."water_temperature" AS "Environmental Data__water_temperature",
  "Environment Data Material"."environmental_data" AS "Environment Data Material__environmental_data",
  "Environment Data Material"."environmental_material" AS "Environment Data Material__environmental_material",
  "Environmental Materials"."id" AS "Environmental Material__id",
  "Environmental Materials"."environmental_material" AS "Environmental Materials__environmental_material",
  "Environment Data Animal Plant"."environmental_data" AS "Environment Data Animal Plant__environmental_data",
  "Environment Data Animal Plant"."animal_or_plant_population" AS "Environment Data Animal Plant__animal_or_plant_population",
  "Animal Or Plant Populations"."id" AS "Animal Or Plant Populatiosn__id",
  "Animal Or Plant Populations"."animal_or_plant_population" AS "Animal Or Plant Populations__animal_or_plant_population",
  "Environment Data Available Data Type"."environmental_data" AS "Environment Data Available Data Type__environmental_data",
  "Environment Data Available Data Type"."available_data_type" AS "Environment Data Available Data Type__available_data_type",
  "Available Data Types"."id" AS "Available Data Type__id",
  "Available Data Types"."available_data_type" AS "Available Data Types__available_data_type",
  "Environment Data Site"."environmental_data" AS "Environment Data Site__environmental_data",
  "Environment Data Site"."environmental_site" AS "Environment Data Site__environmental_site",
  "Environmental Sites"."id" AS "Environmental Sites__id",
  "Environmental Sites"."environmental_site" AS "Environmental Sites__environmental_site",
  "Environment Data Weather Type"."environmental_data" AS "Environment Data Weather Type__environmental_data",
  "Environment Data Weather Type"."weather_type" AS "Environment Data Weather Type__weather_type",
  "Weather Types"."id" AS "Weather Types__id",
  "Weather Types"."weather_type" AS "Weather Types__weather_type",
  "Anatomical Data"."id" AS "Anatomical Data__id",
  "Anatomical Data"."sample_id" AS "Anatomical Data__sample_id",
  "Anatomical Data"."anatomical_region" AS "Anatomical Data__anatomical_region",
  "Anatomical Regions"."id" AS "Anatomical Regions__id",
  "Anatomical Regions"."anatomical_region" AS "Anatomical Regions__anatomical_region",
  "Anatomical Data Material"."anatomical_data" AS "Anatomical Data Material__anatomical_data",
  "Anatomical Data Material"."anatomical_material" AS "Anatomical Data Material__anatomical_material",
  "Anatomical Materials"."id" AS "Anatomical Materials__id",
  "Anatomical Materials"."anatomical_material" AS "Anatomical Materials__anatomical_material",
  "Anatomical Data Body"."anatomical_data" AS "Anatomical Data Body__anatomical_data",
  "Anatomical Data Body"."body_product" AS "Anatomical Data Body__body_product",
  "Body Products"."id" AS "Body Products__id",
  "Body Products"."body_product" AS "Body Products__body_product",
  "Anatomical Data Part"."anatomical_data" AS "Anatomical Data Part__anatomical_data",
  "Anatomical Data Part"."anatomical_part" AS "Anatomical Data Part__anatomical_part",
  "Anatomical Parts"."id" AS "Anatomical Parts__id",
  "Anatomical Parts"."anatomical_part" AS "Anatomical Parts__anatomical_part"
  
FROM
  "public"."samples"
 
LEFT JOIN "public"."collection_information" AS "Collection Information" ON "public"."samples"."id" = "Collection Information"."sample_id"
  LEFT JOIN "public"."sample_purpose" AS "Sample Purpose" ON "Collection Information"."id" = "Sample Purpose"."collection_information"
  LEFT JOIN "public"."purposes" AS "Purposes - Purpose Of Sampling" ON "Sample Purpose"."purpose_of_sampling" = "Purposes - Purpose Of Sampling"."id"
  LEFT JOIN "public"."sample_plan" AS "Sample Plan" ON "public"."samples"."sample_plan" = "Sample Plan"."id"
  LEFT JOIN "public"."extraction_information" AS "Extraction Information" ON "public"."samples"."id" = "Extraction Information"."sample_id"
  LEFT JOIN "public"."sample_activity" AS "Sample Activity" ON "Collection Information"."id" = "Sample Activity"."collection_information"
  LEFT JOIN "public"."activities" AS "Activities - Presampling Activity" ON "Sample Activity"."presampling_activity" = "Activities - Presampling Activity"."id"
  LEFT JOIN "public"."contact_information" AS "Contact Information - Contact Information" ON "Collection Information"."contact_information" = "Contact Information - Contact Information"."id"
  LEFT JOIN "public"."agencies" AS "Agencies - Sample Collected By" ON "Collection Information"."sample_collected_by" = "Agencies - Sample Collected By"."id"
  LEFT JOIN "public"."sample_collection_date_precision" AS "Sample Collection Date Precision" ON "Collection Information"."sample_collection_date_precision" = "Sample Collection Date Precision"."id"
  LEFT JOIN "public"."specimen_processing" AS "Specimen Processing" ON "Collection Information"."specimen_processing" = "Specimen Processing"."id"
  LEFT JOIN "public"."collection_devices" AS "Collection Devices" ON "Collection Information"."collection_device" = "Collection Devices"."id"
  LEFT JOIN "public"."collection_methods" AS "Collection Methods" ON "Collection Information"."collection_method" = "Collection Methods"."id"
  LEFT JOIN "public"."geo_loc" AS "Geo Loc" ON "public"."samples"."id" = "Geo Loc"."sample_id"
  LEFT JOIN "public"."alternative_sample_ids" AS "Alternative Sample Ids" ON "public"."samples"."id" = "Alternative Sample Ids"."sample_id"
  LEFT JOIN "public"."countries" AS "Countries - Geo Loc Name Country" ON "Geo Loc"."geo_loc_name_country" = "Countries - Geo Loc Name Country"."id"
  LEFT JOIN "public"."state_province_regions" AS "State Province Regions - Geo Loc Name State Province Region" ON "Geo Loc"."geo_loc_name_state_province_region" = "State Province Regions - Geo Loc Name State Province Region"."id"
  LEFT JOIN "public"."geo_loc_name_sites" AS "Geo Loc Name Sites" ON "Geo Loc"."geo_loc_name_site" = "Geo Loc Name Sites"."id"
  LEFT JOIN "public"."food_data" AS "Food Data" ON "public"."samples"."id" = "Food Data"."sample_id"
  LEFT JOIN "public"."food_product_production_stream" AS "Food Product Production Stream" ON "Food Data"."food_product_production_stream" = "Food Product Production Stream"."id"
  LEFT JOIN "public"."countries" AS "Countries - Food Product Origin Country" ON "Food Data"."food_product_origin_country" = "Countries - Food Product Origin Country"."id"
  LEFT JOIN "public"."food_data_product" AS "Food Data Product" ON "Food Data"."id" = "Food Data Product"."food_data"
  LEFT JOIN "public"."food_products" AS "Food Products" ON "Food Data Product"."food_product" = "Food Products"."id"
  LEFT JOIN "public"."food_data_product_property" AS "Food Data Product Property" ON "Food Data"."id" = "Food Data Product Property"."food_data"
  LEFT JOIN "public"."food_product_properties" AS "Food Product Properties" ON "Food Data Product Property"."food_product_property" = "Food Product Properties"."id"
  LEFT JOIN "public"."food_data_packaging" AS "Food Data Packaging" ON "Food Data"."id" = "Food Data Packaging"."food_data"
  LEFT JOIN "public"."food_packaging" AS "Food Packaging" ON "Food Data Packaging"."food_packaging" = "Food Packaging"."id"
  LEFT JOIN "public"."food_data_source" AS "Food Data Source" ON "Food Data"."id" = "Food Data Source"."food_data"
  LEFT JOIN "public"."animal_source_of_food" AS "Animal Source Of Food" ON "Food Data Source"."animal_source_of_food" = "Animal Source Of Food"."id"
  LEFT JOIN "public"."environmental_data" AS "Environmental Data" ON "public"."samples"."id" = "Environmental Data"."sample_id"
  LEFT JOIN "public"."environment_data_material" AS "Environment Data Material" ON "Environmental Data"."id" = "Environment Data Material"."environmental_data"
  LEFT JOIN "public"."environmental_materials" AS "Environmental Materials" ON "Environment Data Material"."environmental_material" = "Environmental Materials"."id"
  LEFT JOIN "public"."environment_data_animal_plant" AS "Environment Data Animal Plant" ON "Environmental Data"."id" = "Environment Data Animal Plant"."environmental_data"
  LEFT JOIN "public"."animal_or_plant_populations" AS "Animal Or Plant Populations" ON "Environment Data Animal Plant"."animal_or_plant_population" = "Animal Or Plant Populations"."id"
  LEFT JOIN "public"."environment_data_available_data_type" AS "Environment Data Available Data Type" ON "Environmental Data"."id" = "Environment Data Available Data Type"."environmental_data"
  LEFT JOIN "public"."available_data_types" AS "Available Data Types" ON "Environment Data Available Data Type"."available_data_type" = "Available Data Types"."id"
  LEFT JOIN "public"."environment_data_site" AS "Environment Data Site" ON "Environmental Data"."id" = "Environment Data Site"."environmental_data"
  LEFT JOIN "public"."environmental_sites" AS "Environmental Sites" ON "Environment Data Site"."environmental_site" = "Environmental Sites"."id"
  LEFT JOIN "public"."environment_data_weather_type" AS "Environment Data Weather Type" ON "Environmental Data"."id" = "Environment Data Weather Type"."environmental_data"
  LEFT JOIN "public"."weather_types" AS "Weather Types" ON "Environment Data Weather Type"."weather_type" = "Weather Types"."id"
  LEFT JOIN "public"."anatomical_data" AS "Anatomical Data" ON "public"."samples"."id" = "Anatomical Data"."sample_id"
  LEFT JOIN "public"."anatomical_regions" AS "Anatomical Regions" ON "Anatomical Data"."anatomical_region" = "Anatomical Regions"."id"
  LEFT JOIN "public"."anatomical_data_material" AS "Anatomical Data Material" ON "Anatomical Data"."id" = "Anatomical Data Material"."anatomical_data"
  LEFT JOIN "public"."anatomical_materials" AS "Anatomical Materials" ON "Anatomical Data Material"."anatomical_material" = "Anatomical Materials"."id"
  LEFT JOIN "public"."anatomical_data_body" AS "Anatomical Data Body" ON "Anatomical Data"."id" = "Anatomical Data Body"."anatomical_data"
  LEFT JOIN "public"."body_products" AS "Body Products" ON "Anatomical Data Body"."body_product" = "Body Products"."id"
  LEFT JOIN "public"."anatomical_data_part" AS "Anatomical Data Part" ON "Anatomical Data"."id" = "Anatomical Data Part"."anatomical_data"
  LEFT JOIN "public"."anatomical_parts" AS "Anatomical Parts" ON "Anatomical Data Part"."anatomical_part" = "Anatomical Parts"."id"
;


--host fields


CREATE TABLE HOST_BREEDS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   HOST_BREED TEXT
);
CREATE TABLE HOST_DISEASES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   HOST_DISEASE TEXT
);
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
    SAMPLE_ID INTEGER UNIQUE REFERENCES SAMPLES(id),
    HOST_SCIENTIFIC_NAME INTEGER REFERENCES HOST_SCIENTIFIC_NAMES(id),
    HOST_ECOTYPE TEXT,
    HOST_BREED INTEGER REFERENCES HOST_BREEDS(id),
    HOST_FOOD_PRODUCTION_NAME INTEGER REFERENCES HOST_FOOD_PRODUCTION_NAMES(id),
    HOST_DISEASE INTEGER REFERENCES HOST_DISEASES(id),
    HOST_AGE_BIN INTEGER REFERENCES HOST_AGE_BIN(id),
    HOST_ORIGIN_GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRIES(id)

);

--create view
CREATE VIEW combined_host_table AS
SELECT
  "public"."hosts"."id" AS "id",
  "public"."hosts"."host_common_name" AS "host_common_name",
  "public"."hosts"."sample_id" AS "sample_id",
  "public"."hosts"."host_scientific_name" AS "host_scientific_name",
  "public"."hosts"."host_ecotype" AS "host_ecotype",
  "public"."hosts"."host_breed" AS "host_breed",
  "public"."hosts"."host_food_production_name" AS "host_food_production_name",
  "public"."hosts"."host_disease" AS "host_disease",
  "public"."hosts"."host_age_bin" AS "host_age_bin",
  "public"."hosts"."host_origin_geo_loc_name_country" AS "host_origin_geo_loc_name_country",
  "Host Common Names"."id" AS "Host Common Names__id",
  "Host Common Names"."host_common_name" AS "Host Common Names__host_common_name",
  "Host Scientific Names"."id" AS "Host Scientific Names__id",
  "Host Scientific Names"."host_scientific_name" AS "Host Scientific Names__host_scientific_name",
  "Host Food Production Names"."id" AS "Host Food Production Names__id",
  "Host Food Production Names"."host_food_production_name" AS "Host Food Production Names__host_food_production_name",
   "Host Age Bin"."id" AS "Host Age Bin__id",
  "Host Age Bin"."host_age_bin" AS "Host Age Bin__host_age_bin"
  
  FROM
  "public"."hosts"
 
LEFT JOIN "public"."host_common_names" AS "Host Common Names" ON "public"."hosts"."host_common_name" = "Host Common Names"."id"
  LEFT JOIN "public"."host_scientific_names" AS "Host Scientific Names" ON "public"."hosts"."host_scientific_name" = "Host Scientific Names"."id"
  LEFT JOIN "public"."host_food_production_names" AS "Host Food Production Names" ON "public"."hosts"."host_food_production_name" = "Host Food Production Names"."id"
  LEFT JOIN "public"."host_breeds" AS "Host Breeds" ON "public"."hosts"."host_breed" = "Host Breeds"."id"
  LEFT JOIN "public"."host_diseases" AS "Host Diseases" ON "public"."hosts"."host_disease" = "Host Diseases"."id"
  LEFT JOIN "public"."host_age_bin" AS "Host Age Bin" ON "public"."hosts"."host_age_bin" = "Host Age Bin"."id"
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
    STRAIN INTEGER REFERENCES STRAINS(id),
    MICROBIOLOGICAL_METHOD TEXT,
    PROGENY_ISOLATE_ID TEXT,
    ISOLATED_BY INTEGER REFERENCES AGENCIES(id),
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    ISOLATION_DATE TEXT,
    ISOLATE_RECEIVED_DATE TEXT,
    IRIDA_ISOLATE_ID TEXT,
    IRIDA_PROJECT_ID TEXT,
    ORGANISM INTEGER REFERENCES ORGANISMS(id),
    TAXONOMIC_IDENTIFICATION_PROCESS INTEGER REFERENCES TAXONOMIC_IDENTIFICATION_PROCESSES(id),
    SEROVAR TEXT,
    SEROTYPING_METHOD TEXT,
    PHAGETYPE TEXT
);

CREATE TABLE ALTERNATIVE_ISOLATE_IDS (
   id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
   ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
   ALTERNATIVE_ISOLATE_ID TEXT


);

--view isolate
CREATE VIEW combined_isolates AS
SELECT
  "public"."isolates"."id" AS "id",
  "public"."isolates"."sample_id" AS "sample_id",
  "public"."isolates"."isolate_id" AS "isolate_id",
  "public"."isolates"."strain" AS "strain",
  "public"."isolates"."microbiological_method" AS "microbiological_method",
  "public"."isolates"."progeny_isolate_id" AS "progeny_isolate_id",
  "public"."isolates"."isolated_by" AS "isolated_by",
  "public"."isolates"."contact_information" AS "contact_information",
  "public"."isolates"."isolation_date" AS "isolation_date",
  "public"."isolates"."isolate_received_date" AS "isolate_received_date",
  "public"."isolates"."irida_isolate_id" AS "irida_isolate_id",
  "public"."isolates"."irida_project_id" AS "irida_project_id",
  "public"."isolates"."organism" AS "organism",
  "public"."isolates"."taxonomic_identification_process" AS "taxonomic_identification_process",
  "public"."isolates"."serovar" AS "serovar",
  "public"."isolates"."serotyping_method" AS "serotyping_method",
  "public"."isolates"."phagetype" AS "phagetype",
  "Contact Information"."id" AS "Contact Information__id",
  "Contact Information"."laboratory_name" AS "Contact Information__laboratory_name",
  "Contact Information"."contact_name" AS "Contact Information__contact_name",
  "Contact Information"."contact_email" AS "Contact Information__contact_email",
  "Agencies - Isolated By"."id" AS "Agencies - Isolated By__id",
  "Agencies - Isolated By"."agency" AS "Agencies - Isolated By__agency",
  "Strains"."id" AS "Strains__id",
  "Strains"."strain" AS "Strains__strain",
  "Alternative Isolate Ids"."isolate_id" AS "Alternative Isolate Ids__isolate_id",
  "Alternative Isolate Ids"."alternative_isolate_id" AS "Alternative Isolate Ids__alternative_isolate_id",
  "Taxonomic Identification Processes"."id" AS "Taxonomic Identification Processes__id",
  "Taxonomic Identification Processes"."taxonomic_identification_process" AS "Taxonomic Identification Processes__taxonomic_ident_91e5277c",
  "Taxonomic Identification Processes"."description" AS "Taxonomic Identification Processes__description",
  "Organisms"."id" AS "Organisms__id",
  "Organisms"."organism" AS "Organisms__organism"
  
FROM
  "public"."isolates"
 
LEFT JOIN "public"."contact_information" AS "Contact Information" ON "public"."isolates"."contact_information" = "Contact Information"."id"
  LEFT JOIN "public"."agencies" AS "Agencies - Isolated By" ON "public"."isolates"."isolated_by" = "Agencies - Isolated By"."id"
  LEFT JOIN "public"."strains" AS "Strains" ON "public"."isolates"."strain" = "Strains"."id"
  LEFT JOIN "public"."alternative_isolate_ids" AS "Alternative Isolate Ids" ON "public"."isolates"."id" = "Alternative Isolate Ids"."isolate_id"
  LEFT JOIN "public"."taxonomic_identification_processes" AS "Taxonomic Identification Processes" ON "public"."isolates"."taxonomic_identification_process" = "Taxonomic Identification Processes"."id"
  LEFT JOIN "public"."organisms" AS "Organisms" ON "public"."isolates"."organism" = "Organisms"."id"
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

CREATE TABLE SEQUENCING_ASSAY_TYPES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_ASSAY_TYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);


--New controlled table
CREATE TABLE GENOMIC_TARGET_ENRICHMENT_METHODS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    GENOMIC_TARGET_ENRICHMENT_METHOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

-- New fields here May 2024
CREATE TABLE SEQUENCING (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    LIBRARY_ID TEXT,
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCED_BY INTEGER REFERENCES AGENCIES(id),
    SEQUENCING_PROJECT_NAME TEXT,
    SEQUENCING_PLATFORM INTEGER REFERENCES SEQUENCING_PLATFORMS(id),
    SEQUENCING_INSTRUMENT INTEGER REFERENCES SEQUENCING_INSTRUMENTS(id),
    --starting here
    SEQUENCING_ASSAY_TYPE INTEGER REFERENCES SEQUENCING_ASSAY_TYPES(id),
    DNA_FRAGMENT_LENGTH TEXT,
    GENOMIC_TARGET_ENRICHMENT_METHOD INTEGER REFERENCES GENOMIC_TARGET_ENRICHMENT_METHODS(id),
    GENOMIC_TARGET_ENRICHMENT_METHOD_DETAILS TEXT,
    AMPLICON_PCR_PRIMER_SCHEME TEXT,
    AMPLICON_SIZE TEXT,
    SEQUENCING_FLOW_CELL TEXT,
    --end of new fields
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

CREATE TABLE METAGENOMICS(
    SAMPLE_ID integer REFERENCES SAMPLES(id),
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    CONSTRAINT metagenomics_samplesequencing_pk PRIMARY KEY (SAMPLE_ID,SEQUENCING_ID)

);
CREATE TABLE WHOLEGENOMESEQUENCING(
    ISOLATE_ID integer REFERENCES ISOLATES(id),
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    CONSTRAINT metagenomics_isolatesSequencing_pk PRIMARY KEY (ISOLATE_ID,SEQUENCING_ID)

);
--create view
CREATE VIEW combined_sequence_table AS
SELECT
  "public"."sequencing"."id" AS "id",
  "public"."sequencing"."library_id" AS "library_id",
  "public"."sequencing"."contact_information" AS "contact_information",
  "public"."sequencing"."sequenced_by" AS "sequenced_by",
  "public"."sequencing"."sequencing_project_name" AS "sequencing_project_name",
  "public"."sequencing"."sequencing_platform" AS "sequencing_platform",
  "sequencing_platforms"."sequencing_platform" AS "sequencing_platform_name",
  "public"."sequencing"."sequencing_instrument" AS "sequencing_instrument",
  "sequencing_instruments"."sequencing_instrument" AS "sequencing_instrument_name",
  "public"."sequencing"."sequencing_assay_type" AS "sequencing_assay_type",
  "sequencing_assay_types"."sequencing_assay_type" AS "sequencing_assay_type_name",
  "public"."sequencing"."dna_fragment_length" AS "dna_fragment_length",
  "public"."sequencing"."genomic_target_enrichment_method" AS "genomic_target_enrichment_method",
  "genomic_target_enrichment_methods"."genomic_target_enrichment_method" AS "genomic_target_enrichment_method_name",
  "public"."sequencing"."genomic_target_enrichment_method_details" AS "genomic_target_enrichment_method_details",
  "public"."sequencing"."amplicon_pcr_primer_scheme" AS "amplicon_pcr_primer_scheme",
  "public"."sequencing"."amplicon_size" AS "amplicon_size",
  "public"."sequencing"."sequencing_flow_cell" AS "sequencing_flow_cell",
  "public"."sequencing"."library_preparation_kit" AS "library_preparation_kit",
  "public"."sequencing"."sequencing_protocol" AS "sequencing_protocol",
  "public"."sequencing"."r1_fastq_filename" AS "r1_fastq_filename",
  "public"."sequencing"."r2_fastq_filename" AS "r2_fastq_filename",
  "public"."sequencing"."fast5_filename" AS "fast5_filename",
  "public"."sequencing"."assembly_filename" AS "assembly_filename",
  "Contact Information"."id" AS "Contact Information__id",
  "Contact Information"."laboratory_name" AS "Contact Information__laboratory_name",
  "Contact Information"."contact_name" AS "Contact Information__contact_name",
  "Contact Information"."contact_email" AS "Contact Information__contact_email",
  "Agencies - Sequenced By"."id" AS "Agencies - Sequenced By__id",
  "Agencies - Sequenced By"."agency" AS "Agencies - Sequenced By__agency",
  "Agencies - Sequenced By"."ontology_id" AS "Agencies - Sequenced By__ontology_id",
  "Agencies - Sequenced By"."description" AS "Agencies - Sequenced By__description",
  "Metagenomics"."sample_id" AS "Metagenomics__sample_id",
  "Metagenomics"."sequencing_id" AS "Metagenomics__sequencing_id",
  "Wholegenomesequencing"."isolate_id" AS "Wholegenomesequencings__isolate_id",
  "Wholegenomesequencing"."sequencing_id" AS "Wholegenomesequencing__sequencing_id",
  "Sequencing Purpose"."sequencing_id" AS "Sequencing Purpose__sequencing_id",
  "Sequencing Purpose"."purpose_of_sequencing" AS "Sequencing Purpose__purpose_of_sequencing",
  "Purposes"."id" AS "Purposes__id",
  "Purposes"."purpose" AS "Purposes__purpose",
  "Purposes"."ontology_id" AS "Purposes__ontology_id",
  "Purposes"."description" AS "Purposes__description"
FROM
  "public"."sequencing"
LEFT JOIN "public"."contact_information" AS "Contact Information" ON "public"."sequencing"."contact_information" = "Contact Information"."id"
LEFT JOIN "public"."agencies" AS "Agencies - Sequenced By" ON "public"."sequencing"."sequenced_by" = "Agencies - Sequenced By"."id"
LEFT JOIN "public"."sequencing_purpose" AS "Sequencing Purpose" ON "public"."sequencing"."id" = "Sequencing Purpose"."sequencing_id"
LEFT JOIN "public"."metagenomics" AS "Metagenomics" ON "public"."sequencing"."id" = "Metagenomics"."sequencing_id"
LEFT JOIN "public"."wholegenomesequencing" AS "Wholegenomesequencing" ON "public"."sequencing"."id" = "Wholegenomesequencing"."sequencing_id"
LEFT JOIN "public"."sequencing_platforms" ON "public"."sequencing"."sequencing_platform" = "sequencing_platforms"."id"
LEFT JOIN "public"."sequencing_instruments" ON "public"."sequencing"."sequencing_instrument" = "sequencing_instruments"."id"
LEFT JOIN "public"."sequencing_assay_types" ON "public"."sequencing"."sequencing_assay_type" = "sequencing_assay_types"."id"
LEFT JOIN "public"."genomic_target_enrichment_methods" ON "public"."sequencing"."genomic_target_enrichment_method" = "genomic_target_enrichment_methods"."id"
LEFT JOIN "public"."purposes" AS "Purposes" ON "Sequencing Purpose"."purpose_of_sequencing" = "Purposes"."id";
;
--NEW tables MAY 20224
CREATE TABLE QUALITY_CONTROL_DETERMINATIONS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    QUALITY_CONTROL_DETERMINATION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);

CREATE TABLE QUALITY_CONTROL_ISSUES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    QUALITY_CONTROL_ISSUE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEQUENCE_ASSEMBLY_SOFTWARE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCE_ASSEMBLY_SOFTWARE TEXT NOT NULL

);

CREATE TABLE REFERENCE_GENOME_ACCESSIONS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    REFERENCE_GENOME_ACCESSION TEXT NOT NULL

);
CREATE TABLE READ_MAPPING_SOFTWARE_NAMES(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    READ_MAPPING_SOFTWARE_NAME TEXT NOT NULL

);
CREATE TABLE BIOINFORMATICS_ANALYSIS(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    QUALITY_CONTROL_METHOD_NAME TEXT,
    QUALITY_CONTROL_METHOD_VERSION TEXT,
    QUALITY_CONTROL_DETERMINATION INTEGER REFERENCES QUALITY_CONTROL_DETERMINATIONS(id),
    QUALITY_CONTROL_ISSUES INTEGER REFERENCES QUALITY_CONTROL_ISSUES(id),
    QUALITY_CONTROL_DETAILS TEXT,
    RAW_SEQUENCE_DATA_PROCESSING_METHOD TEXT,
    DEHOSTING_METHOD TEXT,
    SEQUENCE_ASSEMBLY_SOFTWARE INTEGER REFERENCES SEQUENCE_ASSEMBLY_SOFTWARE(id),
    SEQUENCE_ASSEMBLY_SOFTWARE_VERSION TEXT,
    BREADTH_OF_COVERAGE_VALUE FLOAT,
    DEPTH_OF_COVERAGE_VALUE FLOAT,
    DEPTH_OF_COVERAGE_THRESHOLD FLOAT,
    GENOME_COMPLETNESS FLOAT,
    NUMBER_OF_BASE_PAIRS_SEQUENCED INTEGER,
    NUMBER_OF_TOTALREADS INTEGER,
    NUMBER_OF_UNIQUE_READS INTEGER,
    MINIMUM_POST_TRIMMING_READ_LENGTH INTEGER,
    NUMBER_OF_CONTIGS INTEGER,
    NS_PER_100_KBP FLOAT,
    N50 FLOAT,
    PERCENT_READ_CONTAMINATION FLOAT,
    SEQUENCE_ASSEMBLY_LENGTH INTEGER,
    CONSENSUS_GENOME_LENGTH INTEGER,
    REFERENCE_GENOME_ACCESSION INTEGER REFERENCES REFERENCE_GENOME_ACCESSIONS(id),
    DEDUPLICATION_METHOD TEXT,
    BIOINFORMATICS_PROTOCOL TEXT,
    READ_MAPPING_SOFTWARE_NAME INTEGER REFERENCES READ_MAPPING_SOFTWARE_NAMES(id),
    READ_MAPPING_SOFTWARE_VERSION TEXT
);

--new view 
CREATE VIEW bioinformatics_analysis_table AS
SELECT
  "public"."bioinformatics_analysis"."id" AS "id",
  "public"."bioinformatics_analysis"."sequencing_id" AS "sequencing_id",
  "public"."bioinformatics_analysis"."quality_control_method_name" AS "quality_control_method_name",
  "public"."bioinformatics_analysis"."quality_control_method_version" AS "quality_control_method_version",
  "public"."bioinformatics_analysis"."quality_control_determination" AS "quality_control_determination",
  "public"."bioinformatics_analysis"."quality_control_issues" AS "quality_control_issues",
  "public"."bioinformatics_analysis"."quality_control_details" AS "quality_control_details",
  "public"."bioinformatics_analysis"."raw_sequence_data_processing_method" AS "raw_sequence_data_processing_method",
  "public"."bioinformatics_analysis"."dehosting_method" AS "dehosting_method",
  "public"."bioinformatics_analysis"."sequence_assembly_software" AS "sequence_assembly_software",
  "public"."bioinformatics_analysis"."sequence_assembly_software_version" AS "sequence_assembly_software_version",
  "public"."bioinformatics_analysis"."breadth_of_coverage_value" AS "breadth_of_coverage_value",
  "public"."bioinformatics_analysis"."depth_of_coverage_value" AS "depth_of_coverage_value",
  "public"."bioinformatics_analysis"."depth_of_coverage_threshold" AS "depth_of_coverage_threshold",
  "public"."bioinformatics_analysis"."genome_completness" AS "genome_completness",
  "public"."bioinformatics_analysis"."number_of_base_pairs_sequenced" AS "number_of_base_pairs_sequenced",
  "public"."bioinformatics_analysis"."number_of_totalreads" AS "number_of_totalreads",
  "public"."bioinformatics_analysis"."number_of_unique_reads" AS "number_of_unique_reads",
  "public"."bioinformatics_analysis"."minimum_post_trimming_read_length" AS "minimum_post_trimming_read_length",
  "public"."bioinformatics_analysis"."number_of_contigs" AS "number_of_contigs",
  "public"."bioinformatics_analysis"."ns_per_100_kbp" AS "ns_per_100_kbp",
  "public"."bioinformatics_analysis"."n50" AS "n50",
  "public"."bioinformatics_analysis"."percent_read_contamination" AS "percent_read_contamination",
  "public"."bioinformatics_analysis"."sequence_assembly_length" AS "sequence_assembly_length",
  "public"."bioinformatics_analysis"."consensus_genome_length" AS "consensus_genome_length",
  "public"."bioinformatics_analysis"."reference_genome_accession" AS "reference_genome_accession",
  "public"."bioinformatics_analysis"."deduplication_method" AS "deduplication_method",
  "public"."bioinformatics_analysis"."bioinformatics_protocol" AS "bioinformatics_protocol",
  "public"."bioinformatics_analysis"."read_mapping_software_name" AS "read_mapping_software_name",
  "public"."bioinformatics_analysis"."read_mapping_software_version" AS "read_mapping_software_version",
  "Quality Control Determinations"."id" AS "Quality Control Determinations__id",
  "Quality Control Determinations"."quality_control_determination" AS "Quality Control Determinations__quality_control_det_19b1af7b",
  "Quality Control Issues"."id" AS "Quality Control Issues__id",
  "Quality Control Issues"."quality_control_issue" AS "Quality Control Issues__quality_control_issue",
  "Sequence Assembly Software"."id" AS "Sequence Assembly Software__id",
  "Sequence Assembly Software"."sequence_assembly_software" AS "Sequence Assembly Software__sequence_assembly_software",
  "Reference Genome Accessions"."id" AS "Reference Genome Accessions__id",
  "Reference Genome Accessions"."reference_genome_accession" AS "Reference Genome Accessions__reference_genome_accession",
  "Read Mapping Software Names"."id" AS "Read Mapping Software Names__id",
  "Read Mapping Software Names"."read_mapping_software_name" AS "Read Mapping Software Names__read_mapping_software_name"
FROM
  "public"."bioinformatics_analysis"
 
LEFT JOIN "public"."quality_control_determinations" AS "Quality Control Determinations" ON "public"."bioinformatics_analysis"."quality_control_determination" = "Quality Control Determinations"."id"
LEFT JOIN "public"."quality_control_issues" AS "Quality Control Issues" ON "public"."bioinformatics_analysis"."quality_control_issues" = "Quality Control Issues"."id"
LEFT JOIN "public"."sequence_assembly_software" AS "Sequence Assembly Software" ON "public"."bioinformatics_analysis"."sequence_assembly_software" = "Sequence Assembly Software"."id"
LEFT JOIN "public"."reference_genome_accessions" AS "Reference Genome Accessions" ON "public"."bioinformatics_analysis"."reference_genome_accession" = "Reference Genome Accessions"."id"
LEFT JOIN "public"."read_mapping_software_names" AS "Read Mapping Software Names" ON "public"."bioinformatics_analysis"."read_mapping_software_name" = "Read Mapping Software Names"."id"
;

CREATE TABLE TAXONOMIC_INFORMATION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    TAXONOMIC_REFERENCE_DATABASE_NAME TEXT,
    TAXONOMIC_REFERENCE_DATABASE_VERSION TEXT,
    TAXONOMIC_ANALYSIS_REPORT_FILENAME TEXT,
    READ_MAPPING_CRITERIA TEXT
);


CREATE TABLE ATTRIBUTE_PACKAGES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ATTRIBUTE_PACKAGE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE PUBLIC_REPOSITORY_INFORMATION (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_ID INTEGER REFERENCES SEQUENCING(id),
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCE_SUBMITTED_BY INTEGER REFERENCES AGENCIES(id),
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
  "public"."public_repository_information"."sequencing_id" AS "sequencing_id",
  "public"."public_repository_information"."contact_information" AS "contact_information",
  "public"."public_repository_information"."sequence_submitted_by" AS "sequence_submitted_by",
  "public"."public_repository_information"."publication_id" AS "publication_id",
  "public"."public_repository_information"."bioproject_accession" AS "bioproject_accession",
  "public"."public_repository_information"."biosample_accession" AS "biosample_accession",
  "public"."public_repository_information"."sra_accession" AS "sra_accession",
  "public"."public_repository_information"."genbank_accession" AS "genbank_accession",
  "public"."public_repository_information"."attribute_package" AS "attribute_package",
  "Contact Information"."id" AS "Contact Information__id",
  "Contact Information"."laboratory_name" AS "Contact Information__laboratory_name",
  "Contact Information"."contact_name" AS "Contact Information__contact_name",
  "Contact Information"."contact_email" AS "Contact Information__contact_email",
  "Agencies - Sequence Submitted By"."id" AS "Agencies - Sequence Submitted By__id",
  "Agencies - Sequence Submitted By"."agency" AS "Agencies - Sequence Submitted By__agency",
  "Agencies - Sequence Submitted By"."ontology_id" AS "Agencies - Sequence Submitted By__ontology_id",
  "Agencies - Sequence Submitted By"."description" AS "Agencies - Sequence Submitted By__description",
  "Attribute Packages"."id" AS "Attribute Packages__id",
  "Attribute Packages"."attribute_package" AS "Attribute Packages__attribute_package"
  
FROM
  "public"."public_repository_information"
 
LEFT JOIN "public"."contact_information" AS "Contact Information" ON "public"."public_repository_information"."contact_information" = "Contact Information"."id"
  LEFT JOIN "public"."agencies" AS "Agencies - Sequence Submitted By" ON "public"."public_repository_information"."sequence_submitted_by" = "Agencies - Sequence Submitted By"."id"
  LEFT JOIN "public"."attribute_packages" AS "Attribute Packages" ON "public"."public_repository_information"."attribute_package" = "Attribute Packages"."id"
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
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
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
  "public"."risk_assessment"."sample_id" AS "sample_id",
  "public"."risk_assessment"."prevalence_metrics" AS "prevalence_metrics",
  "public"."risk_assessment"."prevalence_metrics_details" AS "prevalence_metrics_details",
  "public"."risk_assessment"."stage_of_production" AS "stage_of_production",
  "public"."risk_assessment"."experimental_intervention_details" AS "experimental_intervention_details",
  "Prevalence Metrics"."id" AS "Prevalence Metrics__id",
  "Prevalence Metrics"."prevalence_metrics" AS "Prevalence Metrics__prevalence_metrics",
  "Stage Of Production"."id" AS "Stage Of Production__id",
  "Stage Of Production"."stage_of_production" AS "Stage Of Production__stage_of_production",
  "Risk Activity"."risk_id" AS "Risk Activity__risk_id",
  "Risk Activity"."experimental_intervention" AS "Risk Activity__experimental_intervention",
  "Activities - Experimental Intervention"."id" AS "Activities - Experimental Intervention__id",
  "Activities - Experimental Intervention"."activity" AS "Activities - Experimental Intervention__activity"
  
FROM
  "public"."risk_assessment"
 
LEFT JOIN "public"."prevalence_metrics" AS "Prevalence Metrics" ON "public"."risk_assessment"."prevalence_metrics" = "Prevalence Metrics"."id"
  LEFT JOIN "public"."stage_of_production" AS "Stage Of Production" ON "public"."risk_assessment"."stage_of_production" = "Stage Of Production"."id"
  LEFT JOIN "public"."risk_activity" AS "Risk Activity" ON "public"."risk_assessment"."id" = "Risk Activity"."risk_id"
  LEFT JOIN "public"."activities" AS "Activities - Experimental Intervention" ON "Risk Activity"."experimental_intervention" = "Activities - Experimental Intervention"."id"
;
--AMR_info
CREATE TABLE AMR_INFO(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISOLATE_ID INTEGER REFERENCES ISOLATES(id),
    AMR_TESTING_BY INTEGER REFERENCES AGENCIES(id),
    CONTACT_INFORMATION INTEGER REFERENCES CONTACT_INFORMATION(id),
    AMR_TESTING_DATE TEXT


);

--create view
CREATE VIEW combined_amr_info AS

SELECT
  "public"."amr_info"."id" AS "id",
  "public"."amr_info"."isolate_id" AS "isolate_id",
  "public"."amr_info"."amr_testing_by" AS "amr_testing_by",
  "public"."amr_info"."contact_information" AS "contact_information",
  "public"."amr_info"."amr_testing_date" AS "amr_testing_date",
  "Contact Information - Contact Information"."id" AS "Contact Information -Contact Information__id",
  "Contact Information - Contact Information"."laboratory_name" AS "Contact Information - Contact Information__laboratory_name",
  "Contact Information - Contact Information"."contact_name" AS "Contact Information - Contact Information__contact_name",
  "Contact Information - Contact Information"."contact_email" AS "Contact Information - Contact Information__contact_email",
  "Agencies - Amr Testing By"."id" AS "Agencies - Amr Testing By__id",
  "Agencies - Amr Testing By"."agency" AS "Agencies - Amr Testing By__agency"
 
FROM
  "public"."amr_info"
 
LEFT JOIN "public"."contact_information" AS "Contact Information - Contact Information" ON "public"."amr_info"."contact_information" = "Contact Information - Contact Information"."id"
LEFT JOIN "public"."agencies" AS "Agencies - Amr Testing By" ON "public"."amr_info"."amr_testing_by" = "Agencies - Amr Testing By"."id"
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


CREATE TABLE LABORATORY_TYPING_METHODS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    LABORATORY_TYPING_METHOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE LABORATORY_TYPING_PLATFORMS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    LABORATORY_TYPING_PLATFORM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE VENDOR_NAMES (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    VENDOR_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
 

CREATE TABLE TESTING_STANDARD (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    TESTING_STANDARD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
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
    MEASUREMENT TEXT,
    MEASUREMENT_UNITS INTEGER REFERENCES MEASUREMENT_UNITS(id),
    MEASUREMENT_SIGN INTEGER REFERENCES MEASUREMENT_SIGN(id),
    LABORATORY_TYPING_METHOD INTEGER REFERENCES LABORATORY_TYPING_METHODS(id),
    LABORATORY_TYPING_PLATFORM INTEGER REFERENCES LABORATORY_TYPING_PLATFORMS(id),
    LABORATORY_TYPING_PLATFORM_VERSION TEXT,
    TESTING_SUSCEPTIBLE_BREAKPOINT FLOAT(4),
    TESTING_INTERMEDIATE_BREAKPOINT FLOAT(4),
    TESTING_RESISTANCE_BREAKPOINT FLOAT(4),
    TESTING_STANDARD INTEGER REFERENCES TESTING_STANDARD(id),
    TESTING_STANDARD_VERSION TEXT,
    TESTING_STANDARD_DETAILS TEXT,
    VENDOR_NAME INTEGER REFERENCES VENDOR_NAMES(id)  
    
    

);

CREATE VIEW combined_amr_antibiotics_profile AS
SELECT
  "public"."amr_antibiotics_profile"."id" AS "id",
  "public"."amr_antibiotics_profile"."isolate_id" AS "isolate_id",
  "public"."amr_antibiotics_profile"."antimicrobial_agent" AS "antimicrobial_agent",
  "public"."amr_antibiotics_profile"."antimicrobial_phenotype" AS "antimicrobial_phenotype",
  "public"."amr_antibiotics_profile"."measurement" AS "measurement",
  "public"."amr_antibiotics_profile"."measurement_units" AS "measurement_units",
  "public"."amr_antibiotics_profile"."measurement_sign" AS "measurement_sign",
  "public"."amr_antibiotics_profile"."laboratory_typing_method" AS "laboratory_typing_method",
   "public"."amr_antibiotics_profile"."laboratory_typing_platform" AS "laboratory_typing_platform",
   "public"."amr_antibiotics_profile"."laboratory_typing_platform_version" AS "laboratory_typing_platform_version",
   "public"."amr_antibiotics_profile"."vendor_name" AS "vendor_name",
  "public"."amr_antibiotics_profile"."testing_standard" AS "testing_standard",
  "Testing Standard"."id" AS "Testing Standard__id",
  "Testing Standard"."testing_standard" AS "Testing Standard__testing_standard",
  "public"."amr_antibiotics_profile"."testing_standard_version" AS "testing_standard_version",
  "public"."amr_antibiotics_profile"."testing_standard_details" AS "testing_standard_details",
  "public"."amr_antibiotics_profile"."testing_susceptible_breakpoint" AS "testing_susceptible_breakpoint",
  "public"."amr_antibiotics_profile"."testing_intermediate_breakpoint" AS "testing_intermediate_breakpoint",
  "public"."amr_antibiotics_profile"."testing_resistance_breakpoint" AS "testing_resistance_breakpoint",
  "Antimicrobial Phenotypes"."id" AS "Antimicrobial Phenotypes__id",
  "Antimicrobial Phenotypes"."antimicrobial_phenotype" AS "Antimicrobial Phenotypes__antimicrobial_phenotype",
  "Antimicrobial Agents"."id" AS "Antimicrobial Agents__id",
  "Antimicrobial Agents"."antimicrobial_agent" AS "Antimicrobial Agents__antimicrobial_agent",
  "Laboratory Typing Methods"."id" AS "Laboratory Typing Methods__id",
  "Laboratory Typing Methods"."laboratory_typing_method" AS "Laboratory Typing Method__laboratory_typing_method",
  "Laboratory Typing Platforms"."id" AS "Laboratory Typing Platforms__id",
  "Laboratory Typing Platforms"."laboratory_typing_platform" AS "Laboratory Typing Platforms__laboratory_typing_platform",
    "Vendor Names"."id" AS "Vendor Names__id",
  "Vendor Names"."vendor_name" AS "Vendor Names__vendor_name",
  "Measurement Sign"."id" AS "Measurement Sign__id",
  "Measurement Sign"."measurement_sign" AS "Measurement Sign__measurement_sign",
   "Measurement Units"."id" AS "Measurement Units__id",
  "Measurement Units"."measurement_units" AS "Measurement Units__measurement_units"
  
FROM
  "public"."amr_antibiotics_profile"
 
LEFT JOIN "public"."antimicrobial_phenotypes" AS "Antimicrobial Phenotypes" ON "public"."amr_antibiotics_profile"."antimicrobial_phenotype" = "Antimicrobial Phenotypes"."id"
  LEFT JOIN "public"."antimicrobial_agents" AS "Antimicrobial Agents" ON "public"."amr_antibiotics_profile"."antimicrobial_agent" = "Antimicrobial Agents"."id"
  LEFT JOIN "public"."testing_standard" AS "Testing Standard" ON "public"."amr_antibiotics_profile"."testing_standard" = "Testing Standard"."id"
  LEFT JOIN "public"."laboratory_typing_methods" AS "Laboratory Typing Methods" ON "public"."amr_antibiotics_profile"."laboratory_typing_method" = "Laboratory Typing Methods"."id"
  LEFT JOIN "public"."laboratory_typing_platforms" AS "Laboratory Typing Platforms" ON "public"."amr_antibiotics_profile"."laboratory_typing_platform" = "Laboratory Typing Platforms"."id"
  LEFT JOIN "public"."vendor_names" AS "Vendor Names" ON "public"."amr_antibiotics_profile"."vendor_name" = "Vendor Names"."id"
  LEFT JOIN "public"."measurement_sign" AS "Measurement Sign" ON "public"."amr_antibiotics_profile"."measurement_sign" = "Measurement Sign"."id"
  LEFT JOIN "public"."measurement_units" AS "Measurement Units" ON "public"."amr_antibiotics_profile"."measurement_units" = "Measurement Units"."id"
  ;


--Card tables AMR

CREATE TABLE AMR_GENES_PROFILES(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SEQUENCING_ID INTEGER REFERENCES SEQUENCING(id),
    SAMPLE_ID INTEGER REFERENCES SAMPLES(id),
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
