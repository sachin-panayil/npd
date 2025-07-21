
CREATE TABLE ndh.address (
    id SERIAL PRIMARY KEY,
    barcode_delivery_code VARCHAR(12),
    smarty_key VARCHAR(10),
    address_us_id INT NULL, --references address_us.id
    address_international_id INT NULL, --references address_international.id
    address_nonstandard_id INT NULL --references address_nonstandard.id
);

CREATE TABLE ndh.address_us (
    id SERIAL PRIMARY KEY,
    address_id INT NOT NULL,
    input_id VARCHAR(36),
    input_index INT,
    candidate_index INT,
    addressee VARCHAR(64),
    delivery_line_1 VARCHAR(64),
    delivery_line_2 VARCHAR(64),
    last_line VARCHAR(64),
    delivery_point_barcode VARCHAR(12),
    -- Components
    urbanization VARCHAR(64),
    primary_number VARCHAR(30),
    street_name VARCHAR(64),
    street_predirection VARCHAR(16),
    street_postdirection VARCHAR(16),
    street_suffix VARCHAR(16),
    secondary_number VARCHAR(32),
    secondary_designator VARCHAR(16),
    extra_secondary_number VARCHAR(32),
    extra_secondary_designator VARCHAR(16),
    pmb_designator VARCHAR(16),
    pmb_number VARCHAR(16),
    city_name VARCHAR(64),
    default_city_name VARCHAR(64),
    state_code CHAR(2), --references fips_state.state_code
    zipcode CHAR(5),
    plus4_code VARCHAR(4),
    delivery_point CHAR(2),
    delivery_point_check_digit CHAR(1),
    -- Metadata
    record_type CHAR(1),
    zip_type VARCHAR(32),
    county_code CHAR(5), --references fips_county.county_code
    ews_match CHAR(5),
    carrier_route CHAR(4),
    congressional_district CHAR(2),
    building_default_indicator CHAR(1),
    rdi VARCHAR(12),
    elot_sequence VARCHAR(4),
    elot_sort VARCHAR(4),
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    coordinate_license INT,
    geo_precision VARCHAR(18),
    time_zone VARCHAR(48),
    utc_offset DECIMAL(4,2),
    dst CHAR(5),
    -- Analysis
    dpv_match_code VARCHAR(1),
    dpv_footnotes VARCHAR(32),
    dpv_cmra VARCHAR(1),
    dpv_vacant VARCHAR(1),
    dpv_no_stat VARCHAR(1),
    active VARCHAR(1),
    footnotes VARCHAR(24),
    lacslink_code VARCHAR(2),
    lacslink_indicator VARCHAR(1),
    suitelink_match VARCHAR(5),
    enhanced_match VARCHAR(64)
);

CREATE TABLE ndh.address_international (
    id SERIAL PRIMARY KEY,
    address_id INT NOT NULL,
    input_id VARCHAR(36),
    country VARCHAR(64),
    geocode VARCHAR(4),
    local_language VARCHAR(6),
    freeform VARCHAR(512),
    address1 VARCHAR(64),
    address2 VARCHAR(64),
    address3 VARCHAR(64),
    address4 VARCHAR(64),
    organization VARCHAR(64),
    locality VARCHAR(64),
    administrative_area VARCHAR(32),
    postal_code VARCHAR(16),
    -- Components
    administrative_area_iso2 VARCHAR(8),
    sub_administrative_area VARCHAR(64),
    country_iso_3 VARCHAR(3),
    premise VARCHAR(64),
    premise_number VARCHAR(64),
    thoroughfare VARCHAR(64),
    -- Metadata
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    geocode_precision VARCHAR(32),
    max_geocode_precision VARCHAR(32),
    address_format VARCHAR(128),
    -- Analysis
    verification_status VARCHAR(32),
    address_precision VARCHAR(32),
    max_address_precision VARCHAR(32)
);

CREATE TABLE ndh.address_nonstandard (
    id SERIAL PRIMARY KEY,
    address_id INT NOT NULL,
    input_id VARCHAR(36),
    input_index INT,
    candidate_index INT,
    addressee VARCHAR(64),
    delivery_line_1 VARCHAR(64),
    delivery_line_2 VARCHAR(64),
    last_line VARCHAR(64),
    -- Any additional fields specific to non-standard addresses
    address_type VARCHAR(32),
    address_format VARCHAR(128),
    raw_address TEXT,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    notes TEXT
);

CREATE TABLE ndh.fhir_address_type (
    id SERIAL PRIMARY KEY,
    value TEXT NOT NULL,
    CONSTRAINT uc_address_type_value UNIQUE (
        value
    )
);


CREATE TABLE ndh.fips_state (
    id CHAR(2) primary key, --this is the state fips code
    name VARCHAR(100) NOT NULL,
    abbreviation CHAR(2) NOT NULL,
    CONSTRAINT uc_fips_state_name UNIQUE (
        name
    ),
    CONSTRAINT uc_fips_state_abbreviation UNIQUE (
        abbreviation
    )
);

CREATE TABLE ndh.fips_county (
    id VARCHAR(5) primary key, -- this is the county fips code
    name VARCHAR(200) not null,
    fips_state_id VARCHAR(2) not null, --references fips_state.id,
    CONSTRAINT uc_fips_county_name UNIQUE (
        name
    )
);


CREATE TABLE ndh.individual_to_address (
    individual_id int   NOT NULL, --references individual.id
    address_type_id int   NOT NULL, --references address_type.id
    address_id INT   NOT NULL, --references address.id
    primary key (individual_id, address_id)
);


