
CREATE TABLE COUNTRY(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COUNTRY TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE STATE_PROVINCE_REGION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    GEO_LOC_STATE_PROVINCE_REGION TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE GEO_LOC_NAME_SITE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    GEO_LOC_NAME_SITE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);




CREATE TABLE GEO_LOC(id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRY(id),
GEO_LOC_NAME_STATE_PROVINCE_REGION INTEGER REFERENCES STATE_PROVINCE_REGION(id),
GEO_LOC_NAME_SITE INTEGER REFERENCES GEO_LOC_NAME_SITE(id),
GEO_LOC_LATITUDE point,
GEO_LOC_LONGITUDE point
);



CREATE TABLE AGENCY(
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
CREATE TABLE PURPOSE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    PURPOSE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT 
);



CREATE TABLE ACTIVITY(
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

CREATE TABLE SAMPLE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_COLLECTOR_SAMPLE_ID TEXT,
    ALTERNATIVE_SAMPLE_ID TEXT NOT NULL,
    SAMPLE_COLLECTED_BY INTEGER REFERENCES AGENCY(id),
    SAMPLE_COLLECTED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SAMPLE_COLLECTION_PROJECT_NAME TEXT,
    SAMPLE_COLLECTION_DATE DATE,
    SAMPLE_COLLECTION_DATE_PRECISION INTEGER REFERENCES SAMPLE_COLLECTION_DATE_PRECISION(id),
    PRESAMPLING_ACTIVITY_DETAILS TEXT,
    SAMPLE_RECEIVED_DATE DATE,
    ORIGINAL_SAMPLE_DESCRIPTION TEXT,
    SPECIMEN_PROCESSING INTEGER REFERENCES SPECIMEN_PROCESSING(id)
);

CREATE TABLE SAMPLE_PURPOSE(
    SAMPLE_ID integer REFERENCES SAMPLE(id),
    PURPOSE_OF_SAMPLING integer REFERENCES PURPOSE(id),
    CONSTRAINT Sample_purposeSampling_pk PRIMARY KEY (SAMPLE_ID, PURPOSE_OF_SAMPLING)
);
CREATE TABLE SAMPLE_ACTIVITY(
    SAMPLE_ID integer REFERENCES SAMPLE(id),
    PRESAMPLING_ACTIVITY integer REFERENCES ACTIVITY(id),
    CONSTRAINT Sample_preSamplingActivity_pk PRIMARY KEY (SAMPLE_ID, PRESAMPLING_ACTIVITY)
);

