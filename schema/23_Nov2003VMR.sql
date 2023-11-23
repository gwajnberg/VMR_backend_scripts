--
-- PostgreSQL database dump
--

-- Dumped from database version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)
-- Dumped by pg_dump version 14.9 (Ubuntu 14.9-0ubuntu0.22.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amr_antibiotics_profile; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_antibiotics_profile (
    id integer NOT NULL,
    isolate_id integer,
    antimicrobial_agent character varying(50),
    resistance_phenotype character varying(150),
    measurement real,
    measurement_units character varying(150),
    measurement_sign character varying(150),
    laboratory_typing_method character varying(150),
    laboratory_typing_platform character varying(150),
    laboratory_typing_platform_version character varying(150),
    vendor_name character varying(150),
    testing_standard character varying(150),
    testing_standard_version character varying(150),
    testing_standard_details character varying(150),
    testing_susceptible_breakpoint real,
    testing_intermediate_breakpoint real,
    testing_resistance_breakpoint real
);


ALTER TABLE public.amr_antibiotics_profile OWNER TO gabriel;

--
-- Name: amr_antibiotics_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.amr_antibiotics_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.amr_antibiotics_profile_id_seq OWNER TO gabriel;

--
-- Name: amr_antibiotics_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.amr_antibiotics_profile_id_seq OWNED BY public.amr_antibiotics_profile.id;


--
-- Name: amr_genes_drugs; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_genes_drugs (
    amr_genes_id integer NOT NULL,
    drug_id integer NOT NULL
);


ALTER TABLE public.amr_genes_drugs OWNER TO gabriel;

--
-- Name: amr_genes_family; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_genes_family (
    amr_genes_id integer NOT NULL,
    amr_gene_family_id integer NOT NULL
);


ALTER TABLE public.amr_genes_family OWNER TO gabriel;

--
-- Name: amr_genes_profile; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_genes_profile (
    id integer NOT NULL,
    isolate_id integer,
    cut_off character varying(50),
    best_hit_aro character varying(150),
    model_type character varying(150)
);


ALTER TABLE public.amr_genes_profile OWNER TO gabriel;

--
-- Name: amr_genes_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.amr_genes_profile_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.amr_genes_profile_id_seq OWNER TO gabriel;

--
-- Name: amr_genes_profile_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.amr_genes_profile_id_seq OWNED BY public.amr_genes_profile.id;


--
-- Name: amr_genes_resistance_mechanism; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_genes_resistance_mechanism (
    amr_genes_id integer NOT NULL,
    resistance_mechanism_id integer NOT NULL
);


ALTER TABLE public.amr_genes_resistance_mechanism OWNER TO gabriel;

--
-- Name: amr_info; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_info (
    id integer NOT NULL,
    isolate_id integer,
    amr_testing_by character varying(150),
    amr_testing_by_laboratory_name character varying(150),
    amr_testing_by_contact_name character varying(150),
    amr_testing_by_contact_email character varying(150),
    amr_testing_date date
);


ALTER TABLE public.amr_info OWNER TO gabriel;

--
-- Name: amr_info_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.amr_info_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.amr_info_id_seq OWNER TO gabriel;

--
-- Name: amr_info_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.amr_info_id_seq OWNED BY public.amr_info.id;


--
-- Name: amr_mob_suite; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_mob_suite (
    id integer NOT NULL,
    amr_genes_id integer,
    molecule_type character varying(150),
    primary_cluster_id character varying(150),
    secondary_cluster_id character varying(150)
);


ALTER TABLE public.amr_mob_suite OWNER TO gabriel;

--
-- Name: amr_mob_suite_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.amr_mob_suite_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.amr_mob_suite_id_seq OWNER TO gabriel;

--
-- Name: amr_mob_suite_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.amr_mob_suite_id_seq OWNED BY public.amr_mob_suite.id;


--
-- Name: amr_mpf_type; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_mpf_type (
    amr_genes_id integer NOT NULL,
    mpf_type character varying(150) NOT NULL
);


ALTER TABLE public.amr_mpf_type OWNER TO gabriel;

--
-- Name: amr_orit_type; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_orit_type (
    amr_genes_id integer NOT NULL,
    orit_type character varying(150) NOT NULL
);


ALTER TABLE public.amr_orit_type OWNER TO gabriel;

--
-- Name: amr_predicted_mobility; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_predicted_mobility (
    amr_genes_id integer NOT NULL,
    predicted_mobility character varying(150) NOT NULL
);


ALTER TABLE public.amr_predicted_mobility OWNER TO gabriel;

--
-- Name: amr_ref_type; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_ref_type (
    amr_genes_id integer NOT NULL,
    rep_type character varying(150) NOT NULL
);


ALTER TABLE public.amr_ref_type OWNER TO gabriel;

--
-- Name: amr_relaxase_type; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.amr_relaxase_type (
    amr_genes_id integer NOT NULL,
    relaxase_type character varying(150) NOT NULL
);


ALTER TABLE public.amr_relaxase_type OWNER TO gabriel;

--
-- Name: hosts; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.hosts (
    id integer NOT NULL,
    sample_collector_sample_id integer,
    host_common_name character varying(150),
    host_scientific_name character varying(150),
    host_ecotype character varying(150),
    host_breed character varying(150),
    host_food_production_name character varying(150),
    host_age_bin character varying(150),
    host_disease character varying(150)
);


ALTER TABLE public.hosts OWNER TO gabriel;

--
-- Name: hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.hosts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.hosts_id_seq OWNER TO gabriel;

--
-- Name: hosts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.hosts_id_seq OWNED BY public.hosts.id;


--
-- Name: isolates; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.isolates (
    id integer NOT NULL,
    sample_collector_sample_id integer,
    microbiological_method character varying(150),
    strain character varying(150),
    isolate_id character varying(150),
    alternative_isolate_id character varying(150),
    progeny_isolate_id character varying(150),
    irida_isolate_id character varying(150),
    irida_project_id character varying(150),
    isolated_by character varying(150),
    isolated_by_laboratory_name character varying(150),
    isolated_by_contact_name character varying(150),
    isolated_by_contact_email character varying(150),
    isolation_date date,
    isolate_received_date date,
    organism character varying(150),
    taxonomic_identification_process character varying(150),
    taxonomic_identification_process_details character varying(150),
    serovar character varying(150),
    serotyping_method character varying(150),
    phagetype character varying(150)
);


ALTER TABLE public.isolates OWNER TO gabriel;

--
-- Name: isolates_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.isolates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.isolates_id_seq OWNER TO gabriel;

--
-- Name: isolates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.isolates_id_seq OWNED BY public.isolates.id;


--
-- Name: repository; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.repository (
    id integer NOT NULL,
    isolate_id integer,
    sequence_submitted_by character varying(150),
    sequence_submitted_by_contact_name character varying(150),
    sequence_submitted_by_contact_email character varying(150),
    publication_id character varying(150),
    attribute_package character varying(150),
    bioproject_accession character varying(150),
    biosample_accession character varying(150),
    sra_accession character varying(150),
    genbank_accession character varying(150)
);


ALTER TABLE public.repository OWNER TO gabriel;

--
-- Name: repository_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.repository_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.repository_id_seq OWNER TO gabriel;

--
-- Name: repository_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.repository_id_seq OWNED BY public.repository.id;


--
-- Name: risk_assessment; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.risk_assessment (
    id integer NOT NULL,
    isolate_id integer,
    sequence_id character varying(150),
    prevalence_metrics character varying(150),
    prevalence_metrics_details character varying(150),
    stage_of_production character varying(150),
    experimental_intervention character varying(150),
    experimental_intervention_details character varying(150)
);


ALTER TABLE public.risk_assessment OWNER TO gabriel;

--
-- Name: risk_assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.risk_assessment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.risk_assessment_id_seq OWNER TO gabriel;

--
-- Name: risk_assessment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.risk_assessment_id_seq OWNED BY public.risk_assessment.id;


--
-- Name: samples; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.samples (
    id integer NOT NULL,
    sample_collector_sample_id character varying(150),
    alternative_sample_id character varying(150),
    sample_collected_by character varying(150),
    sample_collected_by_laboratory_name character varying(150),
    sample_collection_project_name_ character varying(150),
    sample_plan_name character varying(150),
    sample_plan_id character varying(150),
    sample_collector_contact_name character varying(150),
    sample_collector_contact_email character varying(150),
    purpose_of_sampling character varying(150),
    presampling_activity character varying(150),
    presampling_activity_details character varying(150),
    specimen_processing character varying(150),
    geo_loc_name_country character varying(150),
    geo_loc_name_state_province_region character varying(150),
    geo_loc_name_site character varying(150),
    food_product_origin_geo_loc_country character varying(150),
    host_origin_geo_loc_country character varying(150),
    geo_loc_latitude character varying(150),
    geo_loc_longitude character varying(150),
    sample_collection_date date,
    sample_collection_date_precision character varying(150),
    sample_received_date date,
    original_sample_description character varying(150),
    environmental_site character varying(150),
    water_depth character varying(150),
    sediment_depth character varying(150),
    air_temperature character varying(150),
    water_temperature character varying(150),
    weather_type character varying(150),
    available_data_types character varying(150),
    animal_or_plant_population character varying(150),
    environmental_material character varying(150),
    anatomical_material character varying(150),
    body_product character varying(150),
    anatomical_part character varying(150),
    anatomical_region character varying(150),
    food_product character varying(150),
    food_product_properties character varying(150),
    animal_source_of_food character varying(150),
    food_product_production_stream character varying(150),
    sample_storage_method character varying(150),
    sample_storage_medium character varying(150),
    collection_device character varying(150),
    collection_method character varying(150),
    food_packaging character varying(150),
    food_quality_date date,
    food_packaging_date date
);


ALTER TABLE public.samples OWNER TO gabriel;

--
-- Name: samples_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.samples_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.samples_id_seq OWNER TO gabriel;

--
-- Name: samples_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.samples_id_seq OWNED BY public.samples.id;


--
-- Name: sequence; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.sequence (
    id integer NOT NULL,
    isolate_id integer,
    library_id character varying(150),
    sequenced_by character varying(150),
    sequenced_by_laboratory_name character varying(150),
    sequenced_by_contact_name character varying(150),
    sequenced_by_contact_email character varying(150),
    purpose_of_sequencing character varying(150),
    sequencing_project_name character varying(150),
    sequencing_platform character varying(150),
    sequencing_instrument character varying(150),
    library_preparation_kit character varying(150),
    sequencing_protocol character varying(150),
    r1_fastq_filename character varying(150),
    r2_fastq_filename character varying(150),
    fast5_filename character varying(150),
    assembly_filename character varying(150)
);


ALTER TABLE public.sequence OWNER TO gabriel;

--
-- Name: sequence_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.sequence_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.sequence_id_seq OWNER TO gabriel;

--
-- Name: sequence_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.sequence_id_seq OWNED BY public.sequence.id;


--
-- Name: term_list; Type: TABLE; Schema: public; Owner: gabriel
--

CREATE TABLE public.term_list (
    id integer NOT NULL,
    term character varying(150),
    term_id character varying(50)
);


ALTER TABLE public.term_list OWNER TO gabriel;

--
-- Name: term_list_id_seq; Type: SEQUENCE; Schema: public; Owner: gabriel
--

CREATE SEQUENCE public.term_list_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.term_list_id_seq OWNER TO gabriel;

--
-- Name: term_list_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: gabriel
--

ALTER SEQUENCE public.term_list_id_seq OWNED BY public.term_list.id;


--
-- Name: amr_antibiotics_profile id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile ALTER COLUMN id SET DEFAULT nextval('public.amr_antibiotics_profile_id_seq'::regclass);


--
-- Name: amr_genes_profile id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_profile ALTER COLUMN id SET DEFAULT nextval('public.amr_genes_profile_id_seq'::regclass);


--
-- Name: amr_info id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_info ALTER COLUMN id SET DEFAULT nextval('public.amr_info_id_seq'::regclass);


--
-- Name: amr_mob_suite id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_mob_suite ALTER COLUMN id SET DEFAULT nextval('public.amr_mob_suite_id_seq'::regclass);


--
-- Name: hosts id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts ALTER COLUMN id SET DEFAULT nextval('public.hosts_id_seq'::regclass);


--
-- Name: isolates id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.isolates ALTER COLUMN id SET DEFAULT nextval('public.isolates_id_seq'::regclass);


--
-- Name: repository id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.repository ALTER COLUMN id SET DEFAULT nextval('public.repository_id_seq'::regclass);


--
-- Name: risk_assessment id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.risk_assessment ALTER COLUMN id SET DEFAULT nextval('public.risk_assessment_id_seq'::regclass);


--
-- Name: samples id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples ALTER COLUMN id SET DEFAULT nextval('public.samples_id_seq'::regclass);


--
-- Name: sequence id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence ALTER COLUMN id SET DEFAULT nextval('public.sequence_id_seq'::regclass);


--
-- Name: term_list id; Type: DEFAULT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.term_list ALTER COLUMN id SET DEFAULT nextval('public.term_list_id_seq'::regclass);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_pkey PRIMARY KEY (id);


--
-- Name: amr_genes_drugs amr_genes_drugs_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_drugs
    ADD CONSTRAINT amr_genes_drugs_pkey PRIMARY KEY (amr_genes_id, drug_id);


--
-- Name: amr_genes_family amr_genes_family_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_family
    ADD CONSTRAINT amr_genes_family_pkey PRIMARY KEY (amr_genes_id, amr_gene_family_id);


--
-- Name: amr_genes_profile amr_genes_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_profile
    ADD CONSTRAINT amr_genes_profile_pkey PRIMARY KEY (id);


--
-- Name: amr_genes_resistance_mechanism amr_genes_resistance_mechanism_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_resistance_mechanism
    ADD CONSTRAINT amr_genes_resistance_mechanism_pkey PRIMARY KEY (amr_genes_id, resistance_mechanism_id);


--
-- Name: amr_info amr_info_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_info
    ADD CONSTRAINT amr_info_pkey PRIMARY KEY (id);


--
-- Name: amr_mob_suite amr_mob_suite_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_mob_suite
    ADD CONSTRAINT amr_mob_suite_pkey PRIMARY KEY (id);


--
-- Name: amr_mpf_type amr_mpf_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_mpf_type
    ADD CONSTRAINT amr_mpf_type_pkey PRIMARY KEY (amr_genes_id, mpf_type);


--
-- Name: amr_orit_type amr_orit_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_orit_type
    ADD CONSTRAINT amr_orit_type_pkey PRIMARY KEY (amr_genes_id, orit_type);


--
-- Name: amr_predicted_mobility amr_predicted_mobility_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_predicted_mobility
    ADD CONSTRAINT amr_predicted_mobility_pkey PRIMARY KEY (amr_genes_id, predicted_mobility);


--
-- Name: amr_ref_type amr_ref_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_ref_type
    ADD CONSTRAINT amr_ref_type_pkey PRIMARY KEY (amr_genes_id, rep_type);


--
-- Name: amr_relaxase_type amr_relaxase_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_relaxase_type
    ADD CONSTRAINT amr_relaxase_type_pkey PRIMARY KEY (amr_genes_id, relaxase_type);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: isolates isolates_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_pkey PRIMARY KEY (id);


--
-- Name: repository repository_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT repository_pkey PRIMARY KEY (id);


--
-- Name: risk_assessment risk_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_assessment_pkey PRIMARY KEY (id);


--
-- Name: samples samples_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- Name: sequence sequence_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequence_pkey PRIMARY KEY (id);


--
-- Name: term_list term_list_pkey; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.term_list
    ADD CONSTRAINT term_list_pkey PRIMARY KEY (id);


--
-- Name: term_list term_list_term_key; Type: CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.term_list
    ADD CONSTRAINT term_list_term_key UNIQUE (term);


--
-- Name: amr_antibiotics_profile amr_antibiotics_antibiotics_list; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_antibiotics_list FOREIGN KEY (antimicrobial_agent) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile amr_antibiotics_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_genes_drugs amr_genes_drugs_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_drugs
    ADD CONSTRAINT amr_genes_drugs_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_genes_drugs amr_genes_drugs_drug_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_drugs
    ADD CONSTRAINT amr_genes_drugs_drug_id_fkey FOREIGN KEY (drug_id) REFERENCES public.term_list(id);


--
-- Name: amr_genes_family amr_genes_family_amr_gene_family_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_family
    ADD CONSTRAINT amr_genes_family_amr_gene_family_id_fkey FOREIGN KEY (amr_gene_family_id) REFERENCES public.term_list(id);


--
-- Name: amr_genes_family amr_genes_family_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_family
    ADD CONSTRAINT amr_genes_family_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_genes_profile amr_genes_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_profile
    ADD CONSTRAINT amr_genes_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_genes_resistance_mechanism amr_genes_resistance_mechanism_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_resistance_mechanism
    ADD CONSTRAINT amr_genes_resistance_mechanism_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_genes_resistance_mechanism amr_genes_resistance_mechanism_resistance_mechanism_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_resistance_mechanism
    ADD CONSTRAINT amr_genes_resistance_mechanism_resistance_mechanism_id_fkey FOREIGN KEY (resistance_mechanism_id) REFERENCES public.term_list(id);


--
-- Name: amr_info amr_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_info
    ADD CONSTRAINT amr_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_mob_suite amr_mob_suite_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_mob_suite
    ADD CONSTRAINT amr_mob_suite_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_mpf_type amr_mpf_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_mpf_type
    ADD CONSTRAINT amr_mpf_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_orit_type amr_orit_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_orit_type
    ADD CONSTRAINT amr_orit_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_predicted_mobility amr_predicted_mobility_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_predicted_mobility
    ADD CONSTRAINT amr_predicted_mobility_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_ref_type amr_ref_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_ref_type
    ADD CONSTRAINT amr_ref_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_relaxase_type amr_relaxase_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_relaxase_type
    ADD CONSTRAINT amr_relaxase_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES public.amr_genes_profile(id);


--
-- Name: amr_info amr_testing_by_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_info
    ADD CONSTRAINT amr_testing_by_term FOREIGN KEY (amr_testing_by) REFERENCES public.term_list(term);


--
-- Name: samples anatomical_material_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT anatomical_material_term FOREIGN KEY (anatomical_material) REFERENCES public.term_list(term);


--
-- Name: samples anatomical_part_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT anatomical_part_term FOREIGN KEY (anatomical_part) REFERENCES public.term_list(term);


--
-- Name: samples anatomical_region_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT anatomical_region_term FOREIGN KEY (anatomical_region) REFERENCES public.term_list(term);


--
-- Name: samples animal_or_plant_population_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT animal_or_plant_population_term FOREIGN KEY (animal_or_plant_population) REFERENCES public.term_list(term);


--
-- Name: samples animal_source_of_food_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT animal_source_of_food_term FOREIGN KEY (animal_source_of_food) REFERENCES public.term_list(term);


--
-- Name: repository attribute_package_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT attribute_package_term FOREIGN KEY (attribute_package) REFERENCES public.term_list(term);


--
-- Name: samples available_data_types_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT available_data_types_term FOREIGN KEY (available_data_types) REFERENCES public.term_list(term);


--
-- Name: amr_genes_profile best_hit_aro_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_genes_profile
    ADD CONSTRAINT best_hit_aro_term FOREIGN KEY (best_hit_aro) REFERENCES public.term_list(term);


--
-- Name: samples body_product_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT body_product_term FOREIGN KEY (body_product) REFERENCES public.term_list(term);


--
-- Name: samples collection_device_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT collection_device_term FOREIGN KEY (collection_device) REFERENCES public.term_list(term);


--
-- Name: samples collection_method_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT collection_method_term FOREIGN KEY (collection_method) REFERENCES public.term_list(term);


--
-- Name: samples environmental_material_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT environmental_material_term FOREIGN KEY (environmental_material) REFERENCES public.term_list(term);


--
-- Name: samples environmental_site_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT environmental_site_term FOREIGN KEY (environmental_site) REFERENCES public.term_list(term);


--
-- Name: risk_assessment experimental_intervention_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT experimental_intervention_term FOREIGN KEY (experimental_intervention) REFERENCES public.term_list(term);


--
-- Name: samples food_packaging_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT food_packaging_term FOREIGN KEY (food_packaging) REFERENCES public.term_list(term);


--
-- Name: samples food_product_production_stream_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT food_product_production_stream_term FOREIGN KEY (food_product_production_stream) REFERENCES public.term_list(term);


--
-- Name: samples food_product_properties_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT food_product_properties_term FOREIGN KEY (food_product_properties) REFERENCES public.term_list(term);


--
-- Name: samples food_product_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT food_product_term FOREIGN KEY (food_product) REFERENCES public.term_list(term);


--
-- Name: samples geo_loc_name_country_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT geo_loc_name_country_term FOREIGN KEY (geo_loc_name_country) REFERENCES public.term_list(term);


--
-- Name: samples geo_loc_name_state_province_region_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT geo_loc_name_state_province_region_term FOREIGN KEY (geo_loc_name_state_province_region) REFERENCES public.term_list(term);


--
-- Name: hosts host_common_name_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT host_common_name_term FOREIGN KEY (host_common_name) REFERENCES public.term_list(term);


--
-- Name: hosts host_food_production_name_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT host_food_production_name_term FOREIGN KEY (host_food_production_name) REFERENCES public.term_list(term);


--
-- Name: hosts host_sample; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT host_sample FOREIGN KEY (sample_collector_sample_id) REFERENCES public.samples(id);


--
-- Name: hosts host_scientific_name_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT host_scientific_name_term FOREIGN KEY (host_scientific_name) REFERENCES public.term_list(term);


--
-- Name: isolates isolate_sample; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolate_sample FOREIGN KEY (sample_collector_sample_id) REFERENCES public.samples(id);


--
-- Name: isolates isolated_by_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolated_by_term FOREIGN KEY (isolated_by) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile laboratory_typing_method_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT laboratory_typing_method_term FOREIGN KEY (laboratory_typing_method) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile laboratory_typing_platform_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT laboratory_typing_platform_term FOREIGN KEY (laboratory_typing_platform) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile measurement_sign_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT measurement_sign_term FOREIGN KEY (measurement_sign) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile measurement_units_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT measurement_units_term FOREIGN KEY (measurement_units) REFERENCES public.term_list(term);


--
-- Name: isolates organism_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT organism_term FOREIGN KEY (organism) REFERENCES public.term_list(term);


--
-- Name: samples presampling_activity_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT presampling_activity_term FOREIGN KEY (presampling_activity) REFERENCES public.term_list(term);


--
-- Name: samples purpose_of_sampling_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT purpose_of_sampling_term FOREIGN KEY (purpose_of_sampling) REFERENCES public.term_list(term);


--
-- Name: sequence purpose_of_sequencing_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT purpose_of_sequencing_term FOREIGN KEY (purpose_of_sequencing) REFERENCES public.term_list(term);


--
-- Name: repository repository_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT repository_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_antibiotics_profile resistance_phenotype_method_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT resistance_phenotype_method_term FOREIGN KEY (resistance_phenotype) REFERENCES public.term_list(term);


--
-- Name: risk_assessment risk_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: samples sample_collected_by_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_collected_by_term FOREIGN KEY (sample_collected_by) REFERENCES public.term_list(term);


--
-- Name: samples sample_collection_date_precision_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_collection_date_precision_term FOREIGN KEY (sample_collection_date_precision) REFERENCES public.term_list(term);


--
-- Name: sequence sequence_isolate; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequence_isolate FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: repository sequence_submitted_by_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.repository
    ADD CONSTRAINT sequence_submitted_by_term FOREIGN KEY (sequence_submitted_by) REFERENCES public.term_list(term);


--
-- Name: sequence sequenced_by_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequenced_by_term FOREIGN KEY (sequenced_by) REFERENCES public.term_list(term);


--
-- Name: sequence sequencing_instrument_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequencing_instrument_term FOREIGN KEY (sequencing_instrument) REFERENCES public.term_list(term);


--
-- Name: sequence sequencing_platform_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.sequence
    ADD CONSTRAINT sequencing_platform_term FOREIGN KEY (sequencing_platform) REFERENCES public.term_list(term);


--
-- Name: samples specimen_processing_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT specimen_processing_term FOREIGN KEY (specimen_processing) REFERENCES public.term_list(term);


--
-- Name: amr_antibiotics_profile testing_standard_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT testing_standard_term FOREIGN KEY (testing_standard) REFERENCES public.term_list(term);


--
-- Name: samples weather_type_term; Type: FK CONSTRAINT; Schema: public; Owner: gabriel
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT weather_type_term FOREIGN KEY (weather_type) REFERENCES public.term_list(term);


--
-- PostgreSQL database dump complete
--

