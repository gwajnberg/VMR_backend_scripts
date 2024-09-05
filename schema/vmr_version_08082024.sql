--
-- PostgreSQL database dump
--

-- Dumped from database version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)
-- Dumped by pg_dump version 16.4 (Ubuntu 16.4-1.pgdg22.04+1)

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

--
-- Name: bioinf; Type: SCHEMA; Schema: -; Owner: gwajnberg
--

CREATE SCHEMA bioinf;


ALTER SCHEMA bioinf OWNER TO gwajnberg;

--
-- Name: ohe; Type: SCHEMA; Schema: -; Owner: gwajnberg
--

CREATE SCHEMA ohe;


ALTER SCHEMA ohe OWNER TO gwajnberg;

--
-- Name: curation_flag; Type: TYPE; Schema: public; Owner: gwajnberg
--

CREATE TYPE public.curation_flag AS ENUM (
    'approved',
    'pending',
    'proposed',
    'not approved'
);


ALTER TYPE public.curation_flag OWNER TO gwajnberg;

--
-- Name: status; Type: TYPE; Schema: public; Owner: gwajnberg
--

CREATE TYPE public.status AS ENUM (
    'curated',
    'ok',
    'flagged',
    'not curated'
);


ALTER TYPE public.status OWNER TO gwajnberg;

--
-- Name: bind_ontology(text, text); Type: FUNCTION; Schema: public; Owner: gwajnberg
--

CREATE FUNCTION public.bind_ontology(term text, ont_id text) RETURNS text
    LANGUAGE sql
    RETURN concat(term, ' [', ont_id, ']');


ALTER FUNCTION public.bind_ontology(term text, ont_id text) OWNER TO gwajnberg;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: amr_genes_drugs; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_genes_drugs (
    amr_genes_id integer NOT NULL,
    drug_id text NOT NULL
);


ALTER TABLE bioinf.amr_genes_drugs OWNER TO gwajnberg;

--
-- Name: amr_genes_families; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_genes_families (
    amr_genes_id integer NOT NULL,
    amr_gene_family_id text NOT NULL
);


ALTER TABLE bioinf.amr_genes_families OWNER TO gwajnberg;

--
-- Name: amr_genes_profiles; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_genes_profiles (
    id integer NOT NULL,
    sequencing_id integer,
    cut_off text,
    best_hit_aro text,
    model_type text
);


ALTER TABLE bioinf.amr_genes_profiles OWNER TO gwajnberg;

--
-- Name: amr_genes_profiles_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE bioinf.amr_genes_profiles ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.amr_genes_profiles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: amr_genes_resistance_mechanism; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_genes_resistance_mechanism (
    amr_genes_id integer NOT NULL,
    resistance_mechanism_id text NOT NULL
);


ALTER TABLE bioinf.amr_genes_resistance_mechanism OWNER TO gwajnberg;

--
-- Name: amr_mob_suite; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_mob_suite (
    id integer NOT NULL,
    amr_genes_id integer,
    molecule_type text,
    primary_cluster_id text,
    secondary_cluster_id text
);


ALTER TABLE bioinf.amr_mob_suite OWNER TO gwajnberg;

--
-- Name: amr_mob_suite_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE bioinf.amr_mob_suite ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.amr_mob_suite_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: amr_mpf_type; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_mpf_type (
    amr_genes_id integer NOT NULL,
    mpf_type text NOT NULL
);


ALTER TABLE bioinf.amr_mpf_type OWNER TO gwajnberg;

--
-- Name: amr_orit_types; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_orit_types (
    amr_genes_id integer NOT NULL,
    orit_type text NOT NULL
);


ALTER TABLE bioinf.amr_orit_types OWNER TO gwajnberg;

--
-- Name: amr_predicted_mobility; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_predicted_mobility (
    amr_genes_id integer NOT NULL,
    predicted_mobility text NOT NULL
);


ALTER TABLE bioinf.amr_predicted_mobility OWNER TO gwajnberg;

--
-- Name: amr_ref_type; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_ref_type (
    amr_genes_id integer NOT NULL,
    rep_type text NOT NULL
);


ALTER TABLE bioinf.amr_ref_type OWNER TO gwajnberg;

--
-- Name: amr_relaxase_type; Type: TABLE; Schema: bioinf; Owner: gwajnberg
--

CREATE TABLE bioinf.amr_relaxase_type (
    amr_genes_id integer NOT NULL,
    relaxase_type text NOT NULL
);


ALTER TABLE bioinf.amr_relaxase_type OWNER TO gwajnberg;

--
-- Name: countries; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true
);


ALTER TABLE public.countries OWNER TO gwajnberg;

--
-- Name: geo_loc; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.geo_loc (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    country integer,
    state_province_region integer,
    site integer,
    latitude numeric(8,6),
    longitude numeric(9,6)
);


ALTER TABLE public.geo_loc OWNER TO gwajnberg;

--
-- Name: state_province_regions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.state_province_regions (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    country_id integer,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true
);


ALTER TABLE public.state_province_regions OWNER TO gwajnberg;

--
-- Name: country_state; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.country_state AS
 SELECT g.sample_id,
    concat_ws(':'::text, c.en_term, states.en_term) AS geo_loc_name
   FROM ((public.geo_loc g
     LEFT JOIN public.countries c ON ((g.country = c.id)))
     LEFT JOIN public.state_province_regions states ON ((g.state_province_region = states.id)));


ALTER VIEW ohe.country_state OWNER TO gwajnberg;

--
-- Name: host_organisms; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.host_organisms (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    scientific_name text,
    en_common_name text,
    fr_common_name text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true
);


ALTER TABLE public.host_organisms OWNER TO gwajnberg;

--
-- Name: hosts; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.hosts (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    host_organism integer,
    host_ecotype text,
    host_breed integer,
    host_food_production_name integer,
    host_disease integer,
    host_age_bin integer,
    host_origin_geo_loc_name_country integer
);


ALTER TABLE public.hosts OWNER TO gwajnberg;

--
-- Name: host_organism; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.host_organism AS
 SELECT h.sample_id,
    org.ontology_id,
    org.scientific_name,
    org.en_common_name
   FROM (public.hosts h
     LEFT JOIN public.host_organisms org ON ((h.host_organism = org.id)));


ALTER VIEW ohe.host_organism OWNER TO gwajnberg;

--
-- Name: anatomical_data; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_data (
    id integer NOT NULL,
    sample_id integer,
    anatomical_region integer
);


ALTER TABLE public.anatomical_data OWNER TO gwajnberg;

--
-- Name: anatomical_data_body; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_data_body (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_body OWNER TO gwajnberg;

--
-- Name: anatomical_data_material; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_data_material (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_material OWNER TO gwajnberg;

--
-- Name: anatomical_data_part; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_data_part (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_part OWNER TO gwajnberg;

--
-- Name: ontology_terms; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.ontology_terms (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true
);


ALTER TABLE public.ontology_terms OWNER TO gwajnberg;

--
-- Name: anatomical_material_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.anatomical_material_agg AS
 SELECT a.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.anatomical_data a
     LEFT JOIN public.anatomical_data_material mat ON ((a.id = mat.id)))
     LEFT JOIN public.ontology_terms o ON ((mat.term_id = o.id)))
  GROUP BY a.sample_id;


ALTER VIEW public.anatomical_material_agg OWNER TO gwajnberg;

--
-- Name: anatomical_part_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.anatomical_part_agg AS
 SELECT a.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.anatomical_data a
     LEFT JOIN public.anatomical_data_part part ON ((a.id = part.id)))
     LEFT JOIN public.ontology_terms o ON ((part.term_id = o.id)))
  GROUP BY a.sample_id;


ALTER VIEW public.anatomical_part_agg OWNER TO gwajnberg;

--
-- Name: body_product_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.body_product_agg AS
 SELECT a.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.anatomical_data a
     LEFT JOIN public.anatomical_data_body body ON ((a.id = body.id)))
     LEFT JOIN public.ontology_terms o ON ((body.term_id = o.id)))
  GROUP BY a.sample_id;


ALTER VIEW public.body_product_agg OWNER TO gwajnberg;

--
-- Name: environmental_data; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    air_temperature double precision,
    air_temperature_units integer,
    water_temperature double precision,
    water_temperature_units integer,
    sediment_depth double precision,
    sediment_depth_units integer,
    water_depth integer,
    water_depth_units integer,
    available_data_type_details text
);


ALTER TABLE public.environmental_data OWNER TO gwajnberg;

--
-- Name: environmental_data_site; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data_site (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.environmental_data_site OWNER TO gwajnberg;

--
-- Name: environmental_site_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.environmental_site_agg AS
 SELECT env.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.environmental_data env
     LEFT JOIN public.environmental_data_site site ON ((site.id = env.id)))
     LEFT JOIN public.ontology_terms o ON ((site.term_id = o.id)))
  GROUP BY env.sample_id;


ALTER VIEW public.environmental_site_agg OWNER TO gwajnberg;

--
-- Name: food_data; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_data (
    id integer NOT NULL,
    sample_id integer,
    food_product_production_stream integer,
    food_product_origin_country integer,
    food_packaging_date date,
    food_quality_date date
);


ALTER TABLE public.food_data OWNER TO gwajnberg;

--
-- Name: food_data_product; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_data_product (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.food_data_product OWNER TO gwajnberg;

--
-- Name: food_data_product_property; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_data_product_property (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.food_data_product_property OWNER TO gwajnberg;

--
-- Name: food_product_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.food_product_agg AS
 SELECT f.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.food_data f
     LEFT JOIN public.food_data_product pro ON ((f.id = pro.id)))
     LEFT JOIN public.ontology_terms o ON ((pro.term_id = o.id)))
  GROUP BY f.sample_id;


ALTER VIEW public.food_product_agg OWNER TO gwajnberg;

--
-- Name: food_product_properties_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.food_product_properties_agg AS
 SELECT f.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.food_data f
     LEFT JOIN public.food_data_product_property pro ON ((f.id = pro.id)))
     LEFT JOIN public.ontology_terms o ON ((pro.term_id = o.id)))
  GROUP BY f.sample_id;


ALTER VIEW public.food_product_properties_agg OWNER TO gwajnberg;

--
-- Name: samples; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.samples (
    id integer NOT NULL,
    project_id integer,
    sample_collector_sample_id text NOT NULL,
    validation_status public.status
);


ALTER TABLE public.samples OWNER TO gwajnberg;

--
-- Name: isolation_source; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.isolation_source AS
 SELECT sample_id,
    string_agg(terms, '; '::text) AS isolation_source
   FROM ( SELECT org.sample_id,
            public.bind_ontology(org.scientific_name, org.ontology_id) AS terms
           FROM (public.samples
             LEFT JOIN ohe.host_organism org ON ((samples.id = org.sample_id)))
        UNION
         SELECT environmental_site_agg.sample_id,
            environmental_site_agg.terms
           FROM public.environmental_site_agg
        UNION
         SELECT anatomical_material_agg.sample_id,
            anatomical_material_agg.terms
           FROM public.anatomical_material_agg
        UNION
         SELECT body_product_agg.sample_id,
            body_product_agg.terms
           FROM public.body_product_agg
        UNION
         SELECT anatomical_part_agg.sample_id,
            anatomical_part_agg.terms
           FROM public.anatomical_part_agg
        UNION
         SELECT food_product_agg.sample_id,
            food_product_agg.terms
           FROM public.food_product_agg
        UNION
         SELECT food_product_properties_agg.sample_id,
            food_product_properties_agg.terms
           FROM public.food_product_properties_agg) unnamed_subquery
  WHERE (terms !~~ 'Not %'::text)
  GROUP BY sample_id;