CREATE TABLE WATER_DATA(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SENDIMENT_DEPTH FLOAT,
    WATER_DEPTH FLOAT,
    WATER_TEMPERATURE FLOAT
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


CREATE TABLE COLLECTION_DEVICE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COLLECTION_DEVICE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE COLLECTION_METHOD(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    COLLECTION_METHOD TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE COLLECTION(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE_STORAGE_METHOD TEXT,
    SAMPLE_STORAGE_MEDIUM TEXT,
    COLLECTION_DEVICE INTEGER REFERENCES COLLECTION_DEVICE(id),
    COLLECTION_METHOD INTEGER REFERENCES COLLECTION_METHOD(id));

CREATE TABLE SAMPLE_COLLECTION_AND_PROCESSING(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    SAMPLE INTEGER REFERENCES SAMPLE(id),
    GEO_LOC INTEGER REFERENCES GEO_LOC(id),
    WATER_DATA INTEGER REFERENCES WATER_DATA(id),
    AIR_TEMPERATURE FLOAT,
    ANATOMICAL_REGION INTEGER REFERENCES ANATOMICAL_REGION(id),
    FOOD_PRODUCT_PRODUCTION_STREAM INTEGER REFERENCES FOOD_PRODUCT_PRODUCTION_STREAM(id),
    FOOD_PACKAGING_DATE DATE,
    FOOD_QUALITY_DATE DATE,
    COLLECTION INTEGER REFERENCES COLLECTION(id),
    VALIDATION_STATUS TEXT
);

CREATE TABLE ENVIRONMENT_DATA_MATERIAL(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ENVIRONMENTAL_MATERIAL integer REFERENCES ENVIRONMENTAL_MATERIAL(id),
    CONSTRAINT EnvironmentData_Material_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ENVIRONMENTAL_MATERIAL)
);
CREATE TABLE ENVIRONMENT_DATA_SITE(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ENVIRONMENTAL_SITE integer REFERENCES ENVIRONMENTAL_SITE(id),
    CONSTRAINT EnvironmentData_Site_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ENVIRONMENTAL_SITE)
);
CREATE TABLE ENVIRONMENT_DATA_WEATHER_TYPE(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    WEATHER_TYPE integer REFERENCES WEATHER_TYPE(id),
    CONSTRAINT environmentData_WeatherType_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, WEATHER_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_AVAILABLE_DATA_TYPE(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    AVAILABLE_DATA_TYPE integer REFERENCES AVAILABLE_DATA_TYPE(id),
    CONSTRAINT environmentData_availableDataType_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, AVAILABLE_DATA_TYPE)
);
CREATE TABLE ENVIRONMENT_DATA_ANIMAL_PLANT(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ANIMAL_OR_PLANT_POPULATION integer REFERENCES ANIMAL_OR_PLANT_POPULATION(id),
    CONSTRAINT environmentData_animalPlant_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ANIMAL_OR_PLANT_POPULATION)
);
CREATE TABLE ANATOMICAL_DATA_BODY(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    BODY_PRODUCT integer REFERENCES BODY_PRODUCT(id),
    CONSTRAINT AnatomicalData_Body_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, BODY_PRODUCT)
);
CREATE TABLE ANATOMICAL_DATA_PART(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ANATOMICAL_PART integer REFERENCES ANATOMICAL_PART(id),
    CONSTRAINT AnatomicalData_Part_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ANATOMICAL_PART)
);
CREATE TABLE ANATOMICAL_DATA_MATERIAL(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ANATOMICAL_MATERIAL integer REFERENCES ANATOMICAL_MATERIAL(id),
    CONSTRAINT AnatomicalData_Material_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ANATOMICAL_MATERIAL)
);

CREATE TABLE FOOD_DATA_PRODUCT(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    FOOD_PRODUCT integer REFERENCES FOOD_PRODUCT(id),
    CONSTRAINT FoodData_Product_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, FOOD_PRODUCT)
);
CREATE TABLE FOOD_DATA_PRODUCT_PROPERTY(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    FOOD_PRODUCT_PROPERTY integer REFERENCES FOOD_PRODUCT_PROPERTY(id),
    CONSTRAINT FoodData_Property_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, FOOD_PRODUCT_PROPERTY)
);
CREATE TABLE FOOD_DATA_SOURCE(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    ANIMAL_SOURCE_OF_FOOD integer REFERENCES ANIMAL_SOURCE_OF_FOOD(id),
    CONSTRAINT FoodData_Source_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, ANIMAL_SOURCE_OF_FOOD)
);

CREATE TABLE FOOD_DATA_PACKAGING(
    SAMPLE_COLLECTION_AND_PROCESSING integer REFERENCES SAMPLE_COLLECTION_AND_PROCESSING(id),
    FOOD_PACKAGING integer REFERENCES FOOD_PACKAGING(id),
    CONSTRAINT FoodData_Packaging_pk PRIMARY KEY (SAMPLE_COLLECTION_AND_PROCESSING, FOOD_PACKAGING)
);



--create view of total sample
CREATE VIEW combined_sample_table AS
SELECT

