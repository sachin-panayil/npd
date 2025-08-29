-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- Link to schema: https://app.quickdatabasediagrams.com/#/d/diFBJ4
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.

CREATE SCHEMA npd;

CREATE TABLE npd.address (
    id uuid PRIMARY KEY,
    barcode_delivery_code character varying(12),
    smarty_key character varying(10),
    address_us_id uuid,
    address_international_id uuid,
    address_nonstandard_id uuid
);

CREATE TABLE npd.address_us (
    id uuid PRIMARY KEY,
    input_id character varying(36),
    input_index integer,
    candidate_index integer,
    addressee character varying(64),
    delivery_line_1 character varying(64),
    delivery_line_2 character varying(64),
    last_line character varying(64),
    delivery_point_barcode character varying(12),
    urbanization character varying(64),
    primary_number character varying(30) NOT NULL,
    street_name character varying(64) NOT NULL,
    street_predirection character varying(16),
    street_postdirection character varying(16),
    street_suffix character varying(16),
    secondary_number character varying(32),
    secondary_designator character varying(16),
    extra_secondary_number character varying(32),
    extra_secondary_designator character varying(16),
    pmb_designator character varying(16),
    pmb_number character varying(16),
    city_name character varying(64) NOT NULL,
    default_city_name character varying(64),
    state_code character(2) NOT NULL,
    zipcode character(5) NOT NULL,
    plus4_code character varying(4),
    delivery_point character(2),
    delivery_point_check_digit character(1),
    record_type character(1),
    zip_type character varying(32),
    county_code character(5) NOT NULL,
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

CREATE TABLE npd.address_international (
    id uuid PRIMARY KEY,
    input_id character varying(36),
    country_code varchar(2) NOT NULL,
    geocode character varying(4),
    local_language character varying(6),
    freeform character varying(512),
    address1 character varying(64) NOT NULL,
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

CREATE TABLE npd.address_nonstandard (
    id uuid PRIMARY KEY,
    input_id character varying(36),
    input_index integer,
    candidate_index integer,
    addressee character varying(64),
    delivery_line_1 character varying(64) NOT NULL,
    delivery_line_2 character varying(64),
    last_line character varying(64),
    address_type character varying(32),
    address_format character varying(128),
    raw_address text,
    latitude numeric(9,6),
    longitude numeric(9,6),
    notes text
);

CREATE TABLE npd.fhir_address_use (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.fhir_name_use (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.fhir_phone_system (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.fhir_phone_use (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.fips_county (
    id character varying(5) PRIMARY KEY,
    name character varying(200) NOT NULL,
    fips_state_id character varying(2) NOT NULL
);

ALTER TABLE npd.fips_county ADD CONSTRAINT uc_fips_county_name_fips_state_id UNIQUE (name, fips_state_id);

CREATE TABLE npd.iso_country (
    code varchar(2) PRIMARY KEY,
    name varchar(50) UNIQUE
);

CREATE TABLE npd.medicare_provider_type (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.nucc_classification (
    id serial PRIMARY KEY,
    nucc_code character varying(10),
    display_name character varying(100),
    nucc_grouping_id integer
);

ALTER TABLE npd.nucc_classification ADD CONSTRAINT uc_nucc_classification_nucc_code_nucc_grouping UNIQUE (nucc_code, nucc_grouping_id);

CREATE TABLE npd.nucc_grouping (
    id serial PRIMARY KEY,
    display_name character varying(100) UNIQUE
);

CREATE TABLE npd.nucc_specialization (
    id serial PRIMARY KEY,
    nucc_code character varying(10),
    display_name character varying(100),
    nucc_classification_id integer
);

ALTER TABLE npd.nucc_specialization ADD CONSTRAINT uc_nucc_specialization_nucc_code_nucc_classification UNIQUE (nucc_code, nucc_classification_id);

CREATE TABLE npd.nucc (
    code character varying(10) PRIMARY KEY,
    display_name text NOT NULL,
    definition text,
    notes text,
    certifying_board_name text,
    certifying_board_url text
);

CREATE TABLE npd.nucc_to_medicare_provider_type (
    medicare_provider_type_id integer NOT NULL,
    nucc_code integer NOT NULL,
	PRIMARY KEY (medicare_provider_type_id, nucc_code)
);


CREATE TABLE npd.other_identifier_type (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

--
-- Name: fips_state; Type: TABLE; Schema: ndh; Owner: -
--

CREATE TABLE npd.fips_state (
    id character(2) PRIMARY KEY,
    name character varying(100) NOT NULL,
    abbreviation character(2) NOT NULL
);


CREATE TABLE npd.provider (
    npi bigint  PRIMARY KEY,
    individual_id uuid UNIQUE
);

CREATE TABLE npd.npi (
    npi bigint   PRIMARY KEY,
    entity_type_code SMALLINT   NOT NULL,
    replacement_npi VARCHAR(11),
    enumeration_date DATE   NOT NULL,
    last_update_date DATE   NOT NULL,
    deactivation_reason_code VARCHAR(3),
    deactivation_date DATE,
    reactivation_date DATE,
    certification_date DATE
);

CREATE TABLE npd.individual (
    id uuid   NOT NULL,
    ssn_id uuid,
    gender char(1),
    sex char(1),
    birth_date date,
    CONSTRAINT pk_individual PRIMARY KEY (
        id
     )
);

CREATE TABLE npd.language_spoken (
    id character(2) PRIMARY KEY,
    value character varying(200) UNIQUE
);

CREATE TABLE npd.individual_to_language_spoken (
    language_spoken_id character(2) NOT NULL,
    individual_id uuid NOT NULL,
    PRIMARY KEY (individual_id, language_spoken_id)
);

CREATE TABLE npd.individual_to_name (
    individual_id uuid   NOT NULL,
    prefix varchar(10) ,
    first_name varchar(50)   NOT NULL,
    middle_name varchar(50)   NOT NULL,
    last_name varchar(200)   NOT NULL,
    start_date date,
    end_date date,
    name_use_id int NOT NULL,
    CONSTRAINT pk_individual_to_name PRIMARY KEY (
        individual_id,first_name,middle_name,last_name, name_use_id
     )
);

CREATE TABLE npd.individual_to_email (
    individual_id uuid   NOT NULL,
    email_address varchar(1000)   NOT NULL,
    email_use_id int   NOT NULL,
    CONSTRAINT pk_individual_to_email PRIMARY KEY (
        individual_id,email_address, email_use_id
     )
);


CREATE TABLE npd.individual_to_phone (
    individual_id uuid   NOT NULL,
    phone_number varchar(20)   NOT NULL,
    extension varchar(10),
    phone_use_id int   NOT NULL,
    CONSTRAINT pk_individual_to_phone PRIMARY KEY (
        individual_id,phone_number, phone_use_id
     )
);

CREATE TABLE npd.individual_to_address (
    individual_id uuid   NOT NULL,
    address_id uuid   NOT NULL,
    address_use_id int   NOT NULL,
    CONSTRAINT pk_individual_to_address PRIMARY KEY (
        individual_id,address_id, address_use_id
     )
);

CREATE TABLE npd.provider_to_taxonomy (
    npi bigint   NOT NULL,
    nucc_code varchar(10)   NOT NULL,
    is_primary boolean DEFAULT FALSE,
    CONSTRAINT pk_provider_to_taxonomy PRIMARY KEY (
        npi,nucc_code
     )
);

CREATE TABLE npd.provider_to_credential (
    npi bigint   NOT NULL,
    credential_type_id int   NOT NULL,
    license_number varchar(20)   NOT NULL,
    state_code char(2)   NOT NULL,
    nucc_code varchar(10)   NOT NULL,
    CONSTRAINT pk_provider_to_credential PRIMARY KEY (
        npi, license_number, state_code, nucc_code
     )
);

CREATE TABLE npd.organization (
    id uuid   NOT NULL,
    authorized_official_id uuid   NOT NULL,
    ein_id uuid,
    parent_id uuid,
    CONSTRAINT pk_organization PRIMARY KEY (
        id
     )
);

CREATE TABLE npd.clinical_organization (
    organization_id uuid   UNIQUE,
    npi bigint,
    endpoint_instance_id uuid,
    CONSTRAINT pk_clinical_organization PRIMARY KEY (
        npi
     )
);

CREATE TABLE npd.organization_to_taxonomy (
    npi bigint   NOT NULL,
    nucc_code varchar(10)   NOT NULL,
    is_primary boolean DEFAULT FALSE,
    CONSTRAINT pk_organization_to_taxonomy PRIMARY KEY (
        npi,nucc_code
     )
);

CREATE TABLE npd.organization_to_phone (
    organization_id uuid   NOT NULL,
    phone_number varchar(20)   NOT NULL,
    extension varchar(10),
    phone_use_id int   NOT NULL,
    CONSTRAINT pk_organization_to_phone PRIMARY KEY (
        organization_id,phone_number, phone_use_id
     )
);

CREATE TABLE npd.organization_to_address (
    organization_id uuid   NOT NULL,
    address_id uuid   NOT NULL,
    address_use_id int   NOT NULL,
    CONSTRAINT pk_organization_to_address PRIMARY KEY (
        organization_id,address_id,address_use_id
     )
);

CREATE TABLE npd.organization_name (
    organization_id uuid,
    name varchar(1000)   NOT NULL,
	PRIMARY KEY (organization_id, name)
);

CREATE TABLE npd.location (
    id uuid   NOT NULL,
    name varchar(200),
    organization_id uuid   NOT NULL,
    address_id uuid   NOT NULL,
    CONSTRAINT pk_location PRIMARY KEY (
        id
     )
);

CREATE TABLE npd.legal_entity (
    ein_id uuid   NOT NULL,
    dba_name varchar(100)   NOT NULL,
    CONSTRAINT pk_legal_entity PRIMARY KEY (
        ein_id
     )
);

CREATE TABLE npd.provider_to_organization (
    individual_id uuid   NOT NULL,
    organization_id uuid   NOT NULL,
    relationship_type_id int   NOT NULL,
    endpoint_id uuid,
	PRIMARY KEY (individual_id, organization_id)
);

CREATE TABLE npd.relationship_type (
    id serial PRIMARY KEY,
    value varchar(20) UNIQUE
);

CREATE TABLE npd.provider_to_location (
    individual_id uuid   NOT NULL,
    organization_id uuid   NOT NULL,
    location_id uuid   NOT NULL,
    other_address_id uuid,
    nucc_code int,
    specialty_id int,
	PRIMARY KEY (individual_id, location_id)
);

CREATE TABLE npd.endpoint (
    id uuid   PRIMARY KEY,
    address varchar(200)   NOT NULL,
    endpoint_type_id int   NOT NULL,
    endpoint_instance_id uuid   NOT NULL
);


CREATE TABLE npd.endpoint_type(
    id serial PRIMARY KEY,
    value varchar(50) UNIQUE
);

ALTER TABLE npd.endpoint ADD FOREIGN KEY (endpoint_type_id) REFERENCES npd.endpoint_type(id);

CREATE TABLE npd.provider_education (
    npi bigint   NOT NULL,
    school_id int,
    degree_type_id int   NOT NULL,
    start_date date,
    end_date date,
    CONSTRAINT pk_provider_education PRIMARY KEY (
        npi,school_id
     )
);

CREATE TABLE npd.degree_type(
    id serial PRIMARY KEY,
    value varchar(50) UNIQUE
);

ALTER TABLE npd.provider_education ADD FOREIGN KEY (degree_type_id) REFERENCES npd.degree_type(id);


CREATE TABLE npd.ehr_vendor (
    id uuid   NOT NULL,
    name varchar(200)   NOT NULL,
    is_cms_aligned_network boolean DEFAULT FALSE,
    CONSTRAINT pk_ehr_vendor PRIMARY KEY (
        id
     )
);

CREATE TABLE npd.endpoint_instance (
    id uuid   NOT NULL,
    ehr_vendor_id uuid   NOT NULL,
    endpoint_instance_type_id int   NOT NULL,
    address varchar(200)   NOT NULL,
    CONSTRAINT pk_endpoint_instance PRIMARY KEY (
        id
     )
);

CREATE TABLE npd.endpoint_instance_type(
    id serial PRIMARY KEY,
    value varchar(50) UNIQUE
);

ALTER TABLE npd.endpoint_instance ADD FOREIGN KEY (endpoint_instance_type_id) REFERENCES npd.endpoint_instance_type(id);


CREATE TABLE npd.provider_to_other_id (
    npi bigint   NOT NULL,
    other_id varchar(100)   NOT NULL,
    other_id_type_id int   NOT NULL,
    CONSTRAINT pk_provider_to_other_id PRIMARY KEY (
        npi, other_id_type_id
     )
);

CREATE TABLE npd.organization_to_other_id (
    npi bigint   NOT NULL,
    other_id varchar(100)   NOT NULL,
    other_id_type_id int   NOT NULL,
    CONSTRAINT pk_organization_to_other_id PRIMARY KEY (
        npi
     )
);

ALTER TABLE NPD.provider ADD CONSTRAINT fk_provider_npi FOREIGN KEY(npi)
REFERENCES NPD.npi (npi);

ALTER TABLE NPD.provider ADD CONSTRAINT fk_provider_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.individual_to_name ADD CONSTRAINT fk_individual_to_name_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.individual_to_email ADD CONSTRAINT fk_individual_to_email_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.individual_to_phone ADD CONSTRAINT fk_individual_to_phone_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.individual_to_address ADD CONSTRAINT fk_individual_to_address_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.individual_to_address ADD CONSTRAINT fk_individual_to_address_address_id FOREIGN KEY(address_id)
REFERENCES NPD.address (id);

ALTER TABLE NPD.provider_to_taxonomy ADD CONSTRAINT fk_provider_to_taxonomy_npi FOREIGN KEY(npi)
REFERENCES NPD.provider (npi);

ALTER TABLE NPD.provider_to_credential ADD CONSTRAINT fk_provider_to_credential_npi_nucc_code FOREIGN KEY(npi, nucc_code)
REFERENCES NPD.provider_to_taxonomy (npi, nucc_code);

ALTER TABLE NPD.organization ADD CONSTRAINT fk_organization_authorized_official_id FOREIGN KEY(authorized_official_id)
REFERENCES NPD.individual (id);

ALTER TABLE NPD.organization ADD CONSTRAINT fk_organization_ein_id FOREIGN KEY(ein_id)
REFERENCES NPD.legal_entity (ein_id);

ALTER TABLE NPD.organization ADD CONSTRAINT fk_organization_parent_id FOREIGN KEY(parent_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.clinical_organization ADD CONSTRAINT fk_clinical_organization_endpoint_instance_id FOREIGN KEY(endpoint_instance_id)
REFERENCES NPD.endpoint_instance (id);

ALTER TABLE NPD.clinical_organization ADD CONSTRAINT fk_clinical_organization_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.clinical_organization ADD CONSTRAINT fk_clinical_organization_npi FOREIGN KEY(npi)
REFERENCES NPD.npi (npi);

ALTER TABLE NPD.organization_to_taxonomy ADD CONSTRAINT fk_organization_to_taxonomy_npi FOREIGN KEY(npi)
REFERENCES NPD.clinical_organization (npi);

ALTER TABLE NPD.organization_to_phone ADD CONSTRAINT fk_organization_to_phone_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.organization_to_address ADD CONSTRAINT fk_organization_to_address_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.organization_name ADD CONSTRAINT fk_organization_name_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.location ADD CONSTRAINT fk_location_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.provider_to_organization ADD CONSTRAINT fk_provider_to_organization_individual_id FOREIGN KEY(individual_id)
REFERENCES NPD.provider (individual_id);

ALTER TABLE NPD.provider_to_organization ADD CONSTRAINT fk_provider_to_organization_organization_id FOREIGN KEY(organization_id)
REFERENCES NPD.organization (id);

ALTER TABLE NPD.provider_to_organization ADD CONSTRAINT fk_provider_to_organization_endpoint_id FOREIGN KEY(endpoint_id)
REFERENCES NPD.endpoint (id);

ALTER TABLE NPD.provider_to_location ADD CONSTRAINT fk_provider_to_location_individual_id_organization_id FOREIGN KEY(individual_id, organization_id)
REFERENCES NPD.provider_to_organization (individual_id, organization_id);

ALTER TABLE NPD.provider_to_location ADD CONSTRAINT fk_provider_to_location_location_id FOREIGN KEY(location_id)
REFERENCES NPD.location (id);

ALTER TABLE NPD.provider_to_location ADD CONSTRAINT fk_provider_to_location_other_address_id FOREIGN KEY(other_address_id)
REFERENCES NPD.address (id);

ALTER TABLE NPD.endpoint ADD CONSTRAINT fk_endpoint_endpoint_instance_id FOREIGN KEY(endpoint_instance_id)
REFERENCES NPD.endpoint_instance (id);

ALTER TABLE NPD.provider_education ADD CONSTRAINT fk_provider_education_npi FOREIGN KEY(npi)
REFERENCES NPD.provider (npi);

ALTER TABLE NPD.endpoint_instance ADD CONSTRAINT fk_endpoint_instance_ehr_vendor_id FOREIGN KEY(ehr_vendor_id)
REFERENCES NPD.ehr_vendor (id);

ALTER TABLE NPD.provider_to_other_id ADD CONSTRAINT fk_provider_to_other_id_npi FOREIGN KEY(npi)
REFERENCES NPD.provider (npi);

ALTER TABLE NPD.organization_to_other_id ADD CONSTRAINT fk_organization_to_other_id_npi FOREIGN KEY(npi)
REFERENCES NPD.clinical_organization (npi);

ALTER TABLE npd.address
    ADD CONSTRAINT address_address_international_id_fkey FOREIGN KEY (address_international_id) REFERENCES npd.address_international(id);


--
-- Name: address address_address_nonstandard_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.address
    ADD CONSTRAINT address_address_nonstandard_id_fkey FOREIGN KEY (address_nonstandard_id) REFERENCES npd.address_nonstandard(id);


--
-- Name: address address_address_us_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.address
    ADD CONSTRAINT address_address_us_id_fkey FOREIGN KEY (address_us_id) REFERENCES npd.address_us(id);


--
-- Name: address_us address_us_county_code_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.address_us
    ADD CONSTRAINT address_us_county_code_fkey FOREIGN KEY (county_code) REFERENCES npd.fips_county(id);


--
-- Name: address_us address_us_state_code_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.address_us
    ADD CONSTRAINT address_us_state_code_fkey FOREIGN KEY (state_code) REFERENCES npd.fips_state(id);


--
-- Name: fips_county fips_county_fips_state_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.fips_county
    ADD CONSTRAINT fips_county_fips_state_id_fkey FOREIGN KEY (fips_state_id) REFERENCES npd.fips_state(id);


--
-- Name: individual_to_address individual_to_address_address_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.individual_to_address
    ADD CONSTRAINT individual_to_address_address_id_fkey FOREIGN KEY (address_id) REFERENCES npd.address(id);


--
-- Name: individual_to_address individual_to_address_address_type_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.individual_to_address
    ADD CONSTRAINT individual_to_address_address_use_id_fkey FOREIGN KEY (address_use_id) REFERENCES npd.fhir_address_use(id) ON DELETE CASCADE;

ALTER TABLE npd.organization_to_address
    ADD CONSTRAINT organization_to_address_address_id_fkey FOREIGN KEY (address_id) REFERENCES npd.address(id);


--
-- Name: individual_to_address individual_to_address_address_type_id_fkey; Type: FK CONSTRAINT; Schema: ndh; Owner: -
--

ALTER TABLE npd.organization_to_address
    ADD CONSTRAINT organization_to_address_address_use_id_fkey FOREIGN KEY (address_use_id) REFERENCES npd.fhir_address_use(id) ON DELETE CASCADE;


ALTER TABLE npd.provider_to_location
    ADD FOREIGN KEY (other_address_id) REFERENCES npd.address(id);

ALTER TABLE npd.address_us ADD foreign key (country_code) references npd.iso_country(code)

alter table npd.fips_state add constraint uc_fips_state_abbreviation unique (abbreviation)

create table npd.fhir_email_use (
id serial primary key,
value varchar(20) unique
);

alter table npd.organization_to_phone add foreign key (phone_use_id) references npd.fhir_phone_use(id);

create table npd.language_spoken (
id varchar(2) primary key,
value varchar(100)
);

alter table npd.individual_to_language_spoken add foreign key (language_spoken_id) references npd.language_spoken(id)

alter table npd.individual_to_name add foreign key (name_use_id) references npd.fhir_name_use(id)


alter table npd.individual_to_phone add foreign key (phone_use_id) references npd.fhir_phone_use(id)

alter table npd.location add foreign key (address_id) references npd.address(id)

alter table npd.nucc_to_medicare_provider_type add column nucc_code varchar(10) 

alter table npd.nucc_to_medicare_provider_type add foreign key (medicare_provider_type_id) references npd.medicare_provider_type(id)

alter table npd.nucc_to_medicare_provider_type add primary key (medicare_provider_type_id, nucc_code)

alter table npd.provider_to_taxonomy add foreign key (nucc_code) references npd.nucc(code)

create table npd.credential_type (
id serial primary key,
value varchar(20)
)