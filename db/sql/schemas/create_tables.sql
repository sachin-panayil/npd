
--
-- Name: address; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.address (
    id integer NOT NULL,
    barcode_delivery_code character varying(12),
    smarty_key character varying(10),
    address_us_id integer,
    address_international_id integer,
    address_nonstandard_id integer
);


ALTER TABLE ndh.address OWNER TO ndh;

--
-- Name: address_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.address_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.address_id_seq OWNER TO ndh;

--
-- Name: address_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.address_id_seq OWNED BY ndh.address.id;


--
-- Name: address_international; Type: TABLE; Schema: ndh; Owner: ndh
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


ALTER TABLE ndh.address_international OWNER TO ndh;

--
-- Name: address_international_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.address_international_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.address_international_id_seq OWNER TO ndh;

--
-- Name: address_international_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.address_international_id_seq OWNED BY ndh.address_international.id;


--
-- Name: address_nonstandard; Type: TABLE; Schema: ndh; Owner: ndh
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


ALTER TABLE ndh.address_nonstandard OWNER TO ndh;

--
-- Name: address_nonstandard_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.address_nonstandard_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.address_nonstandard_id_seq OWNER TO ndh;

--
-- Name: address_nonstandard_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.address_nonstandard_id_seq OWNED BY ndh.address_nonstandard.id;


--
-- Name: address_us; Type: TABLE; Schema: ndh; Owner: ndh
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


ALTER TABLE ndh.address_us OWNER TO ndh;

--
-- Name: address_us_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.address_us_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.address_us_id_seq OWNER TO ndh;

--
-- Name: address_us_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.address_us_id_seq OWNED BY ndh.address_us.id;


--
-- Name: clinical_credential; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.clinical_credential (
    id integer NOT NULL,
    acronym character varying(20) NOT NULL,
    name character varying(100),
    source_url character varying(250)
);


ALTER TABLE ndh.clinical_credential OWNER TO ndh;

--
-- Name: clinical_credential_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.clinical_credential_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.clinical_credential_id_seq OWNER TO ndh;

--
-- Name: clinical_credential_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.clinical_credential_id_seq OWNED BY ndh.clinical_credential.id;


--
-- Name: clinical_school; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.clinical_school (
    id integer NOT NULL,
    name character varying(20) NOT NULL,
    url character varying(500)
);


ALTER TABLE ndh.clinical_school OWNER TO ndh;

--
-- Name: clinical_school_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.clinical_school_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.clinical_school_id_seq OWNER TO ndh;

--
-- Name: clinical_school_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.clinical_school_id_seq OWNED BY ndh.clinical_school.id;