"public"."sample_collection_and_processing"."id" AS "id",
  "public"."sample_collection_and_processing"."sample" AS "sample",
  "public"."sample_collection_and_processing"."geo_loc" AS "geo_loc",
  "public"."sample_collection_and_processing"."water_data" AS "water_data",
  "public"."sample_collection_and_processing"."air_temperature" AS "air_temperature",
  "public"."sample_collection_and_processing"."anatomical_region" AS "anatomical_region",
  "public"."sample_collection_and_processing"."food_product_production_stream" AS "food_product_production_stream",
  "public"."sample_collection_and_processing"."food_packaging_date" AS "food_packaging_date",
  "public"."sample_collection_and_processing"."food_quality_date" AS "food_quality_date",
  "public"."sample_collection_and_processing"."collection" AS "collection",
  "Sample"."id" AS "Sample__id",
  "Sample"."sample_collector_sample_id" AS "Sample__sample_collector_sample_id",
  "Sample"."alternative_sample_id" AS "Sample__alternative_sample_id",
  "Sample"."sample_collected_by" AS "Sample__sample_collected_by",
  "Sample"."sample_collected_by_contact_name" AS "Sample__sample_collected_by_contact_name",
  "Sample"."sample_collection_project_name" AS "Sample__sample_collection_project_name",
  "Sample"."sample_collection_date" AS "Sample__sample_collection_date",
  "Sample"."sample_collection_date_precision" AS "Sample__sample_collection_date_precision",
  "Sample"."presampling_activity_details" AS "Sample__presampling_activity_details",
  "Sample"."sample_received_date" AS "Sample__sample_received_date",
  "Sample"."original_sample_description" AS "Sample__original_sample_description",
  "Sample"."specimen_processing" AS "Sample__specimen_processing",
  "Contact Information - Sample Collected By"."id" AS "Contact Information - Sample Collected By__id",
  "Contact Information - Sample Collected By"."laboratory_name" AS "Contact Information - Sample Collected By__laboratory_name",
  "Contact Information - Sample Collected By"."contact_name" AS "Contact Information - Sample Collected By__contact_name",
  "Contact Information - Sample Collected By"."contact_email" AS "Contact Information - Sample Collected By__contact_email",
  "Agency - Sample Collected By"."id" AS "Agency - Sample Collected By__id",
  "Agency - Sample Collected By"."agency" AS "Agency - Sample Collected By__agency",
  "Sample Collection Date Precision"."id" AS "Sample Collection Date Precision__id",
  "Sample Collection Date Precision"."sample_collection_date_precision" AS "Sample Collection Date Precision__sample_collection_fedbc862",
  "Sample Purpose"."sample_id" AS "Sample Purpose__sample_id",
  "Sample Purpose"."purpose_of_sampling" AS "Sample Purpose__purpose_of_sampling",
  "Purpose - Purpose Of Sampling"."id" AS "Purpose - Purpose Of Sampling__id",
  "Purpose - Purpose Of Sampling"."purpose" AS "Purpose - Purpose Of Sampling__purpose",
  "Sample Activity"."sample_id" AS "Sample Activity__sample_id",
  "Sample Activity"."presampling_activity" AS "Sample Activity__presampling_activity",
  "Activity - Presampling Activity"."id" AS "Activity - Presampling Activity__id",
  "Activity - Presampling Activity"."activity" AS "Activity - Presampling Activity__activity",
  "Specimen Processing"."id" AS "Specimen Processing__id",
  "Specimen Processing"."specimen_processing" AS "Specimen Processing__specimen_processing",
  "Geo Loc"."id" AS "Geo Loc__id",
  "Geo Loc"."geo_loc_name_country" AS "Geo Loc__geo_loc_name_country",
  "Geo Loc"."geo_loc_name_state_province_region" AS "Geo Loc__geo_loc_name_state_province_region",
  "Geo Loc"."geo_loc_name_site" AS "Geo Loc__geo_loc_name_site",
  "Geo Loc"."geo_loc_latitude" AS "Geo Loc__geo_loc_latitude",
  "Geo Loc"."geo_loc_longitude" AS "Geo Loc__geo_loc_longitude",
  "Country - Geo Loc Name Country"."id" AS "Country - Geo Loc Name Country__id",
  "Country - Geo Loc Name Country"."country" AS "Country - Geo Loc Name Country__country",
  "State Province Region - Geo Loc Name State Province Region"."id" AS "State Province Region - Geo Loc Name State Province_3a67694b",
  "State Province Region - Geo Loc Name State Province Region"."geo_loc_state_province_region" AS "State Province Region - Geo Loc Name State Province_75747284",
  "Geo Loc Name Site"."id" AS "Geo Loc Name Site__id",
  "Geo Loc Name Site"."geo_loc_name_site" AS "Geo Loc Name Site__geo_loc_name_site",
  "Water Data"."id" AS "Water Data__id",
  "Water Data"."sendiment_depth" AS "Water Data__sendiment_depth",
  "Water Data"."water_depth" AS "Water Data__water_depth",
  "Water Data"."water_temperature" AS "Water Data__water_temperature",
  "Anatomical Data Material"."sample_collection_and_processing" AS "Anatomical Data Material__sample_collection_and_processing",
  "Anatomical Data Material"."anatomical_material" AS "Anatomical Data Material__anatomical_material",
  "Anatomical Material"."id" AS "Anatomical Material__id",
  "Anatomical Material"."anatomical_material" AS "Anatomical Material__anatomical_material",
  "Anatomical Data Body"."sample_collection_and_processing" AS "Anatomical Data Body__sample_collection_and_processing",
  "Anatomical Data Body"."body_product" AS "Anatomical Data Body__body_product",
  "Body Product"."id" AS "Body Product__id",
  "Body Product"."body_product" AS "Body Product__body_product",
  "Anatomical Data Part"."sample_collection_and_processing" AS "Anatomical Data Part__sample_collection_and_processing",
  "Anatomical Data Part"."anatomical_part" AS "Anatomical Data Part__anatomical_part",
  "Anatomical Part"."id" AS "Anatomical Part__id",
  "Anatomical Part"."anatomical_part" AS "Anatomical Part__anatomical_part",
   "Environment Data Material"."sample_collection_and_processing" AS "Environment Data Material__sample_collection_and_processing",
  "Environment Data Material"."environmental_material" AS "Environment Data Material__environmental_material",
  "Environmental Material"."id" AS "Environmental Material__id",
  "Environmental Material"."environmental_material" AS "Environmental Material__environmental_material",
   "Environment Data Animal Plant"."sample_collection_and_processing" AS "Environment Data Animal Plant__sample_collection_an_7ca5ab51",
  "Environment Data Animal Plant"."animal_or_plant_population" AS "Environment Data Animal Plant__animal_or_plant_population",
  "Environment Data Available Data Type"."sample_collection_and_processing" AS "Environment Data Available Data Type__sample_collec_77035d80",
  "Environment Data Available Data Type"."available_data_type" AS "Environment Data Available Data Type__available_data_type",
  "Animal Or Plant Population"."id" AS "Animal Or Plant Population__id",
  "Animal Or Plant Population"."animal_or_plant_population" AS "Animal Or Plant Population__animal_or_plant_population",
  "Available Data Type"."id" AS "Available Data Type__id",
  "Available Data Type"."available_data_type" AS "Available Data Type__available_data_type",
  "Environment Data Site"."sample_collection_and_processing" AS "Environment Data Site__sample_collection_and_processing",
  "Environment Data Site"."environmental_site" AS "Environment Data Site__environmental_site",
  "Environment Data Weather Type"."sample_collection_and_processing" AS "Environment Data Weather Type__sample_collection_an_10923388",
  "Environment Data Weather Type"."weather_type" AS "Environment Data Weather Type__weather_type",
  "Environmental Site"."id" AS "Environmental Site__id",
  "Environmental Site"."environmental_site" AS "Environmental Site__environmental_site",
  "Weather Type"."id" AS "Weather Type__id",
  "Weather Type"."weather_type" AS "Weather Type__weather_type",
   "Food Data Product"."sample_collection_and_processing" AS "Food Data Product__sample_collection_and_processing",
  "Food Data Product"."food_product" AS "Food Data Product__food_product",
  "Food Data Product Property"."sample_collection_and_processing" AS "Food Data Product Property__sample_collection_and_processing",
  "Food Data Product Property"."food_product_property" AS "Food Data Product Property__food_product_property",
  "Food Data Packaging"."sample_collection_and_processing" AS "Food Data Packaging__sample_collection_and_processing",
  "Food Data Packaging"."food_packaging" AS "Food Data Packaging__food_packaging",
  "Food Data Source"."sample_collection_and_processing" AS "Food Data Source__sample_collection_and_processing",
  "Food Data Source"."animal_source_of_food" AS "Food Data Source__animal_source_of_food",
  "Food Product"."id" AS "Food Product__id",
  "Food Product"."food_product" AS "Food Product__food_product",
   "Food Product Property"."id" AS "Food Product Property__id",
  "Food Product Property"."food_product_property" AS "Food Product Property__food_product_property",
  "Food Packaging"."id" AS "Food Packaging__id",
  "Food Packaging"."food_packaging" AS "Food Packaging__food_packaging",
  "Animal Source Of Food"."id" AS "Animal Source Of Food__id",
  "Animal Source Of Food"."animal_source_of_food" AS "Animal Source Of Food__animal_source_of_food",
  "Food Product Production Stream"."id" AS "Food Product Production Stream__id",
  "Food Product Production Stream"."food_product_production_stream" AS "Food Product Production Stream__food_product_produc_060b416e",
   "Collection"."id" AS "Collection__id",
  "Collection"."sample_storage_method" AS "Collection__sample_storage_method",
  "Collection"."sample_storage_medium" AS "Collection__sample_storage_medium",
  "Collection"."collection_device" AS "Collection__collection_device",
  "Collection"."collection_method" AS "Collection__collection_method",
  "Collection Device"."id" AS "Collection Device__id",
  "Collection Device"."collection_device" AS "Collection Device__collection_device",
   "Collection Method"."id" AS "Collection Method__id",
  "Collection Method"."collection_method" AS "Collection Method__collection_method"
  
