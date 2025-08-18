--
-- PostgreSQL database dump
--

-- Dumped from database version 17.4
-- Dumped by pg_dump version 17.0

-- Started on 2025-08-08 13:49:09 EDT

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
-- TOC entry 6 (class 2615 OID 17291)
-- Name: ndh; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA ndh;


--
-- TOC entry 282 (class 1255 OID 18237)
-- Name: insert_practitioner(bigint, character varying, character varying, date, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character varying, character, character varying); Type: FUNCTION; Schema: ndh; Owner: -
--

CREATE FUNCTION ndh.insert_practitioner(p_npi bigint, p_ssn character varying, p_gender_code character varying, p_birth_date date, p_first_name character varying, p_middle_name character varying, p_last_name character varying, p_name_prefix character varying, p_name_suffix character varying, p_language_spoken_id character varying, p_email_address character varying, p_nucc_taxonomy_code_id character varying, p_state_id character, p_phone_number character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
DECLARE p_individual_id int; p_phone_number_id int;
BEGIN

	INSERT INTO npi(npi, entity_type_code, enumeration_date, last_update_date)
	VALUES (p_npi, 1, CURRENT_DATE, CURRENT_DATE);

    INSERT INTO individual (ssn, gender_code, birth_date)
    VALUES (p_ssn, p_gender_code, p_birth_date)
	RETURNING id into p_individual_id;

	INSERT INTO provider (individual_id, npi)
	VALUES (p_individual_id, p_npi);

	INSERT INTO individual_to_name (individual_id, first_name, middle_name, last_name, prefix, suffix, fhir_name_type_id,effective_date)
	VALUES (p_individual_id, p_first_name,p_middle_name, p_last_name,p_name_prefix, p_name_suffix,2,p_birth_date);

	INSERT INTO phone_number (value)
	VALUES (p_phone_number)
	RETURNING id into p_phone_number_id;

	INSERT INTO individual_to_phone_number (individual_id, phone_number_id, phone_type_id)
	VALUES (p_individual_id, p_phone_number_id, 1);

	INSERT INTO individual_to_email_address (individual_id, email_address)
	VALUES (p_individual_id, p_email_address);

	INSERT INTO individual_to_language_spoken (individual_id, language_spoken_id)
	VALUES (p_individual_id, p_language_spoken_id);

	INSERT INTO individual_to_nucc_taxonomy_code (individual_id, nucc_taxonomy_code_id, state_id)
	values (p_individual_id, p_nucc_taxonomy_code_id, p_state_id);
	
END;
$$;


--
-- TOC entry 219 (class 1259 OID 17843)
-- Name: address; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.address (
    id integer NOT NULL,
    barcode_delivery_code character varying(12),
    smarty_key character varying(10),
    address_us_id integer,
    address_international_id integer,
    address_nonstandard_id integer
);


--
-- TOC entry 218 (class 1259 OID 17842)
-- Name: address_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4594 (class 0 OID 0)
-- Dependencies: 218
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.address_id_seq OWNED BY ndh.address.id;


--
-- TOC entry 223 (class 1259 OID 17859)
-- Name: address_international; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.address_international (
    id integer NOT NULL,
    address_id integer NOT NULL,
    input_id character varying(36),
    country character varying(64),
    geocode character varying(4),
    local_language character varying(6),
    freeform character varying(512),
    address1 character varying(64),
    address2 character varying(64),
    address3 character varying(64),
    address4 character varying(64),
    organization character varying(64),
    locality character varying(64),
    administrative_area character varying(32),
    postal_code character varying(16),
    administrative_area_iso2 character varying(8),
    sub_administrative_area character varying(64),
    country_iso_3 character varying(3),
    premise character varying(64),
    premise_number character varying(64),
    thoroughfare character varying(64),
    latitude numeric(9,6),
    longitude numeric(9,6),
    geocode_precision character varying(32),
    max_geocode_precision character varying(32),
    address_format character varying(128),
    verification_status character varying(32),
    address_precision character varying(32),
    max_address_precision character varying(32)
);


--
-- TOC entry 222 (class 1259 OID 17858)
-- Name: address_international_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.address_international_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4595 (class 0 OID 0)
-- Dependencies: 222
-- Name: address_international_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.address_international_id_seq OWNED BY ndh.address_international.id;


--
-- TOC entry 225 (class 1259 OID 17868)
-- Name: address_nonstandard; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.address_nonstandard (
    id integer NOT NULL,
    address_id integer NOT NULL,
    input_id character varying(36),
    input_index integer,
    candidate_index integer,
    addressee character varying(64),
    delivery_line_1 character varying(64),
    delivery_line_2 character varying(64),
    last_line character varying(64),
    address_type character varying(32),
    address_format character varying(128),
    raw_address text,
    latitude numeric(9,6),
    longitude numeric(9,6),
    notes text
);


--
-- TOC entry 224 (class 1259 OID 17867)
-- Name: address_nonstandard_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.address_nonstandard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4596 (class 0 OID 0)
-- Dependencies: 224
-- Name: address_nonstandard_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.address_nonstandard_id_seq OWNED BY ndh.address_nonstandard.id;


--
-- TOC entry 221 (class 1259 OID 17850)
-- Name: address_us; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.address_us (
    id integer NOT NULL,
    address_id integer NOT NULL,
    input_id character varying(36),
    input_index integer,
    candidate_index integer,
    addressee character varying(64),
    delivery_line_1 character varying(64),
    delivery_line_2 character varying(64),
    last_line character varying(64),
    delivery_point_barcode character varying(12),
    urbanization character varying(64),
    primary_number character varying(30),
    street_name character varying(64),
    street_predirection character varying(16),
    street_postdirection character varying(16),
    street_suffix character varying(16),
    secondary_number character varying(32),
    secondary_designator character varying(16),
    extra_secondary_number character varying(32),
    extra_secondary_designator character varying(16),
    pmb_designator character varying(16),
    pmb_number character varying(16),
    city_name character varying(64),
    default_city_name character varying(64),
    state_code character(2),
    zipcode character(5),
    plus4_code character varying(4),
    delivery_point character(2),
    delivery_point_check_digit character(1),
    record_type character(1),
    zip_type character varying(32),
    county_code character(5),
    ews_match character(5),
    carrier_route character(4),
    congressional_district character(2),
    building_default_indicator character(1),
    rdi character varying(12),
    elot_sequence character varying(4),
    elot_sort character varying(4),
    latitude numeric(9,6),
    longitude numeric(9,6),
    coordinate_license integer,
    geo_precision character varying(18),
    time_zone character varying(48),
    utc_offset numeric(4,2),
    dst character(5),
    dpv_match_code character varying(1),
    dpv_footnotes character varying(32),
    dpv_cmra character varying(1),
    dpv_vacant character varying(1),
    dpv_no_stat character varying(1),
    active character varying(1),
    footnotes character varying(24),
    lacslink_code character varying(2),
    lacslink_indicator character varying(1),
    suitelink_match character varying(5),
    enhanced_match character varying(64)
);


--
-- TOC entry 220 (class 1259 OID 17849)
-- Name: address_us_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.address_us_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4597 (class 0 OID 0)
-- Dependencies: 220
-- Name: address_us_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.address_us_id_seq OWNED BY ndh.address_us.id;


--
-- TOC entry 235 (class 1259 OID 17925)
-- Name: clinical_credential; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.clinical_credential (
    id integer NOT NULL,
    acronym character varying(20) NOT NULL,
    name character varying(100),
    source_url character varying(250)
);


--
-- TOC entry 234 (class 1259 OID 17924)
-- Name: clinical_credential_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.clinical_credential_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4598 (class 0 OID 0)
-- Dependencies: 234
-- Name: clinical_credential_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.clinical_credential_id_seq OWNED BY ndh.clinical_credential.id;


--
-- TOC entry 239 (class 1259 OID 17942)
-- Name: clinical_school; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.clinical_school (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    url character varying(500)
);


--
-- TOC entry 238 (class 1259 OID 17941)
-- Name: clinical_school_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.clinical_school_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4599 (class 0 OID 0)
-- Dependencies: 238
-- Name: clinical_school_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.clinical_school_id_seq OWNED BY ndh.clinical_school.id;


--
-- TOC entry 227 (class 1259 OID 17877)
-- Name: fhir_address_use; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fhir_address_use (
    id integer NOT NULL,
    value text NOT NULL
);


--
-- TOC entry 226 (class 1259 OID 17876)
-- Name: fhir_address_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.fhir_address_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4600 (class 0 OID 0)
-- Dependencies: 226
-- Name: fhir_address_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.fhir_address_type_id_seq OWNED BY ndh.fhir_address_use.id;


--
-- TOC entry 244 (class 1259 OID 17970)
-- Name: fhir_name_use; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fhir_name_use (
    id integer NOT NULL,
    value character varying(50) NOT NULL
);


--
-- TOC entry 243 (class 1259 OID 17969)
-- Name: fhir_name_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.fhir_name_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4601 (class 0 OID 0)
-- Dependencies: 243
-- Name: fhir_name_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.fhir_name_type_id_seq OWNED BY ndh.fhir_name_use.id;


--
-- TOC entry 260 (class 1259 OID 18980)
-- Name: fhir_phone_system; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fhir_phone_system (
    id integer NOT NULL,
    value character varying(20)
);


--
-- TOC entry 259 (class 1259 OID 18979)
-- Name: fhir_phone_system_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.fhir_phone_system_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4602 (class 0 OID 0)
-- Dependencies: 259
-- Name: fhir_phone_system_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.fhir_phone_system_id_seq OWNED BY ndh.fhir_phone_system.id;


--
-- TOC entry 248 (class 1259 OID 17990)
-- Name: fhir_phone_use; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fhir_phone_use (
    id integer NOT NULL,
    value text NOT NULL
);


--
-- TOC entry 229 (class 1259 OID 17896)
-- Name: fips_county; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fips_county (
    id character varying(5) NOT NULL,
    name character varying(200) NOT NULL,
    fips_state_id character varying(2) NOT NULL
);


--
-- TOC entry 228 (class 1259 OID 17887)
-- Name: fips_state; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.fips_state (
    id character(2) NOT NULL,
    name character varying(100) NOT NULL,
    abbreviation character(2) NOT NULL
);


--
-- TOC entry 241 (class 1259 OID 17956)
-- Name: individual; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual (
    ssn character varying(10) DEFAULT NULL::character varying,
    gender_code character(1) DEFAULT NULL::bpchar,
    birth_date date,
    id uuid NOT NULL
);


--
-- TOC entry 269 (class 1259 OID 19719)
-- Name: individual_to_nucc_taxonomy_to_license; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_nucc_taxonomy_to_license (
    id integer NOT NULL,
    individual_id uuid,
    nucc_taxonomy_code_id character varying(10),
    state_id character(2),
    license_number character varying(20)
);


--
-- TOC entry 268 (class 1259 OID 19718)
-- Name: individual_nucc_taxonomy_to_license_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.individual_nucc_taxonomy_to_license_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4603 (class 0 OID 0)
-- Dependencies: 268
-- Name: individual_nucc_taxonomy_to_license_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.individual_nucc_taxonomy_to_license_id_seq OWNED BY ndh.individual_to_nucc_taxonomy_to_license.id;


--
-- TOC entry 230 (class 1259 OID 17903)
-- Name: individual_to_address; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_address (
    address_use_id integer NOT NULL,
    address_id integer NOT NULL,
    individual_id uuid NOT NULL
);


--
-- TOC entry 240 (class 1259 OID 17950)
-- Name: individual_to_clinical_credential; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_clinical_credential (
    clinical_credential_id integer NOT NULL,
    receipt_date date,
    clinical_school_id integer,
    individual_id uuid NOT NULL
);


--
-- TOC entry 245 (class 1259 OID 17978)
-- Name: individual_to_email_address; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_email_address (
    email_address character varying(300) NOT NULL,
    individual_id uuid
);


--
-- TOC entry 237 (class 1259 OID 17936)
-- Name: individual_to_language_spoken; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_language_spoken (
    language_spoken_id character(2) NOT NULL,
    individual_id uuid NOT NULL
);


--
-- TOC entry 242 (class 1259 OID 17964)
-- Name: individual_to_name; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_name (
    last_name character varying(100),
    first_name character varying(100),
    middle_name character varying(21),
    prefix character varying(6),
    suffix character varying(6),
    fhir_name_use_id integer NOT NULL,
    effective_date date NOT NULL,
    end_date date,
    individual_id uuid NOT NULL
);


--
-- TOC entry 249 (class 1259 OID 18000)
-- Name: individual_to_phone_number; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.individual_to_phone_number (
    fhir_phone_use_id integer NOT NULL,
    phone_number_id integer NOT NULL,
    extension character varying(10),
    fhir_phone_system_id integer,
    individual_id uuid NOT NULL
);


--
-- TOC entry 236 (class 1259 OID 17931)
-- Name: language_spoken; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.language_spoken (
    id character(2) NOT NULL,
    value character varying(200)
);


--
-- TOC entry 254 (class 1259 OID 18027)
-- Name: medicare_provider_type; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.medicare_provider_type (
    id integer NOT NULL,
    value character varying NOT NULL
);


--
-- TOC entry 253 (class 1259 OID 18026)
-- Name: medicare_provider_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.medicare_provider_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4604 (class 0 OID 0)
-- Dependencies: 253
-- Name: medicare_provider_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.medicare_provider_type_id_seq OWNED BY ndh.medicare_provider_type.id;


--
-- TOC entry 270 (class 1259 OID 19749)
-- Name: ndh.fips_county; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh."ndh.fips_county" (
    id text,
    name text,
    fips_state_id text
);


--
-- TOC entry 246 (class 1259 OID 17983)
-- Name: npi; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.npi (
    npi bigint NOT NULL,
    entity_type_code smallint NOT NULL,
    replacement_npi bigint,
    enumeration_date date NOT NULL,
    last_update_date date NOT NULL,
    deactivation_reason_code character varying(3),
    deactivation_date date,
    reactivation_date date,
    certification_date date,
    CONSTRAINT npi_npi_check CHECK (((npi > 999999999) AND (npi < '10000000000'::bigint)))
);


--
-- TOC entry 264 (class 1259 OID 19417)
-- Name: nucc_classification; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.nucc_classification (
    id integer NOT NULL,
    nucc_taxonomy_code_id character varying(10),
    display_name character varying(100),
    nucc_grouping_id integer
);


--
-- TOC entry 263 (class 1259 OID 19416)
-- Name: nucc_classification_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.nucc_classification_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4605 (class 0 OID 0)
-- Dependencies: 263
-- Name: nucc_classification_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.nucc_classification_id_seq OWNED BY ndh.nucc_classification.id;


--
-- TOC entry 262 (class 1259 OID 19410)
-- Name: nucc_grouping; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.nucc_grouping (
    id integer NOT NULL,
    display_name character varying(100)
);


--
-- TOC entry 261 (class 1259 OID 19409)
-- Name: nucc_group_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.nucc_group_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4606 (class 0 OID 0)
-- Dependencies: 261
-- Name: nucc_group_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.nucc_group_id_seq OWNED BY ndh.nucc_grouping.id;


--
-- TOC entry 266 (class 1259 OID 19424)
-- Name: nucc_specialization; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.nucc_specialization (
    id integer NOT NULL,
    nucc_taxonomy_code_id character varying(10),
    display_name character varying(100),
    nucc_classification_id integer
);


--
-- TOC entry 267 (class 1259 OID 19454)
-- Name: nucc_hierarchy; Type: VIEW; Schema: ndh; Owner: -
--

CREATE VIEW ndh.nucc_hierarchy AS
 SELECT "Grouping",
    "Classification",
    "Specialization",
    "Taxonomy Code"
   FROM ( SELECT g.display_name AS "Grouping",
            c.display_name AS "Classification",
            s.display_name AS "Specialization",
            s.nucc_taxonomy_code_id AS "Taxonomy Code"
           FROM ((ndh.nucc_specialization s
             LEFT JOIN ndh.nucc_classification c ON ((c.id = s.nucc_classification_id)))
             LEFT JOIN ndh.nucc_grouping g ON ((g.id = c.nucc_grouping_id)))
        UNION
         SELECT g.display_name AS "Grouping",
            c.display_name AS "Classification",
            ''::character varying AS "Specialization",
                CASE
                    WHEN (c.nucc_taxonomy_code_id IS NULL) THEN ''::character varying
                    ELSE c.nucc_taxonomy_code_id
                END AS "Taxonomy Code"
           FROM (ndh.nucc_classification c
             LEFT JOIN ndh.nucc_grouping g ON ((g.id = c.nucc_grouping_id)))
        UNION
         SELECT g.display_name AS "Grouping",
            ''::character varying AS "Classification",
            ''::character varying AS "Specialization",
            ''::character varying AS "Taxonomy Code"
           FROM ndh.nucc_grouping g) unnamed_subquery
  ORDER BY ROW("Grouping", "Classification", "Specialization");


--
-- TOC entry 265 (class 1259 OID 19423)
-- Name: nucc_specialization_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.nucc_specialization_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4607 (class 0 OID 0)
-- Dependencies: 265
-- Name: nucc_specialization_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.nucc_specialization_id_seq OWNED BY ndh.nucc_specialization.id;


--
-- TOC entry 252 (class 1259 OID 18014)
-- Name: nucc_taxonomy_code; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.nucc_taxonomy_code (
    id character varying(10) NOT NULL,
    display_name text NOT NULL,
    definition text,
    notes text,
    certifying_board_name text,
    certifying_board_url text
);


--
-- TOC entry 256 (class 1259 OID 18038)
-- Name: nucc_taxonomy_code_to_medicare_provider_type; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.nucc_taxonomy_code_to_medicare_provider_type (
    id integer NOT NULL,
    medicare_provider_type_id integer NOT NULL,
    nucc_taxonomy_code_id integer NOT NULL
);


--
-- TOC entry 255 (class 1259 OID 18037)
-- Name: nucc_taxonomy_code_to_medicare_provider_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4608 (class 0 OID 0)
-- Dependencies: 255
-- Name: nucc_taxonomy_code_to_medicare_provider_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq OWNED BY ndh.nucc_taxonomy_code_to_medicare_provider_type.id;


--
-- TOC entry 232 (class 1259 OID 17909)
-- Name: other_identifier_type; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.other_identifier_type (
    id integer NOT NULL,
    value text NOT NULL
);


--
-- TOC entry 231 (class 1259 OID 17908)
-- Name: other_identifier_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.other_identifier_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4609 (class 0 OID 0)
-- Dependencies: 231
-- Name: other_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.other_identifier_type_id_seq OWNED BY ndh.other_identifier_type.id;


--
-- TOC entry 251 (class 1259 OID 18006)
-- Name: phone_number; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.phone_number (
    id integer NOT NULL,
    value character varying(20) NOT NULL
);


--
-- TOC entry 250 (class 1259 OID 18005)
-- Name: phone_number_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.phone_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4610 (class 0 OID 0)
-- Dependencies: 250
-- Name: phone_number_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.phone_number_id_seq OWNED BY ndh.phone_number.id;


--
-- TOC entry 247 (class 1259 OID 17989)
-- Name: phone_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: -
--

CREATE SEQUENCE ndh.phone_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- TOC entry 4611 (class 0 OID 0)
-- Dependencies: 247
-- Name: phone_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: -
--

ALTER SEQUENCE ndh.phone_type_id_seq OWNED BY ndh.fhir_phone_use.id;


--
-- TOC entry 258 (class 1259 OID 18214)
-- Name: provider; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.provider (
    npi bigint NOT NULL,
    individual_id uuid
);


--
-- TOC entry 257 (class 1259 OID 18164)
-- Name: provider_to_nucc_taxonomy_code; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.provider_to_nucc_taxonomy_code (
    nucc_taxonomy_code_id character varying(10) NOT NULL,
    is_primary boolean NOT NULL,
    individual_id uuid NOT NULL
);


--
-- TOC entry 233 (class 1259 OID 17919)
-- Name: provider_to_other_identifier; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE ndh.provider_to_other_identifier (
    value character varying(21) NOT NULL,
    other_identifier_type_id integer NOT NULL,
    state_id character(2) NOT NULL,
    issuer_name character varying(81) NOT NULL,
    issue_date date,
    expiry_date date,
    individual_id uuid NOT NULL
);


--
-- TOC entry 4302 (class 2604 OID 17846)
-- Name: address id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address ALTER COLUMN id SET DEFAULT nextval('ndh.address_id_seq'::regclass);


--
-- TOC entry 4304 (class 2604 OID 17862)
-- Name: address_international id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_international ALTER COLUMN id SET DEFAULT nextval('ndh.address_international_id_seq'::regclass);


--
-- TOC entry 4305 (class 2604 OID 17871)
-- Name: address_nonstandard id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_nonstandard ALTER COLUMN id SET DEFAULT nextval('ndh.address_nonstandard_id_seq'::regclass);


--
-- TOC entry 4303 (class 2604 OID 17853)
-- Name: address_us id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_us ALTER COLUMN id SET DEFAULT nextval('ndh.address_us_id_seq'::regclass);


--
-- TOC entry 4308 (class 2604 OID 17928)
-- Name: clinical_credential id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.clinical_credential ALTER COLUMN id SET DEFAULT nextval('ndh.clinical_credential_id_seq'::regclass);


--
-- TOC entry 4309 (class 2604 OID 17945)
-- Name: clinical_school id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.clinical_school ALTER COLUMN id SET DEFAULT nextval('ndh.clinical_school_id_seq'::regclass);


--
-- TOC entry 4306 (class 2604 OID 17880)
-- Name: fhir_address_use id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_address_use ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_address_type_id_seq'::regclass);


--
-- TOC entry 4312 (class 2604 OID 17973)
-- Name: fhir_name_use id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_name_use ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_name_type_id_seq'::regclass);


--
-- TOC entry 4317 (class 2604 OID 18983)
-- Name: fhir_phone_system id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_phone_system ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_phone_system_id_seq'::regclass);


--
-- TOC entry 4313 (class 2604 OID 17993)
-- Name: fhir_phone_use id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_phone_use ALTER COLUMN id SET DEFAULT nextval('ndh.phone_type_id_seq'::regclass);


--
-- TOC entry 4321 (class 2604 OID 19722)
-- Name: individual_to_nucc_taxonomy_to_license id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_nucc_taxonomy_to_license ALTER COLUMN id SET DEFAULT nextval('ndh.individual_nucc_taxonomy_to_license_id_seq'::regclass);


--
-- TOC entry 4315 (class 2604 OID 18030)
-- Name: medicare_provider_type id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.medicare_provider_type ALTER COLUMN id SET DEFAULT nextval('ndh.medicare_provider_type_id_seq'::regclass);


--
-- TOC entry 4319 (class 2604 OID 19420)
-- Name: nucc_classification id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_classification ALTER COLUMN id SET DEFAULT nextval('ndh.nucc_classification_id_seq'::regclass);


--
-- TOC entry 4318 (class 2604 OID 19413)
-- Name: nucc_grouping id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_grouping ALTER COLUMN id SET DEFAULT nextval('ndh.nucc_group_id_seq'::regclass);


--
-- TOC entry 4320 (class 2604 OID 19427)
-- Name: nucc_specialization id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_specialization ALTER COLUMN id SET DEFAULT nextval('ndh.nucc_specialization_id_seq'::regclass);


--
-- TOC entry 4316 (class 2604 OID 18041)
-- Name: nucc_taxonomy_code_to_medicare_provider_type id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code_to_medicare_provider_type ALTER COLUMN id SET DEFAULT nextval('ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq'::regclass);


--
-- TOC entry 4307 (class 2604 OID 17912)
-- Name: other_identifier_type id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.other_identifier_type ALTER COLUMN id SET DEFAULT nextval('ndh.other_identifier_type_id_seq'::regclass);


--
-- TOC entry 4314 (class 2604 OID 18009)
-- Name: phone_number id; Type: DEFAULT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.phone_number ALTER COLUMN id SET DEFAULT nextval('ndh.phone_number_id_seq'::regclass);


--
-- TOC entry 4328 (class 2606 OID 17866)
-- Name: address_international address_international_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_international
    ADD CONSTRAINT address_international_pkey PRIMARY KEY (id);


--
-- TOC entry 4330 (class 2606 OID 17875)
-- Name: address_nonstandard address_nonstandard_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_nonstandard
    ADD CONSTRAINT address_nonstandard_pkey PRIMARY KEY (id);


--
-- TOC entry 4324 (class 2606 OID 17848)
-- Name: address address_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- TOC entry 4326 (class 2606 OID 17857)
-- Name: address_us address_us_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_us
    ADD CONSTRAINT address_us_pkey PRIMARY KEY (id);


--
-- TOC entry 4354 (class 2606 OID 17930)
-- Name: clinical_credential clinical_credential_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.clinical_credential
    ADD CONSTRAINT clinical_credential_pkey PRIMARY KEY (id);


--
-- TOC entry 4360 (class 2606 OID 17949)
-- Name: clinical_school clinical_school_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.clinical_school
    ADD CONSTRAINT clinical_school_pkey PRIMARY KEY (id);


--
-- TOC entry 4332 (class 2606 OID 17884)
-- Name: fhir_address_use fhir_address_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_address_use
    ADD CONSTRAINT fhir_address_use_pkey PRIMARY KEY (id);


--
-- TOC entry 4369 (class 2606 OID 17975)
-- Name: fhir_name_use fhir_name_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_name_use
    ADD CONSTRAINT fhir_name_use_pkey PRIMARY KEY (id);


--
-- TOC entry 4402 (class 2606 OID 18985)
-- Name: fhir_phone_system fhir_phone_system_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_phone_system
    ADD CONSTRAINT fhir_phone_system_pkey PRIMARY KEY (id);


--
-- TOC entry 4377 (class 2606 OID 17997)
-- Name: fhir_phone_use fhir_phone_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_phone_use
    ADD CONSTRAINT fhir_phone_use_pkey PRIMARY KEY (id);


--
-- TOC entry 4342 (class 2606 OID 17900)
-- Name: fips_county fips_county_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT fips_county_pkey PRIMARY KEY (id);


--
-- TOC entry 4336 (class 2606 OID 17891)
-- Name: fips_state fips_state_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT fips_state_pkey PRIMARY KEY (id);


--
-- TOC entry 4364 (class 2606 OID 18992)
-- Name: individual individual_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual
    ADD CONSTRAINT individual_pkey PRIMARY KEY (id);


--
-- TOC entry 4346 (class 2606 OID 19034)
-- Name: individual_to_address individual_to_address_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_address
    ADD CONSTRAINT individual_to_address_pkey PRIMARY KEY (individual_id, address_id);


--
-- TOC entry 4362 (class 2606 OID 19036)
-- Name: individual_to_clinical_credential individual_to_clinical_credential_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_clinical_credential
    ADD CONSTRAINT individual_to_clinical_credential_pkey PRIMARY KEY (individual_id, clinical_credential_id);


--
-- TOC entry 4373 (class 2606 OID 19038)
-- Name: individual_to_email_address individual_to_email_address_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_email_address
    ADD CONSTRAINT individual_to_email_address_pkey PRIMARY KEY (email_address);


--
-- TOC entry 4358 (class 2606 OID 19040)
-- Name: individual_to_language_spoken individual_to_language_spoken_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_language_spoken
    ADD CONSTRAINT individual_to_language_spoken_pkey PRIMARY KEY (individual_id, language_spoken_id);


--
-- TOC entry 4367 (class 2606 OID 19710)
-- Name: individual_to_name individual_to_name_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_name
    ADD CONSTRAINT individual_to_name_pkey PRIMARY KEY (individual_id, fhir_name_use_id, effective_date);


--
-- TOC entry 4396 (class 2606 OID 19729)
-- Name: provider_to_nucc_taxonomy_code individual_to_nucc_taxonomy_code_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_nucc_taxonomy_code
    ADD CONSTRAINT individual_to_nucc_taxonomy_code_pkey PRIMARY KEY (individual_id, nucc_taxonomy_code_id);


--
-- TOC entry 4410 (class 2606 OID 19724)
-- Name: individual_to_nucc_taxonomy_to_license individual_to_nucc_taxonomy_to_license_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_nucc_taxonomy_to_license
    ADD CONSTRAINT individual_to_nucc_taxonomy_to_license_pkey PRIMARY KEY (id);


--
-- TOC entry 4352 (class 2606 OID 19708)
-- Name: provider_to_other_identifier individual_to_other_identifier_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_other_identifier
    ADD CONSTRAINT individual_to_other_identifier_pkey PRIMARY KEY (individual_id, state_id, value, other_identifier_type_id, issuer_name);


--
-- TOC entry 4381 (class 2606 OID 19050)
-- Name: individual_to_phone_number individual_to_phone_number_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_phone_number
    ADD CONSTRAINT individual_to_phone_number_pkey PRIMARY KEY (individual_id, phone_number_id, fhir_phone_use_id);


--
-- TOC entry 4356 (class 2606 OID 17935)
-- Name: language_spoken language_spoken_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.language_spoken
    ADD CONSTRAINT language_spoken_pkey PRIMARY KEY (id);


--
-- TOC entry 4390 (class 2606 OID 18034)
-- Name: medicare_provider_type medicare_provider_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.medicare_provider_type
    ADD CONSTRAINT medicare_provider_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4375 (class 2606 OID 17988)
-- Name: npi npi_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.npi
    ADD CONSTRAINT npi_pkey PRIMARY KEY (npi);


--
-- TOC entry 4406 (class 2606 OID 19422)
-- Name: nucc_classification nucc_classification_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_classification
    ADD CONSTRAINT nucc_classification_pkey PRIMARY KEY (id);


--
-- TOC entry 4404 (class 2606 OID 19415)
-- Name: nucc_grouping nucc_grouping_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_grouping
    ADD CONSTRAINT nucc_grouping_pkey PRIMARY KEY (id);


--
-- TOC entry 4408 (class 2606 OID 19429)
-- Name: nucc_specialization nucc_specialization_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_specialization
    ADD CONSTRAINT nucc_specialization_pkey PRIMARY KEY (id);


--
-- TOC entry 4388 (class 2606 OID 18020)
-- Name: nucc_taxonomy_code nucc_taxonomy_code_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code
    ADD CONSTRAINT nucc_taxonomy_code_pkey PRIMARY KEY (id);


--
-- TOC entry 4394 (class 2606 OID 18043)
-- Name: nucc_taxonomy_code_to_medicare_provider_type nucc_taxonomy_code_to_medicare_provider_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code_to_medicare_provider_type
    ADD CONSTRAINT nucc_taxonomy_code_to_medicare_provider_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4348 (class 2606 OID 17916)
-- Name: other_identifier_type other_identifier_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.other_identifier_type
    ADD CONSTRAINT other_identifier_type_pkey PRIMARY KEY (id);


--
-- TOC entry 4383 (class 2606 OID 18011)
-- Name: phone_number phone_number_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.phone_number
    ADD CONSTRAINT phone_number_pkey PRIMARY KEY (id);


--
-- TOC entry 4398 (class 2606 OID 18218)
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (npi);


--
-- TOC entry 4334 (class 2606 OID 17886)
-- Name: fhir_address_use uc_fhir_address_use_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_address_use
    ADD CONSTRAINT uc_fhir_address_use_value UNIQUE (value);


--
-- TOC entry 4371 (class 2606 OID 17977)
-- Name: fhir_name_use uc_fhir_name_use_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_name_use
    ADD CONSTRAINT uc_fhir_name_use_value UNIQUE (value);


--
-- TOC entry 4379 (class 2606 OID 17999)
-- Name: fhir_phone_use uc_fhir_phone_use_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fhir_phone_use
    ADD CONSTRAINT uc_fhir_phone_use_value UNIQUE (value);


--
-- TOC entry 4344 (class 2606 OID 17902)
-- Name: fips_county uc_fips_county_name; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT uc_fips_county_name UNIQUE (name);


--
-- TOC entry 4338 (class 2606 OID 17895)
-- Name: fips_state uc_fips_state_abbreviation; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT uc_fips_state_abbreviation UNIQUE (abbreviation);


--
-- TOC entry 4340 (class 2606 OID 17893)
-- Name: fips_state uc_fips_state_name; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT uc_fips_state_name UNIQUE (name);


--
-- TOC entry 4392 (class 2606 OID 18036)
-- Name: medicare_provider_type uc_medicare_provider_type_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.medicare_provider_type
    ADD CONSTRAINT uc_medicare_provider_type_value UNIQUE (value);


--
-- TOC entry 4350 (class 2606 OID 17918)
-- Name: other_identifier_type uc_other_identifier_type_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.other_identifier_type
    ADD CONSTRAINT uc_other_identifier_type_value UNIQUE (value);


--
-- TOC entry 4385 (class 2606 OID 18013)
-- Name: phone_number uc_phone_number_value; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.phone_number
    ADD CONSTRAINT uc_phone_number_value UNIQUE (value);


--
-- TOC entry 4400 (class 2606 OID 19738)
-- Name: provider uc_provider_individual_id; Type: CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider
    ADD CONSTRAINT uc_provider_individual_id UNIQUE (individual_id);


--
-- TOC entry 4365 (class 1259 OID 19736)
-- Name: individual_to_name_last_name_first_name_middle_name_idx; Type: INDEX; Schema: ndh; Owner: -
--

CREATE INDEX individual_to_name_last_name_first_name_middle_name_idx ON ndh.individual_to_name USING btree (last_name, first_name, middle_name);


--
-- TOC entry 4386 (class 1259 OID 19735)
-- Name: nucc_taxonomy_code_display_name_idx; Type: INDEX; Schema: ndh; Owner: -
--

CREATE INDEX nucc_taxonomy_code_display_name_idx ON ndh.nucc_taxonomy_code USING btree (display_name);


--
-- TOC entry 4411 (class 2606 OID 18070)
-- Name: address address_address_international_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address
    ADD CONSTRAINT address_address_international_id_fkey FOREIGN KEY (address_international_id) REFERENCES ndh.address_international(id);


--
-- TOC entry 4412 (class 2606 OID 18075)
-- Name: address address_address_nonstandard_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address
    ADD CONSTRAINT address_address_nonstandard_id_fkey FOREIGN KEY (address_nonstandard_id) REFERENCES ndh.address_nonstandard(id);


--
-- TOC entry 4413 (class 2606 OID 18770)
-- Name: address address_address_us_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address
    ADD CONSTRAINT address_address_us_id_fkey FOREIGN KEY (address_us_id) REFERENCES ndh.address_us(id);


--
-- TOC entry 4414 (class 2606 OID 18085)
-- Name: address_us address_us_county_code_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_us
    ADD CONSTRAINT address_us_county_code_fkey FOREIGN KEY (county_code) REFERENCES ndh.fips_county(id);


--
-- TOC entry 4415 (class 2606 OID 18080)
-- Name: address_us address_us_state_code_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.address_us
    ADD CONSTRAINT address_us_state_code_fkey FOREIGN KEY (state_code) REFERENCES ndh.fips_state(id);


--
-- TOC entry 4416 (class 2606 OID 18065)
-- Name: fips_county fips_county_fips_state_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT fips_county_fips_state_id_fkey FOREIGN KEY (fips_state_id) REFERENCES ndh.fips_state(id);


--
-- TOC entry 4417 (class 2606 OID 18090)
-- Name: fips_county fips_county_fips_state_id_fkey1; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT fips_county_fips_state_id_fkey1 FOREIGN KEY (fips_state_id) REFERENCES ndh.fips_state(id);


--
-- TOC entry 4442 (class 2606 OID 19730)
-- Name: individual_to_nucc_taxonomy_to_license individual_nucc_taxonomy_to_l_individual_id_nucc_taxonomy__fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_nucc_taxonomy_to_license
    ADD CONSTRAINT individual_nucc_taxonomy_to_l_individual_id_nucc_taxonomy__fkey FOREIGN KEY (individual_id, nucc_taxonomy_code_id) REFERENCES ndh.provider_to_nucc_taxonomy_code(individual_id, nucc_taxonomy_code_id);


--
-- TOC entry 4418 (class 2606 OID 18124)
-- Name: individual_to_address individual_to_address_address_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_address
    ADD CONSTRAINT individual_to_address_address_id_fkey FOREIGN KEY (address_id) REFERENCES ndh.address(id);


--
-- TOC entry 4419 (class 2606 OID 18119)
-- Name: individual_to_address individual_to_address_address_type_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_address
    ADD CONSTRAINT individual_to_address_address_type_id_fkey FOREIGN KEY (address_use_id) REFERENCES ndh.fhir_address_use(id) ON DELETE CASCADE;


--
-- TOC entry 4420 (class 2606 OID 19055)
-- Name: individual_to_address individual_to_address_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_address
    ADD CONSTRAINT individual_to_address_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4427 (class 2606 OID 18129)
-- Name: individual_to_clinical_credential individual_to_clinical_credential_clinical_credential_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_clinical_credential
    ADD CONSTRAINT individual_to_clinical_credential_clinical_credential_id_fkey FOREIGN KEY (clinical_credential_id) REFERENCES ndh.clinical_credential(id) ON UPDATE CASCADE;


--
-- TOC entry 4430 (class 2606 OID 19060)
-- Name: individual_to_email_address individual_to_email_address_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_email_address
    ADD CONSTRAINT individual_to_email_address_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4425 (class 2606 OID 19065)
-- Name: individual_to_language_spoken individual_to_language_spoken_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_language_spoken
    ADD CONSTRAINT individual_to_language_spoken_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4426 (class 2606 OID 18144)
-- Name: individual_to_language_spoken individual_to_language_spoken_language_spoken_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_language_spoken
    ADD CONSTRAINT individual_to_language_spoken_language_spoken_id_fkey FOREIGN KEY (language_spoken_id) REFERENCES ndh.language_spoken(id) ON UPDATE CASCADE;


--
-- TOC entry 4428 (class 2606 OID 18154)
-- Name: individual_to_name individual_to_name_fhir_name_use_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_name
    ADD CONSTRAINT individual_to_name_fhir_name_use_id_fkey FOREIGN KEY (fhir_name_use_id) REFERENCES ndh.fhir_name_use(id);


--
-- TOC entry 4429 (class 2606 OID 19070)
-- Name: individual_to_name individual_to_name_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_name
    ADD CONSTRAINT individual_to_name_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4435 (class 2606 OID 19075)
-- Name: provider_to_nucc_taxonomy_code individual_to_nucc_taxonomy_code_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_nucc_taxonomy_code
    ADD CONSTRAINT individual_to_nucc_taxonomy_code_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4436 (class 2606 OID 18174)
-- Name: provider_to_nucc_taxonomy_code individual_to_nucc_taxonomy_code_nucc_taxonomy_code_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_nucc_taxonomy_code
    ADD CONSTRAINT individual_to_nucc_taxonomy_code_nucc_taxonomy_code_id_fkey FOREIGN KEY (nucc_taxonomy_code_id) REFERENCES ndh.nucc_taxonomy_code(id);


--
-- TOC entry 4421 (class 2606 OID 19080)
-- Name: provider_to_other_identifier individual_to_other_identifier_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_other_identifier
    ADD CONSTRAINT individual_to_other_identifier_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4422 (class 2606 OID 18184)
-- Name: provider_to_other_identifier individual_to_other_identifier_other_identifier_type_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_other_identifier
    ADD CONSTRAINT individual_to_other_identifier_other_identifier_type_id_fkey FOREIGN KEY (other_identifier_type_id) REFERENCES ndh.other_identifier_type(id);


--
-- TOC entry 4423 (class 2606 OID 18189)
-- Name: provider_to_other_identifier individual_to_other_identifier_state_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_other_identifier
    ADD CONSTRAINT individual_to_other_identifier_state_id_fkey FOREIGN KEY (state_id) REFERENCES ndh.fips_state(id);


--
-- TOC entry 4431 (class 2606 OID 18986)
-- Name: individual_to_phone_number individual_to_phone_number_fhir_phone_system_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_phone_number
    ADD CONSTRAINT individual_to_phone_number_fhir_phone_system_id_fkey FOREIGN KEY (fhir_phone_system_id) REFERENCES ndh.fhir_phone_system(id);


--
-- TOC entry 4432 (class 2606 OID 19085)
-- Name: individual_to_phone_number individual_to_phone_number_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_phone_number
    ADD CONSTRAINT individual_to_phone_number_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4433 (class 2606 OID 18194)
-- Name: individual_to_phone_number individual_to_phone_number_phone_number_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_phone_number
    ADD CONSTRAINT individual_to_phone_number_phone_number_id_fkey FOREIGN KEY (phone_number_id) REFERENCES ndh.phone_number(id);


--
-- TOC entry 4434 (class 2606 OID 18204)
-- Name: individual_to_phone_number individual_to_phone_number_phone_type_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.individual_to_phone_number
    ADD CONSTRAINT individual_to_phone_number_phone_type_id_fkey FOREIGN KEY (fhir_phone_use_id) REFERENCES ndh.fhir_phone_use(id);


--
-- TOC entry 4440 (class 2606 OID 19430)
-- Name: nucc_classification nucc_classification_nucc_grouping_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_classification
    ADD CONSTRAINT nucc_classification_nucc_grouping_id_fkey FOREIGN KEY (nucc_grouping_id) REFERENCES ndh.nucc_grouping(id);


--
-- TOC entry 4441 (class 2606 OID 19447)
-- Name: nucc_specialization nucc_specialization_nucc_classification_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.nucc_specialization
    ADD CONSTRAINT nucc_specialization_nucc_classification_id_fkey FOREIGN KEY (nucc_classification_id) REFERENCES ndh.nucc_classification(id);


--
-- TOC entry 4438 (class 2606 OID 19700)
-- Name: provider provider_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider
    ADD CONSTRAINT provider_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.individual(id) ON DELETE CASCADE;


--
-- TOC entry 4439 (class 2606 OID 19695)
-- Name: provider provider_npi_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider
    ADD CONSTRAINT provider_npi_fkey FOREIGN KEY (npi) REFERENCES ndh.npi(npi) ON DELETE CASCADE;


--
-- TOC entry 4437 (class 2606 OID 19739)
-- Name: provider_to_nucc_taxonomy_code provider_to_nucc_taxonomy_code_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_nucc_taxonomy_code
    ADD CONSTRAINT provider_to_nucc_taxonomy_code_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.provider(individual_id);


--
-- TOC entry 4424 (class 2606 OID 19744)
-- Name: provider_to_other_identifier provider_to_other_identifier_individual_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE ONLY ndh.provider_to_other_identifier
    ADD CONSTRAINT provider_to_other_identifier_individual_id_fkey FOREIGN KEY (individual_id) REFERENCES ndh.provider(individual_id);


-- Completed on 2025-08-08 13:51:29 EDT

--
-- PostgreSQL database dump complete
--