--
-- Name: fhir_address_use; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fhir_address_use (
    id integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE ndh.fhir_address_use OWNER TO ndh;

--
-- Name: fhir_address_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.fhir_address_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.fhir_address_type_id_seq OWNER TO ndh;

--
-- Name: fhir_address_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.fhir_address_type_id_seq OWNED BY ndh.fhir_address_use.id;


--
-- Name: fhir_name_use; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fhir_name_use (
    id integer NOT NULL,
    value character varying(50) NOT NULL
);


ALTER TABLE ndh.fhir_name_use OWNER TO ndh;

--
-- Name: fhir_name_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.fhir_name_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.fhir_name_type_id_seq OWNER TO ndh;

--
-- Name: fhir_name_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.fhir_name_type_id_seq OWNED BY ndh.fhir_name_use.id;


--
-- Name: fhir_phone_system; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fhir_phone_system (
    id integer NOT NULL,
    value character varying(20)
);


ALTER TABLE ndh.fhir_phone_system OWNER TO ndh;

--
-- Name: fhir_phone_system_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.fhir_phone_system_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.fhir_phone_system_id_seq OWNER TO ndh;

--
-- Name: fhir_phone_system_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.fhir_phone_system_id_seq OWNED BY ndh.fhir_phone_system.id;


--
-- Name: fhir_phone_use; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fhir_phone_use (
    id integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE ndh.fhir_phone_use OWNER TO ndh;

--
-- Name: fips_county; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fips_county (
    id character varying(5) NOT NULL,
    name character varying(200) NOT NULL,
    fips_state_id character varying(2) NOT NULL
);


ALTER TABLE ndh.fips_county OWNER TO ndh;

--
-- Name: fips_state; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.fips_state (
    id character(2) NOT NULL,
    name character varying(100) NOT NULL,
    abbreviation character(2) NOT NULL
);


ALTER TABLE ndh.fips_state OWNER TO ndh;

--
-- Name: individual; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual (
    ssn character varying(10) DEFAULT NULL::character varying,
    gender_code character(1) DEFAULT NULL::bpchar,
    birth_date date,
    id uuid NOT NULL
);


ALTER TABLE ndh.individual OWNER TO ndh;

--
-- Name: individual_to_address; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_address (
    address_use_id integer NOT NULL,
    address_id integer NOT NULL,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_address OWNER TO ndh;

--
-- Name: individual_to_clinical_credential; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_clinical_credential (
    clinical_credential_id integer NOT NULL,
    receipt_date date,
    clinical_school_id integer,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_clinical_credential OWNER TO ndh;

--
-- Name: individual_to_email_address; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_email_address (
    email_address character varying(300) NOT NULL,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_email_address OWNER TO ndh;

--
-- Name: individual_to_language_spoken; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_language_spoken (
    language_spoken_id character(2) NOT NULL,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_language_spoken OWNER TO ndh;

--
-- Name: individual_to_name; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_name (
    last_name character varying(100) NOT NULL,
    first_name character varying(100) NOT NULL,
    middle_name character varying(21) NOT NULL,
    prefix character varying(6) NOT NULL,
    suffix character varying(6) NOT NULL,
    fhir_name_type_id integer NOT NULL,
    effective_date date NOT NULL,
    end_date date,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_name OWNER TO ndh;

--
-- Name: individual_to_nucc_taxonomy_code; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_nucc_taxonomy_code (
    nucc_taxonomy_code_id character varying(10) NOT NULL,
    state_id character(2) NOT NULL,
    license_number character varying(20),
    is_primary boolean,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_nucc_taxonomy_code OWNER TO ndh;

--
-- Name: individual_to_other_identifier; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_other_identifier (
    value character varying(21) NOT NULL,
    other_identifier_type_id integer NOT NULL,
    state_id character(2) NOT NULL,
    issuer_name character varying(81),
    issue_date date,
    expiry_date date,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_other_identifier OWNER TO ndh;

--
-- Name: individual_to_phone_number; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.individual_to_phone_number (
    fhir_phone_use_id integer NOT NULL,
    phone_number_id integer NOT NULL,
    extension character varying(10),
    fhir_phone_system_id integer,
    individual_id uuid
);


ALTER TABLE ndh.individual_to_phone_number OWNER TO ndh;

--
-- Name: language_spoken; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.language_spoken (
    id character(2) NOT NULL,
    value character varying(200)
);


ALTER TABLE ndh.language_spoken OWNER TO ndh;

--
-- Name: medicare_provider_type; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.medicare_provider_type (
    id integer NOT NULL,
    value character varying NOT NULL
);


ALTER TABLE ndh.medicare_provider_type OWNER TO ndh;

--
-- Name: medicare_provider_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.medicare_provider_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.medicare_provider_type_id_seq OWNER TO ndh;

--
-- Name: medicare_provider_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.medicare_provider_type_id_seq OWNED BY ndh.medicare_provider_type.id;


--
-- Name: npi; Type: TABLE; Schema: ndh; Owner: ndh
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


ALTER TABLE ndh.npi OWNER TO ndh;

--
-- Name: nucc_taxonomy_code; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.nucc_taxonomy_code (
    id character varying(10) NOT NULL,
    display_name text NOT NULL,
    parent_id character varying(10),
    definition text,
    notes text,
    certifying_board_name text,
    certifying_board_url text
);


ALTER TABLE ndh.nucc_taxonomy_code OWNER TO ndh;

--
-- Name: nucc_taxonomy_code_to_medicare_provider_type; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.nucc_taxonomy_code_to_medicare_provider_type (
    id integer NOT NULL,
    medicare_provider_type_id integer NOT NULL,
    nucc_taxonomy_code_id integer NOT NULL
);


ALTER TABLE ndh.nucc_taxonomy_code_to_medicare_provider_type OWNER TO ndh;

--
-- Name: nucc_taxonomy_code_to_medicare_provider_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq OWNER TO ndh;

--
-- Name: nucc_taxonomy_code_to_medicare_provider_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq OWNED BY ndh.nucc_taxonomy_code_to_medicare_provider_type.id;


--
-- Name: other_identifier_type; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.other_identifier_type (
    id integer NOT NULL,
    value text NOT NULL
);


ALTER TABLE ndh.other_identifier_type OWNER TO ndh;

--
-- Name: other_identifier_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.other_identifier_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.other_identifier_type_id_seq OWNER TO ndh;

--
-- Name: other_identifier_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.other_identifier_type_id_seq OWNED BY ndh.other_identifier_type.id;


--
-- Name: phone_number; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.phone_number (
    id integer NOT NULL,
    value character varying(20) NOT NULL
);


ALTER TABLE ndh.phone_number OWNER TO ndh;

--
-- Name: phone_number_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.phone_number_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.phone_number_id_seq OWNER TO ndh;

--
-- Name: phone_number_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.phone_number_id_seq OWNED BY ndh.phone_number.id;


--
-- Name: phone_type_id_seq; Type: SEQUENCE; Schema: ndh; Owner: ndh
--

CREATE SEQUENCE ndh.phone_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE ndh.phone_type_id_seq OWNER TO ndh;

--
-- Name: phone_type_id_seq; Type: SEQUENCE OWNED BY; Schema: ndh; Owner: ndh
--

ALTER SEQUENCE ndh.phone_type_id_seq OWNED BY ndh.fhir_phone_use.id;


--
-- Name: provider; Type: TABLE; Schema: ndh; Owner: ndh
--

CREATE TABLE ndh.provider (
    npi bigint NOT NULL,
    individual_id uuid
);


ALTER TABLE ndh.provider OWNER TO ndh;

--
-- Name: address id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address ALTER COLUMN id SET DEFAULT nextval('ndh.address_id_seq'::regclass);


--
-- Name: address_international id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_international ALTER COLUMN id SET DEFAULT nextval('ndh.address_international_id_seq'::regclass);


--
-- Name: address_nonstandard id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_nonstandard ALTER COLUMN id SET DEFAULT nextval('ndh.address_nonstandard_id_seq'::regclass);


--
-- Name: address_us id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_us ALTER COLUMN id SET DEFAULT nextval('ndh.address_us_id_seq'::regclass);


--
-- Name: clinical_credential id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.clinical_credential ALTER COLUMN id SET DEFAULT nextval('ndh.clinical_credential_id_seq'::regclass);


--
-- Name: clinical_school id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.clinical_school ALTER COLUMN id SET DEFAULT nextval('ndh.clinical_school_id_seq'::regclass);


--
-- Name: fhir_address_use id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_address_use ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_address_type_id_seq'::regclass);


--
-- Name: fhir_name_use id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_name_use ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_name_type_id_seq'::regclass);


--
-- Name: fhir_phone_system id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_phone_system ALTER COLUMN id SET DEFAULT nextval('ndh.fhir_phone_system_id_seq'::regclass);


--
-- Name: fhir_phone_use id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_phone_use ALTER COLUMN id SET DEFAULT nextval('ndh.phone_type_id_seq'::regclass);


--
-- Name: medicare_provider_type id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.medicare_provider_type ALTER COLUMN id SET DEFAULT nextval('ndh.medicare_provider_type_id_seq'::regclass);


--
-- Name: nucc_taxonomy_code_to_medicare_provider_type id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code_to_medicare_provider_type ALTER COLUMN id SET DEFAULT nextval('ndh.nucc_taxonomy_code_to_medicare_provider_type_id_seq'::regclass);


--
-- Name: other_identifier_type id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.other_identifier_type ALTER COLUMN id SET DEFAULT nextval('ndh.other_identifier_type_id_seq'::regclass);


--
-- Name: phone_number id; Type: DEFAULT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.phone_number ALTER COLUMN id SET DEFAULT nextval('ndh.phone_number_id_seq'::regclass);


--
-- Name: address_international address_international_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_international
    ADD CONSTRAINT address_international_pkey PRIMARY KEY (id);


--
-- Name: address_nonstandard address_nonstandard_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_nonstandard
    ADD CONSTRAINT address_nonstandard_pkey PRIMARY KEY (id);


--
-- Name: address address_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address
    ADD CONSTRAINT address_pkey PRIMARY KEY (id);


--
-- Name: address_us address_us_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.address_us
    ADD CONSTRAINT address_us_pkey PRIMARY KEY (id);


--
-- Name: clinical_credential clinical_credential_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.clinical_credential
    ADD CONSTRAINT clinical_credential_pkey PRIMARY KEY (id);


--
-- Name: clinical_school clinical_school_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.clinical_school
    ADD CONSTRAINT clinical_school_pkey PRIMARY KEY (id);


--
-- Name: fhir_address_use fhir_address_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_address_use
    ADD CONSTRAINT fhir_address_use_pkey PRIMARY KEY (id);


--
-- Name: fhir_name_use fhir_name_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_name_use
    ADD CONSTRAINT fhir_name_use_pkey PRIMARY KEY (id);


--
-- Name: fhir_phone_system fhir_phone_system_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_phone_system
    ADD CONSTRAINT fhir_phone_system_pkey PRIMARY KEY (id);


--
-- Name: fhir_phone_use fhir_phone_use_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_phone_use
    ADD CONSTRAINT fhir_phone_use_pkey PRIMARY KEY (id);


--
-- Name: fips_county fips_county_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT fips_county_pkey PRIMARY KEY (id);


--
-- Name: fips_state fips_state_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT fips_state_pkey PRIMARY KEY (id);


--
-- Name: individual individual_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.individual
    ADD CONSTRAINT individual_pkey PRIMARY KEY (id);


--
-- Name: language_spoken language_spoken_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.language_spoken
    ADD CONSTRAINT language_spoken_pkey PRIMARY KEY (id);


--
-- Name: medicare_provider_type medicare_provider_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.medicare_provider_type
    ADD CONSTRAINT medicare_provider_type_pkey PRIMARY KEY (id);


--
-- Name: npi npi_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.npi
    ADD CONSTRAINT npi_pkey PRIMARY KEY (npi);


--
-- Name: nucc_taxonomy_code nucc_taxonomy_code_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code
    ADD CONSTRAINT nucc_taxonomy_code_pkey PRIMARY KEY (id);


--
-- Name: nucc_taxonomy_code_to_medicare_provider_type nucc_taxonomy_code_to_medicare_provider_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.nucc_taxonomy_code_to_medicare_provider_type
    ADD CONSTRAINT nucc_taxonomy_code_to_medicare_provider_type_pkey PRIMARY KEY (id);


--
-- Name: other_identifier_type other_identifier_type_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.other_identifier_type
    ADD CONSTRAINT other_identifier_type_pkey PRIMARY KEY (id);


--
-- Name: phone_number phone_number_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.phone_number
    ADD CONSTRAINT phone_number_pkey PRIMARY KEY (id);


--
-- Name: provider provider_pkey; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.provider
    ADD CONSTRAINT provider_pkey PRIMARY KEY (npi);


--
-- Name: fhir_address_use uc_fhir_address_use_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_address_use
    ADD CONSTRAINT uc_fhir_address_use_value UNIQUE (value);


--
-- Name: fhir_name_use uc_fhir_name_use_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_name_use
    ADD CONSTRAINT uc_fhir_name_use_value UNIQUE (value);


--
-- Name: fhir_phone_use uc_fhir_phone_use_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fhir_phone_use
    ADD CONSTRAINT uc_fhir_phone_use_value UNIQUE (value);


--
-- Name: fips_county uc_fips_county_name; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fips_county
    ADD CONSTRAINT uc_fips_county_name UNIQUE (name);


--
-- Name: fips_state uc_fips_state_abbreviation; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT uc_fips_state_abbreviation UNIQUE (abbreviation);


--
-- Name: fips_state uc_fips_state_name; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.fips_state
    ADD CONSTRAINT uc_fips_state_name UNIQUE (name);


--
-- Name: medicare_provider_type uc_medicare_provider_type_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.medicare_provider_type
    ADD CONSTRAINT uc_medicare_provider_type_value UNIQUE (value);


--
-- Name: other_identifier_type uc_other_identifier_type_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.other_identifier_type
    ADD CONSTRAINT uc_other_identifier_type_value UNIQUE (value);


--
-- Name: phone_number uc_phone_number_value; Type: CONSTRAINT; Schema: ndh; Owner: ndh
--

ALTER TABLE ONLY ndh.phone_number
    ADD CONSTRAINT uc_phone_number_value UNIQUE (value);