FROM
  "public"."sample_collection_and_processing"
 
LEFT JOIN "public"."sample" AS "Sample" ON "public"."sample_collection_and_processing"."sample" = "Sample"."id"
   LEFT JOIN "public"."contact_information" AS "Contact Information - Sample Collected By" ON "Sample"."sample_collected_by_contact_name" = "Contact Information - Sample Collected By"."id"
  LEFT JOIN "public"."agency" AS "Agency - Sample Collected By" ON "Sample"."sample_collected_by" = "Agency - Sample Collected By"."id"
  LEFT JOIN "public"."sample_collection_date_precision" AS "Sample Collection Date Precision" ON "Sample"."sample_collection_date_precision" = "Sample Collection Date Precision"."id"
  LEFT JOIN "public"."sample_purpose" AS "Sample Purpose" ON "Sample"."id" = "Sample Purpose"."sample_id"
  LEFT JOIN "public"."purpose" AS "Purpose - Purpose Of Sampling" ON "Sample Purpose"."purpose_of_sampling" = "Purpose - Purpose Of Sampling"."id"
  LEFT JOIN "public"."sample_activity" AS "Sample Activity" ON "Sample"."id" = "Sample Activity"."sample_id"
  LEFT JOIN "public"."activity" AS "Activity - Presampling Activity" ON "Sample Activity"."presampling_activity" = "Activity - Presampling Activity"."id"
  LEFT JOIN "public"."specimen_processing" AS "Specimen Processing" ON "Sample"."specimen_processing" = "Specimen Processing"."id"
  LEFT JOIN "public"."geo_loc" AS "Geo Loc" ON "public"."sample_collection_and_processing"."geo_loc" = "Geo Loc"."id"
  LEFT JOIN "public"."country" AS "Country - Geo Loc Name Country" ON "Geo Loc"."geo_loc_name_country" = "Country - Geo Loc Name Country"."id"
  LEFT JOIN "public"."state_province_region" AS "State Province Region - Geo Loc Name State Province Region" ON "Geo Loc"."geo_loc_name_state_province_region" = "State Province Region - Geo Loc Name State Province Region"."id"
  LEFT JOIN "public"."geo_loc_name_site" AS "Geo Loc Name Site" ON "Geo Loc"."geo_loc_name_site" = "Geo Loc Name Site"."id"
  LEFT JOIN "public"."water_data" AS "Water Data" ON "public"."sample_collection_and_processing"."water_data" = "Water Data"."id"
  LEFT JOIN "public"."anatomical_data_material" AS "Anatomical Data Material" ON "public"."sample_collection_and_processing"."id" = "Anatomical Data Material"."sample_collection_and_processing"
  LEFT JOIN "public"."anatomical_material" AS "Anatomical Material" ON "Anatomical Data Material"."anatomical_material" = "Anatomical Material"."id"
  LEFT JOIN "public"."anatomical_data_body" AS "Anatomical Data Body" ON "public"."sample_collection_and_processing"."id" = "Anatomical Data Body"."sample_collection_and_processing"
  LEFT JOIN "public"."body_product" AS "Body Product" ON "Anatomical Data Body"."body_product" = "Body Product"."id"
  LEFT JOIN "public"."anatomical_data_part" AS "Anatomical Data Part" ON "public"."sample_collection_and_processing"."id" = "Anatomical Data Part"."sample_collection_and_processing"
  LEFT JOIN "public"."anatomical_part" AS "Anatomical Part" ON "Anatomical Data Part"."anatomical_part" = "Anatomical Part"."id"
  LEFT JOIN "public"."environment_data_material" AS "Environment Data Material" ON "public"."sample_collection_and_processing"."id" = "Environment Data Material"."sample_collection_and_processing"
  LEFT JOIN "public"."environmental_material" AS "Environmental Material" ON "Environment Data Material"."environmental_material" = "Environmental Material"."id"
  LEFT JOIN "public"."environment_data_animal_plant" AS "Environment Data Animal Plant" ON "public"."sample_collection_and_processing"."id" = "Environment Data Animal Plant"."sample_collection_and_processing"
  LEFT JOIN "public"."environment_data_available_data_type" AS "Environment Data Available Data Type" ON "public"."sample_collection_and_processing"."id" = "Environment Data Available Data Type"."sample_collection_and_processing"
  LEFT JOIN "public"."animal_or_plant_population" AS "Animal Or Plant Population" ON "Environment Data Animal Plant"."animal_or_plant_population" = "Animal Or Plant Population"."id"
  LEFT JOIN "public"."available_data_type" AS "Available Data Type" ON "Environment Data Available Data Type"."available_data_type" = "Available Data Type"."id"
  LEFT JOIN "public"."environment_data_site" AS "Environment Data Site" ON "public"."sample_collection_and_processing"."id" = "Environment Data Site"."sample_collection_and_processing"
  LEFT JOIN "public"."environment_data_weather_type" AS "Environment Data Weather Type" ON "public"."sample_collection_and_processing"."id" = "Environment Data Weather Type"."sample_collection_and_processing"
  LEFT JOIN "public"."environmental_site" AS "Environmental Site" ON "Environment Data Site"."environmental_site" = "Environmental Site"."id"
  LEFT JOIN "public"."weather_type" AS "Weather Type" ON "Environment Data Weather Type"."weather_type" = "Weather Type"."id"
  LEFT JOIN "public"."food_data_product" AS "Food Data Product" ON "public"."sample_collection_and_processing"."id" = "Food Data Product"."sample_collection_and_processing"
  LEFT JOIN "public"."food_data_product_property" AS "Food Data Product Property" ON "public"."sample_collection_and_processing"."id" = "Food Data Product Property"."sample_collection_and_processing"
  LEFT JOIN "public"."food_data_packaging" AS "Food Data Packaging" ON "public"."sample_collection_and_processing"."id" = "Food Data Packaging"."sample_collection_and_processing"
  LEFT JOIN "public"."food_data_source" AS "Food Data Source" ON "public"."sample_collection_and_processing"."id" = "Food Data Source"."sample_collection_and_processing"
  LEFT JOIN "public"."food_product" AS "Food Product" ON "Food Data Product"."food_product" = "Food Product"."id"
  LEFT JOIN "public"."food_product_property" AS "Food Product Property" ON "Food Data Product Property"."food_product_property" = "Food Product Property"."id"
  LEFT JOIN "public"."food_packaging" AS "Food Packaging" ON "Food Data Packaging"."food_packaging" = "Food Packaging"."id"
  LEFT JOIN "public"."animal_source_of_food" AS "Animal Source Of Food" ON "Food Data Source"."animal_source_of_food" = "Animal Source Of Food"."id"
  LEFT JOIN "public"."food_product_production_stream" AS "Food Product Production Stream" ON "public"."sample_collection_and_processing"."food_product_production_stream" = "Food Product Production Stream"."id"
  LEFT JOIN "public"."collection" AS "Collection" ON "public"."sample_collection_and_processing"."collection" = "Collection"."id"
  LEFT JOIN "public"."collection_device" AS "Collection Device" ON "Collection"."collection_device" = "Collection Device"."id"
  LEFT JOIN "public"."collection_method" AS "Collection Method" ON "Collection"."collection_method" = "Collection Method"."id"