CREATE TABLE ndh.other_identifier_type (
    id SERIAL PRIMARY KEY,
    value TEXT NOT NULL,
    CONSTRAINT uc_other_identifier_type_value UNIQUE (
        value
    )
);


CREATE TABLE ndh.individual_to_other_identifier (
    individual_id  int NOT NULL, --references individual.id
    value VARCHAR(21)   NOT NULL,
    other_identifier_type_id INTEGER   NOT NULL, --references identifier_type.id
    state_id char(2), --references fips_state.id
    issuer_name VARCHAR(81),
    issue_date date,
    expiry_date date,
    primary key (individual_id, value, state_id)
);


CREATE TABLE ndh.clinical_credential (
    id SERIAL PRIMARY KEY,
    -- i.e. M.D.
    acronym VARCHAR(20) NOT NULL,
    -- i.e. Medical Doctor
    name VARCHAR(100),
    -- for when there is only one source for the credential (unlike medical schools etc)
    source_url VARCHAR(250)
);

CREATE TABLE ndh.language_spoken (
    id char(2) primary key, --language abbreviation
    value varchar(200)
);

CREATE TABLE ndh.individual_to_language_spoken (
    individual_id int, --references individual.id
    language_spoken_id char(2), --language_spoken_id
    primary key (individual_id, language_spoken_id)
);

CREATE TABLE ndh.clinical_school (
    id SERIAL PRIMARY KEY,
    -- i.e. M.D.
    name VARCHAR(20)   NOT NULL,
    url VARCHAR(500)
);


CREATE TABLE ndh.individual_to_clinical_credential (
    individual_id int   NOT NULL,
    clinical_credential_id int   NOT NULL, --references clinical_credential.id
    receipt_date DATE,
    clinical_school_id INT, --references clinical_school.id
    primary key (individual_id, clinical_credential_id)
);


CREATE TABLE ndh.individual (
    id SERIAL PRIMARY KEY,
    ssn VARCHAR(10)   DEFAULT NULL,
    sex_code CHAR(1)  DEFAULT NULL,
    birth_date DATE,
    npi bigint
);

CREATE TABLE ndh.individual_to_name (
    individual_id int, --references individual.id
    last_name VARCHAR(100) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    middle_name VARCHAR(21),
    name_prefix VARCHAR(6),
    name_suffix VARCHAR(6),
    fhir_name_type_id int NOT NULL, --references fhir_name_type.id
    effective_date date NOT null,
    end_date date,
    primary key (individual_id, last_name, first_name, middle_name, name_prefix, name_suffix, fhir_name_type_id, effective_date)
);

CREATE TABLE ndh.fhir_name_type (
    id serial primary key,
    value varchar(50) not null,
    CONSTRAINT uc_fhir_name_type_value UNIQUE (
        value
    )
);

CREATE TABLE ndh.individual_to_email_address (
    individual_id int, --references individual.id
    email_address varchar(300),
    primary key (individual_id, email_address)
);


CREATE TABLE ndh.npi (
    npi BIGINT   primary key check (npi>999999999 and npi<10000000000), --currently npis are 10 digits
    entity_type_code SMALLINT   NOT NULL,
    replacement_npi BIGINT  DEFAULT NULL, --references ndh.npi
    enumeration_date DATE  NOT NULL,
    last_update_date DATE   NOT NULL,
    deactivation_reason_code VARCHAR(3),
    deactivation_date DATE,
    reactivation_date DATE,
    certification_date DATE 
);


CREATE TABLE ndh.phone_type (
    id SERIAL PRIMARY KEY,
    value TEXT NOT NULL,
    CONSTRAINT uc_phone_type_value UNIQUE (
        value
    )
);


CREATE TABLE ndh.individual_to_phone_number (
    individual_id int  NOT NULL, --references individual.id
    phone_type_id INTEGER  NOT NULL, --references phone_type.id
    phone_number_id INTEGER  NOT NULL, --references phone_number.id
    extension VARCHAR(10),
    --to the prior comment about the fax issue, phone type would include fax
    PRIMARY KEY (individual_id, phone_number_id, phone_type_id)
);


Create TABLE ndh.phone_number (
    id SERIAL PRIMARY KEY,
    value VARCHAR(20) NOT NULL,
    CONSTRAINT uc_phone_number_value UNIQUE (value)
);



CREATE TABLE ndh.nucc_taxonomy_code (
    id VARCHAR(10) primary key, --nucc code
    display_name TEXT NOT NULL,
    parent_id VARCHAR(10), --references nucc_taxonomy_code.taxonomy_code (Note: this is how we get the classification/ specialization/ etc.)
    definition TEXT,
    notes TEXT,
    certifying_board_name TEXT,
    certifying_board_url TEXT
);


CREATE TABLE ndh.individual_to_nucc_taxonomy_code (
    individual_id INT, --references individual.id
    nucc_taxonomy_code_id VARCHAR(10), --references nucc_taxonomy_code.id
    state_id char(2), --references fips_state.id
    license_number VARCHAR(20),
    is_primary BOOLEAN,
    primary key (individual_id, nucc_taxonomy_code_id, state_id)
);


CREATE TABLE ndh.medicare_provider_type (
    id SERIAL PRIMARY KEY,
    value VARCHAR NOT NULL,
    CONSTRAINT uc_medicare_provider_type_value UNIQUE (
        value
    )
);

--FRED: Is this part of the hydration or something we'll be storing like this long term?
CREATE TABLE ndh.nucc_taxonomy_code_to_medicare_provider_type (
    medicare_provider_type_id INT   NOT NULL, --references medicare_provider_type.name
    nucc_taxonomy_code_id INT   NOT NULL,
    PRIMARY KEY (medicare_provider_type_id, nucc_taxonomy_code_id)
);