ALTER VIEW ohe.isolation_source OWNER TO gwajnberg;

--
-- Name: source_type; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.source_type AS
 SELECT h.sample_id,
        CASE
            WHEN (h.scientific_name = 'Homo sapiens'::text) THEN 'Human'::text
            WHEN (f.terms IS NOT NULL) THEN 'Food'::text
            WHEN (h.scientific_name <> 'Homo sapiens'::text) THEN 'Animal'::text
            ELSE 'Environmental'::text
        END AS source_type
   FROM (ohe.host_organism h
     LEFT JOIN public.food_product_agg f ON (((h.sample_id = f.sample_id) AND (f.terms !~~ 'Not %'::text))));


ALTER VIEW ohe.source_type OWNER TO gwajnberg;

--
-- Name: extractions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.extractions (
    id integer NOT NULL,
    experimental_protocol_field text,
    experimental_specimen_role_type integer,
    nucleic_acid_extraction_method text,
    nucleic_acid_extraction_kit text,
    sample_volume_measurement_value double precision,
    sample_volume_measurement_unit integer,
    residual_sample_status integer,
    sample_storage_duration_value double precision,
    sample_storage_duration_unit integer,
    nucleic_acid_storage_duration_value double precision,
    nucleic_acid_storage_duration_unit integer
);


ALTER TABLE public.extractions OWNER TO gwajnberg;

--
-- Name: isolates; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.isolates (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    isolate_id text NOT NULL,
    organism integer,
    strain integer,
    microbiological_method text,
    progeny_isolate_id text,
    isolated_by integer,
    contact_information integer,
    isolation_date date,
    isolate_received_date date,
    taxonomic_identification_process integer,
    taxonomic_identification_process_details text,
    serovar text,
    serotyping_method text,
    phagetype text
);


ALTER TABLE public.isolates OWNER TO gwajnberg;

--
-- Name: public_repository_information; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.public_repository_information (
    id integer NOT NULL,
    sequencing_id integer,
    contact_information integer,
    sequence_submitted_by integer,
    publication_id text,
    bioproject_accession text,
    biosample_accession text,
    sra_accession text,
    genbank_accession text,
    attribute_package integer
);


ALTER TABLE public.public_repository_information OWNER TO gwajnberg;

--
-- Name: sequencing; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequencing (
    id integer NOT NULL,
    extraction_id integer,
    library_id text,
    contact_information integer,
    sequenced_by integer,
    sequencing_project_name text,
    sequencing_platform integer,
    sequencing_instrument integer,
    sequencing_assay_type integer,
    dna_fragment_length integer,
    genomic_target_enrichment_method integer,
    genomic_target_enrichment_method_details text,
    amplicon_pcr_primer_scheme text,
    amplicon_size text,
    sequencing_flow_cell_version text,
    library_preparation_kit text,
    sequencing_protocol text,
    irida_isolate_id text,
    irida_project_id text,
    r1_fastq_filename text,
    r2_fastq_filename text,
    fast5_filename text,
    assembly_filename text
);


ALTER TABLE public.sequencing OWNER TO gwajnberg;

--
-- Name: wgs_extractions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.wgs_extractions (
    isolate_id integer NOT NULL,
    extraction_id integer NOT NULL
);


ALTER TABLE public.wgs_extractions OWNER TO gwajnberg;

--
-- Name: wgs; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.wgs AS
 SELECT wgs.isolate_id,
    ext.id AS extraction_id,
    seq.id AS sequencing_id,
    seq.library_id,
    ext.experimental_protocol_field,
    ext.experimental_specimen_role_type,
    ext.nucleic_acid_extraction_method,
    ext.nucleic_acid_extraction_kit,
    ext.sample_volume_measurement_value,
    ext.sample_volume_measurement_unit,
    ext.residual_sample_status,
    ext.sample_storage_duration_value,
    ext.sample_storage_duration_unit,
    ext.nucleic_acid_storage_duration_value,
    ext.nucleic_acid_storage_duration_unit,
    seq.contact_information,
    seq.sequenced_by,
    seq.sequencing_project_name,
    seq.sequencing_platform,
    seq.sequencing_instrument,
    seq.sequencing_assay_type,
    seq.dna_fragment_length,
    seq.genomic_target_enrichment_method,
    seq.genomic_target_enrichment_method_details,
    seq.amplicon_pcr_primer_scheme,
    seq.amplicon_size,
    seq.sequencing_flow_cell_version,
    seq.library_preparation_kit,
    seq.sequencing_protocol,
    seq.irida_isolate_id,
    seq.irida_project_id,
    seq.r1_fastq_filename,
    seq.r2_fastq_filename,
    seq.fast5_filename,
    seq.assembly_filename
   FROM ((public.wgs_extractions wgs
     LEFT JOIN public.extractions ext ON ((wgs.extraction_id = ext.id)))
     LEFT JOIN public.sequencing seq ON ((ext.id = seq.extraction_id)));


ALTER VIEW public.wgs OWNER TO gwajnberg;

--
-- Name: wgs_by_isolate; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.wgs_by_isolate AS
 WITH wgs_w_project AS (
         SELECT i.id AS isolate_id,
            wgs.sequencing_id,
                CASE
                    WHEN (wgs.sequenced_by IS NOT NULL) THEN public.bind_ontology(seq_by.en_term, seq_by.ontology_id)
                    ELSE NULL::text
                END AS sequenced_by,
            p.bioproject_accession
           FROM (((public.isolates i
             LEFT JOIN public.wgs ON ((wgs.isolate_id = i.id)))
             LEFT JOIN public.public_repository_information p ON ((wgs.sequencing_id = p.sequencing_id)))
             LEFT JOIN public.ontology_terms seq_by ON ((wgs.sequenced_by = seq_by.id)))
        )
 SELECT isolate_id,
    string_agg(
        CASE
            WHEN (seqnum_acc = 1) THEN bioproject_accession
            ELSE NULL::text
        END, '; '::text) AS bioproject_accession,
    string_agg(
        CASE
            WHEN (seqnum_sby = 1) THEN sequenced_by
            ELSE NULL::text
        END, '; '::text) AS sequenced_by
   FROM ( SELECT wgs_w_project.isolate_id,
            wgs_w_project.sequencing_id,
            wgs_w_project.sequenced_by,
            wgs_w_project.bioproject_accession,
            row_number() OVER (PARTITION BY wgs_w_project.isolate_id, wgs_w_project.bioproject_accession) AS seqnum_acc,
            row_number() OVER (PARTITION BY wgs_w_project.isolate_id, wgs_w_project.sequenced_by) AS seqnum_sby
           FROM wgs_w_project) unnamed_subquery
  GROUP BY isolate_id;


ALTER VIEW ohe.wgs_by_isolate OWNER TO gwajnberg;

--
-- Name: collection_information; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.collection_information (
    id integer NOT NULL,
    sample_id integer,
    sample_collected_by integer,
    contact_information integer,
    sample_collection_date date,
    sample_collection_date_precision integer,
    presampling_activity_details text,
    sample_received_date date,
    original_sample_description text,
    specimen_processing integer,
    sample_storage_method text,
    sample_storage_medium text,
    collection_device integer,
    collection_method integer
);


ALTER TABLE public.collection_information OWNER TO gwajnberg;

--
-- Name: microbes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.microbes (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    scientific_name text,
    curated boolean DEFAULT true
);


ALTER TABLE public.microbes OWNER TO gwajnberg;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    sample_plan_id text,
    sample_plan_name text,
    project_name text,
    description text
);


ALTER TABLE public.projects OWNER TO gwajnberg;

--
-- Name: sample_purposes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sample_purposes (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.sample_purposes OWNER TO gwajnberg;

--
-- Name: sample_purposes_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.sample_purposes_agg AS
 SELECT ci.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.collection_information ci
     LEFT JOIN public.sample_purposes sp ON ((ci.id = sp.id)))
     LEFT JOIN public.ontology_terms o ON ((sp.term_id = o.id)))
  GROUP BY ci.sample_id;


ALTER VIEW public.sample_purposes_agg OWNER TO gwajnberg;

--
-- Name: collection_information_fields; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.collection_information_fields AS
 SELECT i.id AS isolate_id,
    s.id AS sample_id,
    microbes.scientific_name AS organism,
    public.bind_ontology(agencies.en_term, agencies.ontology_id) AS collected_by,
    c.sample_collection_date AS collection_date,
    i.isolation_date AS cult_isol_date,
    country.geo_loc_name,
    source.isolation_source,
    src_type.source_type,
    public.bind_ontology(col_device.en_term, col_device.ontology_id) AS samp_collect_device,
    sp.terms AS purpose_of_sampling,
    projects.project_name,
    concat_ws(' | '::text, geo_loc.latitude, geo_loc.longitude) AS lat_lon,
    i.serovar,
    seq.sequenced_by
   FROM ((((((((((((public.isolates i
     LEFT JOIN public.samples s ON ((i.sample_id = s.id)))
     LEFT JOIN public.microbes ON ((i.organism = microbes.id)))
     LEFT JOIN public.collection_information c ON ((s.id = c.sample_id)))
     LEFT JOIN public.ontology_terms agencies ON ((c.sample_collected_by = agencies.id)))
     LEFT JOIN ohe.country_state country ON ((s.id = country.sample_id)))
     LEFT JOIN public.projects ON ((s.project_id = projects.id)))
     LEFT JOIN public.geo_loc ON ((s.id = geo_loc.sample_id)))
     LEFT JOIN public.sample_purposes_agg sp ON ((s.id = sp.sample_id)))
     LEFT JOIN ohe.wgs_by_isolate seq ON ((i.id = seq.isolate_id)))
     LEFT JOIN ohe.source_type src_type ON ((s.id = src_type.sample_id)))
     LEFT JOIN public.ontology_terms col_device ON ((c.collection_device = col_device.id)))
     LEFT JOIN ohe.isolation_source source ON ((s.id = source.sample_id)));


ALTER VIEW ohe.collection_information_fields OWNER TO gwajnberg;