;


--host fields


CREATE TABLE HOST_COMMON_NAME (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_COMMON_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOST_SCIENTIFIC_NAME (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_SCIENTIFIC_NAME TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE HOST_FOOD_PRODUCTION_NAME (
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
CREATE TABLE HOST (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    HOST_COMMON_NAME INTEGER REFERENCES HOST_COMMON_NAME(id),
    SAMPLE_COLLECTOR_SAMPLE_ID INTEGER REFERENCES SAMPLE(id),
    HOST_SCIENTIFIC_NAME INTEGER REFERENCES HOST_SCIENTIFIC_NAME(id),
    HOST_ECOTYPE TEXT,
    HOST_BREED TEXT,
    HOST_FOOD_PRODUCTION_NAME INTEGER REFERENCES HOST_FOOD_PRODUCTION_NAME(id),
    HOST_DISEASE TEXT,
    HOST_AGE_BIN INTEGER REFERENCES HOST_AGE_BIN(id),
    GEO_LOC_NAME_HOST_ORIGIN_GEO_LOC_NAME_COUNTRY INTEGER REFERENCES COUNTRY(id)

);

--create view
CREATE VIEW combined_host_table AS
SELECT
  "public"."host"."id" AS "id",
  "public"."host"."host_common_name" AS "host_common_name",
  "public"."host"."sample_collector_sample_id" AS "sample_collector_sample_id",
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
CREATE TABLE ORGANISM (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ORGANISM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE TAXONOMIC_IDENTIFICATION_PROCESS (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    TAXONOMIC_IDENTIFICATION_PROCESS TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DETAILS TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE ORGANISM_DATA (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ORGANISM INTEGER REFERENCES ORGANISM(id),
    TAXONOMIC_IDENTIFICATION_PROCESS INTEGER REFERENCES TAXONOMIC_IDENTIFICATION_PROCESS(id),
    SEROVAR TEXT,
    SEROTYPING_METHOD TEXT,
    PHAGETYPE TEXT


);
CREATE TABLE ISOLATE (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SAMPLE_COLLECTOR_SAMPLE_ID INTEGER REFERENCES SAMPLE(id),
    ISOLATE_ID TEXT NOT NULL,
    ALNTERNATIVE_ISOLATE_ID TEXT,
    STRAIN TEXT,
    MICROBIOLOGICAL_METHOD TEXT,
    PROGENY_ISOLATE_ID TEXT,
    ISOLATED_BY INTEGER REFERENCES AGENCY(id),
    ISOLATED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    ISOLATION_DATE DATE,
    ISOLATE_RECEIVED_DATE DATE,
    IRIDA_ISOLATE_ID TEXT,
    IRIDA_PROJECT_ID TEXT,
    ORGANISM_DATA INTEGER REFERENCES ORGANISM_DATA(id)
);

--view isolate
CREATE VIEW combined_isolate_table AS
SELECT
  "public"."isolate"."id" AS "id",
  "public"."isolate"."sample_collector_sample_id" AS "sample_collector_sample_id",
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
CREATE TABLE SEQUENCING_PLATFORM (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_PLATFORM TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEQUENCING_INSTRUMENT (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    SEQUENCING_INSTRUMENT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE SEQUENCING (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    LIBRARY_ID TEXT,
    SEQUENCED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCED_BY INTEGER REFERENCES AGENCY(id),
    PURPOSE_OF_SEQUENCING INTEGER REFERENCES PURPOSE(id),
    SEQUENCING_PROJECT_NAME TEXT,
    SEQUENCING_PLATFORM INTEGER REFERENCES SEQUENCING_PLATFORM(id),
    SEQUENCING_INSTRUMENT INTEGER REFERENCES SEQUENCING_INSTRUMENT(id),
    LIBRARY_PREPARATION_KIT TEXT,
    SEQUENCING_PROTOCOL TEXT,
    R1_FASTQ_FILENAME TEXT,
    R2_FASTQ_FILENAME TEXT,
    FAST5_FILENAME TEXT,
    ASSEMBLY_FILENAME TEXT
    



);
CREATE TABLE SEQUENCING_PURPOSE(
    SEQUENCING_ID integer REFERENCES SEQUENCING(id),
    PURPOSE_OF_SEQUENCING integer REFERENCES PURPOSE(id),
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

CREATE TABLE ATTRIBUTE_PACKAGE (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ATTRIBUTE_PACKAGE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE PUBLIC_REPOSITORY_INFORMATION (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    SEQUENCE_SUBMITED_BY_CONTACT_NAME INTEGER REFERENCES CONTACT_INFORMATION(id),
    SEQUENCE_SUBMITED_BY INTEGER REFERENCES AGENCY(id),
    PUBLICATION_ID TEXT,
    BIOPROJECT_ACCESSION TEXT,
    BIOSAMPLE_ACCESSION TEXT,
    SRA_ACCESSION TEXT,
    GENBANK_ACCESSION TEXT,
    ATTRIBUTE_PACKAGE INTEGER REFERENCES ATTRIBUTE_PACKAGE(id)
    


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
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    SEQUENCE_ID TEXT,
    PREVALENCE_METRICS INTEGER REFERENCES PREVALENCE_METRICS(id),
    PREVALENCE_METRICS_DETAILS TEXT,
    STAGE_OF_PRODUCTION INTEGER REFERENCES STAGE_OF_PRODUCTION(id),
    EXPERIMENTAL_INTERVENTION_DETAILS TEXT
    

);
CREATE TABLE RISK_ACTIVITY(
    RISK_ID integer REFERENCES RISK_ASSESSMENT(id),
    EXPERIMENTAL_INTERVENTION integer REFERENCES ACTIVITY(id),
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
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    AMR_TESTED_BY INTEGER REFERENCES AGENCY(id),
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
CREATE TABLE ANTIMICROBIAL_AGENT (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANTIMICROBIAL_AGENT TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE ANTIMICROBIAL_PHENOTYPE (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ANTIMICROBIAL_PHENOTYPE TEXT NOT NULL,
    ONTOLOGY_ID TEXT,
    DESCRIPTION TEXT
);
CREATE TABLE AMR_ANTIBIOTICS_PROFILE(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    ANTIMICROBIAL_AGENT INTEGER REFERENCES ANTIMICROBIAL_AGENT(id),
    ANTIMICROBIAL_PHENOTYPE INTEGER REFERENCES ANTIMICROBIAL_PHENOTYPE(id),
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

CREATE TABLE AMR_GENES_PROFILE(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    ISOLATE_ID INTEGER REFERENCES ISOLATE(id),
    CUT_OFF TEXT,
    BEST_HIT_ARO TEXT,
    MODEL_TYPE TEXT
    );

CREATE TABLE AMR_MOB_SUITE(
    id INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY, 
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    MOLECULE_TYPE TEXT,
    PRIMARY_CLUSTER_ID TEXT,
    SECONDARY_CLUSTER_ID TEXT
    );

    CREATE TABLE AMR_REF_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    REP_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, REP_TYPE)
    );
    CREATE TABLE AMR_RELAXASE_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    RELAXASE_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, RELAXASE_TYPE)
    );
    
    CREATE TABLE AMR_MPF_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    MPF_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, MPF_TYPE)
    );

    CREATE TABLE AMR_ORIT_TYPE(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    ORIT_TYPE TEXT,
    PRIMARY KEY (AMR_GENES_ID, ORIT_TYPE)
    );
    
    CREATE TABLE AMR_PREDICTED_MOBILITY(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    PREDICTED_MOBILITY TEXT,
    PRIMARY KEY (AMR_GENES_ID, PREDICTED_MOBILITY)
    );

    CREATE TABLE AMR_GENES_DRUGS(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    DRUG_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, DRUG_ID)
    );
    

    --creating amr_gene_Resistance_mechanism
    CREATE TABLE AMR_GENES_RESISTANCE_MECHANISM(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    RESISTANCE_MECHANISM_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, RESISTANCE_MECHANISM_ID)
    );
    
    --creating amr_gene_Family
    CREATE TABLE AMR_GENES_FAMILY(
    AMR_GENES_ID integer REFERENCES AMR_GENES_PROFILE(id),
    AMR_GENE_FAMILY_ID TEXT,
    PRIMARY KEY (AMR_GENES_ID, AMR_GENE_FAMILY_ID)
    );
--ONTOLOGY_REFERENCE TABLE

CREATE TABLE ONTOLOGY_REFERENCE(
	NAME text PRIMARY KEY,
	BASE_ONTOLOGY_NAME text NOT NULL,
	BASE_ONTOLOGY_IDENTIFIER text NOT NULL,
	DEFINITION text NOT NULL,
	GUIDENCE text,
	EXAMPLE text
);

















