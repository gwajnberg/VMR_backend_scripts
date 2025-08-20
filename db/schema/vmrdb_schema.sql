--
-- PostgreSQL database dump
--

-- Dumped from database version 16.6 (Ubuntu 16.6-1.pgdg22.04+1)
-- Dumped by pg_dump version 17.2 (Ubuntu 17.2-1.pgdg22.04+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: audit; Type: SCHEMA; Schema: -; Owner: grdi
--

CREATE SCHEMA audit;


ALTER SCHEMA audit OWNER TO grdi;

--
-- Name: SCHEMA audit; Type: COMMENT; Schema: -; Owner: grdi
--

COMMENT ON SCHEMA audit IS 'Out-of-table audit/history logging tables and trigger functions';


--
-- Name: bioinf; Type: SCHEMA; Schema: -; Owner: grdi
--

CREATE SCHEMA bioinf;


ALTER SCHEMA bioinf OWNER TO grdi;

--
-- Name: ohe; Type: SCHEMA; Schema: -; Owner: grdi
--

CREATE SCHEMA ohe;


ALTER SCHEMA ohe OWNER TO grdi;

--
-- Name: pbi; Type: SCHEMA; Schema: -; Owner: grdi
--

CREATE SCHEMA pbi;


ALTER SCHEMA pbi OWNER TO grdi;

--
-- Name: hstore; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS hstore WITH SCHEMA public;


--
-- Name: EXTENSION hstore; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION hstore IS 'data type for storing sets of (key, value) pairs';


--
-- Name: curation_flag; Type: TYPE; Schema: public; Owner: grdi
--

CREATE TYPE public.curation_flag AS ENUM (
    'approved',
    'pending',
    'proposed',
    'not approved'
);


ALTER TYPE public.curation_flag OWNER TO grdi;

--
-- Name: status; Type: TYPE; Schema: public; Owner: grdi
--

CREATE TYPE public.status AS ENUM (
    'curated',
    'ok',
    'flagged',
    'not curated'
);


ALTER TYPE public.status OWNER TO grdi;

--
-- Name: log_changes(); Type: FUNCTION; Schema: audit; Owner: grdi
--

CREATE FUNCTION audit.log_changes() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'pg_catalog', 'public'
    AS $_$
DECLARE
    audit_row audit.logged_actions%ROWTYPE; --  Define a rowtype variable, which will be used to insert relevant information
    excluded_cols text[] := ARRAY[]::text[];
    old_row       hstore := hstore(OLD.*) - excluded_cols;
    new_row       hstore := hstore(NEW.*) - excluded_cols;
    row_id        int;
BEGIN
    -- Just raise error if trigger is accidently set to anything other then BEFORE
    IF TG_WHEN <> 'BEFORE' THEN
        RAISE EXCEPTION 'audit.if_modified_func() may only run as a BEFORE trigger';
    END IF;
    -- This IF-ELSE simply retrieves the right id from the table being worked on.
    IF TG_NARGS = 0 THEN -- If no paramter is passed, assume that the row_id is simply "id"
        audit_row.row_id = OLD.id;
    ELSE -- If there is no "id" column in the table, then we must pass the id to log as a parameter to the trigger.
        EXECUTE format('SELECT $1.%I', TG_ARGV[0]) USING OLD INTO row_id;
        audit_row.row_id = row_id;
    END IF;
    -- Set the values of the audit row!
    audit_row.event_id          = nextval('audit.logged_actions_event_id_seq');
    audit_row.schema_name       = TG_TABLE_SCHEMA::text;
    audit_row.table_name        = TG_TABLE_NAME::text;
    audit_row.relid             = TG_RELID;
    audit_row.session_user_name = session_user::text;
    audit_row.action_timestamp  = current_timestamp;
    audit_row.application_name  = current_setting('application_name');
    audit_row.action_type       = substring(TG_OP,1,1);
    audit_row.previous_values   = NULL;
    IF (TG_OP = 'UPDATE') THEN
        audit_row.previous_values = old_row - new_row;
        IF audit_row.previous_values = hstore('') THEN -- If the update results in no changes, then say so
            RAISE EXCEPTION 'Update on table % and row id % results in no change', TG_TABLE_NAME, OLD.id;
            RETURN NULL;
        END IF;
        INSERT INTO audit.logged_actions VALUES (audit_row.*);
        NEW.was_updated := TRUE;
        RETURN NEW;
    ELSIF (TG_OP = 'DELETE') THEN
        audit_row.previous_values = old_row;
        INSERT INTO audit.logged_actions VALUES (audit_row.*);
        RETURN OLD;
    ELSE
        RAISE EXCEPTION '[audit.if_modified_func] - Trigger func added as trigger for unhandled case: %, %',TG_OP, TG_LEVEL;
        RETURN NULL;
    END IF;
END;
$_$;


ALTER FUNCTION audit.log_changes() OWNER TO grdi;

--
-- Name: aggregate_multi_choice_table(text); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.aggregate_multi_choice_table(table_name text) RETURNS TABLE(sample_id integer, vals text)
    LANGUAGE plpgsql
    AS $$
BEGIN
   RETURN QUERY EXECUTE format('
     SELECT sample_id,
  	    string_agg(ontology_full_term(term_id), ''; '') AS terms
       FROM %I 
   GROUP BY sample_id', table_name);
END; 
$$;


ALTER FUNCTION public.aggregate_multi_choice_table(table_name text) OWNER TO grdi;

--
-- Name: bind_ontology(text, text); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.bind_ontology(term text, ont_id text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF   (term IS NULL OR ont_id IS NULL)
      THEN RETURN NULL;
    ELSE
      RETURN concat(term, ' [', ont_id, ']');
    END IF;
  END;
$$;


ALTER FUNCTION public.bind_ontology(term text, ont_id text) OWNER TO grdi;

--
-- Name: ontology_full_term(integer, text); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.ontology_full_term(i integer, lang text DEFAULT 'en'::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    RETURN(
      SELECT CASE WHEN lang = 'en' THEN bind_ontology(o.en_term, o.ontology_id)
                  WHEN lang = 'fr' THEN bind_ontology(o.fr_term, o.ontology_id)
              END
        FROM ontology_terms AS o
       WHERE o.id = i);
  END;
$$;


ALTER FUNCTION public.ontology_full_term(i integer, lang text) OWNER TO grdi;

--
-- Name: ontology_id(integer); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.ontology_id(i integer) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    RETURN(
      SELECT o.ontology_id
        FROM ontology_terms AS o
       WHERE o.id = i);
  END;
$$;


ALTER FUNCTION public.ontology_id(i integer) OWNER TO grdi;

--
-- Name: ontology_term(integer, text); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.ontology_term(i integer, lang text DEFAULT 'en'::text) RETURNS text
    LANGUAGE plpgsql
    AS $$
  BEGIN
    RETURN(
      SELECT CASE WHEN lang = 'en' THEN o.en_term
                  WHEN lang = 'fr' THEN o.fr_term
              END
        FROM ontology_terms AS o
       WHERE o.id = i);
  END;
$$;


ALTER FUNCTION public.ontology_term(i integer, lang text) OWNER TO grdi;

--
-- Name: trigger_set_usertimestamp(); Type: FUNCTION; Schema: public; Owner: grdi
--

CREATE FUNCTION public.trigger_set_usertimestamp() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        NEW.updated_at := current_timestamp;
        NEW.updated_by := current_user;
        RETURN NEW;
    END;
$$;


ALTER FUNCTION public.trigger_set_usertimestamp() OWNER TO grdi;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: logged_actions; Type: TABLE; Schema: audit; Owner: grdi
--

CREATE TABLE audit.logged_actions (
    event_id bigint NOT NULL,
    schema_name text NOT NULL,
    table_name text NOT NULL,
    relid oid NOT NULL,
    row_id integer NOT NULL,
    session_user_name text NOT NULL,
    application_name text,
    action_type text NOT NULL,
    action_timestamp timestamp with time zone NOT NULL,
    previous_values public.hstore,
    CONSTRAINT logged_actions_action_type_check CHECK ((action_type = ANY (ARRAY['D'::text, 'U'::text])))
);


ALTER TABLE audit.logged_actions OWNER TO grdi;

--
-- Name: logged_actions_event_id_seq; Type: SEQUENCE; Schema: audit; Owner: grdi
--

CREATE SEQUENCE audit.logged_actions_event_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE audit.logged_actions_event_id_seq OWNER TO grdi;

--
-- Name: logged_actions_event_id_seq; Type: SEQUENCE OWNED BY; Schema: audit; Owner: grdi
--

ALTER SEQUENCE audit.logged_actions_event_id_seq OWNED BY audit.logged_actions.event_id;


--
-- Name: digis_elements; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.digis_elements (
    id integer NOT NULL,
    sequencing_id integer,
    seqid text,
    source text,
    type text,
    start integer,
    "end" integer,
    score double precision,
    strand text,
    phase text,
    element_id text,
    level text,
    qid text,
    qstart integer,
    qend integer,
    blast_score double precision,
    evalue text,
    orf_similarity double precision,
    is_similarity double precision,
    genbank_class text,
    CONSTRAINT digis_elements_strand_check CHECK ((strand = ANY (ARRAY['+'::text, '-'::text])))
);


ALTER TABLE bioinf.digis_elements OWNER TO grdi;

--
-- Name: digis_elements_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.digis_elements ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.digis_elements_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: ecoli_serotyping; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.ecoli_serotyping (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    ecoli_serotype text,
    htype text,
    otype text
);


ALTER TABLE bioinf.ecoli_serotyping OWNER TO grdi;

--
-- Name: ecoli_serotyping_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.ecoli_serotyping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.ecoli_serotyping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: iceberg_blastn_genome; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.iceberg_blastn_genome (
    id integer NOT NULL,
    sequencing_id integer,
    sequence text,
    start integer,
    "end" integer,
    strand text,
    iceberg_id text,
    coverage_range text,
    gaps text,
    percent_coverage double precision,
    percent_identity double precision,
    database text,
    accession text,
    product text,
    description text,
    CONSTRAINT iceberg_blastn_genome_strand_check CHECK ((strand = ANY (ARRAY['+'::text, '-'::text])))
);


ALTER TABLE bioinf.iceberg_blastn_genome OWNER TO grdi;

--
-- Name: iceberg_blastn_genome_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.iceberg_blastn_genome ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.iceberg_blastn_genome_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: iceberg_blastp_genes; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.iceberg_blastp_genes (
    id integer NOT NULL,
    sequencing_id integer,
    sequence text,
    start integer,
    "end" integer,
    strand text,
    iceberg_id text,
    coverage_range text,
    gaps text,
    percent_coverage double precision,
    percent_identity double precision,
    database text,
    accession text,
    product text,
    description text,
    CONSTRAINT iceberg_blastp_genes_strand_check CHECK ((strand = ANY (ARRAY['+'::text, '-'::text])))
);


ALTER TABLE bioinf.iceberg_blastp_genes OWNER TO grdi;

--
-- Name: iceberg_blastp_genes_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.iceberg_blastp_genes ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.iceberg_blastp_genes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: integron_finder; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.integron_finder (
    id integer NOT NULL,
    sequencing_id integer,
    id_replicon text NOT NULL,
    calin integer NOT NULL,
    complete integer NOT NULL,
    in0 integer NOT NULL,
    topology text NOT NULL,
    size integer NOT NULL
);


ALTER TABLE bioinf.integron_finder OWNER TO grdi;

--
-- Name: integron_finder_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.integron_finder ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.integron_finder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: island_path; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.island_path (
    id integer NOT NULL,
    sequencing_id integer,
    start_position integer,
    end_position integer
);


ALTER TABLE bioinf.island_path OWNER TO grdi;

--
-- Name: island_path_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.island_path ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.island_path_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: kleborate; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.kleborate (
    id integer NOT NULL,
    sequencing_id integer,
    species text,
    species_match text,
    contig_count integer,
    n50 integer,
    largest_contig integer,
    total_size bigint,
    ambiguous_bases text,
    qc_warnings text,
    mlst_st text,
    clonal_complex text,
    gapa text,
    infb text,
    mdh text,
    pgi text,
    phoe text,
    rpob text,
    tonb text,
    ybst text,
    yersiniabactin text,
    ybts text,
    ybtx text,
    ybtq text,
    ybtp text,
    ybta text,
    irp2 text,
    irp1 text,
    ybtu text,
    ybtt text,
    ybte text,
    fyua text,
    spurious_ybt_hits text,
    cbst text,
    colibactin text,
    clba text,
    clbb text,
    clbc text,
    clbd text,
    clbe text,
    clbf text,
    clbg text,
    clbh text,
    clbi text,
    clbl text,
    clbm text,
    clbn text,
    clbo text,
    clbp text,
    clbq text,
    spurious_clb_hits text,
    abst text,
    aerobactin text,
    iuca text,
    iucb text,
    iucc text,
    iucd text,
    iuta text,
    spurious_abst_hits text,
    smst text,
    salmochelin text,
    irob text,
    iroc text,
    irod text,
    iron text,
    spurious_smst_hits text,
    rmst text,
    rmpadc text,
    rmpa text,
    rmpd text,
    rmpc text,
    spurious_rmst_hits text,
    rmpa2 text,
    virulence_score text,
    spurious_resistance_hits text,
    agly_acquired text,
    col_acquired text,
    fcyn_acquired text,
    flq_acquired text,
    gly_acquired text,
    mls_acquired text,
    phe_acquired text,
    rif_acquired text,
    sul_acquired text,
    tet_acquired text,
    tgc_acquired text,
    tmt_acquired text,
    bla_acquired text,
    bla_inhr_acquired text,
    bla_esbl_acquired text,
    bla_esbl_inhr_acquired text,
    bla_carb_acquired text,
    bla_chr text,
    shv_mutations text,
    omp_mutations text,
    col_mutations text,
    wzi text,
    k_locus text,
    k_type text,
    k_locus_confidence text,
    k_locus_problems text,
    k_locus_identity text,
    k_missing_expected_genes text,
    o_locus text,
    o_type text,
    o_locus_confidence text,
    o_locus_problems text,
    o_locus_identity text,
    o_missing_expected_genes text,
    resistance_score text,
    num_resistance_classes integer,
    num_resistance_genes integer,
    truncated_resistance_hits text,
    flq_mutations text
);


ALTER TABLE bioinf.kleborate OWNER TO grdi;

--
-- Name: kleborate_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.kleborate ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.kleborate_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mlst; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.mlst (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    mlst_sequence text,
    mlst_scheme text
);


ALTER TABLE bioinf.mlst OWNER TO grdi;

--
-- Name: mlst_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.mlst ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.mlst_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: mob_rgi; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.mob_rgi (
    id integer NOT NULL,
    sequencing_id integer,
    orf_id text,
    contig text,
    start integer,
    stop integer,
    orientation text,
    cut_off text,
    pass_bitscore double precision,
    best_hit_bitscore double precision,
    best_hit_aro text,
    best_identities double precision,
    aro text,
    model_type text,
    snps_in_best_hit_aro text,
    other_snps text,
    drug_class text,
    resistance_mechanism text,
    amr_gene_families text,
    predicted_dna text,
    predicted_protein text,
    card_protein_sequence text,
    percentage_length_of_reference_sequence double precision,
    hsp_id text,
    model_id text,
    nudged text,
    note text,
    hit_start integer,
    hit_end integer,
    antibiotic text,
    molecule_type text,
    primary_cluster_id text,
    secondary_cluster_id text,
    size integer,
    gc double precision,
    md5 text,
    circularity_status text,
    rep_type text,
    rep_type_accessions text,
    relaxase_type text,
    relaxase_type_accessions text,
    mpf_type text,
    mpf_type_accessions text,
    orit_type text,
    orit_accessions text,
    amr_predicted_mobility text,
    mash_nearest_neighbor text,
    mash_neighbor_distance double precision,
    mash_neighbor_identification text,
    repetitive_dna_id text,
    repetitive_dna_type text,
    filtering_reason text
);


ALTER TABLE bioinf.mob_rgi OWNER TO grdi;

--
-- Name: mob_rgi_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.mob_rgi ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.mob_rgi_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: plasmid_finder; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.plasmid_finder (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    plasmid text
);


ALTER TABLE bioinf.plasmid_finder OWNER TO grdi;

--
-- Name: plasmid_finder_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.plasmid_finder ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.plasmid_finder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: refseq_masher; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.refseq_masher (
    id integer NOT NULL,
    sequencing_id integer,
    sample text,
    top_taxonomy_name text,
    distance double precision,
    pvalue double precision,
    matching text,
    full_taxonomy text,
    taxonomic_subspecies text,
    taxonomic_species text,
    taxonomic_genus text,
    taxonomic_family text,
    taxonomic_order text,
    taxonomic_class text,
    taxonomic_phylum text,
    taxonomic_superkingdom text,
    subspecies text,
    serovar text,
    plasmid text,
    bioproject text,
    biosample text,
    taxid integer,
    assembly_accession text,
    match_id text
);


ALTER TABLE bioinf.refseq_masher OWNER TO grdi;

--
-- Name: refseq_masher_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.refseq_masher ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.refseq_masher_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: resfinder; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.resfinder (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    resfinder_gene text
);


ALTER TABLE bioinf.resfinder OWNER TO grdi;

--
-- Name: resfinder_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.resfinder ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.resfinder_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: resfinder_predicted_phenotypes; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.resfinder_predicted_phenotypes (
    resfinder_id integer NOT NULL,
    predicted_phenotype text NOT NULL
);


ALTER TABLE bioinf.resfinder_predicted_phenotypes OWNER TO grdi;

--
-- Name: salmonella_serotyping; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.salmonella_serotyping (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    serovar text,
    serovar_antigen text,
    serogroup text,
    o_antigen text,
    h2 text,
    h1 text,
    genome text
);


ALTER TABLE bioinf.salmonella_serotyping OWNER TO grdi;

--
-- Name: salmonella_serotyping_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.salmonella_serotyping ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.salmonella_serotyping_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: virulence_vf; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.virulence_vf (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    vf_gene text,
    vf_protein_function text
);


ALTER TABLE bioinf.virulence_vf OWNER TO grdi;

--
-- Name: virulence_vf_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.virulence_vf ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.virulence_vf_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: virulence_vfdb; Type: TABLE; Schema: bioinf; Owner: grdi
--

CREATE TABLE bioinf.virulence_vfdb (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
    gene_accession text,
    product_resistance text
);


ALTER TABLE bioinf.virulence_vfdb OWNER TO grdi;

--
-- Name: virulence_vfdb_id_seq; Type: SEQUENCE; Schema: bioinf; Owner: grdi
--

ALTER TABLE bioinf.virulence_vfdb ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME bioinf.virulence_vfdb_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: countries; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.countries (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.countries OWNER TO grdi;

--
-- Name: samples; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.samples (
    id integer NOT NULL,
    project_id integer,
    sample_collector_sample_id text NOT NULL,
    original_sample_description text,
    sample_collected_by integer,
    contact_information integer,
    sample_collection_date date,
    sample_collection_date_precision integer,
    collection_device integer,
    collection_method integer,
    specimen_processing integer,
    presampling_activity_details text,
    geo_loc_name_country integer,
    geo_loc_name_state_province_region integer,
    geo_loc_name_site text,
    geo_loc_latitude numeric(8,6),
    geo_loc_longitude numeric(9,6),
    sample_storage_method text,
    sample_storage_medium text,
    specimen_processing_details text,
    sample_received_date date,
    sample_collection_end_date date,
    sample_processing_date date,
    sample_collection_start_time time without time zone,
    sample_collection_end_time time without time zone,
    sample_collection_time_of_day integer,
    sample_collection_time_duration_value integer,
    sample_collection_time_duration_unit integer,
    food_product_production_stream integer,
    food_product_origin_geo_loc_name_country integer,
    food_packaging_date date,
    food_quality_date date,
    anatomical_region integer,
    host_organism integer,
    host_ecotype text,
    host_breed text,
    host_food_production_name integer,
    host_disease text,
    host_age_bin integer,
    host_origin_geo_loc_name_country integer,
    air_temperature double precision,
    air_temperature_units integer,
    water_temperature double precision,
    water_temperature_units integer,
    sediment_depth double precision,
    sediment_depth_units integer,
    water_depth integer,
    water_depth_units integer,
    available_data_type_details text,
    precipitation_measurement_value text,
    precipitation_measurement_unit integer,
    precipitation_measurement_method text,
    prevalence_metrics text,
    prevalence_metrics_details text,
    stage_of_production integer,
    experimental_intervention_details text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    experimental_protocol_field text,
    experimental_specimen_role_type integer,
    sample_volume_measurement_value double precision,
    sample_volume_measurement_unit integer,
    sample_storage_duration_value double precision,
    sample_storage_duration_unit integer,
    residual_sample_status integer
);


ALTER TABLE public.samples OWNER TO grdi;

--
-- Name: state_province_regions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.state_province_regions (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    country_id integer,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    region text
);


ALTER TABLE public.state_province_regions OWNER TO grdi;

--
-- Name: country_state; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.country_state AS
 SELECT sam.id AS sample_id,
    concat_ws(':'::text, cnt.en_term, states.en_term) AS geo_loc_name
   FROM ((public.samples sam
     LEFT JOIN public.countries cnt ON ((sam.geo_loc_name_country = cnt.id)))
     LEFT JOIN public.state_province_regions states ON ((sam.geo_loc_name_state_province_region = states.id)));


ALTER VIEW ohe.country_state OWNER TO grdi;

--
-- Name: host_organisms; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.host_organisms (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    scientific_name text,
    en_common_name text,
    fr_common_name text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.host_organisms OWNER TO grdi;

--
-- Name: host_organism; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.host_organism AS
 SELECT sam.id AS sample_id,
    org.ontology_id,
    org.scientific_name,
    org.en_common_name
   FROM (public.samples sam
     LEFT JOIN public.host_organisms org ON ((sam.host_organism = org.id)));


ALTER VIEW ohe.host_organism OWNER TO grdi;

--
-- Name: isolation_source; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.isolation_source AS
 WITH all_sources AS (
         SELECT org.sample_id,
            public.bind_ontology(org.scientific_name, org.ontology_id) AS terms
           FROM (public.samples
             LEFT JOIN ohe.host_organism org ON ((samples.id = org.sample_id)))
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('environmental_data_site'::text) aggregate_multi_choice_table(sample_id, vals)
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('anatomical_data_material'::text) aggregate_multi_choice_table(sample_id, vals)
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('anatomical_data_body'::text) aggregate_multi_choice_table(sample_id, vals)
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('anatomical_data_part'::text) aggregate_multi_choice_table(sample_id, vals)
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('food_data_product'::text) aggregate_multi_choice_table(sample_id, vals)
        UNION
         SELECT aggregate_multi_choice_table.sample_id,
            aggregate_multi_choice_table.vals
           FROM public.aggregate_multi_choice_table('food_data_product_property'::text) aggregate_multi_choice_table(sample_id, vals)
        )
 SELECT sample_id,
    string_agg(terms, '; '::text) AS isolation_source
   FROM all_sources
  WHERE (terms !~~ 'Not %'::text)
  GROUP BY sample_id;


ALTER VIEW ohe.isolation_source OWNER TO grdi;

--
-- Name: source_type; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.source_type AS
 SELECT h.sample_id,
        CASE
            WHEN (h.scientific_name = 'Homo sapiens'::text) THEN 'Human'::text
            WHEN (f.vals IS NOT NULL) THEN 'Food'::text
            WHEN (h.scientific_name <> 'Homo sapiens'::text) THEN 'Animal'::text
            ELSE 'Environmental'::text
        END AS source_type
   FROM (ohe.host_organism h
     LEFT JOIN public.aggregate_multi_choice_table('food_data_product'::text) f(sample_id, vals) ON (((h.sample_id = f.sample_id) AND (f.vals !~~ 'Not %'::text))));


ALTER VIEW ohe.source_type OWNER TO grdi;

--
-- Name: extractions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.extractions (
    id integer NOT NULL,
    nucleic_acid_extraction_method text,
    nucleic_acid_extraction_kit text,
    nucleic_acid_storage_duration_value double precision,
    nucleic_acid_storage_duration_unit integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.extractions OWNER TO grdi;

--
-- Name: isolates; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.isolates (
    id integer NOT NULL,
    sample_id integer NOT NULL,
    isolate_id text NOT NULL,
    organism integer,
    strain text,
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
    phagetype text,
    irida_sample_id integer,
    irida_project_id integer,
    biosample_id text,
    bioproject_id text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.isolates OWNER TO grdi;

--
-- Name: public_repository_information; Type: TABLE; Schema: public; Owner: grdi
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
    attribute_package integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.public_repository_information OWNER TO grdi;

--
-- Name: sequencing; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequencing (
    id integer NOT NULL,
    extraction_id integer NOT NULL,
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
    r1_fastq_filename text,
    r2_fastq_filename text,
    fast5_filename text,
    genome_sequence_filename text,
    r1_irida_id integer,
    r2_irida_id integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sequencing_date date
);


ALTER TABLE public.sequencing OWNER TO grdi;

--
-- Name: wgs_extractions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.wgs_extractions (
    isolate_id integer NOT NULL,
    extraction_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    updated_at timestamp with time zone,
    updated_by text
);


ALTER TABLE public.wgs_extractions OWNER TO grdi;

--
-- Name: wgs; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.wgs AS
 SELECT wgs.isolate_id,
    iso.irida_sample_id,
    ext.id AS extraction_id,
    seq.id AS sequencing_id,
    seq.library_id,
    ext.nucleic_acid_extraction_method,
    ext.nucleic_acid_extraction_kit,
    ext.nucleic_acid_storage_duration_value,
    ext.nucleic_acid_storage_duration_unit,
    seq.contact_information,
    seq.sequenced_by,
    seq.sequencing_date,
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
    seq.r1_fastq_filename,
    seq.r2_fastq_filename,
    seq.fast5_filename,
    seq.genome_sequence_filename,
    seq.r1_irida_id,
    seq.r2_irida_id
   FROM (((public.wgs_extractions wgs
     LEFT JOIN public.extractions ext ON ((wgs.extraction_id = ext.id)))
     LEFT JOIN public.sequencing seq ON ((ext.id = seq.extraction_id)))
     LEFT JOIN public.isolates iso ON ((iso.id = wgs.isolate_id)));


ALTER VIEW public.wgs OWNER TO grdi;

--
-- Name: wgs_by_isolate; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.wgs_by_isolate AS
 WITH wgs_w_project AS (
         SELECT iso.id AS isolate_id,
            wgs.sequencing_id,
            public.ontology_full_term(wgs.sequenced_by) AS sequenced_by,
            pri.bioproject_accession
           FROM ((public.isolates iso
             LEFT JOIN public.wgs wgs ON ((wgs.isolate_id = iso.id)))
             LEFT JOIN public.public_repository_information pri ON ((wgs.sequencing_id = pri.sequencing_id)))
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


ALTER VIEW ohe.wgs_by_isolate OWNER TO grdi;

--
-- Name: microbes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.microbes (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    scientific_name text,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.microbes OWNER TO grdi;

--
-- Name: projects; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    sample_plan_id text,
    sample_plan_name text,
    project_name text,
    description text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.projects OWNER TO grdi;

--
-- Name: collection_information_fields; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.collection_information_fields AS
 SELECT iso.id AS isolate_id,
    sam.id AS sample_id,
    microbes.scientific_name AS organism,
    public.ontology_full_term(sam.sample_collected_by) AS collected_by,
    sam.sample_collection_date AS collection_date,
    iso.isolation_date AS cult_isol_date,
    country.geo_loc_name,
    source.isolation_source,
    src_type.source_type,
    public.ontology_full_term(sam.collection_device) AS samp_collect_device,
    sp.vals AS purpose_of_sampling,
    pro.project_name,
    concat_ws(' | '::text, sam.geo_loc_latitude, sam.geo_loc_longitude) AS lat_lon,
    iso.serovar,
    seq.sequenced_by
   FROM ((((((((public.isolates iso
     LEFT JOIN public.samples sam ON ((iso.sample_id = sam.id)))
     LEFT JOIN public.microbes ON ((iso.organism = microbes.id)))
     LEFT JOIN ohe.country_state country ON ((sam.id = country.sample_id)))
     LEFT JOIN public.projects pro ON ((sam.project_id = pro.id)))
     LEFT JOIN public.aggregate_multi_choice_table('sample_purposes'::text) sp(sample_id, vals) ON ((sam.id = sp.sample_id)))
     LEFT JOIN ohe.wgs_by_isolate seq ON ((iso.id = seq.isolate_id)))
     LEFT JOIN ohe.source_type src_type ON ((sam.id = src_type.sample_id)))
     LEFT JOIN ohe.isolation_source source ON ((sam.id = source.sample_id)));


ALTER VIEW ohe.collection_information_fields OWNER TO grdi;

--
-- Name: environmental_data_site; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_site (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_site OWNER TO grdi;

--
-- Name: ontology_terms; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.ontology_terms (
    id integer NOT NULL,
    ontology_id text NOT NULL,
    en_term text,
    fr_term text,
    en_description text,
    fr_description text,
    curated boolean DEFAULT true,
    deprecated boolean DEFAULT false,
    replaced_by integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.ontology_terms OWNER TO grdi;

--
-- Name: fac_type_and_local_scale; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.fac_type_and_local_scale AS
 SELECT sam.id AS sample_id,
    string_agg(
        CASE
            WHEN (ont.ontology_id = ANY (ARRAY['ENVO:01000925'::text, 'ENVO:00003862'::text, 'ENVO:01001448'::text, 'ENVO:00002221'::text, 'ENVO:03501396'::text, 'ENVO:01000984'::text, 'ENVO:0350142'::text])) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS facility_type,
    string_agg(
        CASE
            WHEN (ont.ontology_id = ANY (ARRAY['ENVO:00000114'::text, 'ENVO:00000314'::text, 'ENVO:03501406'::text, 'ENVO:03501441'::text, 'ENVO:03501405'::text, 'ENVO:00000078'::text, 'ENVO:03501443'::text, 'ENVO:03501384'::text, 'ENVO:03501416'::text, 'ENVO:01000627'::text, 'ENVO:03501444'::text, 'ENVO:00000294'::text, 'ENVO:03501417'::text, 'ENVO:01000306'::text, 'ENVO:01001873'::text, 'ENVO:01001874'::text, 'ENVO:00000020'::text, 'ENVO:03501423'::text, 'ENVO:01001872'::text, 'ENVO:01000320'::text, 'ENVO:03501440'::text, 'ENVO:00000208'::text, 'ENVO:00000562'::text, 'ENVO:00000033'::text, 'ENVO:00000025'::text, 'ENVO:00000450'::text, 'ENVO:00000022'::text, 'ENVO:03501439'::text, 'ENVO:01000772'::text, 'ENVO:03501438'::text, 'ENVO:00000023'::text, 'ENVO:00000495'::text, 'ENVO:01001191'::text, 'ENVO:00000109'::text])) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS env_local_scale
   FROM ((public.samples sam
     JOIN public.environmental_data_site site ON ((sam.id = site.sample_id)))
     LEFT JOIN public.ontology_terms ont ON ((site.term_id = ont.id)))
  GROUP BY sam.id;


ALTER VIEW ohe.fac_type_and_local_scale OWNER TO grdi;

--
-- Name: sample_activity; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sample_activity (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.sample_activity OWNER TO grdi;

--
-- Name: fertilizer_admin; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.fertilizer_admin AS
 SELECT sam.id AS sample_id,
    sam.presampling_activity_details AS fertilizer_admin
   FROM (public.sample_activity sa
     LEFT JOIN public.samples sam ON ((sam.id = sa.sample_id)))
  WHERE (sa.term_id = ( SELECT ontology_terms.id
           FROM public.ontology_terms
          WHERE (ontology_terms.ontology_id = 'GENEPIO:0100543'::text)));


ALTER VIEW ohe.fertilizer_admin OWNER TO grdi;

--
-- Name: environmental_data_material; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_material (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_material OWNER TO grdi;

--
-- Name: geo_feat_and_medium; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.geo_feat_and_medium AS
 WITH vals(ont) AS (
         VALUES ('AGRO:00000671'::text), ('GENEPIO:0100896'::text), ('AGRO:00000673'::text), ('GENEPIO:0100897'::text), ('AGRO:00000674'::text), ('ENVO:03501379'::text), ('AGRO:00000675'::text), ('AGRO:00000679'::text), ('AGRO:00000680'::text), ('AGRO:00000676'::text), ('AGRO:00000677'::text), ('NCIT:C49844'::text), ('GSSO:012935'::text), ('OBI:0002806'::text), ('ENVO:03501431'::text), ('ENVO:03501379'::text), ('AGRO:00000678'::text), ('AGRO:00000672'::text), ('ENVO:03501430'::text), ('ENVO:03501400'::text), ('AGRO:00000670'::text), ('NCIT:C49947'::text), ('ENVO:03501415'::text), ('ENVO:03501414'::text), ('AGRO:00000669'::text)
        )
 SELECT sam.id AS sample_id,
    string_agg(
        CASE
            WHEN (ont.ontology_id IN ( SELECT vals.ont
               FROM vals)) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS coll_site_geo_feat,
    string_agg(
        CASE
            WHEN (NOT (ont.ontology_id IN ( SELECT vals.ont
               FROM vals))) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS env_medium
   FROM ((public.samples sam
     JOIN public.environmental_data_material mat ON ((mat.sample_id = sam.id)))
     LEFT JOIN public.ontology_terms ont ON ((mat.term_id = ont.id)))
  GROUP BY sam.id;


ALTER VIEW ohe.geo_feat_and_medium OWNER TO grdi;

--
-- Name: environmental_fields; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.environmental_fields AS
 SELECT iso.id AS isolate_id,
    sam.id AS sample_id,
    fac.facility_type,
    feat.coll_site_geo_feat,
    fac.env_local_scale,
    feat.env_medium,
    fert.fertilizer_admin
   FROM ((((public.isolates iso
     LEFT JOIN public.samples sam ON ((iso.sample_id = sam.id)))
     LEFT JOIN ohe.fac_type_and_local_scale fac ON ((sam.id = fac.sample_id)))
     LEFT JOIN ohe.geo_feat_and_medium feat ON ((sam.id = feat.sample_id)))
     LEFT JOIN ohe.fertilizer_admin fert ON ((sam.id = fert.sample_id)));


ALTER VIEW ohe.environmental_fields OWNER TO grdi;

--
-- Name: food_data_product_property; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_data_product_property (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.food_data_product_property OWNER TO grdi;

--
-- Name: food_process_and_preserve; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.food_process_and_preserve AS
 SELECT sam.id AS sample_id,
    string_agg(
        CASE
            WHEN (ont.ontology_id <> ALL (ARRAY['FOODON:03510128'::text, 'FOODON:00002418'::text, 'FOODON:03307539'::text, 'FOODON:03302148'::text])) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS food_processing_method,
    string_agg(
        CASE
            WHEN (ont.ontology_id = ANY (ARRAY['FOODON:00002418'::text, 'FOODON:03307539'::text, 'FOODON:03302148'::text])) THEN public.bind_ontology(ont.en_term, ont.ontology_id)
            ELSE NULL::text
        END, '; '::text) AS food_preserv_proc
   FROM ((public.food_data_product_property prop
     LEFT JOIN public.samples sam ON ((sam.id = prop.sample_id)))
     LEFT JOIN public.ontology_terms ont ON ((prop.term_id = ont.id)))
  GROUP BY sam.id;


ALTER VIEW ohe.food_process_and_preserve OWNER TO grdi;

--
-- Name: food_fields; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.food_fields AS
 SELECT iso.id AS isolate_id,
    sam.id AS sample_id,
    countries.en_term AS food_origin,
    source.vals AS food_source,
    proc.food_processing_method,
    proc.food_preserv_proc,
    public.ontology_full_term(sam.food_product_production_stream) AS food_prod,
    product.vals AS food_product_type,
    pack.vals AS food_contain_wrap,
    sam.food_quality_date
   FROM ((((((public.isolates iso
     LEFT JOIN public.samples sam ON ((sam.id = iso.sample_id)))
     LEFT JOIN public.countries ON ((sam.food_product_origin_geo_loc_name_country = countries.id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_source'::text) source(sample_id, vals) ON ((sam.id = source.sample_id)))
     LEFT JOIN ohe.food_process_and_preserve proc ON ((sam.id = proc.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_product'::text) product(sample_id, vals) ON ((sam.id = product.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_packaging'::text) pack(sample_id, vals) ON ((sam.id = pack.sample_id)));


ALTER VIEW ohe.food_fields OWNER TO grdi;

--
-- Name: host; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.host AS
 SELECT org.sample_id,
        CASE
            WHEN (org.ontology_id IS NOT NULL) THEN public.bind_ontology(org.en_common_name, org.ontology_id)
            ELSE public.bind_ontology(fd_prod.en_term, fd_prod.ontology_id)
        END AS host
   FROM ((ohe.host_organism org
     LEFT JOIN public.samples sam ON ((org.sample_id = sam.id)))
     LEFT JOIN public.ontology_terms fd_prod ON ((sam.host_food_production_name = fd_prod.id)));


ALTER VIEW ohe.host OWNER TO grdi;

--
-- Name: host_am; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.host_am AS
 SELECT sam.id AS sample_id,
    sam.presampling_activity_details AS host_am
   FROM (public.sample_activity sa
     LEFT JOIN public.samples sam ON ((sa.sample_id = sam.id)))
  WHERE (sa.term_id = ( SELECT ontology_terms.id
           FROM public.ontology_terms
          WHERE (ontology_terms.ontology_id = 'GENEPIO:0100537'::text)));


ALTER VIEW ohe.host_am OWNER TO grdi;

--
-- Name: host_housing; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.host_housing AS
 SELECT site.sample_id,
    string_agg(public.bind_ontology(ont.en_term, ont.ontology_id), '; '::text) AS host_housing
   FROM ((public.environmental_data_site site
     LEFT JOIN public.samples sam ON ((sam.id = site.sample_id)))
     LEFT JOIN public.ontology_terms ont ON ((site.term_id = ont.id)))
  WHERE (ont.ontology_id = ANY (ARRAY['ENVO:01000922'::text, 'ENVO:00002196'::text, 'ENVO:00000073'::text, 'ENVO:03501257'::text, 'ENVO:03501383'::text, 'ENVO:03501385'::text, 'ENVO:03501413'::text, 'ENVO:03501387'::text, 'EOL:0001903'::text, 'ENVO:01001874'::text, 'ENVO:03501439'::text, 'ENVO:03501372'::text, 'ENVO:03501386'::text]))
  GROUP BY site.sample_id;


ALTER VIEW ohe.host_housing OWNER TO grdi;

--
-- Name: host_fields; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.host_fields AS
 SELECT iso.id AS isolate_id,
    sam.id AS sample_id,
    host_col.host,
    public.ontology_full_term(sam.host_age_bin) AS host_age,
    sam.host_disease,
    env_site.vals AS environmental_site,
    ana_mat.vals AS host_tissue_sampled,
    body_prod.vals AS host_body_product,
    sam.host_ecotype AS host_variety,
    sam.host_breed AS host_animal_breed,
    risk.vals AS upstream_intervention,
    host_am.host_am,
    housing.host_housing
   FROM ((((((((public.isolates iso
     LEFT JOIN public.samples sam ON ((iso.sample_id = sam.id)))
     LEFT JOIN ohe.host host_col ON ((sam.id = host_col.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_site'::text) env_site(sample_id, vals) ON ((sam.id = env_site.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('anatomical_data_material'::text) ana_mat(sample_id, vals) ON ((sam.id = ana_mat.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('anatomical_data_part'::text) body_prod(sample_id, vals) ON ((sam.id = body_prod.sample_id)))
     LEFT JOIN public.aggregate_multi_choice_table('risk_activity'::text) risk(sample_id, vals) ON ((sam.id = risk.sample_id)))
     LEFT JOIN ohe.host_am host_am ON ((sam.id = host_am.sample_id)))
     LEFT JOIN ohe.host_housing housing ON ((sam.id = housing.sample_id)));


ALTER VIEW ohe.host_fields OWNER TO grdi;

--
-- Name: alternative_isolate_ids; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.alternative_isolate_ids (
    isolate_id integer NOT NULL,
    alternative_isolate_id text NOT NULL,
    note text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.alternative_isolate_ids OWNER TO grdi;

--
-- Name: alt_iso_wide; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.alt_iso_wide AS
 SELECT isolate_id,
    string_agg(alternative_isolate_id, '; '::text) AS alt_isolate_names
   FROM public.alternative_isolate_ids
  GROUP BY isolate_id;


ALTER VIEW public.alt_iso_wide OWNER TO grdi;

--
-- Name: sample_identification_fields; Type: VIEW; Schema: ohe; Owner: grdi
--

CREATE VIEW ohe.sample_identification_fields AS
 SELECT iso.id AS isolate_id,
    iso.isolate_id AS sample_name,
    sam.id AS sample_id,
    seq.bioproject_accession,
    COALESCE(iso.strain, iso.isolate_id) AS strain,
    alt_iso_wide.alt_isolate_names AS isolate_name_alias
   FROM (((public.isolates iso
     LEFT JOIN public.samples sam ON ((iso.sample_id = sam.id)))
     LEFT JOIN ohe.wgs_by_isolate seq ON ((iso.id = seq.isolate_id)))
     LEFT JOIN public.alt_iso_wide ON ((alt_iso_wide.isolate_id = iso.id)));


ALTER VIEW ohe.sample_identification_fields OWNER TO grdi;

--
-- Name: one_health_enterics_export; Type: VIEW; Schema: ohe; Owner: grdi
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


ALTER VIEW ohe.one_health_enterics_export OWNER TO grdi;

--
-- Name: activities; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.activities (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.activities OWNER TO grdi;

--
-- Name: agencies; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.agencies (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.agencies OWNER TO grdi;

--
-- Name: alternative_sample_ids; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.alternative_sample_ids (
    sample_id integer NOT NULL,
    alternative_sample_id text NOT NULL,
    note text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.alternative_sample_ids OWNER TO grdi;

--
-- Name: possible_isolate_names; Type: VIEW; Schema: public; Owner: grdi
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


ALTER VIEW public.possible_isolate_names OWNER TO grdi;

--
-- Name: possible_sample_names; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.possible_sample_names AS
 SELECT sam.id AS sample_id,
    sam.sample_collector_sample_id AS user_sample_id,
    'Assigned as main sample ID'::text AS note
   FROM public.samples sam
UNION ALL
 SELECT alt.sample_id,
    alt.alternative_sample_id AS user_sample_id,
    alt.note
   FROM public.alternative_sample_ids alt
  ORDER BY 1;


ALTER VIEW public.possible_sample_names OWNER TO grdi;

--
-- Name: projects_samples_isolates; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.projects_samples_isolates AS
 SELECT pro.id AS project_id,
    pro.sample_plan_id,
    pro.sample_plan_name,
    pro.project_name,
    pro.description,
    sam.id AS sample_id,
    sam.sample_collector_sample_id,
    iso.id AS isolate_id,
    iso.isolate_id AS user_isolate_id,
    iso.biosample_id AS biosample_accession,
    iso.bioproject_id AS bioproject_accession,
    iso.irida_project_id,
    iso.irida_sample_id,
    iso.organism,
    iso.strain,
    iso.microbiological_method,
    iso.progeny_isolate_id,
    iso.isolated_by,
    iso.contact_information,
    iso.isolation_date,
    iso.isolate_received_date,
    iso.taxonomic_identification_process,
    iso.taxonomic_identification_process_details,
    iso.serovar,
    iso.serotyping_method,
    iso.phagetype
   FROM ((public.projects pro
     LEFT JOIN public.samples sam ON ((sam.project_id = pro.id)))
     LEFT JOIN public.isolates iso ON ((iso.sample_id = sam.id)));


ALTER VIEW public.projects_samples_isolates OWNER TO grdi;

--
-- Name: all_possible_ids; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.all_possible_ids AS
 SELECT psi.project_id,
    psi.sample_id,
    iso.isolate_id,
    NULL::integer AS sequencing_id,
    'isolate ID'::text AS id_type,
    iso.isolate_collector_id AS identifier,
    iso.note
   FROM (public.possible_isolate_names iso
     LEFT JOIN public.projects_samples_isolates psi ON ((psi.isolate_id = iso.isolate_id)))
UNION
 SELECT psi.project_id,
    sam.sample_id,
    NULL::integer AS isolate_id,
    NULL::integer AS sequencing_id,
    'sample ID'::text AS id_type,
    sam.user_sample_id AS identifier,
    sam.note
   FROM (public.possible_sample_names sam
     LEFT JOIN public.projects_samples_isolates psi ON ((psi.sample_id = sam.sample_id)))
UNION
 SELECT psi.project_id,
    psi.sample_id,
    wgs.isolate_id,
    wgs.sequencing_id,
    'library ID'::text AS id_type,
    wgs.library_id AS identifier,
    NULL::text AS note
   FROM (public.wgs
     LEFT JOIN public.projects_samples_isolates psi ON ((psi.isolate_id = wgs.isolate_id)))
  WHERE (wgs.library_id IS NOT NULL);


ALTER VIEW public.all_possible_ids OWNER TO grdi;

--
-- Name: alt_sample_wide; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.alt_sample_wide AS
 SELECT sample_id,
    string_agg(alternative_sample_id, '; '::text) AS alternative_sample_ids
   FROM public.alternative_sample_ids
  GROUP BY sample_id;


ALTER VIEW public.alt_sample_wide OWNER TO grdi;

--
-- Name: am_susceptibility_tests; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.am_susceptibility_tests (
    id integer NOT NULL,
    isolate_id integer NOT NULL,
    amr_testing_by integer,
    testing_date date,
    contact_information integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.am_susceptibility_tests OWNER TO grdi;

--
-- Name: am_susceptibility_tests_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: amr_antibiotics_profile; Type: TABLE; Schema: public; Owner: grdi
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
    vendor_name integer,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.amr_antibiotics_profile OWNER TO grdi;

--
-- Name: amr_antibiotics_profile_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: anatomical_data_body; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_data_body (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_body OWNER TO grdi;

--
-- Name: anatomical_data_material; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_data_material (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_material OWNER TO grdi;

--
-- Name: anatomical_data_part; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_data_part (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.anatomical_data_part OWNER TO grdi;

--
-- Name: anatomical_materials; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_materials (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.anatomical_materials OWNER TO grdi;

--
-- Name: anatomical_parts; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_parts (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.anatomical_parts OWNER TO grdi;

--
-- Name: anatomical_regions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.anatomical_regions (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.anatomical_regions OWNER TO grdi;

--
-- Name: animal_or_plant_populations; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.animal_or_plant_populations (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.animal_or_plant_populations OWNER TO grdi;

--
-- Name: animal_source_of_food; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.animal_source_of_food (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.animal_source_of_food OWNER TO grdi;

--
-- Name: antimicrobial_agents; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.antimicrobial_agents (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.antimicrobial_agents OWNER TO grdi;

--
-- Name: antimicrobial_phenotypes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.antimicrobial_phenotypes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.antimicrobial_phenotypes OWNER TO grdi;

--
-- Name: attribute_packages; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.attribute_packages (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.attribute_packages OWNER TO grdi;

--
-- Name: available_data_types; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.available_data_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.available_data_types OWNER TO grdi;

--
-- Name: body_products; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.body_products (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.body_products OWNER TO grdi;

--
-- Name: collection_devices; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.collection_devices (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.collection_devices OWNER TO grdi;

--
-- Name: collection_methods; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.collection_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.collection_methods OWNER TO grdi;

--
-- Name: consensus_sequence_software; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.consensus_sequence_software (
    id integer NOT NULL,
    name text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.consensus_sequence_software OWNER TO grdi;

--
-- Name: consensus_sequence_software_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: contact_information; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.contact_information (
    id integer NOT NULL,
    laboratory_name text DEFAULT 'Not Provided [GENEPIO:0001668]'::text NOT NULL,
    contact_name text NOT NULL,
    contact_email text DEFAULT 'Not Provided [GENEPIO:0001668]'::text NOT NULL,
    note text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.contact_information OWNER TO grdi;

--
-- Name: contact_information_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: countries_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: foreign_keys; Type: MATERIALIZED VIEW; Schema: public; Owner: grdi
--

CREATE MATERIALIZED VIEW public.foreign_keys AS
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
  WHERE (((tc.constraint_type)::text = 'FOREIGN KEY'::text) AND ((tc.table_schema)::name = 'public'::name))
  WITH NO DATA;


ALTER MATERIALIZED VIEW public.foreign_keys OWNER TO grdi;

--
-- Name: country_cols; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.country_cols AS
 SELECT table_name,
    column_name
   FROM public.foreign_keys
  WHERE (((foreign_table_name)::name = 'countries'::name) AND ((table_name)::name <> 'state_province_regions'::name));


ALTER VIEW public.country_cols OWNER TO grdi;

--
-- Name: db_versions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.db_versions (
    major_release integer NOT NULL,
    minor_release integer NOT NULL,
    script_name text NOT NULL,
    grdi_template_version text,
    date_applied date NOT NULL,
    note text
);


ALTER TABLE public.db_versions OWNER TO grdi;

--
-- Name: depth_units; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.depth_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.depth_units OWNER TO grdi;

--
-- Name: duration_units; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.duration_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.duration_units OWNER TO grdi;

--
-- Name: environmental_data_animal_plant; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_animal_plant (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_animal_plant OWNER TO grdi;

--
-- Name: environmental_data_available_data_type; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_available_data_type (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_available_data_type OWNER TO grdi;

--
-- Name: environmental_data_material_constituents; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_material_constituents (
    term_id text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_material_constituents OWNER TO grdi;

--
-- Name: environmental_data_presampling_weather_conditions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_presampling_weather_conditions (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_presampling_weather_conditions OWNER TO grdi;

--
-- Name: environmental_data_sampling_weather_conditions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_data_sampling_weather_conditions (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.environmental_data_sampling_weather_conditions OWNER TO grdi;

--
-- Name: environmental_materials; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_materials (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.environmental_materials OWNER TO grdi;

--
-- Name: environmental_sites; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.environmental_sites (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.environmental_sites OWNER TO grdi;

--
-- Name: experimental_specimen_role_types; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.experimental_specimen_role_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.experimental_specimen_role_types OWNER TO grdi;

--
-- Name: extractions_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: food_data_label_claims; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_data_label_claims (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.food_data_label_claims OWNER TO grdi;

--
-- Name: food_data_packaging; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_data_packaging (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.food_data_packaging OWNER TO grdi;

--
-- Name: food_data_product; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_data_product (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.food_data_product OWNER TO grdi;

--
-- Name: food_data_source; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_data_source (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.food_data_source OWNER TO grdi;

--
-- Name: food_packaging; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_packaging (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.food_packaging OWNER TO grdi;

--
-- Name: food_product_production_streams; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_product_production_streams (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.food_product_production_streams OWNER TO grdi;

--
-- Name: food_product_properties; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_product_properties (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.food_product_properties OWNER TO grdi;

--
-- Name: food_products; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.food_products (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.food_products OWNER TO grdi;

--
-- Name: full_sample_metadata; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.full_sample_metadata AS
 WITH mat_const AS (
         SELECT environmental_data_material_constituents.sample_id,
            string_agg(environmental_data_material_constituents.term_id, '; '::text) AS vals
           FROM public.environmental_data_material_constituents
          GROUP BY environmental_data_material_constituents.sample_id
        )
 SELECT sam.id AS sample_id,
    sam.sample_collector_sample_id,
    alt.alternative_sample_ids,
    pro.project_name AS sample_collection_project_name,
    pro.description AS project_description,
    pro.sample_plan_id,
    pro.sample_plan_name,
    sam.original_sample_description,
    public.ontology_full_term(sam.sample_collected_by) AS sample_collected_by,
    contacts.contact_name AS sample_collector_contact_name,
    contacts.contact_email AS sample_collector_contact_email,
    contacts.laboratory_name AS sample_collected_by_laboratory_name,
    sam.sample_collection_date,
    sam.sample_collection_end_date,
    sam.sample_collection_start_time,
    sam.sample_collection_end_time,
    public.ontology_full_term(sam.sample_collection_time_of_day) AS sample_collection_time_of_day,
    sam.sample_collection_time_duration_value,
    public.ontology_full_term(sam.sample_collection_time_duration_unit) AS sample_collection_time_duration_unit,
    public.ontology_full_term(sam.sample_collection_date_precision) AS sample_collection_date_precision,
    activities.vals AS presampling_activity,
    sam.presampling_activity_details,
    purposes.vals AS purpose_of_sampling,
    sam.sample_received_date,
    public.ontology_full_term(sam.specimen_processing) AS specimen_processing,
    sam.specimen_processing_details,
    sam.sample_storage_method,
    sam.sample_storage_medium,
    public.ontology_full_term(sam.collection_device) AS collection_device,
    public.ontology_full_term(sam.collection_method) AS collection_method,
    sam.sample_processing_date,
    sam.experimental_protocol_field,
    public.ontology_full_term(sam.experimental_specimen_role_type) AS experimental_specimen_role_type,
    sam.sample_volume_measurement_value,
    public.ontology_full_term(sam.sample_volume_measurement_unit) AS sample_volume_measurement_unit,
    sam.sample_storage_duration_value,
    public.ontology_full_term(sam.sample_storage_duration_unit) AS sample_storage_duration_unit,
    sam.residual_sample_status,
    public.bind_ontology(cnt.en_term, cnt.ontology_id) AS geo_loc_name_country,
    public.bind_ontology(sta.en_term, sta.ontology_id) AS geo_loc_name_state_province_region,
    sam.geo_loc_latitude,
    sam.geo_loc_longitude,
    sam.geo_loc_name_site,
    public.ontology_full_term(sam.anatomical_region) AS anatomical_region,
    body.vals AS body_product,
    material.vals AS anatomical_material,
    part.vals AS anatomical_part,
    public.bind_ontology(food_origin.en_term, food_origin.ontology_id) AS food_product_origin_geo_loc_name_country,
    public.ontology_full_term(sam.food_product_production_stream) AS food_product_production_stream,
    sam.food_packaging_date,
    sam.food_quality_date,
    claims.vals AS label_claim,
    packaging.vals AS food_packaging,
    products.vals AS food_product,
    properties.vals AS food_product_properties,
    sources.vals AS animal_source_of_food,
    sam.air_temperature,
    public.ontology_full_term(sam.air_temperature_units) AS air_temperature_units,
    sam.water_depth,
    public.ontology_full_term(sam.water_depth_units) AS water_depth_units,
    sam.water_temperature,
    public.ontology_full_term(sam.water_temperature_units) AS water_temperature_units,
    sam.sediment_depth,
    public.ontology_full_term(sam.sediment_depth_units) AS sediment_depth_units,
    sam.available_data_type_details,
    avail_type.vals AS available_data_types,
    aniplant.vals AS animal_or_plant_population,
    mat.vals AS environmental_material,
    mat_const.vals AS environmental_material_constituent,
    site.vals AS environmental_site,
    sample_weather.vals AS sampling_weather_conditions,
    presample_weather.vals AS presampling_weather_conditions,
    sam.precipitation_measurement_value,
    public.ontology_full_term(sam.precipitation_measurement_unit) AS precipitation_measurement_unit,
    sam.precipitation_measurement_method,
    public.bind_ontology(org.en_common_name, org.ontology_id) AS host_common_name,
    public.bind_ontology(org.scientific_name, org.ontology_id) AS host_scientific_name,
    sam.host_ecotype,
    sam.host_breed,
    public.ontology_full_term(sam.host_food_production_name) AS host_food_production_name,
    sam.host_disease,
    public.ontology_full_term(sam.host_age_bin) AS host_age_bin,
    public.bind_ontology(cnt.en_term, cnt.ontology_id) AS host_origin_geo_loc_name_country,
    sam.prevalence_metrics,
    sam.prevalence_metrics_details,
    sam.stage_of_production,
    risk_activity.vals AS experimental_intervention,
    sam.experimental_intervention_details
   FROM ((((((((((((((((((((((((((public.samples sam
     LEFT JOIN public.projects pro ON ((pro.id = sam.project_id)))
     LEFT JOIN public.alt_sample_wide alt ON ((alt.sample_id = sam.id)))
     LEFT JOIN public.contact_information contacts ON ((contacts.id = sam.contact_information)))
     LEFT JOIN public.aggregate_multi_choice_table('sample_activity'::text) activities(sample_id, vals) ON ((activities.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('sample_purposes'::text) purposes(sample_id, vals) ON ((purposes.sample_id = sam.id)))
     LEFT JOIN public.countries cnt ON ((cnt.id = sam.geo_loc_name_country)))
     LEFT JOIN public.state_province_regions sta ON ((sta.id = sam.geo_loc_name_state_province_region)))
     LEFT JOIN public.aggregate_multi_choice_table('anatomical_data_body'::text) body(sample_id, vals) ON ((body.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('anatomical_data_material'::text) material(sample_id, vals) ON ((material.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('anatomical_data_part'::text) part(sample_id, vals) ON ((part.sample_id = sam.id)))
     LEFT JOIN public.countries food_origin ON ((food_origin.id = sam.food_product_origin_geo_loc_name_country)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_label_claims'::text) claims(sample_id, vals) ON ((claims.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_packaging'::text) packaging(sample_id, vals) ON ((packaging.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_product'::text) products(sample_id, vals) ON ((products.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_product_property'::text) properties(sample_id, vals) ON ((properties.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('food_data_source'::text) sources(sample_id, vals) ON ((sources.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_animal_plant'::text) aniplant(sample_id, vals) ON ((aniplant.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_available_data_type'::text) avail_type(sample_id, vals) ON ((avail_type.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_material'::text) mat(sample_id, vals) ON ((mat.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_site'::text) site(sample_id, vals) ON ((site.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_sampling_weather_conditions'::text) sample_weather(sample_id, vals) ON ((sample_weather.sample_id = sam.id)))
     LEFT JOIN public.aggregate_multi_choice_table('environmental_data_presampling_weather_conditions'::text) presample_weather(sample_id, vals) ON ((presample_weather.sample_id = sam.id)))
     LEFT JOIN mat_const ON ((mat_const.sample_id = sam.id)))
     LEFT JOIN public.host_organisms org ON ((org.id = sam.host_organism)))
     LEFT JOIN public.countries host_cnt ON ((host_cnt.id = sam.host_origin_geo_loc_name_country)))
     LEFT JOIN public.aggregate_multi_choice_table('risk_activity'::text) risk_activity(sample_id, vals) ON ((risk_activity.sample_id = sam.id)));


ALTER VIEW public.full_sample_metadata OWNER TO grdi;

--
-- Name: genomic_target_enrichment_methods; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.genomic_target_enrichment_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.genomic_target_enrichment_methods OWNER TO grdi;

--
-- Name: host_age_bin; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.host_age_bin (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.host_age_bin OWNER TO grdi;

--
-- Name: host_food_production_names; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.host_food_production_names (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.host_food_production_names OWNER TO grdi;

--
-- Name: host_organisms_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: isolates_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: isolates_wide; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.isolates_wide AS
 SELECT iso.id AS isolate_id,
    iso.sample_id,
    iso.isolate_id AS user_isolate_id,
    alt.alt_isolate_names AS alternative_isolate_ids,
    iso.strain,
    public.bind_ontology(org.scientific_name, org.ontology_id) AS organism,
    iso.microbiological_method,
    iso.progeny_isolate_id,
    public.ontology_full_term(iso.isolated_by) AS isolated_by,
    con.contact_name AS isolated_by_contact_name,
    con.contact_email AS isolated_by_contact_email,
    con.laboratory_name AS isolated_by_lab_name,
    iso.isolation_date,
    iso.isolate_received_date,
    public.ontology_full_term(iso.taxonomic_identification_process) AS taxonomic_identification_process,
    iso.taxonomic_identification_process_details,
    iso.serovar,
    iso.serotyping_method,
    iso.phagetype,
    iso.irida_project_id,
    iso.irida_sample_id,
    iso.bioproject_id,
    iso.biosample_id
   FROM (((public.isolates iso
     LEFT JOIN public.alt_iso_wide alt ON ((alt.isolate_id = iso.id)))
     LEFT JOIN public.microbes org ON ((org.id = iso.organism)))
     LEFT JOIN public.contact_information con ON ((con.id = iso.contact_information)));


ALTER VIEW public.isolates_wide OWNER TO grdi;

--
-- Name: wgs_wide; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.wgs_wide AS
 SELECT wgs.isolate_id,
    wgs.irida_sample_id,
    wgs.library_id AS user_library_id,
    wgs.nucleic_acid_extraction_method,
    wgs.nucleic_acid_extraction_kit,
    wgs.nucleic_acid_storage_duration_value,
    public.ontology_full_term(wgs.nucleic_acid_storage_duration_unit) AS nucleic_acid_storage_duration_unit,
    public.ontology_full_term(wgs.sequenced_by) AS sequenced_by,
    wgs.sequencing_date,
    con.contact_name AS sequenced_by_contact_name,
    con.contact_email AS sequenced_by_contact_email,
    con.laboratory_name AS sequenced_by_laboratory_name,
    wgs.sequencing_project_name,
    public.ontology_full_term(wgs.sequencing_platform) AS sequencing_platform,
    public.ontology_full_term(wgs.sequencing_instrument) AS sequencing_instrument,
    public.ontology_full_term(wgs.sequencing_assay_type) AS sequencing_assay_type,
    wgs.dna_fragment_length,
    public.ontology_full_term(wgs.genomic_target_enrichment_method) AS genomic_target_enrichment_method,
    wgs.genomic_target_enrichment_method_details,
    wgs.amplicon_pcr_primer_scheme,
    wgs.amplicon_size,
    wgs.sequencing_flow_cell_version,
    wgs.library_preparation_kit,
    wgs.sequencing_protocol,
    wgs.r1_fastq_filename,
    wgs.r2_fastq_filename,
    wgs.fast5_filename,
    wgs.genome_sequence_filename,
    wgs.r1_irida_id,
    wgs.r2_irida_id
   FROM (public.wgs
     LEFT JOIN public.contact_information con ON ((con.id = wgs.contact_information)));


ALTER VIEW public.wgs_wide OWNER TO grdi;

--
-- Name: kleb_view; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.kleb_view AS
 SELECT (iso.irida_sample_id)::text AS irida_sample_id,
    prov.region,
    EXTRACT(year FROM sam.sample_collection_date) AS collection_year,
    iso.organism,
    iso.user_isolate_id,
    wgs.user_library_id,
    wide.host_common_name,
    wide.host_scientific_name,
    wide.environmental_material,
    wide.environmental_site,
    wide.food_product,
    wide.body_product,
    wide.anatomical_part
   FROM ((((public.wgs_wide wgs
     LEFT JOIN public.isolates_wide iso ON ((iso.isolate_id = wgs.isolate_id)))
     LEFT JOIN public.samples sam ON ((sam.id = iso.sample_id)))
     LEFT JOIN public.state_province_regions prov ON ((prov.id = sam.geo_loc_name_state_province_region)))
     LEFT JOIN public.full_sample_metadata wide ON ((wide.sample_id = sam.id)));


ALTER VIEW public.kleb_view OWNER TO grdi;

--
-- Name: label_claims; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.label_claims (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.label_claims OWNER TO grdi;

--
-- Name: laboratory_typing_methods; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.laboratory_typing_methods (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.laboratory_typing_methods OWNER TO grdi;

--
-- Name: laboratory_typing_platforms; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.laboratory_typing_platforms (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.laboratory_typing_platforms OWNER TO grdi;

--
-- Name: latest_version; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.latest_version AS
 SELECT ((major_release || '.'::text) || lpad((minor_release)::text, 2, '0'::text)) AS db_ver,
    grdi_template_version AS template_ver,
    date_applied,
    note
   FROM public.db_versions
  ORDER BY major_release DESC, minor_release DESC
 LIMIT 1;


ALTER VIEW public.latest_version OWNER TO grdi;

--
-- Name: measurement_sign; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.measurement_sign (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.measurement_sign OWNER TO grdi;

--
-- Name: measurement_units; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.measurement_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.measurement_units OWNER TO grdi;

--
-- Name: metagenomic_extractions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.metagenomic_extractions (
    sample_id integer NOT NULL,
    extraction_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.metagenomic_extractions OWNER TO grdi;

--
-- Name: microbes_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: n_isos_and_seqs_by_microbe; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.n_isos_and_seqs_by_microbe AS
 WITH n_iso AS (
         SELECT m.scientific_name,
            count(m.scientific_name) AS n_isolates
           FROM (public.isolates
             LEFT JOIN public.microbes m ON ((m.id = isolates.organism)))
          GROUP BY m.scientific_name
        ), n_seq AS (
         SELECT m.scientific_name,
            count(m.scientific_name) AS n_seqs
           FROM ((public.wgs
             LEFT JOIN public.isolates i ON ((i.id = wgs.isolate_id)))
             LEFT JOIN public.microbes m ON ((m.id = i.organism)))
          GROUP BY m.scientific_name
        )
 SELECT n_iso.scientific_name,
    n_iso.n_isolates,
    COALESCE(n_seq.n_seqs, (0)::bigint) AS n_seqs
   FROM (n_iso
     FULL JOIN n_seq ON ((n_iso.scientific_name = n_seq.scientific_name)))
  ORDER BY n_iso.n_isolates DESC;


ALTER VIEW public.n_isos_and_seqs_by_microbe OWNER TO grdi;

--
-- Name: n_sam_iso_seq; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.n_sam_iso_seq AS
 SELECT count(DISTINCT psi.project_id) AS n_projects,
    count(DISTINCT psi.sample_id) AS n_samples,
    count(DISTINCT psi.isolate_id) AS n_isolates,
    count(DISTINCT wgs.sequencing_id) AS n_sequences
   FROM (public.projects_samples_isolates psi
     LEFT JOIN public.wgs ON ((wgs.isolate_id = psi.isolate_id)));


ALTER VIEW public.n_sam_iso_seq OWNER TO grdi;

--
-- Name: ncbi_antibiogram_format; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.ncbi_antibiogram_format AS
 WITH amr AS (
         SELECT i.id AS isolate_id,
            i.isolate_id AS user_isolate_id,
            public.ontology_term(amr_1.antimicrobial_agent) AS ab,
            public.ontology_id(amr_1.antimicrobial_phenotype) AS pheno,
            public.ontology_id(amr_1.measurement_sign) AS sign,
            amr_1.measurement,
            public.ontology_id(amr_1.measurement_units) AS units,
            public.ontology_id(amr_1.laboratory_typing_method) AS typing,
            public.ontology_id(amr_1.laboratory_typing_platform) AS platform,
            public.ontology_id(amr_1.vendor_name) AS vendor,
            public.ontology_id(amr_1.testing_standard) AS standard,
            amr_1.laboratory_typing_platform_version AS laboratory_typing_method_version_or_reagent
           FROM ((public.isolates i
             JOIN public.am_susceptibility_tests tests ON ((i.id = tests.isolate_id)))
             JOIN public.amr_antibiotics_profile amr_1 ON ((amr_1.test_id = tests.id)))
        )
 SELECT user_isolate_id AS sample_name,
        CASE
            WHEN (ab = 'Polymyxin B'::text) THEN 'polymyxin B'::text
            ELSE lower(ab)
        END AS antibiotic,
        CASE
            WHEN (pheno = 'ARO:3004301'::text) THEN 'resistant'::text
            WHEN (pheno = 'ARO:3004302'::text) THEN 'susceptible'::text
            WHEN (pheno = 'ARO:3004300'::text) THEN 'intermediate'::text
            WHEN (pheno = 'ARO:3004303'::text) THEN 'nonsusceptible'::text
            WHEN (pheno = 'GENEPIO:0002040'::text) THEN 'not defined'::text
            WHEN (pheno = 'GENEPIO:0100585'::text) THEN 'not defined'::text
            WHEN (pheno = 'ARO:3004304'::text) THEN 'susceptible-dose dependent'::text
            ELSE NULL::text
        END AS resistance_phenotype,
        CASE
            WHEN (sign = 'GENEPIO:0001002'::text) THEN '<'::text
            WHEN (sign = 'GENEPIO:0001003'::text) THEN '<='::text
            WHEN (sign = 'GENEPIO:0001004'::text) THEN '=='::text
            WHEN (sign = 'GENEPIO:0001006'::text) THEN '>'::text
            WHEN (sign = 'GENEPIO:0001005'::text) THEN '>='::text
            ELSE NULL::text
        END AS measurement_sign,
        CASE
            WHEN ((ab = 'Amoxicillin-clavulanic acid'::text) AND (standard = 'ARO:3004366'::text)) THEN concat(measurement, '/', (measurement / (2)::double precision))
            WHEN ((ab = 'Amoxicillin-clavulanic acid'::text) AND (standard = 'ARO:3004368'::text)) THEN concat(measurement, '/', 2)
            WHEN ((ab = 'Trimethoprim-sulfamethoxazole'::text) AND (standard = 'ARO:3004366'::text)) THEN concat(measurement, '/', round(((measurement * (19)::double precision))::numeric, 2))
            ELSE (measurement)::text
        END AS measurement,
        CASE
            WHEN (units = 'UO:0000273'::text) THEN 'mg/L'::text
            WHEN (units = 'UO:0000016'::text) THEN 'mm'::text
            WHEN (units = 'UO:0000274'::text) THEN 'mg/L'::text
            ELSE NULL::text
        END AS measurement_units,
        CASE
            WHEN (typing = 'NCIT:85595'::text) THEN 'disk diffusion'::text
            WHEN (typing = 'NCIT:85596'::text) THEN 'e-test'::text
            WHEN (typing = 'ARO:3004411'::text) THEN 'agar dilution'::text
            WHEN (typing = 'ARO:3004397'::text) THEN 'MIC'::text
            ELSE NULL::text
        END AS laboratory_typing_method,
        CASE
            WHEN (platform = 'ARO:3007569'::text) THEN 'BIOMIC'::text
            WHEN (platform = 'ARO:3004400'::text) THEN 'Microscan'::text
            WHEN (platform = 'ARO:3004401'::text) THEN 'Phoenix'::text
            WHEN (platform = 'ARO:3004402'::text) THEN 'Sensititre'::text
            WHEN (platform = 'ARO:3004403'::text) THEN 'Vitek'::text
            ELSE NULL::text
        END AS laboratory_typing_platform,
        CASE
            WHEN (vendor = 'ARO:3004405'::text) THEN 'Becton Dickinson'::text
            WHEN (vendor = 'ARO:3004406'::text) THEN 'Biomérieux'::text
            WHEN (vendor = 'ARO:3004408'::text) THEN 'Omron'::text
            WHEN (vendor = 'ARO:3004407'::text) THEN 'Siemens'::text
            WHEN (vendor = 'ARO:3004409'::text) THEN 'Trek'::text
            ELSE NULL::text
        END AS vendor,
    laboratory_typing_method_version_or_reagent,
        CASE
            WHEN (standard = 'ARO:3004365'::text) THEN 'BSAC'::text
            WHEN (standard = 'ARO:3004366'::text) THEN 'CLSI'::text
            WHEN (standard = 'ARO:3004367'::text) THEN 'DIN'::text
            WHEN (standard = 'ARO:3004368'::text) THEN 'EUCAST'::text
            WHEN (standard = 'ARO:3007195'::text) THEN 'NARMS'::text
            WHEN (standard = 'ARO:3007193'::text) THEN 'NCCLS'::text
            WHEN (standard = 'ARO:3004369'::text) THEN 'SFM'::text
            WHEN (standard = 'ARO:3007397'::text) THEN 'SIR'::text
            WHEN (standard = 'ARO:3007398'::text) THEN 'WRG'::text
            ELSE 'missing'::text
        END AS testing_standard
   FROM amr;


ALTER VIEW public.ncbi_antibiogram_format OWNER TO grdi;

--
-- Name: ncbi_wgs_export; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.ncbi_wgs_export AS
 WITH sel AS (
         SELECT isolates.biosample_id,
            wgs.isolate_id,
            wgs.library_id,
            microbes.scientific_name AS organism,
            public.ontology_id(wgs.sequencing_platform) AS platform,
            public.ontology_term(wgs.sequencing_instrument) AS instrument,
            wgs.sequencing_assay_type,
            public.ontology_id(wgs.sequencing_assay_type) AS assay_type_id,
            wgs.r1_fastq_filename,
            wgs.r2_fastq_filename,
            wgs.fast5_filename,
            wgs.r1_irida_id,
            wgs.r2_irida_id
           FROM ((public.wgs
             LEFT JOIN public.isolates ON ((isolates.id = wgs.isolate_id)))
             LEFT JOIN public.microbes ON ((isolates.organism = microbes.id)))
        )
 SELECT biosample_id AS biosample_accession,
    library_id AS "library_ID",
    concat(public.ontology_term(sequencing_assay_type), ' of ', organism) AS title,
        CASE
            WHEN (assay_type_id = 'OBI:0002117'::text) THEN 'WGS'::text
            WHEN ((assay_type_id = 'OBI:0002763'::text) OR (assay_type_id = 'OBI:0002767'::text)) THEN 'AMPLICON'::text
            WHEN ((assay_type_id = 'OBI:0002623'::text) OR (assay_type_id = 'OBI:0002768'::text)) THEN 'OTHER'::text
            ELSE NULL::text
        END AS library_strategy,
        CASE
            WHEN ((assay_type_id = 'OBI:0002117'::text) OR (assay_type_id = 'OBI:0002763'::text) OR (assay_type_id = 'OBI:0002767'::text)) THEN 'GENOMIC'::text
            WHEN (assay_type_id = 'OBI:0002623'::text) THEN 'MEAGENOMIC'::text
            WHEN (assay_type_id = 'OBI:0002768'::text) THEN 'VIRAL RNA'::text
            ELSE NULL::text
        END AS library_source,
        CASE
            WHEN ((assay_type_id = 'OBI:0002117'::text) OR (assay_type_id = 'OBI:0002623'::text) OR (assay_type_id = 'OBI:0002768'::text)) THEN 'RANDOM'::text
            WHEN ((assay_type_id = 'OBI:0002763'::text) OR (assay_type_id = 'OBI:0002767'::text)) THEN 'PCR'::text
            ELSE NULL::text
        END AS library_selection,
        CASE
            WHEN ((r1_fastq_filename IS NOT NULL) AND (r2_fastq_filename IS NOT NULL)) THEN 'paired'::text
            ELSE 'single'::text
        END AS library_layout,
        CASE
            WHEN (platform = 'GENEPIO:0001923'::text) THEN 'ILLUMINA'::text
            WHEN (platform = 'GENEPIO:0001927'::text) THEN 'PACBIO_SMRT'::text
            WHEN (platform = 'GENEPIO:0002683'::text) THEN 'ION_TORRENT'::text
            WHEN (platform = 'OBI:0002755'::text) THEN 'OXFORD_NANOPORE'::text
            WHEN (platform = 'GENEPIO:0004324'::text) THEN 'BGISEQ'::text
            WHEN (platform = 'GENEPIO:0004325'::text) THEN 'DNBSEQ'::text
            ELSE NULL::text
        END AS platform,
        CASE
            WHEN (instrument IS NOT NULL) THEN instrument
            ELSE 'Unspecified'::text
        END AS instrument_model,
    NULL::text AS design_description,
        CASE
            WHEN (r1_fastq_filename IS NOT NULL) THEN 'fastq'::text
            WHEN (fast5_filename IS NOT NULL) THEN 'OxfordNanopore_native'::text
            ELSE NULL::text
        END AS filetype,
        CASE
            WHEN (r1_fastq_filename IS NOT NULL) THEN r1_fastq_filename
            WHEN (fast5_filename IS NOT NULL) THEN fast5_filename
            ELSE NULL::text
        END AS filename,
        CASE
            WHEN (r2_fastq_filename IS NOT NULL) THEN r2_fastq_filename
            ELSE NULL::text
        END AS filename2,
    NULL::text AS filename3,
    NULL::text AS filename4,
    NULL::text AS assembly,
    NULL::text AS fasta_file,
    r1_irida_id,
    r2_irida_id
   FROM sel
  WHERE ((r1_fastq_filename IS NOT NULL) OR (r2_fastq_filename IS NOT NULL) OR (fast5_filename IS NOT NULL));


ALTER VIEW public.ncbi_wgs_export OWNER TO grdi;

--
-- Name: ontology_columns; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.ontology_columns AS
 SELECT table_name,
    column_name
   FROM public.foreign_keys
  WHERE ((foreign_table_name)::name IN ( SELECT foreign_keys_1.table_name
           FROM public.foreign_keys foreign_keys_1
          WHERE ((foreign_keys_1.foreign_table_name)::name = 'ontology_terms'::name)));


ALTER VIEW public.ontology_columns OWNER TO grdi;

--
-- Name: ontology_terms_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: project_stats; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.project_stats AS
SELECT
    NULL::integer AS "Project Database ID",
    NULL::text AS "Sample plan ID",
    NULL::text AS "Sample plan name",
    NULL::text AS "Project name",
    NULL::bigint AS "Number of Samples",
    NULL::bigint AS "Number of Isolates",
    NULL::bigint AS "Number of WGS",
    NULL::bigint AS "Number of AST";


ALTER VIEW public.project_stats OWNER TO grdi;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: public_repository_information_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: purposes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.purposes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.purposes OWNER TO grdi;

--
-- Name: quality_control_determinations; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.quality_control_determinations (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.quality_control_determinations OWNER TO grdi;

--
-- Name: quality_control_issues; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.quality_control_issues (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.quality_control_issues OWNER TO grdi;

--
-- Name: read_mapping_software_names; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.read_mapping_software_names (
    id integer NOT NULL,
    name text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.read_mapping_software_names OWNER TO grdi;

--
-- Name: read_mapping_software_names_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: reference_genome_accessions; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.reference_genome_accessions (
    id integer NOT NULL,
    accession text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.reference_genome_accessions OWNER TO grdi;

--
-- Name: reference_genome_accessions_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: residual_sample_status; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.residual_sample_status (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.residual_sample_status OWNER TO grdi;

--
-- Name: risk_activity; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.risk_activity (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.risk_activity OWNER TO grdi;

--
-- Name: sample_collection_date_precision; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sample_collection_date_precision (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sample_collection_date_precision OWNER TO grdi;

--
-- Name: sample_metadata_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
--

ALTER TABLE public.samples ALTER COLUMN id ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.sample_metadata_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: sample_purposes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sample_purposes (
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false,
    sample_id integer NOT NULL
);


ALTER TABLE public.sample_purposes OWNER TO grdi;

--
-- Name: sequence_assembly_software; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequence_assembly_software (
    id integer NOT NULL,
    name text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sequence_assembly_software OWNER TO grdi;

--
-- Name: sequence_assembly_software_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: sequencing_assay_types; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequencing_assay_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sequencing_assay_types OWNER TO grdi;

--
-- Name: sequencing_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: sequencing_instruments; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequencing_instruments (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sequencing_instruments OWNER TO grdi;

--
-- Name: sequencing_platforms; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequencing_platforms (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sequencing_platforms OWNER TO grdi;

--
-- Name: sequencing_purposes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.sequencing_purposes (
    id integer NOT NULL,
    term_id integer NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.sequencing_purposes OWNER TO grdi;

--
-- Name: specimen_processing; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.specimen_processing (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.specimen_processing OWNER TO grdi;

--
-- Name: stage_of_production; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.stage_of_production (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.stage_of_production OWNER TO grdi;

--
-- Name: state_province_regions_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: taxonomic_identification_processes; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.taxonomic_identification_processes (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.taxonomic_identification_processes OWNER TO grdi;

--
-- Name: temperature_units; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.temperature_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.temperature_units OWNER TO grdi;

--
-- Name: template_mapping; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.template_mapping (
    id integer NOT NULL,
    grdi_group text,
    grdi_field text,
    vmr_table text,
    vmr_field text,
    is_lookup boolean,
    is_multi_choice boolean,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.template_mapping OWNER TO grdi;

--
-- Name: template_mapping_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: testing_standard; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.testing_standard (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.testing_standard OWNER TO grdi;

--
-- Name: time_of_day; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.time_of_day (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.time_of_day OWNER TO grdi;

--
-- Name: user_bioinformatic_analyses; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.user_bioinformatic_analyses (
    id integer NOT NULL,
    sequencing_id integer NOT NULL,
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
    read_mapping_criteria text,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.user_bioinformatic_analyses OWNER TO grdi;

--
-- Name: user_bioinformatic_analyses_id_seq; Type: SEQUENCE; Schema: public; Owner: grdi
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
-- Name: vendor_names; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.vendor_names (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.vendor_names OWNER TO grdi;

--
-- Name: volume_measurement_units; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.volume_measurement_units (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.volume_measurement_units OWNER TO grdi;

--
-- Name: weather_types; Type: TABLE; Schema: public; Owner: grdi
--

CREATE TABLE public.weather_types (
    ontology_term_id integer NOT NULL,
    curated boolean DEFAULT true,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL,
    inserted_by text DEFAULT CURRENT_USER NOT NULL,
    was_updated boolean DEFAULT false
);


ALTER TABLE public.weather_types OWNER TO grdi;

--
-- Name: wgs_full_wide_metadata; Type: VIEW; Schema: public; Owner: grdi
--

CREATE VIEW public.wgs_full_wide_metadata AS
 SELECT iso.user_isolate_id,
    iso.alternative_isolate_ids,
    sam.sample_collector_sample_id,
    wgs.user_library_id,
    wgs.nucleic_acid_extraction_method,
    wgs.nucleic_acid_extraction_kit,
    wgs.nucleic_acid_storage_duration_value,
    wgs.nucleic_acid_storage_duration_unit,
    wgs.sequenced_by,
    wgs.sequencing_date,
    wgs.sequenced_by_contact_name,
    wgs.sequenced_by_contact_email,
    wgs.sequenced_by_laboratory_name,
    wgs.sequencing_project_name,
    wgs.sequencing_platform,
    wgs.sequencing_instrument,
    wgs.sequencing_assay_type,
    wgs.dna_fragment_length,
    wgs.genomic_target_enrichment_method,
    wgs.genomic_target_enrichment_method_details,
    wgs.amplicon_pcr_primer_scheme,
    wgs.amplicon_size,
    wgs.sequencing_flow_cell_version,
    wgs.library_preparation_kit,
    wgs.sequencing_protocol,
    wgs.r1_fastq_filename,
    wgs.r2_fastq_filename,
    wgs.fast5_filename,
    wgs.genome_sequence_filename,
    wgs.r1_irida_id,
    wgs.r2_irida_id,
    iso.organism,
    iso.microbiological_method,
    iso.progeny_isolate_id,
    iso.isolated_by,
    iso.isolated_by_contact_name,
    iso.isolated_by_contact_email,
    iso.isolated_by_lab_name,
    iso.isolation_date,
    iso.isolate_received_date,
    iso.taxonomic_identification_process,
    iso.taxonomic_identification_process_details,
    iso.serovar,
    iso.serotyping_method,
    iso.phagetype,
    iso.irida_project_id,
    iso.irida_sample_id,
    iso.bioproject_id,
    iso.biosample_id,
    sam.sample_collection_project_name,
    sam.project_description,
    sam.sample_plan_id,
    sam.sample_plan_name,
    sam.original_sample_description,
    sam.sample_collected_by,
    sam.sample_collector_contact_name,
    sam.sample_collector_contact_email,
    sam.sample_collected_by_laboratory_name,
    sam.sample_collection_date,
    sam.sample_collection_date_precision,
    sam.presampling_activity,
    sam.presampling_activity_details,
    sam.purpose_of_sampling,
    sam.sample_received_date,
    sam.specimen_processing,
    sam.sample_storage_method,
    sam.sample_storage_medium,
    sam.collection_device,
    sam.collection_method,
    sam.specimen_processing_details,
    sam.sample_collection_end_date,
    sam.sample_processing_date,
    sam.sample_collection_start_time,
    sam.sample_collection_end_time,
    sam.sample_collection_time_of_day,
    sam.sample_collection_time_duration_value,
    sam.sample_collection_time_duration_unit,
    sam.experimental_protocol_field,
    sam.experimental_specimen_role_type,
    sam.sample_volume_measurement_value,
    sam.sample_storage_duration_unit,
    sam.residual_sample_status,
    sam.sample_storage_duration_value,
    sam.sample_volume_measurement_unit,
    sam.geo_loc_name_country,
    sam.geo_loc_name_state_province_region,
    sam.geo_loc_latitude,
    sam.geo_loc_longitude,
    sam.geo_loc_name_site,
    sam.air_temperature,
    sam.air_temperature_units,
    sam.water_depth,
    sam.water_depth_units,
    sam.water_temperature,
    sam.water_temperature_units,
    sam.sediment_depth,
    sam.sediment_depth_units,
    sam.available_data_type_details,
    sam.available_data_types,
    sam.animal_or_plant_population,
    sam.environmental_material,
    sam.environmental_material_constituent,
    sam.environmental_site,
    sam.sampling_weather_conditions,
    sam.presampling_weather_conditions,
    sam.precipitation_measurement_value,
    sam.precipitation_measurement_unit,
    sam.precipitation_measurement_method,
    sam.body_product,
    sam.anatomical_material,
    sam.anatomical_part,
    sam.anatomical_region,
    sam.host_common_name,
    sam.host_scientific_name,
    sam.host_ecotype,
    sam.host_breed,
    sam.host_food_production_name,
    sam.host_disease,
    sam.host_age_bin,
    sam.host_origin_geo_loc_name_country,
    sam.food_product_origin_geo_loc_name_country,
    sam.food_product_production_stream,
    sam.food_packaging_date,
    sam.food_quality_date,
    sam.label_claim,
    sam.food_packaging,
    sam.food_product,
    sam.food_product_properties,
    sam.animal_source_of_food
   FROM ((public.wgs_wide wgs
     LEFT JOIN public.isolates_wide iso ON ((iso.isolate_id = wgs.isolate_id)))
     LEFT JOIN public.full_sample_metadata sam ON ((sam.sample_id = iso.sample_id)));


ALTER VIEW public.wgs_full_wide_metadata OWNER TO grdi;

--
-- Name: logged_actions event_id; Type: DEFAULT; Schema: audit; Owner: grdi
--

ALTER TABLE ONLY audit.logged_actions ALTER COLUMN event_id SET DEFAULT nextval('audit.logged_actions_event_id_seq'::regclass);


--
-- Name: logged_actions logged_actions_pkey; Type: CONSTRAINT; Schema: audit; Owner: grdi
--

ALTER TABLE ONLY audit.logged_actions
    ADD CONSTRAINT logged_actions_pkey PRIMARY KEY (event_id);


--
-- Name: digis_elements digis_elements_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.digis_elements
    ADD CONSTRAINT digis_elements_pkey PRIMARY KEY (id);


--
-- Name: ecoli_serotyping ecoli_serotyping_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.ecoli_serotyping
    ADD CONSTRAINT ecoli_serotyping_pkey PRIMARY KEY (id);


--
-- Name: iceberg_blastn_genome iceberg_blastn_genome_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.iceberg_blastn_genome
    ADD CONSTRAINT iceberg_blastn_genome_pkey PRIMARY KEY (id);


--
-- Name: iceberg_blastp_genes iceberg_blastp_genes_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.iceberg_blastp_genes
    ADD CONSTRAINT iceberg_blastp_genes_pkey PRIMARY KEY (id);


--
-- Name: integron_finder integron_finder_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.integron_finder
    ADD CONSTRAINT integron_finder_pkey PRIMARY KEY (id);


--
-- Name: island_path island_path_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.island_path
    ADD CONSTRAINT island_path_pkey PRIMARY KEY (id);


--
-- Name: kleborate kleborate_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.kleborate
    ADD CONSTRAINT kleborate_pkey PRIMARY KEY (id);


--
-- Name: mlst mlst_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.mlst
    ADD CONSTRAINT mlst_pkey PRIMARY KEY (id);


--
-- Name: mob_rgi mob_rgi_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.mob_rgi
    ADD CONSTRAINT mob_rgi_pkey PRIMARY KEY (id);


--
-- Name: plasmid_finder plasmid_finder_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.plasmid_finder
    ADD CONSTRAINT plasmid_finder_pkey PRIMARY KEY (id);


--
-- Name: refseq_masher refseq_masher_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.refseq_masher
    ADD CONSTRAINT refseq_masher_pkey PRIMARY KEY (id);


--
-- Name: resfinder resfinder_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.resfinder
    ADD CONSTRAINT resfinder_pkey PRIMARY KEY (id);


--
-- Name: resfinder_predicted_phenotypes resfinder_predicted_phenotypes_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.resfinder_predicted_phenotypes
    ADD CONSTRAINT resfinder_predicted_phenotypes_pkey PRIMARY KEY (resfinder_id, predicted_phenotype);


--
-- Name: salmonella_serotyping salmonella_serotyping_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.salmonella_serotyping
    ADD CONSTRAINT salmonella_serotyping_pkey PRIMARY KEY (id);


--
-- Name: virulence_vf virulence_vf_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.virulence_vf
    ADD CONSTRAINT virulence_vf_pkey PRIMARY KEY (id);


--
-- Name: virulence_vfdb virulence_vfdb_pkey; Type: CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.virulence_vfdb
    ADD CONSTRAINT virulence_vfdb_pkey PRIMARY KEY (id);


--
-- Name: activities activities_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: agencies agencies_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.agencies
    ADD CONSTRAINT agencies_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: alternative_isolate_ids alternative_isolate_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.alternative_isolate_ids
    ADD CONSTRAINT alternative_isolate_ids_pkey PRIMARY KEY (isolate_id, alternative_isolate_id);


--
-- Name: alternative_sample_ids alternative_sample_ids_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.alternative_sample_ids
    ADD CONSTRAINT alternative_sample_ids_pkey PRIMARY KEY (sample_id, alternative_sample_id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_pkey PRIMARY KEY (id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_pkey PRIMARY KEY (id);


--
-- Name: anatomical_data_body anatomical_data_body_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: anatomical_data_material anatomical_data_material_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: anatomical_data_part anatomical_data_part_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: anatomical_materials anatomical_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_materials
    ADD CONSTRAINT anatomical_materials_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: anatomical_parts anatomical_parts_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_parts
    ADD CONSTRAINT anatomical_parts_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: anatomical_regions anatomical_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_regions
    ADD CONSTRAINT anatomical_regions_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: animal_or_plant_populations animal_or_plant_populations_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.animal_or_plant_populations
    ADD CONSTRAINT animal_or_plant_populations_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: animal_source_of_food animal_source_of_food_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.animal_source_of_food
    ADD CONSTRAINT animal_source_of_food_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: antimicrobial_agents antimicrobial_agents_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.antimicrobial_agents
    ADD CONSTRAINT antimicrobial_agents_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: antimicrobial_phenotypes antimicrobial_phenotypes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.antimicrobial_phenotypes
    ADD CONSTRAINT antimicrobial_phenotypes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: attribute_packages attribute_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.attribute_packages
    ADD CONSTRAINT attribute_packages_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: available_data_types available_data_types_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.available_data_types
    ADD CONSTRAINT available_data_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: body_products body_products_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.body_products
    ADD CONSTRAINT body_products_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: collection_devices collection_devices_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.collection_devices
    ADD CONSTRAINT collection_devices_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: collection_methods collection_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.collection_methods
    ADD CONSTRAINT collection_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: consensus_sequence_software consensus_sequence_software_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.consensus_sequence_software
    ADD CONSTRAINT consensus_sequence_software_pkey PRIMARY KEY (id);


--
-- Name: contact_information contact_information_laboratory_name_contact_name_contact_em_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.contact_information
    ADD CONSTRAINT contact_information_laboratory_name_contact_name_contact_em_key UNIQUE NULLS NOT DISTINCT (laboratory_name, contact_name, contact_email);


--
-- Name: contact_information contact_information_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.contact_information
    ADD CONSTRAINT contact_information_pkey PRIMARY KEY (id);


--
-- Name: countries countries_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_ontology_id_key UNIQUE (ontology_id);


--
-- Name: countries countries_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.countries
    ADD CONSTRAINT countries_pkey PRIMARY KEY (id);


--
-- Name: db_versions db_versions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.db_versions
    ADD CONSTRAINT db_versions_pkey PRIMARY KEY (major_release, minor_release);


--
-- Name: depth_units depth_units_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.depth_units
    ADD CONSTRAINT depth_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: duration_units duration_units_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.duration_units
    ADD CONSTRAINT duration_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_material_constituents environmental_data_material_constituents_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_material_constituents
    ADD CONSTRAINT environmental_data_material_constituents_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_material environmental_data_material_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_material_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_presampling_weather_conditions environmental_data_presampling_weather_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_presampling_weather_conditions
    ADD CONSTRAINT environmental_data_presampling_weather_conditions_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_sampling_weather_conditions environmental_data_sampling_weather_conditions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_sampling_weather_conditions
    ADD CONSTRAINT environmental_data_sampling_weather_conditions_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_data_site environmental_data_site_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: environmental_materials environmental_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_materials
    ADD CONSTRAINT environmental_materials_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: environmental_sites environmental_sites_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_sites
    ADD CONSTRAINT environmental_sites_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: experimental_specimen_role_types experimental_specimen_role_types_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.experimental_specimen_role_types
    ADD CONSTRAINT experimental_specimen_role_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: extractions extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_pkey PRIMARY KEY (id);


--
-- Name: food_data_label_claims food_data_label_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_label_claims
    ADD CONSTRAINT food_data_label_claims_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: food_data_packaging food_data_packaging_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: food_data_product food_data_product_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: food_data_product_property food_data_product_property_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: food_data_source food_data_source_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: food_packaging food_packaging_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_packaging
    ADD CONSTRAINT food_packaging_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_product_production_streams food_product_production_streams_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_product_production_streams
    ADD CONSTRAINT food_product_production_streams_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_product_properties food_product_properties_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_product_properties
    ADD CONSTRAINT food_product_properties_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: food_products food_products_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_products
    ADD CONSTRAINT food_products_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: genomic_target_enrichment_methods genomic_target_enrichment_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.genomic_target_enrichment_methods
    ADD CONSTRAINT genomic_target_enrichment_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: host_age_bin host_age_bin_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_age_bin
    ADD CONSTRAINT host_age_bin_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: host_food_production_names host_food_production_names_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_food_production_names
    ADD CONSTRAINT host_food_production_names_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: host_organisms host_organisms_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_organisms
    ADD CONSTRAINT host_organisms_ontology_id_key UNIQUE (ontology_id);


--
-- Name: host_organisms host_organisms_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_organisms
    ADD CONSTRAINT host_organisms_pkey PRIMARY KEY (id);


--
-- Name: isolates isolates_isolate_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_isolate_id_key UNIQUE (isolate_id);


--
-- Name: isolates isolates_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_pkey PRIMARY KEY (id);


--
-- Name: label_claims label_claims_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.label_claims
    ADD CONSTRAINT label_claims_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: laboratory_typing_methods laboratory_typing_methods_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.laboratory_typing_methods
    ADD CONSTRAINT laboratory_typing_methods_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: laboratory_typing_platforms laboratory_typing_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.laboratory_typing_platforms
    ADD CONSTRAINT laboratory_typing_platforms_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: measurement_sign measurement_sign_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.measurement_sign
    ADD CONSTRAINT measurement_sign_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: measurement_units measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.measurement_units
    ADD CONSTRAINT measurement_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: metagenomic_extractions metagenomic_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_pkey PRIMARY KEY (sample_id, extraction_id);


--
-- Name: microbes microbes_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.microbes
    ADD CONSTRAINT microbes_ontology_id_key UNIQUE (ontology_id);


--
-- Name: microbes microbes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.microbes
    ADD CONSTRAINT microbes_pkey PRIMARY KEY (id);


--
-- Name: ontology_terms ontology_terms_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.ontology_terms
    ADD CONSTRAINT ontology_terms_ontology_id_key UNIQUE (ontology_id);


--
-- Name: ontology_terms ontology_terms_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.ontology_terms
    ADD CONSTRAINT ontology_terms_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_sample_plan_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_sample_plan_id_key UNIQUE (sample_plan_id);


--
-- Name: public_repository_information public_repository_information_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_pkey PRIMARY KEY (id);


--
-- Name: purposes purposes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.purposes
    ADD CONSTRAINT purposes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: quality_control_determinations quality_control_determinations_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.quality_control_determinations
    ADD CONSTRAINT quality_control_determinations_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: quality_control_issues quality_control_issues_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.quality_control_issues
    ADD CONSTRAINT quality_control_issues_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: read_mapping_software_names read_mapping_software_names_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.read_mapping_software_names
    ADD CONSTRAINT read_mapping_software_names_pkey PRIMARY KEY (id);


--
-- Name: reference_genome_accessions reference_genome_accessions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.reference_genome_accessions
    ADD CONSTRAINT reference_genome_accessions_pkey PRIMARY KEY (id);


--
-- Name: residual_sample_status residual_sample_status_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.residual_sample_status
    ADD CONSTRAINT residual_sample_status_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: risk_activity risk_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: sample_activity sample_activity_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: sample_collection_date_precision sample_collection_date_precision_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_collection_date_precision
    ADD CONSTRAINT sample_collection_date_precision_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: samples sample_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_pkey PRIMARY KEY (id);


--
-- Name: sample_purposes sample_purposes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purposes_pkey PRIMARY KEY (sample_id, term_id);


--
-- Name: sequence_assembly_software sequence_assembly_software_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequence_assembly_software
    ADD CONSTRAINT sequence_assembly_software_pkey PRIMARY KEY (id);


--
-- Name: sequencing_assay_types sequencing_assay_types_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_assay_types
    ADD CONSTRAINT sequencing_assay_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing_instruments sequencing_instruments_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_instruments
    ADD CONSTRAINT sequencing_instruments_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing sequencing_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_pkey PRIMARY KEY (id);


--
-- Name: sequencing_platforms sequencing_platforms_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_platforms
    ADD CONSTRAINT sequencing_platforms_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: sequencing_purposes sequencing_purposes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_pkey PRIMARY KEY (id, term_id);


--
-- Name: specimen_processing specimen_processing_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.specimen_processing
    ADD CONSTRAINT specimen_processing_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: stage_of_production stage_of_production_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.stage_of_production
    ADD CONSTRAINT stage_of_production_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: state_province_regions state_province_regions_ontology_id_key; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_ontology_id_key UNIQUE (ontology_id);


--
-- Name: state_province_regions state_province_regions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_pkey PRIMARY KEY (id);


--
-- Name: taxonomic_identification_processes taxonomic_identification_processes_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.taxonomic_identification_processes
    ADD CONSTRAINT taxonomic_identification_processes_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: temperature_units temperature_units_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.temperature_units
    ADD CONSTRAINT temperature_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: template_mapping template_mapping_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.template_mapping
    ADD CONSTRAINT template_mapping_pkey PRIMARY KEY (id);


--
-- Name: testing_standard testing_standard_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.testing_standard
    ADD CONSTRAINT testing_standard_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: time_of_day time_of_day_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.time_of_day
    ADD CONSTRAINT time_of_day_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_pkey PRIMARY KEY (id);


--
-- Name: vendor_names vendor_names_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.vendor_names
    ADD CONSTRAINT vendor_names_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: volume_measurement_units volume_measurement_units_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.volume_measurement_units
    ADD CONSTRAINT volume_measurement_units_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: weather_types weather_types_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.weather_types
    ADD CONSTRAINT weather_types_pkey PRIMARY KEY (ontology_term_id);


--
-- Name: wgs_extractions wgs_extractions_pkey; Type: CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_pkey PRIMARY KEY (isolate_id, extraction_id);


--
-- Name: project_stats _RETURN; Type: RULE; Schema: public; Owner: grdi
--

CREATE OR REPLACE VIEW public.project_stats AS
 SELECT pro.id AS "Project Database ID",
    pro.sample_plan_id AS "Sample plan ID",
    pro.sample_plan_name AS "Sample plan name",
    pro.project_name AS "Project name",
    count(DISTINCT sam.id) AS "Number of Samples",
    count(DISTINCT iso.id) AS "Number of Isolates",
    count(DISTINCT wgs.sequencing_id) AS "Number of WGS",
    count(DISTINCT ab.id) AS "Number of AST"
   FROM ((((public.projects pro
     LEFT JOIN public.samples sam ON ((pro.id = sam.project_id)))
     LEFT JOIN public.isolates iso ON ((iso.sample_id = sam.id)))
     LEFT JOIN public.wgs ON ((wgs.isolate_id = iso.id)))
     LEFT JOIN public.am_susceptibility_tests ab ON ((ab.isolate_id = iso.id)))
  GROUP BY pro.id;


--
-- Name: activities audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.activities FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: agencies audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.agencies FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: alternative_isolate_ids audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.alternative_isolate_ids FOR EACH ROW EXECUTE FUNCTION audit.log_changes('isolate_id');


--
-- Name: alternative_sample_ids audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.alternative_sample_ids FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: am_susceptibility_tests audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.am_susceptibility_tests FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: amr_antibiotics_profile audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.amr_antibiotics_profile FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: anatomical_data_body audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_data_body FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: anatomical_data_material audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_data_material FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: anatomical_data_part audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_data_part FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: anatomical_materials audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_materials FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: anatomical_parts audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_parts FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: anatomical_regions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.anatomical_regions FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: animal_or_plant_populations audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.animal_or_plant_populations FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: animal_source_of_food audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.animal_source_of_food FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: antimicrobial_agents audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.antimicrobial_agents FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: antimicrobial_phenotypes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.antimicrobial_phenotypes FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: attribute_packages audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.attribute_packages FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: available_data_types audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.available_data_types FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: body_products audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.body_products FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: collection_devices audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.collection_devices FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: collection_methods audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.collection_methods FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: consensus_sequence_software audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.consensus_sequence_software FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: contact_information audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.contact_information FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: countries audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.countries FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: depth_units audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.depth_units FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: duration_units audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.duration_units FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: environmental_data_animal_plant audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_animal_plant FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_available_data_type audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_available_data_type FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_material audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_material FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_material_constituents audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_material_constituents FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_presampling_weather_conditions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_presampling_weather_conditions FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_sampling_weather_conditions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_sampling_weather_conditions FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_data_site audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_data_site FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: environmental_materials audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_materials FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: environmental_sites audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.environmental_sites FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: experimental_specimen_role_types audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.experimental_specimen_role_types FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: extractions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.extractions FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: food_data_label_claims audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_data_label_claims FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: food_data_packaging audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_data_packaging FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: food_data_product audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_data_product FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: food_data_product_property audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_data_product_property FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: food_data_source audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_data_source FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: food_packaging audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_packaging FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: food_product_production_streams audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_product_production_streams FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: food_product_properties audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_product_properties FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: food_products audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.food_products FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: genomic_target_enrichment_methods audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.genomic_target_enrichment_methods FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: host_age_bin audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.host_age_bin FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: host_food_production_names audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.host_food_production_names FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: host_organisms audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.host_organisms FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: isolates audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.isolates FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: label_claims audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.label_claims FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: laboratory_typing_methods audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.laboratory_typing_methods FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: laboratory_typing_platforms audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.laboratory_typing_platforms FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: measurement_sign audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.measurement_sign FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: measurement_units audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.measurement_units FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: metagenomic_extractions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.metagenomic_extractions FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: microbes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.microbes FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: ontology_terms audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.ontology_terms FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: projects audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: public_repository_information audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.public_repository_information FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: purposes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.purposes FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: quality_control_determinations audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.quality_control_determinations FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: quality_control_issues audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.quality_control_issues FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: read_mapping_software_names audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.read_mapping_software_names FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: reference_genome_accessions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.reference_genome_accessions FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: residual_sample_status audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.residual_sample_status FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: risk_activity audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.risk_activity FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: sample_activity audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sample_activity FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: sample_collection_date_precision audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sample_collection_date_precision FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: sample_purposes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sample_purposes FOR EACH ROW EXECUTE FUNCTION audit.log_changes('sample_id');


--
-- Name: samples audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.samples FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: sequence_assembly_software audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequence_assembly_software FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: sequencing audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequencing FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: sequencing_assay_types audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequencing_assay_types FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: sequencing_instruments audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequencing_instruments FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: sequencing_platforms audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequencing_platforms FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: sequencing_purposes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.sequencing_purposes FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: specimen_processing audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.specimen_processing FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: stage_of_production audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.stage_of_production FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: state_province_regions audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.state_province_regions FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: taxonomic_identification_processes audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.taxonomic_identification_processes FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: temperature_units audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.temperature_units FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: template_mapping audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.template_mapping FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: testing_standard audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.testing_standard FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: time_of_day audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.time_of_day FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: user_bioinformatic_analyses audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.user_bioinformatic_analyses FOR EACH ROW EXECUTE FUNCTION audit.log_changes();


--
-- Name: vendor_names audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.vendor_names FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: volume_measurement_units audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.volume_measurement_units FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: weather_types audit_changes_to_ext_table; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER audit_changes_to_ext_table BEFORE DELETE OR UPDATE ON public.weather_types FOR EACH ROW EXECUTE FUNCTION audit.log_changes('ontology_term_id');


--
-- Name: wgs_extractions update_usertimestamp; Type: TRIGGER; Schema: public; Owner: grdi
--

CREATE TRIGGER update_usertimestamp BEFORE UPDATE ON public.wgs_extractions FOR EACH ROW EXECUTE FUNCTION public.trigger_set_usertimestamp();


--
-- Name: digis_elements digis_elements_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.digis_elements
    ADD CONSTRAINT digis_elements_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: ecoli_serotyping ecoli_serotyping_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.ecoli_serotyping
    ADD CONSTRAINT ecoli_serotyping_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: iceberg_blastn_genome iceberg_blastn_genome_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.iceberg_blastn_genome
    ADD CONSTRAINT iceberg_blastn_genome_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: iceberg_blastp_genes iceberg_blastp_genes_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.iceberg_blastp_genes
    ADD CONSTRAINT iceberg_blastp_genes_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: integron_finder integron_finder_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.integron_finder
    ADD CONSTRAINT integron_finder_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: island_path island_path_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.island_path
    ADD CONSTRAINT island_path_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: kleborate kleborate_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.kleborate
    ADD CONSTRAINT kleborate_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: mlst mlst_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.mlst
    ADD CONSTRAINT mlst_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: mob_rgi mob_rgi_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.mob_rgi
    ADD CONSTRAINT mob_rgi_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: plasmid_finder plasmid_finder_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.plasmid_finder
    ADD CONSTRAINT plasmid_finder_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: refseq_masher refseq_masher_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.refseq_masher
    ADD CONSTRAINT refseq_masher_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: resfinder_predicted_phenotypes resfinder_predicted_phenotypes_resfinder_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.resfinder_predicted_phenotypes
    ADD CONSTRAINT resfinder_predicted_phenotypes_resfinder_id_fkey FOREIGN KEY (resfinder_id) REFERENCES bioinf.resfinder(id);


--
-- Name: resfinder resfinder_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.resfinder
    ADD CONSTRAINT resfinder_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: salmonella_serotyping salmonella_serotyping_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.salmonella_serotyping
    ADD CONSTRAINT salmonella_serotyping_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: virulence_vf virulence_vf_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.virulence_vf
    ADD CONSTRAINT virulence_vf_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: virulence_vfdb virulence_vfdb_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: bioinf; Owner: grdi
--

ALTER TABLE ONLY bioinf.virulence_vfdb
    ADD CONSTRAINT virulence_vfdb_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: activities activities_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.activities
    ADD CONSTRAINT activities_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: agencies agencies_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.agencies
    ADD CONSTRAINT agencies_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: alternative_isolate_ids alternative_isolate_ids_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.alternative_isolate_ids
    ADD CONSTRAINT alternative_isolate_ids_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: alternative_sample_ids alternative_sample_ids_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.alternative_sample_ids
    ADD CONSTRAINT alternative_sample_ids_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_amr_testing_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_amr_testing_by_fkey FOREIGN KEY (amr_testing_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: am_susceptibility_tests am_susceptibility_tests_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.am_susceptibility_tests
    ADD CONSTRAINT am_susceptibility_tests_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_antimicrobial_agent_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_antimicrobial_agent_fkey FOREIGN KEY (antimicrobial_agent) REFERENCES public.antimicrobial_agents(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_antimicrobial_phenotype_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_antimicrobial_phenotype_fkey FOREIGN KEY (antimicrobial_phenotype) REFERENCES public.antimicrobial_phenotypes(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_laboratory_typing_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_laboratory_typing_method_fkey FOREIGN KEY (laboratory_typing_method) REFERENCES public.laboratory_typing_methods(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_laboratory_typing_platform_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_laboratory_typing_platform_fkey FOREIGN KEY (laboratory_typing_platform) REFERENCES public.laboratory_typing_platforms(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_measurement_sign_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_measurement_sign_fkey FOREIGN KEY (measurement_sign) REFERENCES public.measurement_sign(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_measurement_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_measurement_units_fkey FOREIGN KEY (measurement_units) REFERENCES public.measurement_units(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_test_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_test_id_fkey FOREIGN KEY (test_id) REFERENCES public.am_susceptibility_tests(id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_testing_standard_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_testing_standard_fkey FOREIGN KEY (testing_standard) REFERENCES public.testing_standard(ontology_term_id);


--
-- Name: amr_antibiotics_profile amr_antibiotics_profile_vendor_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.amr_antibiotics_profile
    ADD CONSTRAINT amr_antibiotics_profile_vendor_name_fkey FOREIGN KEY (vendor_name) REFERENCES public.vendor_names(ontology_term_id);


--
-- Name: anatomical_data_body anatomical_data_body_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: anatomical_data_body anatomical_data_body_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_body
    ADD CONSTRAINT anatomical_data_body_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.body_products(ontology_term_id);


--
-- Name: anatomical_data_material anatomical_data_material_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: anatomical_data_material anatomical_data_material_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_material
    ADD CONSTRAINT anatomical_data_material_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.anatomical_materials(ontology_term_id);


--
-- Name: anatomical_data_part anatomical_data_part_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: anatomical_data_part anatomical_data_part_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_data_part
    ADD CONSTRAINT anatomical_data_part_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.anatomical_parts(ontology_term_id);


--
-- Name: anatomical_materials anatomical_materials_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_materials
    ADD CONSTRAINT anatomical_materials_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: anatomical_parts anatomical_parts_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_parts
    ADD CONSTRAINT anatomical_parts_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: anatomical_regions anatomical_regions_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.anatomical_regions
    ADD CONSTRAINT anatomical_regions_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: animal_or_plant_populations animal_or_plant_populations_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.animal_or_plant_populations
    ADD CONSTRAINT animal_or_plant_populations_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: animal_source_of_food animal_source_of_food_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.animal_source_of_food
    ADD CONSTRAINT animal_source_of_food_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: antimicrobial_agents antimicrobial_agents_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.antimicrobial_agents
    ADD CONSTRAINT antimicrobial_agents_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: antimicrobial_phenotypes antimicrobial_phenotypes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.antimicrobial_phenotypes
    ADD CONSTRAINT antimicrobial_phenotypes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: attribute_packages attribute_packages_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.attribute_packages
    ADD CONSTRAINT attribute_packages_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: available_data_types available_data_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.available_data_types
    ADD CONSTRAINT available_data_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: body_products body_products_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.body_products
    ADD CONSTRAINT body_products_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: collection_devices collection_devices_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.collection_devices
    ADD CONSTRAINT collection_devices_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: collection_methods collection_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.collection_methods
    ADD CONSTRAINT collection_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: depth_units depth_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.depth_units
    ADD CONSTRAINT depth_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: duration_units duration_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.duration_units
    ADD CONSTRAINT duration_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_animal_plant environmental_data_animal_plant_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_animal_plant
    ADD CONSTRAINT environmental_data_animal_plant_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.animal_or_plant_populations(ontology_term_id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_available_data_type environmental_data_available_data_type_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_available_data_type
    ADD CONSTRAINT environmental_data_available_data_type_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.available_data_types(ontology_term_id);


--
-- Name: environmental_data_material_constituents environmental_data_material_constituents_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_material_constituents
    ADD CONSTRAINT environmental_data_material_constituents_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_material environmental_data_material_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_material_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_material environmental_data_material_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_material
    ADD CONSTRAINT environmental_data_material_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.environmental_materials(ontology_term_id);


--
-- Name: environmental_data_presampling_weather_conditions environmental_data_presampling_weather_condition_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_presampling_weather_conditions
    ADD CONSTRAINT environmental_data_presampling_weather_condition_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_presampling_weather_conditions environmental_data_presampling_weather_conditions_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_presampling_weather_conditions
    ADD CONSTRAINT environmental_data_presampling_weather_conditions_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.weather_types(ontology_term_id);


--
-- Name: environmental_data_sampling_weather_conditions environmental_data_sampling_weather_conditions_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_sampling_weather_conditions
    ADD CONSTRAINT environmental_data_sampling_weather_conditions_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_sampling_weather_conditions environmental_data_sampling_weather_conditions_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_sampling_weather_conditions
    ADD CONSTRAINT environmental_data_sampling_weather_conditions_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.weather_types(ontology_term_id);


--
-- Name: environmental_data_site environmental_data_site_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: environmental_data_site environmental_data_site_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_data_site
    ADD CONSTRAINT environmental_data_site_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.environmental_sites(ontology_term_id);


--
-- Name: environmental_materials environmental_materials_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_materials
    ADD CONSTRAINT environmental_materials_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: environmental_sites environmental_sites_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.environmental_sites
    ADD CONSTRAINT environmental_sites_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: experimental_specimen_role_types experimental_specimen_role_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.experimental_specimen_role_types
    ADD CONSTRAINT experimental_specimen_role_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: extractions extractions_nucleic_acid_storage_duration_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.extractions
    ADD CONSTRAINT extractions_nucleic_acid_storage_duration_unit_fkey FOREIGN KEY (nucleic_acid_storage_duration_unit) REFERENCES public.duration_units(ontology_term_id);


--
-- Name: food_data_label_claims food_data_label_claims_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_label_claims
    ADD CONSTRAINT food_data_label_claims_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_label_claims food_data_label_claims_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_label_claims
    ADD CONSTRAINT food_data_label_claims_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.label_claims(ontology_term_id);


--
-- Name: food_data_packaging food_data_packaging_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_packaging food_data_packaging_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_packaging
    ADD CONSTRAINT food_data_packaging_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_packaging(ontology_term_id);


--
-- Name: food_data_product_property food_data_product_property_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_product_property food_data_product_property_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product_property
    ADD CONSTRAINT food_data_product_property_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_product_properties(ontology_term_id);


--
-- Name: food_data_product food_data_product_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_product food_data_product_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_product
    ADD CONSTRAINT food_data_product_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.food_products(ontology_term_id);


--
-- Name: food_data_source food_data_source_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: food_data_source food_data_source_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_data_source
    ADD CONSTRAINT food_data_source_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.animal_source_of_food(ontology_term_id);


--
-- Name: food_packaging food_packaging_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_packaging
    ADD CONSTRAINT food_packaging_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_product_production_streams food_product_production_streams_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_product_production_streams
    ADD CONSTRAINT food_product_production_streams_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_product_properties food_product_properties_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_product_properties
    ADD CONSTRAINT food_product_properties_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: food_products food_products_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.food_products
    ADD CONSTRAINT food_products_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: genomic_target_enrichment_methods genomic_target_enrichment_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.genomic_target_enrichment_methods
    ADD CONSTRAINT genomic_target_enrichment_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: host_age_bin host_age_bin_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_age_bin
    ADD CONSTRAINT host_age_bin_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: host_food_production_names host_food_production_names_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.host_food_production_names
    ADD CONSTRAINT host_food_production_names_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: isolates isolates_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: isolates isolates_isolated_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_isolated_by_fkey FOREIGN KEY (isolated_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: isolates isolates_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_organism_fkey FOREIGN KEY (organism) REFERENCES public.microbes(id);


--
-- Name: isolates isolates_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: isolates isolates_taxonomic_identification_process_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.isolates
    ADD CONSTRAINT isolates_taxonomic_identification_process_fkey FOREIGN KEY (taxonomic_identification_process) REFERENCES public.taxonomic_identification_processes(ontology_term_id);


--
-- Name: label_claims label_claims_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.label_claims
    ADD CONSTRAINT label_claims_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: laboratory_typing_methods laboratory_typing_methods_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.laboratory_typing_methods
    ADD CONSTRAINT laboratory_typing_methods_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: laboratory_typing_platforms laboratory_typing_platforms_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.laboratory_typing_platforms
    ADD CONSTRAINT laboratory_typing_platforms_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: measurement_sign measurement_sign_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.measurement_sign
    ADD CONSTRAINT measurement_sign_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: measurement_units measurement_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.measurement_units
    ADD CONSTRAINT measurement_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: metagenomic_extractions metagenomic_extractions_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: metagenomic_extractions metagenomic_extractions_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.metagenomic_extractions
    ADD CONSTRAINT metagenomic_extractions_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: ontology_terms ontology_terms_replaced_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.ontology_terms
    ADD CONSTRAINT ontology_terms_replaced_by_fkey FOREIGN KEY (replaced_by) REFERENCES public.ontology_terms(id);


--
-- Name: public_repository_information public_repository_information_attribute_package_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_attribute_package_fkey FOREIGN KEY (attribute_package) REFERENCES public.attribute_packages(ontology_term_id);


--
-- Name: public_repository_information public_repository_information_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: public_repository_information public_repository_information_sequence_submitted_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_sequence_submitted_by_fkey FOREIGN KEY (sequence_submitted_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: public_repository_information public_repository_information_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.public_repository_information
    ADD CONSTRAINT public_repository_information_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: purposes purposes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.purposes
    ADD CONSTRAINT purposes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: quality_control_determinations quality_control_determinations_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.quality_control_determinations
    ADD CONSTRAINT quality_control_determinations_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: quality_control_issues quality_control_issues_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.quality_control_issues
    ADD CONSTRAINT quality_control_issues_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: residual_sample_status residual_sample_status_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.residual_sample_status
    ADD CONSTRAINT residual_sample_status_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: risk_activity risk_activity_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: risk_activity risk_activity_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.risk_activity
    ADD CONSTRAINT risk_activity_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.activities(ontology_term_id);


--
-- Name: sample_activity sample_activity_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: sample_activity sample_activity_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_activity
    ADD CONSTRAINT sample_activity_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.activities(ontology_term_id);


--
-- Name: sample_collection_date_precision sample_collection_date_precision_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_collection_date_precision
    ADD CONSTRAINT sample_collection_date_precision_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: samples sample_metadata_air_temperature_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_air_temperature_units_fkey FOREIGN KEY (air_temperature_units) REFERENCES public.temperature_units(ontology_term_id);


--
-- Name: samples sample_metadata_anatomical_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_anatomical_region_fkey FOREIGN KEY (anatomical_region) REFERENCES public.anatomical_regions(ontology_term_id);


--
-- Name: samples sample_metadata_collection_device_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_collection_device_fkey FOREIGN KEY (collection_device) REFERENCES public.collection_devices(ontology_term_id);


--
-- Name: samples sample_metadata_collection_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_collection_method_fkey FOREIGN KEY (collection_method) REFERENCES public.collection_methods(ontology_term_id);


--
-- Name: samples sample_metadata_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: samples sample_metadata_food_product_origin_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_food_product_origin_country_fkey FOREIGN KEY (food_product_origin_geo_loc_name_country) REFERENCES public.countries(id);


--
-- Name: samples sample_metadata_food_product_production_stream_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_food_product_production_stream_fkey FOREIGN KEY (food_product_production_stream) REFERENCES public.food_product_production_streams(ontology_term_id);


--
-- Name: samples sample_metadata_geo_loc_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_geo_loc_country_fkey FOREIGN KEY (geo_loc_name_country) REFERENCES public.countries(id);


--
-- Name: samples sample_metadata_geo_loc_state_province_region_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_geo_loc_state_province_region_fkey FOREIGN KEY (geo_loc_name_state_province_region) REFERENCES public.state_province_regions(id);


--
-- Name: samples sample_metadata_host_age_bin_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_host_age_bin_fkey FOREIGN KEY (host_age_bin) REFERENCES public.host_age_bin(ontology_term_id);


--
-- Name: samples sample_metadata_host_food_production_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_host_food_production_name_fkey FOREIGN KEY (host_food_production_name) REFERENCES public.host_food_production_names(ontology_term_id);


--
-- Name: samples sample_metadata_host_organism_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_host_organism_fkey FOREIGN KEY (host_organism) REFERENCES public.host_organisms(id);


--
-- Name: samples sample_metadata_host_origin_geo_loc_name_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_host_origin_geo_loc_name_country_fkey FOREIGN KEY (host_origin_geo_loc_name_country) REFERENCES public.countries(id);


--
-- Name: samples sample_metadata_precipitation_measurement_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_precipitation_measurement_unit_fkey FOREIGN KEY (precipitation_measurement_unit) REFERENCES public.depth_units(ontology_term_id);


--
-- Name: samples sample_metadata_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id);


--
-- Name: samples sample_metadata_sample_collected_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_sample_collected_by_fkey FOREIGN KEY (sample_collected_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: samples sample_metadata_sample_collection_date_precision_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_sample_collection_date_precision_fkey FOREIGN KEY (sample_collection_date_precision) REFERENCES public.sample_collection_date_precision(ontology_term_id);


--
-- Name: samples sample_metadata_sample_collection_time_duration_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_sample_collection_time_duration_unit_fkey FOREIGN KEY (sample_collection_time_duration_unit) REFERENCES public.duration_units(ontology_term_id);


--
-- Name: samples sample_metadata_sample_collection_time_of_day_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_sample_collection_time_of_day_fkey FOREIGN KEY (sample_collection_time_of_day) REFERENCES public.time_of_day(ontology_term_id);


--
-- Name: samples sample_metadata_sediment_depth_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_sediment_depth_units_fkey FOREIGN KEY (sediment_depth_units) REFERENCES public.depth_units(ontology_term_id);


--
-- Name: samples sample_metadata_specimen_processing_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_specimen_processing_fkey FOREIGN KEY (specimen_processing) REFERENCES public.specimen_processing(ontology_term_id);


--
-- Name: samples sample_metadata_stage_of_production_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_stage_of_production_fkey FOREIGN KEY (stage_of_production) REFERENCES public.stage_of_production(ontology_term_id);


--
-- Name: samples sample_metadata_water_depth_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_water_depth_units_fkey FOREIGN KEY (water_depth_units) REFERENCES public.depth_units(ontology_term_id);


--
-- Name: samples sample_metadata_water_temperature_units_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT sample_metadata_water_temperature_units_fkey FOREIGN KEY (water_temperature_units) REFERENCES public.temperature_units(ontology_term_id);


--
-- Name: sample_purposes sample_purposes_sample_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purposes_sample_id_fkey FOREIGN KEY (sample_id) REFERENCES public.samples(id);


--
-- Name: sample_purposes sample_purposes_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sample_purposes
    ADD CONSTRAINT sample_purposes_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.purposes(ontology_term_id);


--
-- Name: samples samples_experimental_specimen_role_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_experimental_specimen_role_type_fkey FOREIGN KEY (experimental_specimen_role_type) REFERENCES public.experimental_specimen_role_types(ontology_term_id);


--
-- Name: samples samples_residual_sample_status_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_residual_sample_status_fkey FOREIGN KEY (residual_sample_status) REFERENCES public.residual_sample_status(ontology_term_id);


--
-- Name: samples samples_sample_storage_duration_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_sample_storage_duration_unit_fkey FOREIGN KEY (sample_storage_duration_unit) REFERENCES public.duration_units(ontology_term_id);


--
-- Name: samples samples_sample_volume_measurement_unit_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.samples
    ADD CONSTRAINT samples_sample_volume_measurement_unit_fkey FOREIGN KEY (sample_volume_measurement_unit) REFERENCES public.volume_measurement_units(ontology_term_id);


--
-- Name: sequencing_assay_types sequencing_assay_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_assay_types
    ADD CONSTRAINT sequencing_assay_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing sequencing_contact_information_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_contact_information_fkey FOREIGN KEY (contact_information) REFERENCES public.contact_information(id);


--
-- Name: sequencing sequencing_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: sequencing sequencing_genomic_target_enrichment_method_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_genomic_target_enrichment_method_fkey FOREIGN KEY (genomic_target_enrichment_method) REFERENCES public.genomic_target_enrichment_methods(ontology_term_id);


--
-- Name: sequencing_instruments sequencing_instruments_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_instruments
    ADD CONSTRAINT sequencing_instruments_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing_platforms sequencing_platforms_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_platforms
    ADD CONSTRAINT sequencing_platforms_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: sequencing_purposes sequencing_purposes_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_id_fkey FOREIGN KEY (id) REFERENCES public.sequencing(id);


--
-- Name: sequencing_purposes sequencing_purposes_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing_purposes
    ADD CONSTRAINT sequencing_purposes_term_id_fkey FOREIGN KEY (term_id) REFERENCES public.purposes(ontology_term_id);


--
-- Name: sequencing sequencing_sequenced_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequenced_by_fkey FOREIGN KEY (sequenced_by) REFERENCES public.agencies(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_assay_type_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_assay_type_fkey FOREIGN KEY (sequencing_assay_type) REFERENCES public.sequencing_assay_types(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_instrument_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_instrument_fkey FOREIGN KEY (sequencing_instrument) REFERENCES public.sequencing_instruments(ontology_term_id);


--
-- Name: sequencing sequencing_sequencing_platform_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.sequencing
    ADD CONSTRAINT sequencing_sequencing_platform_fkey FOREIGN KEY (sequencing_platform) REFERENCES public.sequencing_platforms(ontology_term_id);


--
-- Name: specimen_processing specimen_processing_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.specimen_processing
    ADD CONSTRAINT specimen_processing_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: stage_of_production stage_of_production_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.stage_of_production
    ADD CONSTRAINT stage_of_production_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: state_province_regions state_province_regions_country_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.state_province_regions
    ADD CONSTRAINT state_province_regions_country_id_fkey FOREIGN KEY (country_id) REFERENCES public.countries(id);


--
-- Name: taxonomic_identification_processes taxonomic_identification_processes_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.taxonomic_identification_processes
    ADD CONSTRAINT taxonomic_identification_processes_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: temperature_units temperature_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.temperature_units
    ADD CONSTRAINT temperature_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: testing_standard testing_standard_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.testing_standard
    ADD CONSTRAINT testing_standard_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: time_of_day time_of_day_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.time_of_day
    ADD CONSTRAINT time_of_day_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_consensus_sequence_software_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_consensus_sequence_software_fkey FOREIGN KEY (consensus_sequence_software) REFERENCES public.consensus_sequence_software(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_quality_control_determination_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_quality_control_determination_fkey FOREIGN KEY (quality_control_determination) REFERENCES public.quality_control_determinations(ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_quality_control_issues_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_quality_control_issues_fkey FOREIGN KEY (quality_control_issues) REFERENCES public.quality_control_issues(ontology_term_id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_read_mapping_software_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_read_mapping_software_name_fkey FOREIGN KEY (read_mapping_software_name) REFERENCES public.read_mapping_software_names(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_reference_genome_accession_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_reference_genome_accession_fkey FOREIGN KEY (reference_genome_accession) REFERENCES public.reference_genome_accessions(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_sequence_assembly_software_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_sequence_assembly_software_fkey FOREIGN KEY (sequence_assembly_software) REFERENCES public.sequence_assembly_software(id);


--
-- Name: user_bioinformatic_analyses user_bioinformatic_analyses_sequencing_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.user_bioinformatic_analyses
    ADD CONSTRAINT user_bioinformatic_analyses_sequencing_id_fkey FOREIGN KEY (sequencing_id) REFERENCES public.sequencing(id);


--
-- Name: vendor_names vendor_names_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.vendor_names
    ADD CONSTRAINT vendor_names_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: volume_measurement_units volume_measurement_units_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.volume_measurement_units
    ADD CONSTRAINT volume_measurement_units_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: weather_types weather_types_ontology_term_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.weather_types
    ADD CONSTRAINT weather_types_ontology_term_id_fkey FOREIGN KEY (ontology_term_id) REFERENCES public.ontology_terms(id);


--
-- Name: wgs_extractions wgs_extractions_extraction_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_extraction_id_fkey FOREIGN KEY (extraction_id) REFERENCES public.extractions(id);


--
-- Name: wgs_extractions wgs_extractions_isolate_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: grdi
--

ALTER TABLE ONLY public.wgs_extractions
    ADD CONSTRAINT wgs_extractions_isolate_id_fkey FOREIGN KEY (isolate_id) REFERENCES public.isolates(id);


--
-- Name: SCHEMA audit; Type: ACL; Schema: -; Owner: grdi
--

GRANT ALL ON SCHEMA audit TO gwajnberg;


--
-- Name: SCHEMA bioinf; Type: ACL; Schema: -; Owner: grdi
--

GRANT ALL ON SCHEMA bioinf TO gwajnberg;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO gwajnberg;


--
-- Name: TABLE logged_actions; Type: ACL; Schema: audit; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE audit.logged_actions TO gwajnberg;


--
-- Name: SEQUENCE logged_actions_event_id_seq; Type: ACL; Schema: audit; Owner: grdi
--

GRANT ALL ON SEQUENCE audit.logged_actions_event_id_seq TO gwajnberg;


--
-- Name: TABLE digis_elements; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.digis_elements TO gwajnberg;


--
-- Name: SEQUENCE digis_elements_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.digis_elements_id_seq TO gwajnberg;


--
-- Name: TABLE ecoli_serotyping; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.ecoli_serotyping TO gwajnberg;


--
-- Name: SEQUENCE ecoli_serotyping_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.ecoli_serotyping_id_seq TO gwajnberg;


--
-- Name: TABLE iceberg_blastn_genome; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.iceberg_blastn_genome TO gwajnberg;


--
-- Name: SEQUENCE iceberg_blastn_genome_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.iceberg_blastn_genome_id_seq TO gwajnberg;


--
-- Name: TABLE iceberg_blastp_genes; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.iceberg_blastp_genes TO gwajnberg;


--
-- Name: SEQUENCE iceberg_blastp_genes_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.iceberg_blastp_genes_id_seq TO gwajnberg;


--
-- Name: TABLE integron_finder; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.integron_finder TO gwajnberg;


--
-- Name: SEQUENCE integron_finder_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.integron_finder_id_seq TO gwajnberg;


--
-- Name: TABLE island_path; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.island_path TO gwajnberg;


--
-- Name: SEQUENCE island_path_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.island_path_id_seq TO gwajnberg;


--
-- Name: TABLE kleborate; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.kleborate TO gwajnberg;


--
-- Name: SEQUENCE kleborate_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.kleborate_id_seq TO gwajnberg;


--
-- Name: TABLE mlst; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.mlst TO gwajnberg;


--
-- Name: SEQUENCE mlst_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.mlst_id_seq TO gwajnberg;


--
-- Name: TABLE mob_rgi; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.mob_rgi TO gwajnberg;


--
-- Name: SEQUENCE mob_rgi_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.mob_rgi_id_seq TO gwajnberg;


--
-- Name: TABLE plasmid_finder; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.plasmid_finder TO gwajnberg;


--
-- Name: SEQUENCE plasmid_finder_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.plasmid_finder_id_seq TO gwajnberg;


--
-- Name: TABLE refseq_masher; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.refseq_masher TO gwajnberg;


--
-- Name: SEQUENCE refseq_masher_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.refseq_masher_id_seq TO gwajnberg;


--
-- Name: TABLE resfinder; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.resfinder TO gwajnberg;


--
-- Name: SEQUENCE resfinder_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.resfinder_id_seq TO gwajnberg;


--
-- Name: TABLE resfinder_predicted_phenotypes; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.resfinder_predicted_phenotypes TO gwajnberg;


--
-- Name: TABLE salmonella_serotyping; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.salmonella_serotyping TO gwajnberg;


--
-- Name: SEQUENCE salmonella_serotyping_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.salmonella_serotyping_id_seq TO gwajnberg;


--
-- Name: TABLE virulence_vf; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.virulence_vf TO gwajnberg;


--
-- Name: SEQUENCE virulence_vf_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.virulence_vf_id_seq TO gwajnberg;


--
-- Name: TABLE virulence_vfdb; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE bioinf.virulence_vfdb TO gwajnberg;


--
-- Name: SEQUENCE virulence_vfdb_id_seq; Type: ACL; Schema: bioinf; Owner: grdi
--

GRANT ALL ON SEQUENCE bioinf.virulence_vfdb_id_seq TO gwajnberg;


--
-- Name: TABLE countries; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.countries TO gwajnberg;


--
-- Name: TABLE samples; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.samples TO gwajnberg;


--
-- Name: TABLE state_province_regions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.state_province_regions TO gwajnberg;


--
-- Name: TABLE host_organisms; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.host_organisms TO gwajnberg;


--
-- Name: TABLE extractions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.extractions TO gwajnberg;


--
-- Name: TABLE isolates; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.isolates TO gwajnberg;


--
-- Name: TABLE public_repository_information; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.public_repository_information TO gwajnberg;


--
-- Name: TABLE sequencing; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequencing TO gwajnberg;


--
-- Name: TABLE wgs_extractions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.wgs_extractions TO gwajnberg;


--
-- Name: TABLE microbes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.microbes TO gwajnberg;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.projects TO gwajnberg;


--
-- Name: TABLE environmental_data_site; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_site TO gwajnberg;


--
-- Name: TABLE ontology_terms; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.ontology_terms TO gwajnberg;


--
-- Name: TABLE sample_activity; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sample_activity TO gwajnberg;


--
-- Name: TABLE environmental_data_material; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_material TO gwajnberg;


--
-- Name: TABLE food_data_product_property; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_data_product_property TO gwajnberg;


--
-- Name: TABLE alternative_isolate_ids; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.alternative_isolate_ids TO gwajnberg;


--
-- Name: TABLE activities; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.activities TO gwajnberg;


--
-- Name: TABLE agencies; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.agencies TO gwajnberg;


--
-- Name: TABLE alternative_sample_ids; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.alternative_sample_ids TO gwajnberg;


--
-- Name: TABLE am_susceptibility_tests; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.am_susceptibility_tests TO gwajnberg;


--
-- Name: SEQUENCE am_susceptibility_tests_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.am_susceptibility_tests_id_seq TO gwajnberg;


--
-- Name: TABLE amr_antibiotics_profile; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.amr_antibiotics_profile TO gwajnberg;


--
-- Name: SEQUENCE amr_antibiotics_profile_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.amr_antibiotics_profile_id_seq TO gwajnberg;


--
-- Name: TABLE anatomical_data_body; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_data_body TO gwajnberg;


--
-- Name: TABLE anatomical_data_material; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_data_material TO gwajnberg;


--
-- Name: TABLE anatomical_data_part; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_data_part TO gwajnberg;


--
-- Name: TABLE anatomical_materials; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_materials TO gwajnberg;


--
-- Name: TABLE anatomical_parts; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_parts TO gwajnberg;


--
-- Name: TABLE anatomical_regions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.anatomical_regions TO gwajnberg;


--
-- Name: TABLE animal_or_plant_populations; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.animal_or_plant_populations TO gwajnberg;


--
-- Name: TABLE animal_source_of_food; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.animal_source_of_food TO gwajnberg;


--
-- Name: TABLE antimicrobial_agents; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.antimicrobial_agents TO gwajnberg;


--
-- Name: TABLE antimicrobial_phenotypes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.antimicrobial_phenotypes TO gwajnberg;


--
-- Name: TABLE attribute_packages; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.attribute_packages TO gwajnberg;


--
-- Name: TABLE available_data_types; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.available_data_types TO gwajnberg;


--
-- Name: TABLE body_products; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.body_products TO gwajnberg;


--
-- Name: TABLE collection_devices; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.collection_devices TO gwajnberg;


--
-- Name: TABLE collection_methods; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.collection_methods TO gwajnberg;


--
-- Name: TABLE consensus_sequence_software; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.consensus_sequence_software TO gwajnberg;


--
-- Name: SEQUENCE consensus_sequence_software_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.consensus_sequence_software_id_seq TO gwajnberg;


--
-- Name: TABLE contact_information; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.contact_information TO gwajnberg;


--
-- Name: SEQUENCE contact_information_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.contact_information_id_seq TO gwajnberg;


--
-- Name: SEQUENCE countries_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.countries_id_seq TO gwajnberg;


--
-- Name: TABLE db_versions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.db_versions TO gwajnberg;


--
-- Name: TABLE depth_units; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.depth_units TO gwajnberg;


--
-- Name: TABLE duration_units; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.duration_units TO gwajnberg;


--
-- Name: TABLE environmental_data_animal_plant; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_animal_plant TO gwajnberg;


--
-- Name: TABLE environmental_data_available_data_type; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_available_data_type TO gwajnberg;


--
-- Name: TABLE environmental_data_material_constituents; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_material_constituents TO gwajnberg;


--
-- Name: TABLE environmental_data_presampling_weather_conditions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_presampling_weather_conditions TO gwajnberg;


--
-- Name: TABLE environmental_data_sampling_weather_conditions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_data_sampling_weather_conditions TO gwajnberg;


--
-- Name: TABLE environmental_materials; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_materials TO gwajnberg;


--
-- Name: TABLE environmental_sites; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.environmental_sites TO gwajnberg;


--
-- Name: TABLE experimental_specimen_role_types; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.experimental_specimen_role_types TO gwajnberg;


--
-- Name: SEQUENCE extractions_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.extractions_id_seq TO gwajnberg;


--
-- Name: TABLE food_data_label_claims; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_data_label_claims TO gwajnberg;


--
-- Name: TABLE food_data_packaging; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_data_packaging TO gwajnberg;


--
-- Name: TABLE food_data_product; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_data_product TO gwajnberg;


--
-- Name: TABLE food_data_source; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_data_source TO gwajnberg;


--
-- Name: TABLE food_packaging; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_packaging TO gwajnberg;


--
-- Name: TABLE food_product_production_streams; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_product_production_streams TO gwajnberg;


--
-- Name: TABLE food_product_properties; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_product_properties TO gwajnberg;


--
-- Name: TABLE food_products; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.food_products TO gwajnberg;


--
-- Name: TABLE genomic_target_enrichment_methods; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.genomic_target_enrichment_methods TO gwajnberg;


--
-- Name: TABLE host_age_bin; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.host_age_bin TO gwajnberg;


--
-- Name: TABLE host_food_production_names; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.host_food_production_names TO gwajnberg;


--
-- Name: SEQUENCE host_organisms_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.host_organisms_id_seq TO gwajnberg;


--
-- Name: SEQUENCE isolates_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.isolates_id_seq TO gwajnberg;


--
-- Name: TABLE label_claims; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.label_claims TO gwajnberg;


--
-- Name: TABLE laboratory_typing_methods; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.laboratory_typing_methods TO gwajnberg;


--
-- Name: TABLE laboratory_typing_platforms; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.laboratory_typing_platforms TO gwajnberg;


--
-- Name: TABLE measurement_sign; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.measurement_sign TO gwajnberg;


--
-- Name: TABLE measurement_units; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.measurement_units TO gwajnberg;


--
-- Name: TABLE metagenomic_extractions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.metagenomic_extractions TO gwajnberg;


--
-- Name: SEQUENCE microbes_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.microbes_id_seq TO gwajnberg;


--
-- Name: SEQUENCE ontology_terms_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.ontology_terms_id_seq TO gwajnberg;


--
-- Name: SEQUENCE projects_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.projects_id_seq TO gwajnberg;


--
-- Name: SEQUENCE public_repository_information_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.public_repository_information_id_seq TO gwajnberg;


--
-- Name: TABLE purposes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.purposes TO gwajnberg;


--
-- Name: TABLE quality_control_determinations; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.quality_control_determinations TO gwajnberg;


--
-- Name: TABLE quality_control_issues; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.quality_control_issues TO gwajnberg;


--
-- Name: TABLE read_mapping_software_names; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.read_mapping_software_names TO gwajnberg;


--
-- Name: SEQUENCE read_mapping_software_names_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.read_mapping_software_names_id_seq TO gwajnberg;


--
-- Name: TABLE reference_genome_accessions; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.reference_genome_accessions TO gwajnberg;


--
-- Name: SEQUENCE reference_genome_accessions_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.reference_genome_accessions_id_seq TO gwajnberg;


--
-- Name: TABLE residual_sample_status; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.residual_sample_status TO gwajnberg;


--
-- Name: TABLE risk_activity; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.risk_activity TO gwajnberg;


--
-- Name: TABLE sample_collection_date_precision; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sample_collection_date_precision TO gwajnberg;


--
-- Name: SEQUENCE sample_metadata_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.sample_metadata_id_seq TO gwajnberg;


--
-- Name: TABLE sample_purposes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sample_purposes TO gwajnberg;


--
-- Name: TABLE sequence_assembly_software; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequence_assembly_software TO gwajnberg;


--
-- Name: SEQUENCE sequence_assembly_software_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.sequence_assembly_software_id_seq TO gwajnberg;


--
-- Name: TABLE sequencing_assay_types; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequencing_assay_types TO gwajnberg;


--
-- Name: SEQUENCE sequencing_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.sequencing_id_seq TO gwajnberg;


--
-- Name: TABLE sequencing_instruments; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequencing_instruments TO gwajnberg;


--
-- Name: TABLE sequencing_platforms; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequencing_platforms TO gwajnberg;


--
-- Name: TABLE sequencing_purposes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.sequencing_purposes TO gwajnberg;


--
-- Name: TABLE specimen_processing; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.specimen_processing TO gwajnberg;


--
-- Name: TABLE stage_of_production; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.stage_of_production TO gwajnberg;


--
-- Name: SEQUENCE state_province_regions_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.state_province_regions_id_seq TO gwajnberg;


--
-- Name: TABLE taxonomic_identification_processes; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.taxonomic_identification_processes TO gwajnberg;


--
-- Name: TABLE temperature_units; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.temperature_units TO gwajnberg;


--
-- Name: TABLE template_mapping; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.template_mapping TO gwajnberg;


--
-- Name: SEQUENCE template_mapping_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.template_mapping_id_seq TO gwajnberg;


--
-- Name: TABLE testing_standard; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.testing_standard TO gwajnberg;


--
-- Name: TABLE time_of_day; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.time_of_day TO gwajnberg;


--
-- Name: TABLE user_bioinformatic_analyses; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.user_bioinformatic_analyses TO gwajnberg;


--
-- Name: SEQUENCE user_bioinformatic_analyses_id_seq; Type: ACL; Schema: public; Owner: grdi
--

GRANT ALL ON SEQUENCE public.user_bioinformatic_analyses_id_seq TO gwajnberg;


--
-- Name: TABLE vendor_names; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.vendor_names TO gwajnberg;


--
-- Name: TABLE volume_measurement_units; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.volume_measurement_units TO gwajnberg;


--
-- Name: TABLE weather_types; Type: ACL; Schema: public; Owner: grdi
--

GRANT SELECT,INSERT,REFERENCES,DELETE,TRIGGER,TRUNCATE,UPDATE ON TABLE public.weather_types TO gwajnberg;


--
-- PostgreSQL database dump complete
--