--
-- Name: fac_type_and_local_scale; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.fac_type_and_local_scale AS
 SELECT env.sample_id,
    string_agg(
        CASE
            WHEN (o.ontology_id = ANY (ARRAY['ENVO:01000925'::text, 'ENVO:00003862'::text, 'ENVO:01001448'::text, 'ENVO:00002221'::text, 'ENVO:03501396'::text, 'ENVO:01000984'::text, 'ENVO:0350142'::text])) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS facility_type,
    string_agg(
        CASE
            WHEN (o.ontology_id = ANY (ARRAY['ENVO:00000114'::text, 'ENVO:00000314'::text, 'ENVO:03501406'::text, 'ENVO:03501441'::text, 'ENVO:03501405'::text, 'ENVO:00000078'::text, 'ENVO:03501443'::text, 'ENVO:03501384'::text, 'ENVO:03501416'::text, 'ENVO:01000627'::text, 'ENVO:03501444'::text, 'ENVO:00000294'::text, 'ENVO:03501417'::text, 'ENVO:01000306'::text, 'ENVO:01001873'::text, 'ENVO:01001874'::text, 'ENVO:00000020'::text, 'ENVO:03501423'::text, 'ENVO:01001872'::text, 'ENVO:01000320'::text, 'ENVO:03501440'::text, 'ENVO:00000208'::text, 'ENVO:00000562'::text, 'ENVO:00000033'::text, 'ENVO:00000025'::text, 'ENVO:00000450'::text, 'ENVO:00000022'::text, 'ENVO:03501439'::text, 'ENVO:01000772'::text, 'ENVO:03501438'::text, 'ENVO:00000023'::text, 'ENVO:00000495'::text, 'ENVO:01001191'::text, 'ENVO:00000109'::text])) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS env_local_scale
   FROM ((public.environmental_data env
     LEFT JOIN public.environmental_data_site e ON ((env.id = e.id)))
     LEFT JOIN public.ontology_terms o ON ((e.term_id = o.id)))
  GROUP BY env.sample_id;


ALTER VIEW ohe.fac_type_and_local_scale OWNER TO gwajnberg;

--
-- Name: sample_activity; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sample_activity (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.sample_activity OWNER TO gwajnberg;

--
-- Name: fertilizer_admin; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.fertilizer_admin AS
 SELECT c.sample_id,
    c.presampling_activity_details AS fertilizer_admin
   FROM (public.sample_activity sa
     LEFT JOIN public.collection_information c ON ((c.id = sa.id)))
  WHERE (sa.term_id = ( SELECT ontology_terms.id
           FROM public.ontology_terms
          WHERE (ontology_terms.ontology_id = 'GENEPIO:0100543'::text)));


ALTER VIEW ohe.fertilizer_admin OWNER TO gwajnberg;

--
-- Name: environmental_data_material; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data_material (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.environmental_data_material OWNER TO gwajnberg;

--
-- Name: geo_feat_and_medium; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.geo_feat_and_medium AS
 WITH vals(ont) AS (
         VALUES ('AGRO:00000671'::text), ('GENEPIO:0100896'::text), ('AGRO:00000673'::text), ('GENEPIO:0100897'::text), ('AGRO:00000674'::text), ('ENVO:03501379'::text), ('AGRO:00000675'::text), ('AGRO:00000679'::text), ('AGRO:00000680'::text), ('AGRO:00000676'::text), ('AGRO:00000677'::text), ('NCIT:C49844'::text), ('GSSO:012935'::text), ('OBI:0002806'::text), ('ENVO:03501431'::text), ('ENVO:03501379'::text), ('AGRO:00000678'::text), ('AGRO:00000672'::text), ('ENVO:03501430'::text), ('ENVO:03501400'::text), ('AGRO:00000670'::text), ('NCIT:C49947'::text), ('ENVO:03501415'::text), ('ENVO:03501414'::text), ('AGRO:00000669'::text)
        )
 SELECT env.sample_id,
    string_agg(
        CASE
            WHEN (o.ontology_id IN ( SELECT vals.ont
               FROM vals)) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS coll_site_geo_feat,
    string_agg(
        CASE
            WHEN (NOT (o.ontology_id IN ( SELECT vals.ont
               FROM vals))) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS env_medium
   FROM ((public.environmental_data env
     LEFT JOIN public.environmental_data_material e ON ((env.id = e.id)))
     LEFT JOIN public.ontology_terms o ON ((e.term_id = o.id)))
  GROUP BY env.sample_id;


ALTER VIEW ohe.geo_feat_and_medium OWNER TO gwajnberg;

--
-- Name: environmental_fields; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.environmental_fields AS
 SELECT i.id AS isolate_id,
    s.id AS sample_id,
    fac.facility_type,
    feat.coll_site_geo_feat,
    fac.env_local_scale,
    feat.env_medium,
    fert.fertilizer_admin
   FROM ((((public.isolates i
     LEFT JOIN public.samples s ON ((i.sample_id = s.id)))
     LEFT JOIN ohe.fac_type_and_local_scale fac ON ((s.id = fac.sample_id)))
     LEFT JOIN ohe.geo_feat_and_medium feat ON ((s.id = feat.sample_id)))
     LEFT JOIN ohe.fertilizer_admin fert ON ((s.id = fert.sample_id)));


ALTER VIEW ohe.environmental_fields OWNER TO gwajnberg;

--
-- Name: food_process_and_preserve; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.food_process_and_preserve AS
 SELECT food_data.sample_id,
    string_agg(
        CASE
            WHEN (o.ontology_id <> ALL (ARRAY['FOODON:03510128'::text, 'FOODON:00002418'::text, 'FOODON:03307539'::text, 'FOODON:03302148'::text])) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS food_processing_method,
    string_agg(
        CASE
            WHEN (o.ontology_id = ANY (ARRAY['FOODON:00002418'::text, 'FOODON:03307539'::text, 'FOODON:03302148'::text])) THEN public.bind_ontology(o.en_term, o.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS food_preserv_proc
   FROM ((public.food_data_product_property prop
     LEFT JOIN public.food_data ON ((prop.id = food_data.id)))
     LEFT JOIN public.ontology_terms o ON ((prop.term_id = o.id)))
  GROUP BY food_data.sample_id;


ALTER VIEW ohe.food_process_and_preserve OWNER TO gwajnberg;

--
-- Name: food_data_source; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_data_source (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.food_data_source OWNER TO gwajnberg;

--
-- Name: animal_source_of_food_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.animal_source_of_food_agg AS
 SELECT fd.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.food_data fd
     LEFT JOIN public.food_data_source fd_src ON ((fd.id = fd_src.id)))
     LEFT JOIN public.ontology_terms o ON ((fd_src.term_id = o.id)))
  GROUP BY fd.sample_id;


ALTER VIEW public.animal_source_of_food_agg OWNER TO gwajnberg;

--
-- Name: food_data_packaging; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_data_packaging (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.food_data_packaging OWNER TO gwajnberg;

--
-- Name: food_packaging_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.food_packaging_agg AS
 SELECT f.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.food_data f
     LEFT JOIN public.food_data_packaging pack ON ((f.id = pack.id)))
     LEFT JOIN public.ontology_terms o ON ((pack.term_id = o.id)))
  GROUP BY f.sample_id;


ALTER VIEW public.food_packaging_agg OWNER TO gwajnberg;

--
-- Name: food_fields; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.food_fields AS
 SELECT i.id AS isolate_id,
    s.id AS sample_id,
    countries.en_term AS food_origin,
    source.terms AS food_source,
    proc.food_processing_method,
    proc.food_preserv_proc,
    public.bind_ontology(prod_str.en_term, prod_str.ontology_id) AS food_prod,
    product.terms AS food_product_type,
    packaging.terms AS food_contain_wrap,
    f.food_quality_date
   FROM ((((((((public.isolates i
     LEFT JOIN public.samples s ON ((s.id = i.sample_id)))
     LEFT JOIN public.food_data f ON ((s.id = f.sample_id)))
     LEFT JOIN public.countries ON ((f.food_product_origin_country = countries.id)))
     LEFT JOIN public.animal_source_of_food_agg source ON ((s.id = source.sample_id)))
     LEFT JOIN ohe.food_process_and_preserve proc ON ((s.id = proc.sample_id)))
     LEFT JOIN public.ontology_terms prod_str ON ((f.food_product_production_stream = prod_str.id)))
     LEFT JOIN public.food_product_agg product ON ((s.id = product.sample_id)))
     LEFT JOIN public.food_packaging_agg packaging ON ((s.id = packaging.sample_id)));


ALTER VIEW ohe.food_fields OWNER TO gwajnberg;

--
-- Name: host; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.host AS
 SELECT org.sample_id,
        CASE
            WHEN (org.ontology_id IS NOT NULL) THEN public.bind_ontology(org.en_common_name, org.ontology_id)
            ELSE public.bind_ontology(fd_prod.en_term, fd_prod.ontology_id)
        END AS host
   FROM ((ohe.host_organism org
     LEFT JOIN public.hosts h ON ((org.sample_id = h.sample_id)))
     LEFT JOIN public.ontology_terms fd_prod ON ((h.host_food_production_name = fd_prod.id)));


ALTER VIEW ohe.host OWNER TO gwajnberg;

--
-- Name: host_am; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.host_am AS
 SELECT c.sample_id,
    c.presampling_activity_details AS host_am
   FROM (public.sample_activity sa
     LEFT JOIN public.collection_information c ON ((sa.id = c.id)))
  WHERE (sa.term_id = ( SELECT ontology_terms.id
           FROM public.ontology_terms
          WHERE (ontology_terms.ontology_id = 'GENEPIO:0100537'::text)));


ALTER VIEW ohe.host_am OWNER TO gwajnberg;

--
-- Name: host_housing; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.host_housing AS
 SELECT ed.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS host_housing
   FROM ((public.environmental_data_site e
     LEFT JOIN public.environmental_data ed ON ((e.id = ed.id)))
     LEFT JOIN public.ontology_terms o ON ((e.term_id = o.id)))
  WHERE (o.ontology_id = ANY (ARRAY['ENVO:01000922'::text, 'ENVO:00002196'::text, 'ENVO:00000073'::text, 'ENVO:03501257'::text, 'ENVO:03501383'::text, 'ENVO:03501385'::text, 'ENVO:03501413'::text, 'ENVO:03501387'::text, 'EOL:0001903'::text, 'ENVO:01001874'::text, 'ENVO:03501439'::text, 'ENVO:03501372'::text, 'ENVO:03501386'::text]))
  GROUP BY ed.sample_id;


ALTER VIEW ohe.host_housing OWNER TO gwajnberg;

--
-- Name: host_breeds; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.host_breeds (
    id integer NOT NULL,
    host_breed text
);


ALTER TABLE public.host_breeds OWNER TO gwajnberg;

--
-- Name: host_diseases; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.host_diseases (
    id integer NOT NULL,
    host_disease text
);


ALTER TABLE public.host_diseases OWNER TO gwajnberg;

--
-- Name: risk_activity; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.risk_activity (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.risk_activity OWNER TO gwajnberg;

--
-- Name: risk_assessment; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.risk_assessment (
    id integer NOT NULL,
    isolate_id integer,
    sample_id integer,
    prevalence_metrics text,
    prevalence_metrics_details text,
    stage_of_production integer,
    experimental_intervention_details text
);


ALTER TABLE public.risk_assessment OWNER TO gwajnberg;

--
-- Name: risk_activity_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.risk_activity_agg AS
 SELECT ra.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.risk_assessment ra
     LEFT JOIN public.risk_activity ON ((ra.id = risk_activity.id)))
     LEFT JOIN public.ontology_terms o ON ((risk_activity.term_id = o.id)))
  GROUP BY ra.sample_id;


ALTER VIEW public.risk_activity_agg OWNER TO gwajnberg;

--
-- Name: host_fields; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.host_fields AS
 SELECT i.id AS isolate_id,
    s.id AS sample_id,
    host_col.host,
    public.bind_ontology(age_ont.en_term, age_ont.ontology_id) AS host_age,
    host_diseases.host_disease,
    env_site.terms AS environmental_site,
    ana_mat.terms AS host_tissue_sampled,
    body_prod.terms AS host_body_product,
    h.host_ecotype AS host_variety,
    breeds.host_breed AS host_animal_breed,
    risk.terms AS upstream_intervention,
    host_am.host_am,
    housing.host_housing
   FROM ((((((((((((public.isolates i
     LEFT JOIN public.samples s ON ((i.sample_id = s.id)))
     LEFT JOIN public.hosts h ON ((s.id = h.sample_id)))
     LEFT JOIN ohe.host host_col ON ((s.id = host_col.sample_id)))
     LEFT JOIN public.ontology_terms age_ont ON ((h.host_age_bin = age_ont.id)))
     LEFT JOIN public.host_diseases ON ((h.host_disease = host_diseases.id)))
     LEFT JOIN public.environmental_site_agg env_site ON ((s.id = env_site.sample_id)))
     LEFT JOIN public.anatomical_material_agg ana_mat ON ((s.id = ana_mat.sample_id)))
     LEFT JOIN public.body_product_agg body_prod ON ((s.id = body_prod.sample_id)))
     LEFT JOIN public.host_breeds breeds ON ((h.host_breed = breeds.id)))
     LEFT JOIN public.risk_activity_agg risk ON ((s.id = risk.sample_id)))
     LEFT JOIN ohe.host_am host_am ON ((s.id = host_am.sample_id)))
     LEFT JOIN ohe.host_housing housing ON ((s.id = housing.sample_id)));


ALTER VIEW ohe.host_fields OWNER TO gwajnberg;

--
-- Name: alternative_isolate_ids; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.alternative_isolate_ids (
    isolate_id integer NOT NULL,
    alternative_isolate_id text NOT NULL,
    note text
);


ALTER TABLE public.alternative_isolate_ids OWNER TO gwajnberg;

--
-- Name: alt_iso_wide; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.alt_iso_wide AS
 SELECT isolate_id,
    string_agg(alternative_isolate_id, '; '::text) AS alt_isolate_names
   FROM public.alternative_isolate_ids
  GROUP BY isolate_id;


ALTER VIEW public.alt_iso_wide OWNER TO gwajnberg;

--
-- Name: strains; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.strains (
    id integer NOT NULL,
    strain text
);


ALTER TABLE public.strains OWNER TO gwajnberg;

--
-- Name: sample_identification_fields; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.sample_identification_fields AS
 SELECT i.id AS isolate_id,
    i.isolate_id AS sample_name,
    s.id AS sample_id,
    seq.bioproject_accession,
    COALESCE(strains.strain, i.isolate_id) AS strain,
    alt_iso_wide.alt_isolate_names AS isolate_name_alias
   FROM ((((public.isolates i
     LEFT JOIN public.samples s ON ((i.sample_id = s.id)))
     LEFT JOIN ohe.wgs_by_isolate seq ON ((i.id = seq.isolate_id)))
     LEFT JOIN public.strains ON ((i.id = strains.id)))
     LEFT JOIN public.alt_iso_wide ON ((alt_iso_wide.isolate_id = i.id)));


ALTER VIEW ohe.sample_identification_fields OWNER TO gwajnberg;

--
-- Name: one_health_enterics_export; Type: VIEW; Schema: ohe; Owner: gwajnberg
--

CREATE VIEW ohe.one_health_enterics_export AS
 SELECT s.sample_name,
    s.bioproject_accession,
    s.isolate_name_alias,
    s.strain,
    NULL::text AS culture_collection,
    NULL::text AS reference_material,
    c.organism,
    c.collected_by,
    c.collection_date,
    c.cult_isol_date,
    c.geo_loc_name,
    c.isolation_source,
    c.source_type,
    c.samp_collect_device,
    c.purpose_of_sampling,
    c.project_name,
    NULL::text AS "IFSAC_category",
    c.lat_lon,
    NULL::text AS serotype,
    c.serovar,
    c.sequenced_by,
    NULL::text AS description,
    h.host,
    NULL::text AS host_sex,
    h.host_age,
    h.host_disease,
    NULL::text AS host_subject_id,
    h.environmental_site AS animal_env,
    h.host_tissue_sampled,
    h.host_body_product,
    h.host_variety,
    h.host_animal_breed,
    h.upstream_intervention,
    h.host_am,
    NULL::text AS host_group_size,
    h.host_housing,
    f.food_origin,
    NULL::text AS intended_consumer,
    NULL::text AS spec_intended_cons,
    e.coll_site_geo_feat,
    f.food_prod,
    NULL::text AS label_claims,
    f.food_product_type,
    NULL::text AS food_industry_code,
    NULL::text AS food_industry_class,
    f.food_source,
    f.food_processing_method,
    f.food_preserv_proc,
    NULL::text AS food_additive,
    NULL::text AS food_contact_surf,
    f.food_contain_wrap,
    NULL::text AS food_pack_medium,
    NULL::text AS food_pack_integrity,
    f.food_quality_date,
    NULL::text AS food_prod_synonym,
    e.facility_type,
    NULL::text AS building_setting,
    NULL::text AS food_type_processed,
    NULL::text AS location_in_facility,
    NULL::text AS env_monitoring_zone,
    NULL::text AS indoor_surf,
    NULL::text AS indoor_surf_subpart,
    NULL::text AS surface_material,
    NULL::text AS material_condition,
    NULL::text AS surface_orientation,
    NULL::text AS surf_temp,
    NULL::text AS biocide_used,
    NULL::text AS animal_intrusion,
    NULL::text AS env_broad_scale,
    e.env_local_scale,
    e.env_medium,
    NULL::text AS plant_growth_med,
    NULL::text AS plant_water_method,
    NULL::text AS rel_location,
    NULL::text AS soil_type,
    NULL::text AS farm_water_source,
    e.fertilizer_admin,
    NULL::text AS food_clean_proc,
    NULL::text AS sanitizer_used_postharvest,
    NULL::text AS farm_equip,
    NULL::text AS extr_weather_event,
    NULL::text AS mechanical_damage
   FROM ((((ohe.sample_identification_fields s
     LEFT JOIN ohe.collection_information_fields c ON ((s.isolate_id = c.isolate_id)))
     LEFT JOIN ohe.host_fields h ON ((s.isolate_id = h.isolate_id)))
     LEFT JOIN ohe.food_fields f ON ((s.isolate_id = f.isolate_id)))
     LEFT JOIN ohe.environmental_fields e ON ((s.isolate_id = e.isolate_id)));


ALTER VIEW ohe.one_health_enterics_export OWNER TO gwajnberg;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.activities (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.activities OWNER TO gwajnberg;

--
-- Name: agencies; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.agencies (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.agencies OWNER TO gwajnberg;

--
-- Name: alternative_sample_ids; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.alternative_sample_ids (
    sample_id integer NOT NULL,
    alternative_sample_id text,
    note text
);


ALTER TABLE public.alternative_sample_ids OWNER TO gwajnberg;

--
-- Name: am_susceptibility_tests; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.am_susceptibility_tests (
    id integer NOT NULL,
    isolate_id integer NOT NULL,
    amr_testing_by integer,
    testing_date date,
    contact_information integer
);


ALTER TABLE public.am_susceptibility_tests OWNER TO gwajnberg;

--
-- Name: am_susceptibility_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.am_susceptibility_tests ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.am_susceptibility_tests_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: amr_antibiotics_profile; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.amr_antibiotics_profile (
    id integer NOT NULL,
    test_id integer NOT NULL,
    antimicrobial_agent integer,
    antimicrobial_phenotype integer,
    measurement real,
    measurement_units integer,
    measurement_sign integer,
    laboratory_typing_method integer,
    laboratory_typing_platform integer,
    laboratory_typing_platform_version text,
    testing_susceptible_breakpoint real,
    testing_intermediate_breakpoint real,
    testing_resistance_breakpoint real,
    testing_standard integer,
    testing_standard_version text,
    testing_standard_details text,
    vendor_name integer
);


ALTER TABLE public.amr_antibiotics_profile OWNER TO gwajnberg;

--
-- Name: amr_antibiotics_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.amr_antibiotics_profile ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.amr_antibiotics_profile_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: anatomical_data_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.anatomical_data ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.anatomical_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: anatomical_data_wide; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.anatomical_data_wide AS
 SELECT a.id AS anatomical_data_id,
    a.sample_id,
    public.bind_ontology(region.en_term, region.ontology_id) AS anatomical_region
   FROM (public.anatomical_data a
     LEFT JOIN public.ontology_terms region ON ((a.anatomical_region = region.id)));


ALTER VIEW public.anatomical_data_wide OWNER TO gwajnberg;

--
-- Name: anatomical_materials; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_materials (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.anatomical_materials OWNER TO gwajnberg;

--
-- Name: anatomical_parts; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_parts (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.anatomical_parts OWNER TO gwajnberg;

--
-- Name: anatomical_regions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.anatomical_regions (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.anatomical_regions OWNER TO gwajnberg;

--
-- Name: animal_or_plant_populations; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.animal_or_plant_populations (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.animal_or_plant_populations OWNER TO gwajnberg;

--
-- Name: animal_source_of_food; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.animal_source_of_food (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.animal_source_of_food OWNER TO gwajnberg;

--
-- Name: antimicrobial_agents; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.antimicrobial_agents (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.antimicrobial_agents OWNER TO gwajnberg;

--
-- Name: antimicrobial_phenotypes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.antimicrobial_phenotypes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.antimicrobial_phenotypes OWNER TO gwajnberg;

--
-- Name: attribute_packages; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.attribute_packages (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.attribute_packages OWNER TO gwajnberg;

--
-- Name: available_data_types; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.available_data_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.available_data_types OWNER TO gwajnberg;

--
-- Name: body_products; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.body_products (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.body_products OWNER TO gwajnberg;

--
-- Name: collection_devices; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.collection_devices (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.collection_devices OWNER TO gwajnberg;

--
-- Name: collection_information_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.collection_information ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.collection_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: collection_methods; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.collection_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.collection_methods OWNER TO gwajnberg;

--
-- Name: consensus_sequence_software; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.consensus_sequence_software (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.consensus_sequence_software OWNER TO gwajnberg;

--
-- Name: consensus_sequence_software_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.consensus_sequence_software ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.consensus_sequence_software_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: contact_information; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.contact_information (
    id integer NOT NULL,
    laboratory_name text,
    contact_name text,
    contact_email text,
    note text
);


ALTER TABLE public.contact_information OWNER TO gwajnberg;

--
-- Name: contact_information_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.contact_information ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.contact_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.countries ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.countries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: depth_units; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.depth_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.depth_units OWNER TO gwajnberg;

--
-- Name: duration_units; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.duration_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.duration_units OWNER TO gwajnberg;

--
-- Name: environmental_data_animal_plant; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data_animal_plant (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.environmental_data_animal_plant OWNER TO gwajnberg;

--
-- Name: environmental_data_available_data_type; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data_available_data_type (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.environmental_data_available_data_type OWNER TO gwajnberg;

--
-- Name: environmental_data_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.environmental_data ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.environmental_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: environmental_data_weather_type; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_data_weather_type (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.environmental_data_weather_type OWNER TO gwajnberg;

--
-- Name: environmental_material_agg; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.environmental_material_agg AS
 SELECT env.sample_id,
    string_agg(public.bind_ontology(o.en_term, o.ontology_id), '; '::text) AS terms
   FROM ((public.environmental_data env
     LEFT JOIN public.environmental_data_material mat ON ((mat.id = env.id)))
     LEFT JOIN public.ontology_terms o ON ((mat.term_id = o.id)))
  GROUP BY env.sample_id;


ALTER VIEW public.environmental_material_agg OWNER TO gwajnberg;

--
-- Name: environmental_materials; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_materials (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.environmental_materials OWNER TO gwajnberg;

--
-- Name: environmental_sites; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.environmental_sites (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.environmental_sites OWNER TO gwajnberg;

--
-- Name: experimental_specimen_role_types; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.experimental_specimen_role_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.experimental_specimen_role_types OWNER TO gwajnberg;

--
-- Name: extractions_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.extractions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.extractions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: food_data_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.food_data ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.food_data_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: food_packaging; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_packaging (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.food_packaging OWNER TO gwajnberg;

--
-- Name: food_product_production_streams; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_product_production_streams (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.food_product_production_streams OWNER TO gwajnberg;

--
-- Name: food_product_properties; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_product_properties (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.food_product_properties OWNER TO gwajnberg;

--
-- Name: food_products; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.food_products (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.food_products OWNER TO gwajnberg;

--
-- Name: foreign_keys; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.foreign_keys AS
 SELECT tc.table_schema,
    tc.constraint_name,
    tc.table_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
   FROM ((information_schema.table_constraints tc
     JOIN information_schema.key_column_usage kcu ON ((((tc.constraint_name)::name = (kcu.constraint_name)::name) AND ((tc.table_schema)::name = (kcu.table_schema)::name))))
     JOIN information_schema.constraint_column_usage ccu ON (((ccu.constraint_name)::name = (tc.constraint_name)::name)))
  WHERE (((tc.constraint_type)::text = 'FOREIGN KEY'::text) AND ((tc.table_schema)::name = 'public'::name));


ALTER VIEW public.foreign_keys OWNER TO gwajnberg;

--
-- Name: geo_loc_name_sites; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.geo_loc_name_sites (
    id integer NOT NULL,
    geo_loc_name_site text NOT NULL
);


ALTER TABLE public.geo_loc_name_sites OWNER TO gwajnberg;

--
-- Name: full_sample_metadata; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.full_sample_metadata AS
 SELECT s.id,
    s.sample_collector_sample_id,
    p.sample_plan_id,
    p.sample_plan_name,
    p.project_name,
    c.id AS collection_information_id,
    c.sample_collected_by,
    c.collection_method,
    c.collection_device,
    c.sample_storage_medium,
    c.sample_storage_method,
    c.specimen_processing,
    c.original_sample_description,
    c.sample_received_date,
    c.presampling_activity_details,
    c.sample_collection_date_precision,
    c.sample_collection_date,
    c.contact_information,
    ci.laboratory_name AS sample_collected_by_laboratory_name,
    ci.contact_name AS sample_collector_contact_name,
    ci.contact_email AS sample_collector_contact_email,
    g.country AS geo_loc_country,
    g.state_province_region AS geo_loc_name_state_province_region,
    site.geo_loc_name_site,
    g.latitude AS geo_loc_latitude,
    g.longitude AS geo_loc_longitude,
    e.id AS environmental_data_id,
    e.air_temperature,
    e.sediment_depth,
    e.water_depth,
    e.water_temperature,
    h.host_organism,
    h.host_origin_geo_loc_name_country,
    h.host_age_bin,
    h.host_disease,
    h.host_food_production_name,
    h.host_breed,
    h.host_ecotype,
    a.anatomical_region,
    f.id AS food_data_id,
    f.food_product_production_stream,
    f.food_product_origin_country,
    f.food_packaging_date,
    f.food_quality_date
   FROM (((((((((public.samples s
     LEFT JOIN public.projects p ON ((s.id = p.id)))
     LEFT JOIN public.collection_information c ON ((s.id = c.sample_id)))
     LEFT JOIN public.contact_information ci ON ((c.contact_information = ci.id)))
     LEFT JOIN public.geo_loc g ON ((s.id = g.sample_id)))
     LEFT JOIN public.geo_loc_name_sites site ON ((g.site = site.id)))
     LEFT JOIN public.environmental_data e ON ((s.id = e.sample_id)))
     LEFT JOIN public.hosts h ON ((s.id = h.sample_id)))
     LEFT JOIN public.anatomical_data a ON ((s.id = a.sample_id)))
     LEFT JOIN public.food_data f ON ((s.id = f.sample_id)));


ALTER VIEW public.full_sample_metadata OWNER TO gwajnberg;

--
-- Name: genomic_target_enrichment_methods; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.genomic_target_enrichment_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.genomic_target_enrichment_methods OWNER TO gwajnberg;

--
-- Name: geo_loc_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.geo_loc ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.geo_loc_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: geo_loc_name_sites_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.geo_loc_name_sites ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.geo_loc_name_sites_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: host_age_bin; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.host_age_bin (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.host_age_bin OWNER TO gwajnberg;

--
-- Name: host_breeds_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.host_breeds ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.host_breeds_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: host_diseases_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.host_diseases ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.host_diseases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: host_food_production_names; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.host_food_production_names (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.host_food_production_names OWNER TO gwajnberg;

--
-- Name: host_organisms_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.host_organisms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.host_organisms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hosts_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.hosts ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.hosts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: hosts_wide; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.hosts_wide AS
 SELECT h.id AS host_id,
    h.sample_id,
    h.host_ecotype,
    public.bind_ontology(ho.en_common_name, ho.ontology_id) AS host_common_name,
    public.bind_ontology(ho.scientific_name, ho.ontology_id) AS host_scientific_name,
    h.host_breed,
    public.bind_ontology(prod_name.en_term, prod_name.ontology_id) AS host_food_production_name,
    h.host_disease,
    public.bind_ontology(age.en_term, age.ontology_id) AS host_age_bin,
    public.bind_ontology(c.en_term, c.ontology_id) AS host_origin_geo_loc_name_country
   FROM ((((public.hosts h
     LEFT JOIN public.host_organisms ho ON ((h.host_organism = ho.id)))
     LEFT JOIN public.ontology_terms age ON ((h.host_age_bin = age.id)))
     LEFT JOIN public.ontology_terms prod_name ON ((h.host_food_production_name = prod_name.id)))
     LEFT JOIN public.countries c ON ((h.host_origin_geo_loc_name_country = c.id)));


ALTER VIEW public.hosts_wide OWNER TO gwajnberg;

--
-- Name: isolates_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.isolates ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.isolates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: laboratory_typing_methods; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.laboratory_typing_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.laboratory_typing_methods OWNER TO gwajnberg;

--
-- Name: laboratory_typing_platforms; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.laboratory_typing_platforms (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.laboratory_typing_platforms OWNER TO gwajnberg;

--
-- Name: measurement_sign; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.measurement_sign (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.measurement_sign OWNER TO gwajnberg;

--
-- Name: measurement_units; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.measurement_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.measurement_units OWNER TO gwajnberg;

--
-- Name: metagenomic_extractions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.metagenomic_extractions (
    sample_id integer NOT NULL,
    extraction_id integer NOT NULL
);


ALTER TABLE public.metagenomic_extractions OWNER TO gwajnberg;

--
-- Name: microbes_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.microbes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.microbes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ontology_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.ontology_terms ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.ontology_terms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: possible_isolate_names; Type: VIEW; Schema: public; Owner: gwajnberg
--

CREATE VIEW public.possible_isolate_names AS
 SELECT i.id AS isolate_id,
    i.isolate_id AS isolate_collector_id,
    'Assigned as main isolate ID'::text AS note
   FROM public.isolates i
UNION ALL
 SELECT a.isolate_id,
    a.alternative_isolate_id AS isolate_collector_id,
    a.note
   FROM public.alternative_isolate_ids a
  ORDER BY 1;


ALTER VIEW public.possible_isolate_names OWNER TO gwajnberg;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.projects ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.projects_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: public_repository_information_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.public_repository_information ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.public_repository_information_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: purposes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.purposes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.purposes OWNER TO gwajnberg;

--
-- Name: quality_control_determinations; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.quality_control_determinations (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.quality_control_determinations OWNER TO gwajnberg;

--
-- Name: quality_control_issues; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.quality_control_issues (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.quality_control_issues OWNER TO gwajnberg;

--
-- Name: read_mapping_software_names; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.read_mapping_software_names (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.read_mapping_software_names OWNER TO gwajnberg;

--
-- Name: read_mapping_software_names_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.read_mapping_software_names ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.read_mapping_software_names_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: reference_genome_accessions; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.reference_genome_accessions (
    id integer NOT NULL,
    accession text NOT NULL
);


ALTER TABLE public.reference_genome_accessions OWNER TO gwajnberg;

--
-- Name: reference_genome_accessions_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.reference_genome_accessions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.reference_genome_accessions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: residual_sample_status; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.residual_sample_status (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.residual_sample_status OWNER TO gwajnberg;

--
-- Name: risk_assessment_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.risk_assessment ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.risk_assessment_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sample_collection_date_precision; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sample_collection_date_precision (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.sample_collection_date_precision OWNER TO gwajnberg;

--
-- Name: samples_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.samples ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.samples_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sequence_assembly_software; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequence_assembly_software (
    id integer NOT NULL,
    name text NOT NULL
);


ALTER TABLE public.sequence_assembly_software OWNER TO gwajnberg;

--
-- Name: sequence_assembly_software_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.sequence_assembly_software ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sequence_assembly_software_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sequencing_assay_types; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequencing_assay_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.sequencing_assay_types OWNER TO gwajnberg;

--
-- Name: sequencing_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.sequencing ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sequencing_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sequencing_instruments; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequencing_instruments (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.sequencing_instruments OWNER TO gwajnberg;

--
-- Name: sequencing_platforms; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequencing_platforms (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.sequencing_platforms OWNER TO gwajnberg;

--
-- Name: sequencing_purposes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.sequencing_purposes (
    id integer NOT NULL,
    term_id integer NOT NULL
);


ALTER TABLE public.sequencing_purposes OWNER TO gwajnberg;

--
-- Name: specimen_processing; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.specimen_processing (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.specimen_processing OWNER TO gwajnberg;

--
-- Name: stage_of_production; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.stage_of_production (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.stage_of_production OWNER TO gwajnberg;

--
-- Name: state_province_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.state_province_regions ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.state_province_regions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: strains_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.strains ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.strains_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: taxonomic_identification_processes; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.taxonomic_identification_processes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.taxonomic_identification_processes OWNER TO gwajnberg;

--
-- Name: temperature_units; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.temperature_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.temperature_units OWNER TO gwajnberg;

--
-- Name: template_mapping; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.template_mapping (
    id integer NOT NULL,
    grdi_group text,
    grdi_field text,
    vmr_table text,
    vmr_field text,
    is_lookup boolean,
    is_multi_choice boolean
);


ALTER TABLE public.template_mapping OWNER TO gwajnberg;

--
-- Name: template_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.template_mapping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.template_mapping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: testing_standard; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.testing_standard (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.testing_standard OWNER TO gwajnberg;

--
-- Name: user_bioinformatic_analyses; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.user_bioinformatic_analyses (
    id integer NOT NULL,
    sequencing_id integer,
    quality_control_method_name text,
    quality_control_method_version text,
    quality_control_determination integer,
    quality_control_issues integer,
    quality_control_details text,
    raw_sequence_data_processing_method text,
    dehosting_method text,
    sequence_assembly_software integer,
    sequence_assembly_software_version text,
    consensus_sequence_software integer,
    consensus_sequence_software_version text,
    breadth_of_coverage_value double precision,
    depth_of_coverage_value double precision,
    depth_of_coverage_threshold double precision,
    genome_completeness double precision,
    number_of_base_pairs_sequenced integer,
    number_of_total_reads integer,
    number_of_unique_reads integer,
    minimum_post_trimming_read_length integer,
    number_of_contigs integer,
    percent_n double precision,
    ns_per_100_kbp double precision,
    n50 double precision,
    percent_read_contamination double precision,
    sequence_assembly_length integer,
    consensus_genome_length integer,
    reference_genome_accession integer,
    deduplication_method text,
    bioinformatics_protocol text,
    read_mapping_software_name integer,
    read_mapping_software_version text,
    taxonomic_reference_database_name text,
    taxonomic_reference_database_version text,
    taxonomic_analysis_report_filename text,
    taxonomic_analysis_date date,
    read_mapping_criteria text
);


ALTER TABLE public.user_bioinformatic_analyses OWNER TO gwajnberg;

--
-- Name: user_bioinformatic_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: gwajnberg
--

ALTER TABLE public.user_bioinformatic_analyses ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.user_bioinformatic_analyses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: vendor_names; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.vendor_names (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.vendor_names OWNER TO gwajnberg;

--
-- Name: volume_measurement_units; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.volume_measurement_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.volume_measurement_units OWNER TO gwajnberg;

--
-- Name: weather_types; Type: TABLE; Schema: public; Owner: gwajnberg
--

CREATE TABLE public.weather_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true
);


ALTER TABLE public.weather_types OWNER TO gwajnberg;

--
-- Name: amr_genes_drugs amr_genes_drugs_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_drugs
    ADD CONSTRAINT amr_genes_drugs_pkey PRIMARY KEY (amr_genes_id, drug_id);


--
-- Name: amr_genes_families amr_genes_families_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_families
    ADD CONSTRAINT amr_genes_families_pkey PRIMARY KEY (amr_genes_id, amr_gene_family_id);


--
-- Name: amr_genes_profiles amr_genes_profiles_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_profiles
    ADD CONSTRAINT amr_genes_profiles_pkey PRIMARY KEY (id);


--
-- Name: amr_genes_resistance_mechanism amr_genes_resistance_mechanism_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_resistance_mechanism
    ADD CONSTRAINT amr_genes_resistance_mechanism_pkey PRIMARY KEY (amr_genes_id, resistance_mechanism_id);


--
-- Name: amr_mob_suite amr_mob_suite_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_mob_suite
    ADD CONSTRAINT amr_mob_suite_pkey PRIMARY KEY (id);


--
-- Name: amr_mpf_type amr_mpf_type_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_mpf_type
    ADD CONSTRAINT amr_mpf_type_pkey PRIMARY KEY (amr_genes_id, mpf_type);


--
-- Name: amr_orit_types amr_orit_types_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_orit_types
    ADD CONSTRAINT amr_orit_types_pkey PRIMARY KEY (amr_genes_id, orit_type);


--
-- Name: amr_predicted_mobility amr_predicted_mobility_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_predicted_mobility
    ADD CONSTRAINT amr_predicted_mobility_pkey PRIMARY KEY (amr_genes_id, predicted_mobility);


--
-- Name: amr_ref_type amr_ref_type_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_ref_type
    ADD CONSTRAINT amr_ref_type_pkey PRIMARY KEY (amr_genes_id, rep_type);


--
-- Name: amr_relaxase_type amr_relaxase_type_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_relaxase_type
    ADD CONSTRAINT amr_relaxase_type_pkey PRIMARY KEY (amr_genes_id, relaxase_type);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: agencies agencies_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.agencies
    ADD CONSTRAINT agencies_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: alternative_sample_ids alt_sample_ids_keep_unique; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.alternative_sample_ids
    ADD CONSTRAINT alt_sample_ids_keep_unique UNIQUE (sample_id, alternative_sample_id);


--
-- Name: alternative_isolate_ids alternative_isolate_ids_alternative_isolate_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.alternative_isolate_ids
    ADD CONSTRAINT alternative_isolate_ids_alternative_isolate_id_key UNIQUE (alternative_isolate_id);


--
-- Name: alternative_sample_ids alternative_sample_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.alternative_sample_ids
    ADD CONSTRAINT alternative_sample_ids_pkey PRIMARY KEY (sample_id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_pkey PRIMARY KEY (id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_pkey PRIMARY KEY (id);


--
-- Name: anatomical_data_body anatomical_data_body_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_pkey PRIMARY KEY (id, term_id);


--
-- Name: anatomical_data_material anatomical_data_material_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_pkey PRIMARY KEY (id, term_id);


--
-- Name: anatomical_data_part anatomical_data_part_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_pkey PRIMARY KEY (id, term_id);


--
-- Name: anatomical_data anatomical_data_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data
    ADD CONSTRAINT anatomical_data_pkey PRIMARY KEY (id);


--
-- Name: anatomical_data anatomical_data_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data
    ADD CONSTRAINT anatomical_data_sample_id_key UNIQUE (sample_id);


--
-- Name: anatomical_materials anatomical_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_materials
    ADD CONSTRAINT anatomical_materials_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: anatomical_parts anatomical_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_parts
    ADD CONSTRAINT anatomical_parts_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: anatomical_regions anatomical_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_regions
    ADD CONSTRAINT anatomical_regions_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: animal_or_plant_populations animal_or_plant_populations_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.animal_or_plant_populations
    ADD CONSTRAINT animal_or_plant_populations_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: animal_source_of_food animal_source_of_food_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.animal_source_of_food
    ADD CONSTRAINT animal_source_of_food_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: antimicrobial_agents antimicrobial_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.antimicrobial_agents
    ADD CONSTRAINT antimicrobial_agents_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: antimicrobial_phenotypes antimicrobial_phenotypes_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.antimicrobial_phenotypes
    ADD CONSTRAINT antimicrobial_phenotypes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: attribute_packages attribute_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.attribute_packages
    ADD CONSTRAINT attribute_packages_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: available_data_types available_data_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.available_data_types
    ADD CONSTRAINT available_data_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: body_products body_products_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.body_products
    ADD CONSTRAINT body_products_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: collection_devices collection_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_devices
    ADD CONSTRAINT collection_devices_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: collection_information collection_information_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_pkey PRIMARY KEY (id);


--
-- Name: collection_information collection_information_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_sample_id_key UNIQUE (sample_id);


--
-- Name: collection_methods collection_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_methods
    ADD CONSTRAINT collection_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: consensus_sequence_software consensus_sequence_software_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.consensus_sequence_software
    ADD CONSTRAINT consensus_sequence_software_pkey PRIMARY KEY (id);


--
-- Name: contact_information contact_information_laboratory_name_contact_name_contact_em_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.contact_information
    ADD CONSTRAINT contact_information_laboratory_name_contact_name_contact_em_key UNIQUE NULLS NOT DISTINCT (laboratory_name, contact_name, contact_email);


--
-- Name: contact_information contact_information_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.contact_information
    ADD CONSTRAINT contact_information_pkey PRIMARY KEY (id);


--
-- Name: countries countries_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_ontology_id_key UNIQUE (ontology_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: depth_units depth_units_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.depth_units
    ADD CONSTRAINT depth_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: duration_units duration_units_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.duration_units
    ADD CONSTRAINT duration_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_pkey PRIMARY KEY (id, term_id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_pkey PRIMARY KEY (id, term_id);


--
-- Name: environmental_data_material environmental_data_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_materials_pkey PRIMARY KEY (id, term_id);


--
-- Name: environmental_data environmental_data_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_pkey PRIMARY KEY (id);


--
-- Name: environmental_data environmental_data_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_sample_id_key UNIQUE (sample_id);


--
-- Name: environmental_data_site environmental_data_site_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_pkey PRIMARY KEY (id, term_id);


--
-- Name: environmental_data_weather_type environmental_data_weather_type_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_weather_type
    ADD CONSTRAINT environmental_data_weather_type_pkey PRIMARY KEY (id, term_id);


--
-- Name: environmental_materials environmental_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_materials
    ADD CONSTRAINT environmental_materials_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: environmental_sites environmental_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_sites
    ADD CONSTRAINT environmental_sites_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: experimental_specimen_role_types experimental_specimen_role_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.experimental_specimen_role_types
    ADD CONSTRAINT experimental_specimen_role_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: extractions extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_pkey PRIMARY KEY (id);


--
-- Name: food_data_packaging food_data_packaging_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_pkey PRIMARY KEY (id, term_id);


--
-- Name: food_data food_data_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data
    ADD CONSTRAINT food_data_pkey PRIMARY KEY (id);


--
-- Name: food_data_product food_data_product_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_pkey PRIMARY KEY (id, term_id);


--
-- Name: food_data_product_property food_data_product_property_pk; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_pk PRIMARY KEY (id, term_id);


--
-- Name: food_data food_data_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data
    ADD CONSTRAINT food_data_sample_id_key UNIQUE (sample_id);


--
-- Name: food_data_source food_data_source_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_pkey PRIMARY KEY (id, term_id);


--
-- Name: food_packaging food_packaging_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_packaging
    ADD CONSTRAINT food_packaging_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_product_production_streams food_product_production_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_product_production_streams
    ADD CONSTRAINT food_product_production_streams_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_product_properties food_product_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_product_properties
    ADD CONSTRAINT food_product_properties_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_products food_products_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_products
    ADD CONSTRAINT food_products_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: genomic_target_enrichment_methods genomic_target_enrichment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.genomic_target_enrichment_methods
    ADD CONSTRAINT genomic_target_enrichment_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: geo_loc_name_sites geo_loc_name_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc_name_sites
    ADD CONSTRAINT geo_loc_name_sites_pkey PRIMARY KEY (id);


--
-- Name: geo_loc geo_loc_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_pkey PRIMARY KEY (id);


--
-- Name: geo_loc geo_loc_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_sample_id_key UNIQUE (sample_id);


--
-- Name: host_age_bin host_age_bin_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_age_bin
    ADD CONSTRAINT host_age_bin_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: host_breeds host_breeds_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_breeds
    ADD CONSTRAINT host_breeds_pkey PRIMARY KEY (id);


--
-- Name: host_diseases host_diseases_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_diseases
    ADD CONSTRAINT host_diseases_pkey PRIMARY KEY (id);


--
-- Name: host_food_production_names host_food_production_names_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_food_production_names
    ADD CONSTRAINT host_food_production_names_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: host_organisms host_organisms_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_organisms
    ADD CONSTRAINT host_organisms_ontology_id_key UNIQUE (ontology_id);


--
-- Name: host_organisms host_organisms_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_organisms
    ADD CONSTRAINT host_organisms_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_pkey PRIMARY KEY (id);


--
-- Name: hosts hosts_sample_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_sample_id_key UNIQUE (sample_id);


--
-- Name: isolates isolates_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_pkey PRIMARY KEY (id);


--
-- Name: laboratory_typing_methods laboratory_typing_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.laboratory_typing_methods
    ADD CONSTRAINT laboratory_typing_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: laboratory_typing_platforms laboratory_typing_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.laboratory_typing_platforms
    ADD CONSTRAINT laboratory_typing_platforms_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: measurement_sign measurement_sign_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.measurement_sign
    ADD CONSTRAINT measurement_sign_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: measurement_units measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.measurement_units
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: metagenomic_extractions metagenomic_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_pkey PRIMARY KEY (sample_id, extraction_id);


--
-- Name: microbes microbes_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.microbes
    ADD CONSTRAINT microbes_ontology_id_key UNIQUE (ontology_id);


--
-- Name: microbes microbes_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.microbes
    ADD CONSTRAINT microbes_pkey PRIMARY KEY (id);


--
-- Name: ontology_terms ontology_terms_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.ontology_terms
    ADD CONSTRAINT ontology_terms_ontology_id_key UNIQUE (ontology_id);


--
-- Name: ontology_terms ontology_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.ontology_terms
    ADD CONSTRAINT ontology_terms_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: public_repository_information public_repository_information_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_pkey PRIMARY KEY (id);


--
-- Name: purposes purposes_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.purposes
    ADD CONSTRAINT purposes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: quality_control_determinations quality_control_determinations_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.quality_control_determinations
    ADD CONSTRAINT quality_control_determinations_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: quality_control_issues quality_control_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.quality_control_issues
    ADD CONSTRAINT quality_control_issues_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: read_mapping_software_names read_mapping_software_names_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.read_mapping_software_names
    ADD CONSTRAINT read_mapping_software_names_pkey PRIMARY KEY (id);


--
-- Name: reference_genome_accessions reference_genome_accessions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.reference_genome_accessions
    ADD CONSTRAINT reference_genome_accessions_pkey PRIMARY KEY (id);


--
-- Name: residual_sample_status residual_sample_status_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.residual_sample_status
    ADD CONSTRAINT residual_sample_status_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: risk_activity risk_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_pkey PRIMARY KEY (id, term_id);


--
-- Name: risk_assessment risk_assessment_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_assessment_pkey PRIMARY KEY (id);


--
-- Name: sample_activity sample_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_pkey PRIMARY KEY (id, term_id);


--
-- Name: sample_collection_date_precision sample_collection_date_precision_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_collection_date_precision
    ADD CONSTRAINT sample_collection_date_precision_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sample_purposes sample_purpose_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purpose_pkey PRIMARY KEY (id, term_id);


--
-- Name: samples samples_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_pkey PRIMARY KEY (id);


--
-- Name: sequence_assembly_software sequence_assembly_software_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequence_assembly_software
    ADD CONSTRAINT sequence_assembly_software_pkey PRIMARY KEY (id);


--
-- Name: sequencing_assay_types sequencing_assay_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_assay_types
    ADD CONSTRAINT sequencing_assay_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing_instruments sequencing_instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_instruments
    ADD CONSTRAINT sequencing_instruments_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing sequencing_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_pkey PRIMARY KEY (id);


--
-- Name: sequencing_platforms sequencing_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_platforms
    ADD CONSTRAINT sequencing_platforms_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing_purposes sequencing_purposes_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_pkey PRIMARY KEY (id, term_id);


--
-- Name: specimen_processing specimen_processing_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.specimen_processing
    ADD CONSTRAINT specimen_processing_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: stage_of_production stage_of_production_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.stage_of_production
    ADD CONSTRAINT stage_of_production_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: state_province_regions state_province_regions_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_ontology_id_key UNIQUE (ontology_id);


--
-- Name: state_province_regions state_province_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_pkey PRIMARY KEY (id);


--
-- Name: strains strains_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.strains
    ADD CONSTRAINT strains_pkey PRIMARY KEY (id);


--
-- Name: taxonomic_identification_processes taxonomic_identification_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.taxonomic_identification_processes
    ADD CONSTRAINT taxonomic_identification_processes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: temperature_units temperature_units_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.temperature_units
    ADD CONSTRAINT temperature_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: template_mapping template_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.template_mapping
    ADD CONSTRAINT template_mapping_pkey PRIMARY KEY (id);


--
-- Name: testing_standard testing_standard_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.testing_standard
    ADD CONSTRAINT testing_standard_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_pkey PRIMARY KEY (id);


--
-- Name: vendor_names vendor_names_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.vendor_names
    ADD CONSTRAINT vendor_names_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: volume_measurement_units volume_measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.volume_measurement_units
    ADD CONSTRAINT volume_measurement_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: weather_types weather_types_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.weather_types
    ADD CONSTRAINT weather_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: wgs_extractions wgs_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_pkey PRIMARY KEY (isolate_id, extraction_id);


--
-- Name: amr_genes_drugs amr_genes_drugs_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_drugs
    ADD CONSTRAINT amr_genes_drugs_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_genes_families amr_genes_families_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_families
    ADD CONSTRAINT amr_genes_families_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_genes_profiles amr_genes_profiles_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_profiles
    ADD CONSTRAINT amr_genes_profiles_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: amr_genes_resistance_mechanism amr_genes_resistance_mechanism_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_genes_resistance_mechanism
    ADD CONSTRAINT amr_genes_resistance_mechanism_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_mob_suite amr_mob_suite_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_mob_suite
    ADD CONSTRAINT amr_mob_suite_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_mpf_type amr_mpf_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_mpf_type
    ADD CONSTRAINT amr_mpf_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_orit_types amr_orit_types_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_orit_types
    ADD CONSTRAINT amr_orit_types_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_predicted_mobility amr_predicted_mobility_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_predicted_mobility
    ADD CONSTRAINT amr_predicted_mobility_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_ref_type amr_ref_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_ref_type
    ADD CONSTRAINT amr_ref_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: amr_relaxase_type amr_relaxase_type_amr_genes_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: gwajnberg
--

ALTER TABLE ONLY bioinf.amr_relaxase_type
    ADD CONSTRAINT amr_relaxase_type_amr_genes_id_fkey FOREIGN KEY (amr_genes_id) REFERENCES bioinf.amr_genes_profiles(id);


--
-- Name: activities activities_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: agencies agencies_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.agencies
    ADD CONSTRAINT agencies_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: alternative_isolate_ids alternative_isolate_ids_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.alternative_isolate_ids
    ADD CONSTRAINT alternative_isolate_ids_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: alternative_sample_ids alternative_sample_ids_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.alternative_sample_ids
    ADD CONSTRAINT alternative_sample_ids_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_amr_testing_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_amr_testing_by_fkey FOREIGN KEY (amr_testing_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_antimicrobial_agent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_antimicrobial_agent_fkey FOREIGN KEY (antimicrobial_agent) REFERENCES public.antimicrobial_agents(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_antimicrobial_phenotype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_antimicrobial_phenotype_fkey FOREIGN KEY (antimicrobial_phenotype) REFERENCES public.antimicrobial_phenotypes(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_laboratory_typing_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_laboratory_typing_method_fkey FOREIGN KEY (laboratory_typing_method) REFERENCES public.laboratory_typing_methods(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_laboratory_typing_platform_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_laboratory_typing_platform_fkey FOREIGN KEY (laboratory_typing_platform) REFERENCES public.laboratory_typing_platforms(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_measurement_sign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_measurement_sign_fkey FOREIGN KEY (measurement_sign) REFERENCES public.measurement_sign(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_measurement_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_measurement_units_fkey FOREIGN KEY (measurement_units) REFERENCES public.measurement_units(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.am_susceptibility_tests(id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_testing_standard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_testing_standard_fkey FOREIGN KEY (testing_standard) REFERENCES public.testing_standard(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_vendor_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_vendor_name_fkey FOREIGN KEY (vendor_name) REFERENCES public.vendor_names(ontology_term_id);


--
-- Name: anatomical_data anatomical_data_anatomical_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data
    ADD CONSTRAINT anatomical_data_anatomical_region_fkey FOREIGN KEY (anatomical_region) REFERENCES public.anatomical_regions(ontology_term_id);


--
-- Name: anatomical_data_body anatomical_data_body_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_id_fkey FOREIGN KEY (id) REFERENCES public.anatomical_data(id);


--
-- Name: anatomical_data_body anatomical_data_body_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.body_products(ontology_term_id);


--
-- Name: anatomical_data_material anatomical_data_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_id_fkey FOREIGN KEY (id) REFERENCES public.anatomical_data(id);


--
-- Name: anatomical_data_material anatomical_data_material_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.anatomical_materials(ontology_term_id);


--
-- Name: anatomical_data_part anatomical_data_part_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_id_fkey FOREIGN KEY (id) REFERENCES public.anatomical_data(id);


--
-- Name: anatomical_data_part anatomical_data_part_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.anatomical_parts(ontology_term_id);


--
-- Name: anatomical_data anatomical_data_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_data
    ADD CONSTRAINT anatomical_data_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: anatomical_materials anatomical_materials_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_materials
    ADD CONSTRAINT anatomical_materials_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: anatomical_parts anatomical_parts_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_parts
    ADD CONSTRAINT anatomical_parts_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: anatomical_regions anatomical_regions_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.anatomical_regions
    ADD CONSTRAINT anatomical_regions_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: animal_or_plant_populations animal_or_plant_populations_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.animal_or_plant_populations
    ADD CONSTRAINT animal_or_plant_populations_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: animal_source_of_food animal_source_of_food_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.animal_source_of_food
    ADD CONSTRAINT animal_source_of_food_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: antimicrobial_agents antimicrobial_agents_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.antimicrobial_agents
    ADD CONSTRAINT antimicrobial_agents_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: antimicrobial_phenotypes antimicrobial_phenotypes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.antimicrobial_phenotypes
    ADD CONSTRAINT antimicrobial_phenotypes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: attribute_packages attribute_packages_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.attribute_packages
    ADD CONSTRAINT attribute_packages_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: available_data_types available_data_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.available_data_types
    ADD CONSTRAINT available_data_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: body_products body_products_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.body_products
    ADD CONSTRAINT body_products_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: collection_devices collection_devices_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_devices
    ADD CONSTRAINT collection_devices_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: collection_information collection_information_collection_device_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_collection_device_fkey FOREIGN KEY (collection_device) REFERENCES public.collection_devices(ontology_term_id);


--
-- Name: collection_information collection_information_collection_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_collection_method_fkey FOREIGN KEY (collection_method) REFERENCES public.collection_methods(ontology_term_id);


--
-- Name: collection_information collection_information_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: collection_information collection_information_sample_collected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_sample_collected_by_fkey FOREIGN KEY (sample_collected_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: collection_information collection_information_sample_collection_date_precision_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_sample_collection_date_precision_fkey FOREIGN KEY (sample_collection_date_precision) REFERENCES public.sample_collection_date_precision(ontology_term_id);


--
-- Name: collection_information collection_information_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: collection_information collection_information_specimen_processing_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_information
    ADD CONSTRAINT collection_information_specimen_processing_fkey FOREIGN KEY (specimen_processing) REFERENCES public.specimen_processing(ontology_term_id);


--
-- Name: collection_methods collection_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.collection_methods
    ADD CONSTRAINT collection_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: depth_units depth_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.depth_units
    ADD CONSTRAINT depth_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: duration_units duration_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.duration_units
    ADD CONSTRAINT duration_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: environmental_data environmental_data_air_temperature_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_air_temperature_units_fkey FOREIGN KEY (air_temperature_units) REFERENCES public.temperature_units(ontology_term_id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_id_fkey FOREIGN KEY (id) REFERENCES public.environmental_data(id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.animal_or_plant_populations(ontology_term_id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_id_fkey FOREIGN KEY (id) REFERENCES public.environmental_data(id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.available_data_types(ontology_term_id);


--
-- Name: environmental_data_material environmental_data_material_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_material_id_fkey FOREIGN KEY (id) REFERENCES public.environmental_data(id);


--
-- Name: environmental_data_material environmental_data_material_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_material_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.environmental_materials(ontology_term_id);


--
-- Name: environmental_data environmental_data_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data environmental_data_sediment_depth_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_sediment_depth_units_fkey FOREIGN KEY (sediment_depth_units) REFERENCES public.depth_units(ontology_term_id);


--
-- Name: environmental_data_site environmental_data_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_id_fkey FOREIGN KEY (id) REFERENCES public.environmental_data(id);


--
-- Name: environmental_data_site environmental_data_site_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.environmental_sites(ontology_term_id);


--
-- Name: environmental_data environmental_data_water_depth_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_water_depth_units_fkey FOREIGN KEY (water_depth_units) REFERENCES public.depth_units(ontology_term_id);


--
-- Name: environmental_data environmental_data_water_temperature_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data
    ADD CONSTRAINT environmental_data_water_temperature_units_fkey FOREIGN KEY (water_temperature_units) REFERENCES public.temperature_units(ontology_term_id);


--
-- Name: environmental_data_weather_type environmental_data_weather_type_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_weather_type
    ADD CONSTRAINT environmental_data_weather_type_id_fkey FOREIGN KEY (id) REFERENCES public.environmental_data(id);


--
-- Name: environmental_data_weather_type environmental_data_weather_type_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_data_weather_type
    ADD CONSTRAINT environmental_data_weather_type_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.weather_types(ontology_term_id);


--
-- Name: environmental_materials environmental_materials_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_materials
    ADD CONSTRAINT environmental_materials_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: environmental_sites environmental_sites_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.environmental_sites
    ADD CONSTRAINT environmental_sites_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: experimental_specimen_role_types experimental_specimen_role_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.experimental_specimen_role_types
    ADD CONSTRAINT experimental_specimen_role_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: extractions extractions_experimental_specimen_role_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_experimental_specimen_role_type_fkey FOREIGN KEY (experimental_specimen_role_type) REFERENCES public.experimental_specimen_role_types(ontology_term_id);


--
-- Name: extractions extractions_nucleic_acid_storage_duration_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_nucleic_acid_storage_duration_unit_fkey FOREIGN KEY (nucleic_acid_storage_duration_unit) REFERENCES public.duration_units(ontology_term_id);


--
-- Name: extractions extractions_residual_sample_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_residual_sample_status_fkey FOREIGN KEY (residual_sample_status) REFERENCES public.residual_sample_status(ontology_term_id);


--
-- Name: extractions extractions_sample_storage_duration_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_sample_storage_duration_unit_fkey FOREIGN KEY (sample_storage_duration_unit) REFERENCES public.duration_units(ontology_term_id);


--
-- Name: extractions extractions_sample_volume_measurement_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_sample_volume_measurement_unit_fkey FOREIGN KEY (sample_volume_measurement_unit) REFERENCES public.volume_measurement_units(ontology_term_id);


--
-- Name: food_data food_data_food_product_origin_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data
    ADD CONSTRAINT food_data_food_product_origin_country_fkey FOREIGN KEY (food_product_origin_country) REFERENCES public.countries(id);


--
-- Name: food_data food_data_food_product_production_stream_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data
    ADD CONSTRAINT food_data_food_product_production_stream_fkey FOREIGN KEY (food_product_production_stream) REFERENCES public.food_product_production_streams(ontology_term_id);


--
-- Name: food_data_packaging food_data_packaging_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_id_fkey FOREIGN KEY (id) REFERENCES public.food_data(id);


--
-- Name: food_data_packaging food_data_packaging_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_packaging(ontology_term_id);


--
-- Name: food_data_product food_data_product_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_id_fkey FOREIGN KEY (id) REFERENCES public.food_data(id);


--
-- Name: food_data_product_property food_data_product_property_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_id_fkey FOREIGN KEY (id) REFERENCES public.food_data(id);


--
-- Name: food_data_product_property food_data_product_property_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_product_properties(ontology_term_id);


--
-- Name: food_data_product food_data_product_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_products(ontology_term_id);


--
-- Name: food_data food_data_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data
    ADD CONSTRAINT food_data_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_source food_data_source_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_id_fkey FOREIGN KEY (id) REFERENCES public.food_data(id);


--
-- Name: food_data_source food_data_source_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.animal_source_of_food(ontology_term_id);


--
-- Name: food_packaging food_packaging_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_packaging
    ADD CONSTRAINT food_packaging_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_product_production_streams food_product_production_streams_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_product_production_streams
    ADD CONSTRAINT food_product_production_streams_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_product_properties food_product_properties_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_product_properties
    ADD CONSTRAINT food_product_properties_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_products food_products_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.food_products
    ADD CONSTRAINT food_products_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: genomic_target_enrichment_methods genomic_target_enrichment_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.genomic_target_enrichment_methods
    ADD CONSTRAINT genomic_target_enrichment_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: geo_loc geo_loc_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_country_fkey FOREIGN KEY (country) REFERENCES public.countries(id);


--
-- Name: geo_loc geo_loc_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: geo_loc geo_loc_site_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_site_fkey FOREIGN KEY (site) REFERENCES public.geo_loc_name_sites(id);


--
-- Name: geo_loc geo_loc_state_province_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.geo_loc
    ADD CONSTRAINT geo_loc_state_province_region_fkey FOREIGN KEY (state_province_region) REFERENCES public.state_province_regions(id);


--
-- Name: host_age_bin host_age_bin_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_age_bin
    ADD CONSTRAINT host_age_bin_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: host_food_production_names host_food_production_names_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.host_food_production_names
    ADD CONSTRAINT host_food_production_names_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: hosts hosts_host_age_bin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_age_bin_fkey FOREIGN KEY (host_age_bin) REFERENCES public.host_age_bin(ontology_term_id);


--
-- Name: hosts hosts_host_breed_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_breed_fkey FOREIGN KEY (host_breed) REFERENCES public.host_breeds(id);


--
-- Name: hosts hosts_host_disease_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_disease_fkey FOREIGN KEY (host_disease) REFERENCES public.host_diseases(id);


--
-- Name: hosts hosts_host_food_production_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_food_production_name_fkey FOREIGN KEY (host_food_production_name) REFERENCES public.host_food_production_names(ontology_term_id);


--
-- Name: hosts hosts_host_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_organism_fkey FOREIGN KEY (host_organism) REFERENCES public.host_organisms(id);


--
-- Name: hosts hosts_host_origin_geo_loc_name_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_host_origin_geo_loc_name_country_fkey FOREIGN KEY (host_origin_geo_loc_name_country) REFERENCES public.countries(id);


--
-- Name: hosts hosts_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.hosts
    ADD CONSTRAINT hosts_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: isolates isolates_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: isolates isolates_isolated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_isolated_by_fkey FOREIGN KEY (isolated_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: isolates isolates_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_organism_fkey FOREIGN KEY (organism) REFERENCES public.microbes(id);


--
-- Name: isolates isolates_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: isolates isolates_strain_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_strain_fkey FOREIGN KEY (strain) REFERENCES public.strains(id);


--
-- Name: isolates isolates_taxonomic_identification_process_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_taxonomic_identification_process_fkey FOREIGN KEY (taxonomic_identification_process) REFERENCES public.taxonomic_identification_processes(ontology_term_id);


--
-- Name: laboratory_typing_methods laboratory_typing_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.laboratory_typing_methods
    ADD CONSTRAINT laboratory_typing_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: laboratory_typing_platforms laboratory_typing_platforms_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.laboratory_typing_platforms
    ADD CONSTRAINT laboratory_typing_platforms_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: measurement_sign measurement_sign_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.measurement_sign
    ADD CONSTRAINT measurement_sign_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: measurement_units measurement_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.measurement_units
    ADD CONSTRAINT measurement_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: metagenomic_extractions metagenomic_extractions_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: metagenomic_extractions metagenomic_extractions_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: public_repository_information public_repository_information_attribute_package_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_attribute_package_fkey FOREIGN KEY (attribute_package) REFERENCES public.attribute_packages(ontology_term_id);


--
-- Name: public_repository_information public_repository_information_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: public_repository_information public_repository_information_sequence_submitted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_sequence_submitted_by_fkey FOREIGN KEY (sequence_submitted_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: public_repository_information public_repository_information_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: purposes purposes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.purposes
    ADD CONSTRAINT purposes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: quality_control_determinations quality_control_determinations_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.quality_control_determinations
    ADD CONSTRAINT quality_control_determinations_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: quality_control_issues quality_control_issues_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.quality_control_issues
    ADD CONSTRAINT quality_control_issues_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: residual_sample_status residual_sample_status_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.residual_sample_status
    ADD CONSTRAINT residual_sample_status_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: risk_activity risk_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_id_fkey FOREIGN KEY (id) REFERENCES public.risk_assessment(id);


--
-- Name: risk_activity risk_activity_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.activities(ontology_term_id);


--
-- Name: risk_assessment risk_assessment_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_assessment_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: risk_assessment risk_assessment_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_assessment_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: risk_assessment risk_assessment_stage_of_production_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.risk_assessment
    ADD CONSTRAINT risk_assessment_stage_of_production_fkey FOREIGN KEY (stage_of_production) REFERENCES public.stage_of_production(ontology_term_id);


--
-- Name: sample_activity sample_activity_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_id_fkey FOREIGN KEY (id) REFERENCES public.collection_information(id);


--
-- Name: sample_activity sample_activity_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.activities(ontology_term_id);


--
-- Name: sample_collection_date_precision sample_collection_date_precision_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_collection_date_precision
    ADD CONSTRAINT sample_collection_date_precision_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sample_purposes sample_purposes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purposes_id_fkey FOREIGN KEY (id) REFERENCES public.collection_information(id);


--
-- Name: sample_purposes sample_purposes_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purposes_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.purposes(ontology_term_id);


--
-- Name: samples samples_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: sequencing_assay_types sequencing_assay_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_assay_types
    ADD CONSTRAINT sequencing_assay_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing sequencing_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: sequencing sequencing_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: sequencing sequencing_genomic_target_enrichment_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_genomic_target_enrichment_method_fkey FOREIGN KEY (genomic_target_enrichment_method) REFERENCES public.genomic_target_enrichment_methods(ontology_term_id);


--
-- Name: sequencing_instruments sequencing_instruments_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_instruments
    ADD CONSTRAINT sequencing_instruments_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing_platforms sequencing_platforms_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_platforms
    ADD CONSTRAINT sequencing_platforms_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing_purposes sequencing_purposes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_id_fkey FOREIGN KEY (id) REFERENCES public.sequencing(id);


--
-- Name: sequencing_purposes sequencing_purposes_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.purposes(ontology_term_id);


--
-- Name: sequencing sequencing_sequenced_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequenced_by_fkey FOREIGN KEY (sequenced_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_assay_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_assay_type_fkey FOREIGN KEY (sequencing_assay_type) REFERENCES public.sequencing_assay_types(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_instrument_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_instrument_fkey FOREIGN KEY (sequencing_instrument) REFERENCES public.sequencing_instruments(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_platform_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_platform_fkey FOREIGN KEY (sequencing_platform) REFERENCES public.sequencing_platforms(ontology_term_id);


--
-- Name: specimen_processing specimen_processing_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.specimen_processing
    ADD CONSTRAINT specimen_processing_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: stage_of_production stage_of_production_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.stage_of_production
    ADD CONSTRAINT stage_of_production_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: state_province_regions state_province_regions_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: taxonomic_identification_processes taxonomic_identification_processes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.taxonomic_identification_processes
    ADD CONSTRAINT taxonomic_identification_processes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: temperature_units temperature_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.temperature_units
    ADD CONSTRAINT temperature_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: testing_standard testing_standard_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.testing_standard
    ADD CONSTRAINT testing_standard_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_consensus_sequence_software_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_consensus_sequence_software_fkey FOREIGN KEY (consensus_sequence_software) REFERENCES public.consensus_sequence_software(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_quality_control_determination_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_quality_control_determination_fkey FOREIGN KEY (quality_control_determination) REFERENCES public.quality_control_determinations(ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_quality_control_issues_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_quality_control_issues_fkey FOREIGN KEY (quality_control_issues) REFERENCES public.quality_control_issues(ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_read_mapping_software_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_read_mapping_software_name_fkey FOREIGN KEY (read_mapping_software_name) REFERENCES public.read_mapping_software_names(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_reference_genome_accession_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_reference_genome_accession_fkey FOREIGN KEY (reference_genome_accession) REFERENCES public.reference_genome_accessions(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_sequence_assembly_software_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_sequence_assembly_software_fkey FOREIGN KEY (sequence_assembly_software) REFERENCES public.sequence_assembly_software(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: vendor_names vendor_names_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.vendor_names
    ADD CONSTRAINT vendor_names_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: volume_measurement_units volume_measurement_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.volume_measurement_units
    ADD CONSTRAINT volume_measurement_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: weather_types weather_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.weather_types
    ADD CONSTRAINT weather_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: wgs_extractions wgs_extractions_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: wgs_extractions wgs_extractions_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: gwajnberg
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- PostgreSQL database dump complete
--

