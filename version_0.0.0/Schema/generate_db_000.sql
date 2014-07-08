DROP DATABASE IF EXISTS db_000;

CREATE DATABASE db_000 CHARACTER SET = utf8 COLLATE = utf8_unicode_ci;
SET GLOBAL slow_query_log = 'ON';
SET GLOBAL long_query_time = 0.8;
SET GLOBAL log_output = 'TABLE'; 

USE db_000;

/*------------------------------------------------------------*/
/* TABLES AND VIEWS */
/*------------------------------------------------------------*/

/*------------------------------------------------------------*/
/* metadata reference */
/*------------------------------------------------------------*/

CREATE TABLE tbl_data_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_data_type PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying exception severity to internal teachscape personnel and applications',
	CONSTRAINT uq_data_type_name UNIQUE(name),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the data type through definition, examples, etc.',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='The severity of an exception returned by a program' ;

CREATE ALGORITHM=MERGE VIEW data_type AS SELECT * FROM tbl_data_type;

CREATE INDEX ix_data_type_name ON tbl_data_type (name);

/*------------------------------------------------------------*/
CREATE TABLE tbl_exception_severity (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_exception_severity PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying exception severity to internal teachscape personnel and applications',
	CONSTRAINT uq_exception_severity_name UNIQUE(name),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining exception severity through definition, examples, etc.',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='The severity of an exception returned by a program' ;

CREATE ALGORITHM=MERGE VIEW exception_severity AS SELECT * FROM tbl_exception_severity;

CREATE INDEX ix_exception_severity_name ON tbl_exception_severity (name);

/*------------------------------------------------------------*/
CREATE TABLE tbl_database_exception (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_database_exception PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying exception severity to internal teachscape personnel and applications',
	CONSTRAINT uq_database_exception_name UNIQUE(name),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining exception severity through definition, examples, etc.',
exception_severity_id int UNSIGNED NULL COMMENT 'Identifies the severity of the exception',
	CONSTRAINT fk_database_exception_to_exception_severity FOREIGN KEY (exception_severity_id) REFERENCES tbl_exception_severity (id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='An exception returned by a database program' ;

CREATE ALGORITHM=MERGE VIEW database_exception AS SELECT * FROM tbl_database_exception;

CREATE INDEX ix_database_exception_name ON tbl_database_exception (name);

/*------------------------------------------------------------*/
/* metadata  */
/*------------------------------------------------------------*/

CREATE TABLE tbl_configuration (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_configuration PRIMARY KEY (id),
configuration_key varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying exception severity to internal teachscape personnel and applications',
	CONSTRAINT uq_configuration_configuration_key UNIQUE(configuration_key),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the data type through definition, examples, etc.',
data_type_id int UNSIGNED NULL COMMENT 'Identifies the data_type',
	CONSTRAINT fk_configuration_to_data_type FOREIGN KEY (data_type_id) REFERENCES tbl_data_type (id),
configuration_value nvarchar(512) NOT NULL COMMENT 'The current value for the configuration',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='The severity of an exception returned by a program' ;

CREATE ALGORITHM=MERGE VIEW configuration AS SELECT * FROM tbl_configuration;

CREATE INDEX ix_configuration_configuration_key ON tbl_configuration (configuration_key);


/*------------------------------------------------------------*/
/* User Management */
/*------------------------------------------------------------*/

/* reference */
CREATE TABLE tbl_transaction_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_transaction_type PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying transaction type to internal teachscape personnel and applications',
	CONSTRAINT uq_transaction_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying transaction type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_transaction_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining transaction type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of transaction against an entity, such as add, delete, update, activate, etc.' ;

CREATE ALGORITHM=MERGE VIEW transaction_type AS SELECT * FROM tbl_transaction_type;

CREATE INDEX ix_transaction_type_name ON tbl_transaction_type (name);
CREATE INDEX ix_transaction_type_external_key ON tbl_transaction_type (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_transaction_status (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_transaction_status PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying transaction status to internal teachscape personnel and applications',
	CONSTRAINT uq_transaction_status_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying transaction status to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_transaction_status_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining transaction status through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A state of a transaction, such as pending, failed, succeeded, etc.' ;

CREATE ALGORITHM=MERGE VIEW transaction_status AS SELECT * FROM tbl_transaction_status;

CREATE INDEX ix_transaction_status_name ON tbl_transaction_status (name);
CREATE INDEX ix_transaction_status_external_key ON tbl_transaction_status (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_resource_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_resource_type PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying resource type to internal teachscape personnel and applications',
	CONSTRAINT uq_resource_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying resource type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_resource_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining resource type through definition, examples, etc.',
requires_role_permission bit NOT NULL DEFAULT 1 COMMENT '1 = A user may only access this resources if they are assigned to an authorized role within the organization',
requires_license_permission bit NOT NULL DEFAULT 1 COMMENT '1 = A user may only access this resource if they or their organization has been licensed to it',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of resource, such as a page, tab, report, widget, application, etc.';

CREATE ALGORITHM=MERGE VIEW resource_type AS SELECT * FROM tbl_resource_type;

CREATE INDEX ix_resource_type_name ON tbl_resource_type (name);
CREATE INDEX ix_resource_type_external_key ON tbl_resource_type (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_grade_range (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_grade_range PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying grade range to internal teachscape personnel and applications',
	CONSTRAINT uq_grade_range_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying grade range to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_grade_range_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining grade range through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A range of school grades that may be associated with a teacher or other education professional';

CREATE ALGORITHM=MERGE VIEW grade_range AS SELECT * FROM tbl_grade_range;

CREATE INDEX ix_grade_range_name ON tbl_grade_range (name);
CREATE INDEX ix_grade_range_external_key ON tbl_grade_range (external_key);


/*------------------------------------------------------------*/
CREATE TABLE tbl_license_model (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_license_model PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the license model to internal teachscape personnel and applications',
	CONSTRAINT uq_license_model_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the license model to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_license_model_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining license model through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A method of permitting use of Teachscape products, for instance whether license seats may be reassigned among users';

CREATE ALGORITHM=MERGE VIEW license_model AS SELECT * FROM tbl_license_model;

CREATE INDEX ix_license_model_name ON tbl_license_model (name);
CREATE INDEX ix_license_model_external_key ON tbl_license_model (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_application (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_application PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying application to internal teachscape personnel and applications',
	CONSTRAINT uq_application_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying application to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_application_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining application through definition, examples, etc.',
is_external bit NOT NULL DEFAULT 0 COMMENT '1 = The application is provided by a third party, 0 = the application is provided by Teachscape',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A computer application with which Teachscape administrators, users and organizations may interact';

CREATE ALGORITHM=MERGE VIEW application AS SELECT * FROM tbl_application;

CREATE INDEX ix_application_name ON tbl_application (name);
CREATE INDEX ix_application_external_key ON tbl_application (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_party_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_party_type PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying party type to internal teachscape personnel and applications',
	CONSTRAINT uq_party_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying party type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_party_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining party type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of party (person, organization, Teachscape, etc.';

CREATE ALGORITHM=MERGE VIEW party_type AS SELECT * FROM tbl_party_type;

CREATE INDEX ix_party_type_name ON tbl_party_type (name);
CREATE INDEX ix_party_type_external_key ON tbl_party_type (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_organization_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_organization_type PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying organization type to internal teachscape personnel and applications',
	CONSTRAINT uq_organization_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying organization type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_organization_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining organization type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A category of education institution, such as state, district and school, usually denoting its administrative level in relation to other organizations';

CREATE ALGORITHM=MERGE VIEW organization_type AS SELECT * FROM tbl_organization_type;

CREATE INDEX ix_organization_type_name ON tbl_organization_type (name);
CREATE INDEX ix_organization_type_external_key ON tbl_organization_type (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_address_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_address_type PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying address type to internal teachscape personnel and applications',
	CONSTRAINT uq_address_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying address type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_address_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining address type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of address, such as mailing, physical, primary, etc.';

CREATE ALGORITHM=MERGE VIEW address_type AS SELECT * FROM tbl_address_type;

CREATE INDEX ix_address_type_name ON tbl_address_type (name);
CREATE INDEX ix_address_type_external_key ON tbl_address_type (external_key);

/* parties */

/*------------------------------------------------------------*/
CREATE TABLE tbl_address (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_address PRIMARY KEY (id),
address_line1 nvarchar (100) NULL COMMENT 'The first line of the address',
address_line2 nvarchar (100) NULL COMMENT 'The second line of the address',
address_city nvarchar (50) NULL COMMENT 'The city of the address',
address_state_code char(2) NULL COMMENT 'The state code of the address',
address_territory nvarchar(50) NULL COMMENT 'The territory of the address',
address_postal_code nvarchar(10) NULL COMMENT 'The postal or zip code of the address',
address_country nvarchar (50) NULL COMMENT 'The country of the address',
degenerate_organization_id int NULL COMMENT 'Cross reference to source organization addressee',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A location of a party or where their mail is received.';

CREATE ALGORITHM=MERGE VIEW address AS SELECT * FROM tbl_address;

CREATE INDEX ix_address_degenerate_organization_id ON tbl_address (degenerate_organization_id);
CREATE INDEX ix_address_external_key ON tbl_address (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_party (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_party PRIMARY KEY (id),
party_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the party type',
	CONSTRAINT fk_party_to_party_type FOREIGN KEY (party_type_id) REFERENCES tbl_party_type (id),
name nvarchar(255) NOT NULL COMMENT 'A text identification of the party (organization name, username, person name, etc.)',
degenerate_id int UNSIGNED COMMENT 'Cross-reference to row id in source system',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A person, user, organization, or other entity who may interact with Teachscape or its applications';

CREATE ALGORITHM=MERGE VIEW party AS SELECT * FROM tbl_party;

CREATE INDEX ix_party_degenerate_type ON tbl_party (degenerate_id, party_type_id);
CREATE INDEX ix_party_type_degenerate ON tbl_party (party_type_id, degenerate_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_role (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_role PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying role to internal teachscape personnel and applications',
	CONSTRAINT uq_role_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying role to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_role_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining role through definition, examples, etc.',
parent_party_type_id int UNSIGNED NULL COMMENT 'Identifies the allowable type for the parent party',
	CONSTRAINT fk_role_to_parent_party_type FOREIGN KEY (parent_party_type_id) REFERENCES tbl_party_type (id),
child_party_type_id int UNSIGNED NULL COMMENT 'Identifies the allowable type for the chile party',
	CONSTRAINT fk_role_to_child_party_type FOREIGN KEY (child_party_type_id) REFERENCES tbl_application (id),
application_id int UNSIGNED NULL COMMENT 'Identifies an application when the role pertains to only one',
CONSTRAINT fk_role_to_application FOREIGN KEY (application_id) REFERENCES tbl_application (id),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A function or set of duties that may be assigned to users within an organization';

CREATE ALGORITHM=MERGE VIEW role AS SELECT * FROM tbl_role;
CREATE INDEX ix_role_external_key ON tbl_role (external_key);

CREATE INDEX ix_role_name ON tbl_role (name);

/*------------------------------------------------------------*/
CREATE TABLE tbl_organization (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_organization PRIMARY KEY (id),
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_organization_to_party FOREIGN KEY (party_id) REFERENCES tbl_party (id),
organization_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization type',
	CONSTRAINT fk_organization_to_organization_type FOREIGN KEY (organization_type_id) REFERENCES tbl_organization_type (id),
name nvarchar(255) NOT NULL COMMENT 'The name of the organization',
	FULLTEXT ft_organization_name (name),
is_active bit NOT NULL DEFAULT 1 COMMENT '1 = The organization his a valid organization, 0 = The organization has been marked for deletion',
uses_new_platform bit NOT NULL DEFAULT 1 COMMENT '1 = The organization has been migrated from TXL, 0 = The organization still uses TXL',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='An organized body of people with a particular purpose, such as an educational institution or a government.';

CREATE ALGORITHM=MERGE VIEW organization AS SELECT * FROM tbl_organization;


CREATE INDEX ix_organization_party ON tbl_organization (party_id);
CREATE INDEX ix_organization_name ON tbl_organization (name, is_active);
CREATE INDEX ix_organization_external_key ON tbl_organization (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_user_profile (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_user PRIMARY KEY (id),
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_user_to_party FOREIGN KEY (party_id) REFERENCES tbl_party (id),
username varchar(65) NOT NULL COMMENT 'A unique string that identifies the user' ,
#	CONSTRAINT uq_user_profile_username UNIQUE(username),
/* The following columns will come into play if we store authentication in this database 
user_password char(20) CHARACTER SET utf8 NOT NULL,
password_salt bigint NOT NULL,
*/
user_email_address varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'The email address used to identify and communicate with this user',
job_code nvarchar(127) NULL COMMENT 'Free-form text used by administrators to track users',
job_name nvarchar(127) NULL COMMENT 'Free-form text used by administrators to track users',
position_code nvarchar(127) NULL COMMENT 'Free-form text used by administrators to track users',
title nvarchar(50) NULL COMMENT 'Free-form text used by administrators to track users',
hire_date date NULL COMMENT 'Free-form text used by administrators to track users',
exit_date date NULL COMMENT 'Free-form text used by administrators to track users',
is_active bit NULL DEFAULT 0 COMMENT '1 = The user is currently active and may login to the application',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
)  ENGINE=INNODB COMMENT='A person, application, or other actor who may log in to teachscape and perform authorized functions';

CREATE ALGORITHM=MERGE VIEW user_profile AS SELECT * FROM tbl_user_profile;

CREATE INDEX ix_user_username ON tbl_user_profile (username);
CREATE INDEX ix_user_party ON tbl_user_profile (party_id);
CREATE INDEX ix_user_email_address ON tbl_user_profile (user_email_address);
CREATE INDEX ix_user_external_key ON tbl_user_profile (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_person (
id int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
CONSTRAINT pk_person PRIMARY KEY (id),
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_person_to_party FOREIGN KEY (party_id) REFERENCES tbl_party (id),
first_name varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'The first or given name of the person',
middle_name varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'The middle name of the person, if applicable',
last_name varchar(65) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL COMMENT 'The last name or surname of the person',
	FULLTEXT ft_person_name (first_name, last_name, middle_name),
person_email_address varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'The email address of the person',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
)
ENGINE=InnoDB
DEFAULT CHARACTER SET=latin1 COLLATE=latin1_swedish_ci
AUTO_INCREMENT=1684465
COMMENT='A person, usually a user or member of a client organization';

CREATE ALGORITHM=MERGE VIEW person AS SELECT * FROM tbl_person;

CREATE INDEX ix_person_party ON tbl_person (party_id);
CREATE INDEX ix_person_email_address ON tbl_person (person_email_address);
CREATE INDEX ix_person_external_key ON tbl_person (external_key);

/******************************/
/* Relationships */
/******************************/

CREATE TABLE tbl_party_relationship (
id int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_party_relationship PRIMARY KEY (id),
parent_id int UNSIGNED NOT NULL COMMENT 'Identifies the parent party',
	CONSTRAINT fk_party_relationship_parent_to_party FOREIGN KEY (parent_id) REFERENCES tbl_party (id),
child_id int UNSIGNED NOT NULL COMMENT 'Identifies the child party',
	CONSTRAINT fk_party_relationship_child_to_party FOREIGN KEY (child_id) REFERENCES tbl_party (id),
role_id int UNSIGNED NOT NULL COMMENT 'Identifies the party relationship type',
	CONSTRAINT fk_party_relationship_to_role FOREIGN KEY (role_id) REFERENCES tbl_role (id),
CONSTRAINT uq_party_relationship UNIQUE (parent_id, child_id, role_id),
start_date datetime NOT NULL COMMENT 'The date the party relationship went into effect',
end_date datetime NULL COMMENT 'The date the party relationship expires',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A relationship between two part s in which the *parent* party inherits the role implied by the party relationship type';

CREATE ALGORITHM=MERGE VIEW party_relationship AS SELECT * FROM tbl_party_relationship;

CREATE INDEX ix_party_relationship_parent_role ON tbl_party_relationship (parent_id, role_id);
CREATE INDEX ix_party_relationship_child_parent_role ON tbl_party_relationship (child_id, parent_id, role_id);
CREATE UNIQUE INDEX ux_party_relationship_child_dates ON tbl_party_relationship (child_id, start_date, end_date, parent_id, role_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_party_address (
id int(10) UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_party_address PRIMARY KEY (id),
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_party_address_to_party FOREIGN KEY (party_id) REFERENCES tbl_party (id),
address_id int UNSIGNED NOT NULL COMMENT 'Identifies the address',
	CONSTRAINT fk_party_address_to_address FOREIGN KEY (address_id) REFERENCES tbl_address (id),
address_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the type of address',
	CONSTRAINT fk_party_address_type_to_address_type FOREIGN KEY (address_type_id) REFERENCES tbl_address_type (id),
is_primary bit NOT NULL DEFAULT 0 COMMENT '1 = this is considered the primary address of the party, 0 = this is not the primary address of the party',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='An address of a party';

CREATE ALGORITHM=MERGE VIEW party_address AS SELECT * FROM tbl_party_address;

CREATE INDEX ix_person_address_party ON tbl_party_address (party_id, is_primary);

/*------------------------------------------------------------*/
CREATE TABLE tbl_organization_role (
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_organization_role_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
role_id int UNSIGNED NOT NULL COMMENT 'Identifies the role',
	CONSTRAINT fk_organization_role_to_role FOREIGN KEY (role_id) REFERENCES tbl_role (id),
CONSTRAINT pk_organization_role PRIMARY KEY (organization_id, role_id),
start_date datetime NOT NULL COMMENT 'The date the organization role went into effect',
end_date datetime NULL COMMENT 'The date the organization role expires',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A role associated with a particular organization.';

CREATE ALGORITHM=MERGE VIEW organization_role AS SELECT * FROM tbl_organization_role;

/*------------------------------------------------------------*/
CREATE TABLE tbl_organization_contact (
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT pk_organization_contact PRIMARY KEY (organization_id),
	CONSTRAINT fk_organization_contact_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
name nvarchar(65) COMMENT 'The name of the contact',
email_address varchar(255) CHARACTER SET latin1 COLLATE latin1_swedish_ci COMMENT 'The email address of the contact',
contact_phone varchar(50) COMMENT 'The phone number of the contact',
contact_sequence tinyint UNSIGNED DEFAULT 1 COMMENT 'The sequence in which the contact should be listed on pages and reports',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A person who acts as a liaison for communication between their organization and Teachscape';

CREATE ALGORITHM=MERGE VIEW organization_contact AS SELECT * FROM tbl_organization_contact;

/*------------------------------------------------------------*/
CREATE TABLE tbl_party_application (
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_party_application_to_party FOREIGN KEY (party_id) REFERENCES tbl_party (id),
application_id int UNSIGNED NOT NULL COMMENT 'Identifies the application',
	CONSTRAINT fk_party_application_to_application FOREIGN KEY (application_id) REFERENCES tbl_application (id),
customer_key varchar(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci  NULL COMMENT 'The key identifying the party to an application',
provisioning_name nvarchar(100) NULL COMMENT 'Unknown legacy value',
site_name  nvarchar(100) NULL COMMENT 'The name of the application web site',
external_id char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='The identification of an party to an application';

CREATE ALGORITHM=MERGE VIEW party_application AS SELECT * FROM tbl_party_application;

/*------------------------------------------------------------*/
CREATE TABLE tbl_user_grade_range (
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user',
	CONSTRAINT fk_user_grade_range_to_user FOREIGN KEY (user_id) REFERENCES tbl_user_profile (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_user_grade_range_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
grade_range_id int UNSIGNED NOT NULL COMMENT 'Identifies the grade range',
	CONSTRAINT fk_user_grade_range_to_grade_range FOREIGN KEY (grade_range_id) REFERENCES tbl_grade_range (id),
CONSTRAINT pk_user_grade_range PRIMARY KEY (user_id, grade_range_id),
grade_range_sequence tinyint UNSIGNED COMMENT 'The sequence in which the grade range should be listed on pages and reports',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A grade range assigned to a user, usually a teacher, within an organization';

CREATE ALGORITHM=MERGE VIEW user_grade_range AS SELECT * FROM tbl_user_grade_range;

/*------------------------------------------------------------*/
CREATE TABLE tbl_custom_group (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_custom_group PRIMARY KEY (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_custom_group_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
name nvarchar(75) NOT NULL COMMENT 'A unique string identifying the group to the organization',
	CONSTRAINT uq_custom_groups_name UNIQUE(name, organization_id),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the group through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
is_active bit NOT NULL DEFAULT 1
) ENGINE=INNODB COMMENT='A term used by an organization to group users';

CREATE ALGORITHM=MERGE VIEW custom_group AS SELECT * FROM tbl_custom_group;

CREATE INDEX ix_custom_group_name ON tbl_custom_group (name);
CREATE INDEX ix_custom_group_external_key ON tbl_custom_group (external_key);


/*------------------------------------------------------------*/
CREATE TABLE tbl_user_custom_group (
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user',
	CONSTRAINT fk_user_custom_group_to_user FOREIGN KEY (user_id) REFERENCES tbl_user_profile (id),
custom_group_id int UNSIGNED NOT NULL COMMENT 'Identifies the custom_group',
	CONSTRAINT fk_user_custom_group_to_custom_group FOREIGN KEY (custom_group_id) REFERENCES tbl_custom_group (id),
CONSTRAINT pk_user_custom_group PRIMARY KEY (user_id, custom_group_id),
is_active bit NOT NULL DEFAULT 1
) ENGINE=INNODB COMMENT='An assignment of a user to a custom group';

CREATE ALGORITHM=MERGE VIEW user_custom_group AS SELECT * FROM tbl_user_custom_group;

/******************************/
/* Products and resources */
/******************************/

/*------------------------------------------------------------*/
CREATE TABLE tbl_product (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_product PRIMARY KEY (id) ,
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the product to internal teachscape personnel and applications',
	CONSTRAINT uq_product_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the product to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_product_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the product through definition, examples, etc.',
application_id int UNSIGNED NOT NULL COMMENT 'Identifies the application',
	CONSTRAINT fk_product_application FOREIGN KEY (application_id) REFERENCES tbl_application (id),
default_license_model_id int UNSIGNED NOT NULL COMMENT 'Identifies the default license model assigned to new licenses if none is specified',
	CONSTRAINT fk_product_license_model FOREIGN KEY (default_license_model_id) REFERENCES tbl_license_model (id),
must_include_all_subproducts bit NOT NULL default 0 COMMENT '1 = this product always includes all contained subproducts, 0 = contained subproducts may be individually included or omitted',
is_assignable_as_resource bit NOT NULL default 0 COMMENT '1 = Users may may be authorized to this product, 0 = users may only be authorized to the subproducts of this product',
users_require_assignment bit NOT NULL DEFAULT 1 COMMENT '1 = Each user needs to be individually assigned to this product to gain access, 0 = All users for authorized organizations are automatically authorized',
default_cascade_permissions bit NOT NULL DEFAULT 0 COMMENT '1 = Resources for this product default to having their permissions extend to all descendant organizations',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A Teachscape service or item available for sale';

CREATE ALGORITHM=MERGE VIEW product AS SELECT * FROM tbl_product;

CREATE INDEX ix_product_name ON tbl_product (name);
CREATE INDEX ix_product_external_key ON tbl_product (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_product_relationship (
parent_id int(10) UNSIGNED NOT NULL COMMENT 'Identifies the parent product',
	CONSTRAINT fk_product_relationship_parent FOREIGN KEY (parent_id) REFERENCES tbl_product (id),
child_id int(10) UNSIGNED NOT NULL COMMENT 'Identifies the child product',
	CONSTRAINT fk_product_relationship_child FOREIGN KEY (child_id) REFERENCES tbl_product (id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed',
CONSTRAINT pk_product_relationship PRIMARY KEY (parent_id, child_id)
)
ENGINE=InnoDB
COMMENT='A relationship between products in which a parent is composed of its children';

CREATE ALGORITHM=MERGE VIEW product_relationship AS SELECT * FROM tbl_product_relationship;

CREATE INDEX ix_product_relationship_parent_child ON tbl_product_relationship (parent_id, child_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_resource (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_resource PRIMARY KEY (id) ,
product_id int UNSIGNED NULL COMMENT 'Identifies the product.  NULL = the resource is not a product',
	CONSTRAINT fk_resource_to_product FOREIGN KEY (product_id) REFERENCES tbl_product (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the resource to internal teachscape personnel and applications',
	CONSTRAINT uq_resource_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the resource to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_resource_label UNIQUE(label),
resource_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource type',
	CONSTRAINT fk_resource_to_resource_type FOREIGN KEY (resource_type_id) REFERENCES tbl_resource_type (id),
description varchar(255) NULL COMMENT 'A short comment further explaining the resource through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
cascade_permissions bit NOT NULL DEFAULT 0 COMMENT '1 = Permissions to this resource extend to all descendant organizations, 0 = permissions to this resource are for each individual organization',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A resource associated with a product';

CREATE ALGORITHM=MERGE VIEW resource AS SELECT * FROM tbl_resource;

CREATE INDEX ix_resource_name ON tbl_resource (name);
CREATE INDEX ix_resource_external_key ON tbl_resource (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_product_resource (
product_id int UNSIGNED NOT NULL COMMENT 'Identifies the product',
	CONSTRAINT fk_product_resource_to_product FOREIGN KEY (product_id) REFERENCES tbl_product (id),
resource_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource',
	CONSTRAINT fk_product_resource_to_resource FOREIGN KEY (resource_id) REFERENCES tbl_resource (id),
CONSTRAINT pk_product_resource PRIMARY KEY (product_id, resource_id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A resource associated with a product that can be assigned permission through licensing that product';

CREATE ALGORITHM=MERGE VIEW product_resource AS SELECT * FROM tbl_product_resource;

CREATE INDEX ix_product_resource_resource ON tbl_product_resource (resource_id, product_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_role_resource (
role_id int UNSIGNED NOT NULL COMMENT 'Identifies the role',
	CONSTRAINT fk_role_resource_to_role FOREIGN KEY (role_id) REFERENCES tbl_role (id),
resource_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource',
	CONSTRAINT fk_role_resource_to_resource FOREIGN KEY (resource_id) REFERENCES tbl_resource (id),
CONSTRAINT pk_role_resource PRIMARY KEY (role_id, resource_id)
) ENGINE=INNODB COMMENT='Permission to a resource granted to a role';

CREATE ALGORITHM=MERGE VIEW role_resource AS SELECT * FROM tbl_role_resource;

CREATE INDEX ix_role_resource_resource_role ON tbl_role_resource (resource_id, role_id);

/******************************/
/* Sales */
/******************************/

/*------------------------------------------------------------*/
CREATE TABLE tbl_contract (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_contract PRIMARY KEY (id),
customer_organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_contract_to_organization FOREIGN KEY (customer_organization_id) REFERENCES tbl_organization (id),
contract_code varchar(127) NULL COMMENT 'The internal Teachscape name for the contract',
label nvarchar(75) NULL COMMENT 'A string identifying the contract to external users that displays on user-facing reports and screens',
case_number nvarchar(50) NULL COMMENT 'A case number to help identify the contract',
contract_note varchar(4096) NULL COMMENT 'A free-form text note for special instructions or explanation',
start_date datetime NOT NULL COMMENT 'The date the contract went into effect',
end_date datetime NULL COMMENT 'The date the contract expires',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A document stating the agreement between the customer and Teachscape granting licenses to use Teachscape products, services and content';

CREATE ALGORITHM=MERGE VIEW contract AS SELECT * FROM tbl_contract;

CREATE UNIQUE INDEX ux_contract_code ON tbl_contract (contract_code, customer_organization_id);
CREATE UNIQUE INDEX ux_contract_case_number ON tbl_contract (case_number, customer_organization_id);
CREATE UNIQUE INDEX ux_contract_label ON tbl_contract (label, customer_organization_id);
CREATE INDEX ix_contract_customer_organization ON tbl_contract (customer_organization_id, start_date, end_date);
CREATE INDEX ix_contract_external_key ON tbl_contract (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_license (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_license PRIMARY KEY (id),
contract_id int UNSIGNED NOT NULL COMMENT 'Identifies the contract',
	CONSTRAINT fk_license_to_contract FOREIGN KEY (contract_id) REFERENCES tbl_contract (id),
product_id int UNSIGNED NOT NULL COMMENT 'Identifies the product',
	CONSTRAINT fk_license_to_product FOREIGN KEY (product_id) REFERENCES tbl_product (id),
number_of_seats int NOT NULL COMMENT 'The number of seats authorized by the license, if applicable',
license_note varchar(4096) NULL COMMENT 'A free-form text note for special instructions or explanation',
start_date datetime NOT NULL COMMENT 'The date the license went into effect',
end_date datetime NULL COMMENT 'The date the license expires',
license_model_id int UNSIGNED NOT NULL COMMENT 'Identifies the license model',
	CONSTRAINT fk_license_license_model FOREIGN KEY (license_model_id) REFERENCES tbl_license_model (id),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time  timestamp NULL DEFAULT CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A component of a contract that creates a permission set';

CREATE ALGORITHM=MERGE VIEW license AS SELECT * FROM tbl_license;

CREATE INDEX ix_license_contract ON tbl_license (contract_id, start_date, end_date);
CREATE INDEX ix_license_product_id ON tbl_license (product_id);
CREATE INDEX ix_license_external_key ON tbl_license (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_license_resource (
license_id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT fk_license_resource_to_license FOREIGN KEY (license_id) REFERENCES tbl_license (id),
resource_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource',
	CONSTRAINT fk_license_resource_to_resource FOREIGN KEY (resource_id) REFERENCES tbl_resource (id),
CONSTRAINT pk_license_resource PRIMARY KEY (license_id, resource_id),
#start_date datetime NOT NULL COMMENT 'The date the license resource became available to licensees',
#end_date datetime NULL COMMENT 'The date the license resource expires',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='Permission to a resource assigned via a license';

CREATE ALGORITHM=MERGE VIEW license_resource AS SELECT * FROM tbl_license_resource;

CREATE INDEX ix_license_resource_resource ON tbl_license_resource (resource_id, license_id);
CREATE INDEX ix_license_resource_license ON tbl_license_resource (license_id, resource_id);

/******************************/
/* permissions */
/******************************/

/*------------------------------------------------------------*/
CREATE TABLE tbl_permission_set (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_permission_set PRIMARY KEY (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_permission_set_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
product_id int UNSIGNED NOT NULL COMMENT 'Identifies the product',
	CONSTRAINT fk_permission_set_to_product FOREIGN KEY (product_id) REFERENCES tbl_product (id),
number_of_seats int NULL COMMENT 'The number of seats authorized by the permission set, if applicable',
start_date datetime NOT NULL COMMENT 'The date the permission_set went into effect',
end_date datetime NULL COMMENT 'The date the permission_set expires',
users_require_assignment bit NOT NULL DEFAULT 1 COMMENT '1 = Each user needs to be individually assigned to this permission set to gain access, 0 = All users for the organization are automatically authorized',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
degenerate_license_id int NULL COMMENT 'cross reference to source license',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A resource made accessible via a license';

CREATE ALGORITHM=MERGE VIEW permission_set AS SELECT * FROM tbl_permission_set;

CREATE INDEX ix_permission_set_organization ON tbl_permission_set (organization_id, start_date, end_date);
CREATE INDEX ix_permission_set_degenerate_license_id ON tbl_permission_set (degenerate_license_id);
CREATE INDEX ix_permission_set_external_key ON tbl_permission_set (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_permission_set_resource (
permission_set_id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Idenitifies the permission set',
	CONSTRAINT fk_permission_set_resource_to_permission_set FOREIGN KEY (permission_set_id) REFERENCES tbl_permission_set (id),
resource_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource',
	CONSTRAINT fk_permission_set_resource_to_resource FOREIGN KEY (resource_id) REFERENCES tbl_resource (id),
CONSTRAINT pk_permission_set_resource PRIMARY KEY (permission_set_id, resource_id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='Permission to a resource assigned via a permission_set';

CREATE ALGORITHM=MERGE VIEW permission_set_resource AS SELECT * FROM tbl_permission_set_resource;

CREATE INDEX ix_permission_set_resource ON tbl_permission_set_resource (resource_id, permission_set_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_user_permission (
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user',
	CONSTRAINT fk_user_permission_to_user FOREIGN KEY (user_id) REFERENCES tbl_user_profile (id),
permission_set_id int UNSIGNED NOT NULL COMMENT 'Identifies the permission set',
	CONSTRAINT fk_user_permission_to_permission_set FOREIGN KEY (permission_set_id) REFERENCES tbl_permission_set (id),
CONSTRAINT pk_user_permission PRIMARY KEY (user_id, permission_set_id),
start_date datetime NOT NULL COMMENT 'The date the user_permission went into effect',
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_user_permission_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
end_date datetime NULL COMMENT 'The date the user_permission expires',
is_transferable bit NOT NULL COMMENT 'This user may be removed from the permission set to make room for another',
is_active bit NOT NULL COMMENT 'This user may access associated resources',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='The granting of permissions to a user via assigning a seat in a permission set';

CREATE ALGORITHM=MERGE VIEW user_permission AS SELECT * FROM tbl_user_permission;

CREATE INDEX ix_user_permission_permission_set ON tbl_user_permission (permission_set_id, user_id);

/*------------------------------------------------------------*/
/* transactions */
/*------------------------------------------------------------*/

/*------------------------------------------------------------*/
CREATE TABLE tbl_license_permission_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_license_permission_transaction PRIMARY KEY (id),
license_id int UNSIGNED NOT NULL COMMENT 'Identifies the license',
	CONSTRAINT fk_license_permission_transaction_to_license FOREIGN KEY (license_id) REFERENCES tbl_license (id),
permission_set_id int UNSIGNED NOT NULL COMMENT 'Identifies the ',
	CONSTRAINT fk_license_permission_transaction_to_permission_set FOREIGN KEY (permission_set_id) REFERENCES tbl_permission_set (id),
seat_number_adjustment int NULL COMMENT 'The number of seats being added or removed from the permission set',
start_date datetime NOT NULL COMMENT 'The date the license went into effect',
end_date datetime NULL COMMENT 'The date the license expires',
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the type of action performed on the license.  E.g. add, delete, extend, etc.',
	CONSTRAINT fk_transaction_to_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_license_permission_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_license_permission_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date the action took effect, usually the date the transaction was successfully executed.',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_license_permission_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time datetime NOT NULL COMMENT 'The date the row was inserted into the database'
) ENGINE=INNODB COMMENT='A licensing event that creates, extends, deletes or modifies a permission set';

CREATE ALGORITHM=MERGE VIEW license_permission_transaction AS SELECT * FROM tbl_license_permission_transaction;

CREATE INDEX ix_license_permission_transaction_license_date ON tbl_license_permission_transaction (license_id, transaction_effective_date);
CREATE INDEX ix_license_permission_transaction_permission_set_date ON tbl_license_permission_transaction (permission_set_id, transaction_effective_date);
CREATE INDEX ix_license_permission_transaction_license_type ON tbl_license_permission_transaction (license_id, transaction_type_id);
CREATE INDEX ix_license_permission_transaction_permission_set_type ON tbl_license_permission_transaction (permission_set_id, transaction_type_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_user_permission_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_user_permission_transaction PRIMARY KEY (id),
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user',
	CONSTRAINT fk_user_permission_transaction_to_user FOREIGN KEY (user_id) REFERENCES tbl_user_profile (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_user_permission_transaction_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
permission_set_id int UNSIGNED NOT NULL COMMENT 'Identifies the permission set',
	CONSTRAINT fk_user_permission_transaction_to_permission_set FOREIGN KEY (permission_set_id) REFERENCES tbl_permission_set (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_user_permission_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_user_permission_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_user_permission_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_user_permission_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a user permission'
;

CREATE ALGORITHM=MERGE VIEW user_permission_transaction AS SELECT * FROM tbl_user_permission_transaction;

CREATE INDEX ix_user_permission_transaction_user_date ON tbl_user_permission_transaction (user_id, transaction_effective_date);
CREATE INDEX ix_user_permission_transaction_user_type ON tbl_user_permission_transaction (user_id, transaction_type_id);
CREATE INDEX ix_user_permission_transaction_permission_set_date ON tbl_user_permission_transaction (permission_set_id, transaction_effective_date);
CREATE INDEX ix_user_permission_transaction_permission_set_type ON tbl_user_permission_transaction (permission_set_id, transaction_type_id);

/*------------------------------------------------------------*/

CREATE TABLE tbl_party_relationship_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_party_relationship_transaction PRIMARY KEY (id),
parent_id int UNSIGNED NOT NULL COMMENT 'Identifies the parent party',
	CONSTRAINT fk_party_relationship_transaction_to_parent FOREIGN KEY (parent_id) REFERENCES tbl_party (id),
child_id int UNSIGNED NULL COMMENT 'Identifies the child party',
	CONSTRAINT fk_party_relationship_transaction_to_child FOREIGN KEY (child_id) REFERENCES tbl_party (id),
role_id int UNSIGNED NULL COMMENT 'Identifies the fole',
	CONSTRAINT fk_party_relationship_trans_to_role FOREIGN KEY (role_id) REFERENCES tbl_role (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_party_relationship_trans_to_trans_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_party_relationship_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the transaction user',
	CONSTRAINT fk_party_transaction_to_transaction_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_party_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of an party relationship'
;

CREATE ALGORITHM=MERGE VIEW party_relationship_transaction AS SELECT * FROM tbl_party_relationship_transaction;

CREATE INDEX ix_party_relationship_transaction_parent_date ON tbl_party_relationship_transaction (parent_id, transaction_effective_date);
CREATE INDEX ix_party_relationship_transaction_parent_type ON tbl_party_relationship_transaction (parent_id, transaction_type_id);
CREATE INDEX ix_party_relationship_transaction_child_date ON tbl_party_relationship_transaction (child_id, transaction_effective_date);
CREATE INDEX ix_party_relationship_transaction_child_type ON tbl_party_relationship_transaction (child_id, transaction_type_id);

/*------------------------------------------------------------*/

CREATE TABLE tbl_organization_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_organization_transaction PRIMARY KEY (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_organization_transaction_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_organization_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_organization_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_organization_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_organization_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of an organization'
;

CREATE ALGORITHM=MERGE VIEW organization_transaction AS SELECT * FROM tbl_organization_transaction;

CREATE INDEX ix_organization_transaction_date ON tbl_organization_transaction (organization_id, transaction_effective_date);
CREATE INDEX ix_organization_transaction_type ON tbl_organization_transaction (organization_id, transaction_type_id);

/*------------------------------------------------------------*/

CREATE TABLE tbl_user_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_user_transaction PRIMARY KEY (id),
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user',
	CONSTRAINT fk_user_transaction_to_user FOREIGN KEY (user_id) REFERENCES tbl_user_profile (id),
organization_id int UNSIGNED NULL COMMENT 'Identifies the organization of the affected user',
	CONSTRAINT fk_user_transaction_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_user_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_user_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_user_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_user_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a user'
;

CREATE ALGORITHM=MERGE VIEW user_transaction AS SELECT * FROM tbl_user_transaction;

CREATE INDEX ix_user_transaction_date ON tbl_user_transaction (user_id, transaction_effective_date);
CREATE INDEX ix_user_transaction_type ON tbl_user_transaction (user_id, transaction_type_id);

/*------------------------------------------------------------*/

CREATE TABLE tbl_user_grade_range_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_grade_range_transaction PRIMARY KEY (id),
user_id int UNSIGNED NULL COMMENT 'Identifies the user',
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization of the affected user',
grade_range_id int UNSIGNED NULL COMMENT 'Identifies the grade range',
grade_range_sequence int NULL COMMENT 'The sequence in which the grade range should be listed on pages and reports',
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_user_grade_range_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_user_grade_range_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_user_grade_range_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_user_grade_range_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a user grade range'
;

CREATE ALGORITHM=MERGE VIEW user_grade_range_transaction AS SELECT * FROM tbl_user_grade_range_transaction;

CREATE INDEX ix_user_grade_range_transaction_date ON tbl_user_grade_range_transaction (user_id, transaction_effective_date);
CREATE INDEX ix_user_grade_range_transaction_type ON tbl_user_grade_range_transaction (user_id, transaction_type_id);


/*------------------------------------------------------------*/

CREATE TABLE tbl_contract_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_contract_transaction PRIMARY KEY (id),
contract_id int UNSIGNED NULL COMMENT 'Identifies the contract',
customer_organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization who entered into the contract with Teachscape',
start_date datetime NULL COMMENT 'The date the contract went into effect',
end_date datetime NULL COMMENT 'The date the contract expires',
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_contract_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_contract_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_contract_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_contract_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a contract'
;

CREATE ALGORITHM=MERGE VIEW contract_transaction AS SELECT * FROM tbl_contract_transaction;

CREATE INDEX ix_contract_transaction_date ON tbl_contract_transaction (contract_id, transaction_effective_date);
CREATE INDEX ix_contract_transaction_type ON tbl_contract_transaction (contract_id, transaction_type_id);

/*------------------------------------------------------------*/

CREATE TABLE tbl_role_resource_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_role_resource_transaction PRIMARY KEY (id),
role_id int UNSIGNED NOT NULL COMMENT 'Identifies the role',
	CONSTRAINT fk_role_resource_transaction_to_role FOREIGN KEY (role_id) REFERENCES tbl_role (id),
resource_id int UNSIGNED NOT NULL COMMENT 'Identifies the resource',
	CONSTRAINT fk_role_resource_transaction_to_resource FOREIGN KEY (resource_id) REFERENCES tbl_resource (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_role_resource_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_role_resource_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES tbl_user_profile (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_role_resource_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES tbl_organization (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
transaction_status_id int UNSIGNED NOT NULL  COMMENT 'Identifies the transaction status',
	CONSTRAINT fk_role_resource_transaction_to_transaction_status FOREIGN KEY (transaction_status_id) REFERENCES tbl_transaction_status (id),
#external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a role resource'
;

CREATE ALGORITHM=MERGE VIEW role_resource_transaction AS SELECT * FROM tbl_role_resource_transaction;

CREATE INDEX ix_role_resource_transaction_role_date ON tbl_role_resource_transaction (role_id, transaction_effective_date);
CREATE INDEX ix_role_resource_transaction_role_type ON tbl_role_resource_transaction (role_id, transaction_type_id);
CREATE INDEX ix_role_resource_transaction_resource_date ON tbl_role_resource_transaction (resource_id, transaction_effective_date);
CREATE INDEX ix_role_resource_transaction_resource_type ON tbl_role_resource_transaction (resource_id, transaction_type_id);

/*------------------------------------------------------------*/
/* Document Service (videos) */
/*------------------------------------------------------------*/

/* reference */

CREATE TABLE tbl_document_medium (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_medium PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the document_medium to internal teachscape personnel and document_mediums',
	CONSTRAINT uq_document_medium_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the document_medium to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_document_medium_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the document_medium through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A means of communication, such as image, video, audio, writing, etc.' ;

CREATE ALGORITHM=MERGE VIEW document_medium AS SELECT * FROM tbl_document_medium;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_relationship_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_relationship_type PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the document relationship type to internal teachscape personnel and document_relationship_types',
	CONSTRAINT uq_document_relationship_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the document relationship type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_document_relationship_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the document relationship type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of relationship between two documents' ;

CREATE ALGORITHM=MERGE VIEW document_relationship_type AS SELECT * FROM tbl_document_relationship_type;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_metadata_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_metadata_type PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the document_metadata type to internal teachscape personnel and document_metadata_types',
	CONSTRAINT uq_document_metadata_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the document_metadata type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_document_metadata_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the document_metadata type through definition, examples, etc.',
is_organization_specific BIT NOT NULL COMMENT '1 = This type of document_metadata is specific to each organization, 0 = This type of document_metadata is shared by all organizations' default 0,
allow_multiple_values BIT NOT NULL COMMENT '1 = One document may be associated with several metadata items of this type, 0 = Only one metadata item per entity may be associated with a document' default 0,
data_type_id int UNSIGNED NULL COMMENT 'Identifies the data type',
 	CONSTRAINT fk_document_metadata_type_data_type FOREIGN KEY (data_type_id) REFERENCES tbl_data_type (id),
is_identifier BIT NOT NULL COMMENT '1 = The metadata values are internal identifiers and can be converted to external keys' default 0,
referenced_entity varchar(128) NULL COMMENT 'Identifies the database object that is identified',
referenced_entity_label_attribute varchar(128) NULL COMMENT 'Identifies the column that provides the human-readable label for the referenced entity',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A document_metadata dimension for filtering documents, such as keyword, subject or teacher' ;

CREATE ALGORITHM=MERGE VIEW document_metadata_type AS SELECT * FROM tbl_document_metadata_type;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_metadata (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_metadata PRIMARY KEY (id) ,
label nvarchar(255) NOT NULL COMMENT 'A unique string identifying the document_metadata to internal teachscape personnel and document_metadata_types',
document_metadata_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the document_metadata_type',
	CONSTRAINT fk_document_metadata_document_metadata_type FOREIGN KEY (document_metadata_type_id) REFERENCES tbl_document_metadata_type (id),
organization_id int UNSIGNED NULL COMMENT 'A value of a particular document_metadata type associated with a document by which to describe it'
# add later when ums is in place
#, CONSTRAINT fk_party_document_model FOREIGN KEY (organization_id) REFERENCES ums.tbl_organization (id)
,
# add later when data is cleaned up
#CONSTRAINT uq_document_metadata_organization_type_text UNIQUE(organization_id, document_metadata_type_id, label),
sequence_number smallint NOT NULL DEFAULT 0 COMMENT 'The relative order in which this tag should display in lists',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A value of a certain type with which a document can be associated and searched for';

CREATE ALGORITHM=MERGE VIEW document_metadata AS SELECT * FROM tbl_document_metadata;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_party_relationship_type (
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_party_relationship_type PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying the document party relationship type to internal teachscape personnel and document_party_relationship_types',
	CONSTRAINT uq_document_party_relationship_type_name UNIQUE(name),
label nvarchar(75) NOT NULL COMMENT 'A unique string identifying the document party relationship type to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_document_party_relationship_type_label UNIQUE(label),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the document party relationship type through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A way in which a party can be associated with a document' ;

CREATE ALGORITHM=MERGE VIEW document_party_relationship_type AS SELECT * FROM tbl_document_party_relationship_type;

/* party */

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_channel (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_channel PRIMARY KEY (id) ,
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_document_channel_party FOREIGN KEY (party_id) REFERENCES db_000.tbl_party (id),
title nvarchar(75) NOT NULL COMMENT 'A string identifying the channel to external users that is initially populated from user administration',
description varchar(255) NOT NULL COMMENT 'A short comment further explaining the channel through definition, examples, etc.',
sequence_number smallint NOT NULL DEFAULT 0 COMMENT 'The relative order in which this channel should display in lists',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A bucket by which a party can categorize a set of documents';

CREATE ALGORITHM=MERGE VIEW document_channel AS SELECT * FROM tbl_document_channel;

/* documents */

/*------------------------------------------------------------*/
CREATE TABLE tbl_document (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document PRIMARY KEY (id),
publication_id char(36) NULL COMMENT 'Identifies the publication in the file processing system',
is_active bit NOT NULL DEFAULT 1 COMMENT '1 = the document is available for all operations, 0 = the document has been discontinued and is no longer available for operations',
is_primary bit NOT NULL DEFAULT 1 COMMENT '1 = the document is not dependent on another and viewable in document searches, 0 = the document exists in an auxiliary to a primary document',
contributing_user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user who contributed or uploaded the document',
contributing_user_organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization under which the user contributed or uploaded the document',
root_document_id int UNSIGNED NULL COMMENT 'Identifies the original document from which this was derived',
document_medium_id int UNSIGNED NOT NULL COMMENT 'Identifies the document_medium (video, image, etc.)',
	CONSTRAINT fk_document_document_medium FOREIGN KEY (document_medium_id) REFERENCES tbl_document_medium (id),
title varchar(255) NOT NULL COMMENT 'A string identifying the document to external users that displays on user-facing reports and screens',
FULLTEXT ft_document_title (title),
description longtext NULL COMMENT 'A string further describing or explaining the document to external users that displays on user-facing reports and screens',
contribution_date datetime NOT NULL COMMENT 'The date the documentwas uploaded',
publish_date datetime NULL COMMENT 'The date the document was made available',
degenerate_video_id int (11) NULL COMMENT 'Identifies the video from the legacy system',
degenerate_artifact_id int (11) NULL COMMENT 'Identifies the artifact from the legacy system',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A digital form of communication (such as a video, image, audio file, or document) that provides information or evidence';

CREATE ALGORITHM=MERGE VIEW document AS SELECT * FROM tbl_document;
/* document- artifacts */
CREATE INDEX ix_document_degenerate_artifact_id ON tbl_document(degenerate_artifact_id);


/*------------------------------------------------------------*/
CREATE TABLE tbl_document_metadata_relationship (
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document',
	CONSTRAINT fk_document_metadata_relationship_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
document_metadata_id int UNSIGNED NOT NULL COMMENT 'Identifies the document_metadata',
	CONSTRAINT fk_document_metadata_relationship_to_document_metadata FOREIGN KEY (document_metadata_id) REFERENCES tbl_document_metadata (id),
CONSTRAINT pk_document_metadata_relationship PRIMARY KEY (document_id, document_metadata_id),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A piece of data that helps describe a particular document.';

CREATE ALGORITHM=MERGE VIEW document_metadata_relationship AS SELECT * FROM tbl_document_metadata_relationship;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_relationship (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_relationship PRIMARY KEY (id),
parent_id int UNSIGNED NOT NULL COMMENT 'Identifies the document that has or contains the child document',
	CONSTRAINT fk_document_relationship_to_parent FOREIGN KEY (parent_id) REFERENCES tbl_document (id),
child_id int UNSIGNED NOT NULL COMMENT 'Identifies the document that is a child of the parent',
	CONSTRAINT fk_document_relationship_to_child FOREIGN KEY (child_id) REFERENCES tbl_document (id),
child_degenerate_artifact_id int (11) NULL COMMENT 'Identifies the artifact from the legacy system',
document_relationship_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the relationship type',
	CONSTRAINT fk_document_relationship_to_relationship_type FOREIGN KEY (document_relationship_type_id) REFERENCES tbl_document_relationship_type (id),
CONSTRAINT uq_document_relationship_parent_child_type UNIQUE (parent_id, child_id, document_relationship_type_id) ,
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A relationship between two documents';

CREATE ALGORITHM=MERGE VIEW document_relationship AS SELECT * FROM tbl_document_relationship;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_party_relationship (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_party_relationship PRIMARY KEY (id) ,
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document',
	CONSTRAINT fk_document_party_relationship_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
party_id int UNSIGNED NOT NULL COMMENT 'Identifies the party',
	CONSTRAINT fk_document_party_relationship_to_party FOREIGN KEY (party_id) REFERENCES db_000.tbl_party (id),
relationship_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the relationship type',
	CONSTRAINT fk_document_relationship_type_relationship_to_relationship_type FOREIGN KEY (relationship_type_id) REFERENCES tbl_document_party_relationship_type (id),
document_channel_id int UNSIGNED NULL COMMENT 'Identifies the channel',
	CONSTRAINT fk_document_party_relationship_to_document_channel FOREIGN KEY (document_channel_id) REFERENCES tbl_document_channel (id),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A relationship, often an authorization, of a party to a document';

CREATE ALGORITHM=MERGE VIEW document_party_relationship AS SELECT * FROM tbl_document_party_relationship;


/*------------------------------------------------------------*/
CREATE TABLE tbl_document_comment (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_comment PRIMARY KEY (id) ,
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document',
	CONSTRAINT fk_document_comment_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user who commented',
	CONSTRAINT fk_document_comment_user FOREIGN KEY (user_id) REFERENCES db_000.tbl_user_profile (id),
user_organization_id int UNSIGNED NULL COMMENT 'Identifies the organization of the user who commented',
	CONSTRAINT fk_document_comment_user_organization FOREIGN KEY (user_organization_id) REFERENCES db_000.tbl_organization (id),
comment_text longtext NOT NULL COMMENT 'The comment',
comment_date datetime NOT NULL COMMENT 'The date and time the comment was added',
timestamp_in_milliseconds bigint NULL COMMENT 'If commenting a document with duration (video, audio, etc.), the point in time that the comment pertains to',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A piece of data that helps describe a particular document.';

CREATE ALGORITHM=MERGE VIEW document_comment AS SELECT * FROM tbl_document_comment;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_aggregate (
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document',
	CONSTRAINT fk_document_aggregate_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
Number_of_views bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'The number of times someone has viewed the document',
Number_of_favorites bigint UNSIGNED NOT NULL DEFAULT 0 COMMENT 'The number of times someone has marked the document as a favorite',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A piece of data that helps describe a particular document.';

CREATE ALGORITHM=MERGE VIEW document_aggregate AS SELECT * FROM tbl_document_aggregate;

/* transactions */

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_transaction PRIMARY KEY (id),
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document whose state was affected by the transaction',
	CONSTRAINT fk_document_transaction_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_transaction_to_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_document_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document'
;

CREATE ALGORITHM=MERGE VIEW document_transaction AS SELECT * FROM tbl_document_transaction;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_relationship_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_relationship_transaction PRIMARY KEY (id),
document_relationship_id int UNSIGNED NOT NULL COMMENT 'Identifies the document relationship whose state was affected by the transaction',
	CONSTRAINT fk_document_relationship_transaction_to_document_relationship FOREIGN KEY (document_relationship_id) REFERENCES tbl_document_relationship (id),
parent_document_id int UNSIGNED NOT NULL COMMENT 'Identifies the parent in the document relationship whose state was affected by the transaction',
	CONSTRAINT fk_document_relationship_transaction_to_parent FOREIGN KEY (parent_document_id) REFERENCES tbl_document_relationship (child_id),
child_document_id int UNSIGNED NOT NULL COMMENT 'Identifies the child in the document relationship whose state was affected by the transaction',
	CONSTRAINT fk_document_relationship_transaction_to_child FOREIGN KEY (child_document_id) REFERENCES tbl_document_relationship (child_id),
document_relationship_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the type of relationship whose state was affected by the transaction',
	CONSTRAINT fk_document_relationship_transaction_to_relationship_type FOREIGN KEY (document_relationship_type_id) REFERENCES tbl_document_relationship_type (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_relationship_transaction_to_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_document_relationship_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_relationship_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW document_relationship_transaction AS SELECT * FROM tbl_document_relationship_transaction;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_aggregate_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_aggregate_transaction PRIMARY KEY (id),
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document whose activity was incremented',
	CONSTRAINT fk_document_aggregate_transaction_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_aggregate_transaction_to_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_document_aggregate_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_aggregate_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW document_aggregate_transaction AS SELECT * FROM tbl_document_aggregate_transaction;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_party_relationship_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_party_relationship_transaction PRIMARY KEY (id),
document_party_relationship_id int UNSIGNED NOT NULL COMMENT 'Identifies the document-party relationship whose state was affected by the transaction',
	CONSTRAINT fk_transaction_to_document_party_relationship FOREIGN KEY (document_party_relationship_id) REFERENCES tbl_document_party_relationship (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_party_relationship_transaction_to_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_party_relationship_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_party_relationship_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW document_party_relationship_transaction AS SELECT * FROM tbl_document_party_relationship_transaction;

/*------------------------------------------------------------*/
CREATE TABLE tbl_user_aggregate_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_user_aggregate_transaction PRIMARY KEY (id),
user_id int UNSIGNED NOT NULL COMMENT 'Identifies the user whose activity was incremented',
	CONSTRAINT fk_user_aggregate_transaction_to_user FOREIGN KEY (user_id) REFERENCES db_000.tbl_user_profile (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_user_aggregate_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW user_aggregate_transaction AS SELECT * FROM tbl_user_aggregate_transaction;

/*------------------------------------------------------------*/
CREATE TABLE tbl_document_channel_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_document_channel_transaction PRIMARY KEY (id),
document_channel_id int UNSIGNED NOT NULL COMMENT 'Identifies the channel whose state was affected by the transaction',
	CONSTRAINT fk_document_channel_transaction_to_document_channel FOREIGN KEY (document_channel_id) REFERENCES tbl_document_channel (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_channel_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_document_channel_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_channel_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW document_channel_transaction AS SELECT * FROM tbl_document_channel_transaction;


/*------------------------------------------------------------*/
CREATE TABLE tbl_document_metadata_transaction (
id int UNSIGNED NOT NULL AUTO_INCREMENT,
	CONSTRAINT pk_document_metadata_transaction PRIMARY KEY (id),
document_metadata_id int UNSIGNED NOT NULL COMMENT 'Identifies the document_metadata whose state was affected by the transaction',
	CONSTRAINT fk_document_metadata_transaction_to_document_metadata FOREIGN KEY (document_metadata_id) REFERENCES tbl_document_metadata (id),
transaction_user_id int UNSIGNED NOT NULL COMMENT 'The user who generated this transaction',
	CONSTRAINT fk_document_metadata_transaction_to_transaction_user FOREIGN KEY (transaction_user_id) REFERENCES db_000.tbl_party (id),
transaction_user_organization_id int UNSIGNED NULL COMMENT 'The organization of the user who generated this transaction',
	CONSTRAINT fk_document_metadata_transaction_to_user_organization FOREIGN KEY (transaction_user_organization_id) REFERENCES db_000.tbl_organization (id),
transaction_type_id int UNSIGNED NOT NULL COMMENT 'Identifies the nature of the event',
	CONSTRAINT fk_document_metadata_transaction_to_transaction_type FOREIGN KEY (transaction_type_id) REFERENCES tbl_transaction_type (id),
transaction_effective_date datetime NOT NULL COMMENT 'The date and time the event occurred',
row_insert_time timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'The date and time the row was persisted to the data store'
)
ENGINE=InnoDB
AUTO_INCREMENT=1
COMMENT='An event that changes the state of a document relationship'
;

CREATE ALGORITHM=MERGE VIEW document_metadata_transaction AS SELECT * FROM tbl_document_metadata_transaction;

/******************************/
/* Focus */
/******************************/

/* Reference */

/*------------------------------------------------------------*/
CREATE TABLE tbl_focus_module(
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_focus_module PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying focus module to internal teachscape personnel and applications',
	CONSTRAINT uq_focus_module_name UNIQUE(name),
title nvarchar(75) NOT NULL COMMENT 'A unique string identifying focus module to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_focus_module_title UNIQUE(title),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining focus module through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of transaction against an entity, such as add, delete, update, activate, etc.' ;

CREATE ALGORITHM=MERGE VIEW focus_module AS SELECT * FROM tbl_focus_module;

CREATE INDEX ix_focus_module_name ON tbl_focus_module (name);
CREATE INDEX ix_focus_module_external_key ON tbl_focus_module (external_key);

/*------------------------------------------------------------*/

CREATE TABLE tbl_school_year(
id int UNSIGNED NOT NULL COMMENT 'Sequential integer serving as surrogate key to the rowe',
	CONSTRAINT pk_school_year PRIMARY KEY (id),
name varchar(50) CHARACTER SET latin1 COLLATE latin1_swedish_ci NOT NULL COMMENT 'A unique string identifying school year to internal teachscape personnel and applications',
	CONSTRAINT uq_school_year_name UNIQUE(name),
title nvarchar(75) NOT NULL COMMENT 'A unique string identifying school year to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_school_year_title UNIQUE(title),
description varchar(255) NOT NULL COMMENT 'A short comment further explaining school year through definition, examples, etc.',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A type of transaction against an entity, such as add, delete, update, activate, etc.' ;

CREATE ALGORITHM=MERGE VIEW school_year AS SELECT * FROM tbl_school_year;

CREATE INDEX ix_school_year_name ON tbl_school_year (name);
CREATE INDEX ix_school_year_external_key ON tbl_school_year (external_key);



/* Rubrics */

/*------------------------------------------------------------*/
CREATE TABLE tbl_framework (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_framework PRIMARY KEY (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_framework_to_orgnization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
title nvarchar(128) NOT NULL COMMENT 'A unique string identifying framework to external users that displays on user-facing reports and screens',
	CONSTRAINT uq_framework_title UNIQUE(organization_id, title),
description nvarchar(512) NOT NULL COMMENT 'A unique string identifying framework to external users that displays on user-facing reports and screens',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A common language and vision of quality teaching to be shared throughout and eductional jurisdiction';

CREATE ALGORITHM=MERGE VIEW framework AS SELECT * FROM tbl_framework;

CREATE INDEX ix_framework_organization ON tbl_framework (organization_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_rubric (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_rubric PRIMARY KEY (id),
organization_id int UNSIGNED NOT NULL COMMENT 'Identifies the organization',
	CONSTRAINT fk_rubric_to_organization FOREIGN KEY (organization_id) REFERENCES tbl_organization (id),
framework_id int UNSIGNED NOT NULL COMMENT 'Identifies the framework',
	CONSTRAINT fk_rubric_to_framework FOREIGN KEY (framework_id) REFERENCES tbl_framework (id),
title nvarchar(75) NOT NULL COMMENT 'A unique string identifying rubric to external users that displays on user-facing reports and screens',
edition nvarchar(25) NOT NULL COMMENT '',
version nvarchar(75) NOT NULL COMMENT '',
start_date datetime NOT NULL COMMENT 'Overrides the permission set start date for the date the calibration becomes active',
end_date datetime NULL COMMENT 'Overrides the permission set end date for the date the calibration expires',
source_rubric_id int UNSIGNED NULL COMMENT 'Identifies the rubric from which this was generated',
	CONSTRAINT fk_rubric_to_source_rubric FOREIGN KEY (source_rubric_id) REFERENCES tbl_rubric (id),
#maximum_depth smallint NULL COMMENT 'The maximum number of nested levels in the rubric hierarchy, including the root',
number_of_scorable_criteria smallint NOT NULL COMMENT 'The number of scorable criteria in the rubric',
default_question_format_id int UNSIGNED NOT NULL COMMENT 'Identifies the default question type',
CONSTRAINT uq_organization_rubric_title UNIQUE(organization_id, title),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A set of criteria and rating scales by which to assess performance against a framework';

CREATE ALGORITHM=MERGE VIEW rubric AS SELECT * FROM tbl_rubric;

CREATE INDEX ix_rubric_organization ON tbl_rubric (organization_id);
CREATE INDEX ix_rubric_framework ON tbl_rubric (framework_id);
CREATE INDEX ix_rubric_external_key ON tbl_rubric (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_rubric_level (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_rubric_level PRIMARY KEY (id),
rubric_id int UNSIGNED NOT NULL COMMENT 'Identifies the rubric',
	CONSTRAINT fk_rubric_level_to_rubric FOREIGN KEY (rubric_id) REFERENCES tbl_rubric (id),
sequence_number smallint NOT NULL COMMENT '',
CONSTRAINT uq_rubric_level_sequence UNIQUE (rubric_id, sequence_number),
title nvarchar(75) NOT NULL COMMENT 'A unique string identifying the rubric level, such as "Basic" or "Exemplary"',
CONSTRAINT uq_rubric_level_title UNIQUE(rubric_id, title),
numeric_value DECIMAL (5,2) NULL COMMENT '',
descriptor text NULL COMMENT '',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A set of criteria and rating scales by which to assess performance against a framework';

CREATE ALGORITHM=MERGE VIEW rubric_level AS SELECT * FROM tbl_rubric_level;

CREATE INDEX ix_rubric_level_external_key ON tbl_rubric_level (external_key);

/*------------------------------------------------------------*/
CREATE TABLE tbl_rubric_criterion (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_rubric_criterion PRIMARY KEY (id),
rubric_id int UNSIGNED NOT NULL COMMENT 'Identifies the rubric',
	CONSTRAINT fk_rubric_criterion_to_rubric FOREIGN KEY (rubric_id) REFERENCES tbl_rubric (id),
short_title nvarchar(10) NOT NULL COMMENT 'A unique string identifying the rubric score, such as "Basic" or "Exemplary"',
title nvarchar(75) NOT NULL COMMENT 'A unique title identifying the rubric score, such as "Basic" or "Exemplary"',
CONSTRAINT uq_rubric_criterion_title UNIQUE(rubric_id, title),
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A set of criteria and rating scales by which to assess performance against a framework';

CREATE ALGORITHM=MERGE VIEW rubric_criterion AS SELECT * FROM tbl_rubric_criterion;

CREATE INDEX ix_rubric_criterion_external_key ON tbl_rubric_criterion (external_key);

/* Exemplars */

/*------------------------------------------------------------*/
CREATE TABLE tbl_exemplar (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_exemplar PRIMARY KEY (id),
document_id int UNSIGNED NOT NULL COMMENT 'Identifies the document',
# Add back when stable and part of a database build 
#	CONSTRAINT fk_exemplar_to_document FOREIGN KEY (document_id) REFERENCES tbl_document (id),
is_active bit NOT NULL DEFAULT 1 COMMENT '1 = the exemplar is available for all operations, 0 = the exemplar has been discontinued or suspended and is not available for operations',
external_key char(36) CHARACTER SET latin1 COLLATE latin1_swedish_ci NULL COMMENT 'A unique identifier used to identify this to the outside world',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='';

CREATE ALGORITHM=MERGE VIEW exemplar AS SELECT * FROM tbl_exemplar;

CREATE INDEX ix_exemplar_external_key ON tbl_exemplar (external_key);


/*------------------------------------------------------------*/
CREATE TABLE tbl_exemplar_grade_range (
exemplar_id int UNSIGNED NOT NULL COMMENT 'Identifies the exemplar',
	CONSTRAINT fk_exemplar_grade_range_to_exemplar FOREIGN KEY (exemplar_id) REFERENCES tbl_exemplar (id),
grade_range_id int UNSIGNED NOT NULL COMMENT 'Identifies the grade_range',
	CONSTRAINT fk_exemplar_grade_range_to_grade_range FOREIGN KEY (grade_range_id) REFERENCES tbl_grade_range (id),
CONSTRAINT pk_exemplar_grade_range PRIMARY KEY (exemplar_id, grade_range_id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A grade_range associated with a exemplar that can be assigned permission through licensing that exemplar';

CREATE ALGORITHM=MERGE VIEW exemplar_grade_range AS SELECT * FROM tbl_exemplar_grade_range;

CREATE INDEX ix_exemplar_grade_range_grade_range ON tbl_exemplar_grade_range (grade_range_id, exemplar_id);


/*------------------------------------------------------------*/
CREATE TABLE tbl_exemplar_evidence (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_exemplar_evidence PRIMARY KEY (id),
exemplar_id int UNSIGNED NOT NULL COMMENT 'Identifies the exemplar',
	CONSTRAINT fk_exemplar_evidence_to_exemplar FOREIGN KEY (exemplar_id) REFERENCES tbl_exemplar (id),
evidence text NOT NULL COMMENT 'A description of the evidence',
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A evidence associated with a exemplar that can be assigned permission through licensing that exemplar';

CREATE ALGORITHM=MERGE VIEW exemplar_evidence AS SELECT * FROM tbl_exemplar_evidence;

CREATE INDEX ix_exemplar_evidence_exemplar ON tbl_exemplar_evidence (exemplar_id);

/* Rubic Exemplars */

/*------------------------------------------------------------*/
CREATE TABLE tbl_exemplar_evidence_criterion (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_exemplar_evidence_criterion PRIMARY KEY (id),
exemplar_evidence_id int UNSIGNED NOT NULL COMMENT 'Identifies the exemplar evidence',
	CONSTRAINT fk_exemplar_evidence_criterion_to_exemplar_evidence FOREIGN KEY (exemplar_evidence_id) REFERENCES tbl_exemplar_evidence (id),
rubric_criterion_id int UNSIGNED NOT NULL COMMENT 'Identifies the criterion',
	CONSTRAINT fk_exemplar_evidence_criterion_to_rubric_criterion FOREIGN KEY (rubric_criterion_id) REFERENCES tbl_rubric_criterion (id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A evidence associated with a exemplar that can be assigned permission through licensing that exemplar';

CREATE ALGORITHM=MERGE VIEW exemplar_evidence_criterion AS SELECT * FROM tbl_exemplar_evidence_criterion;

CREATE INDEX ix_exemplar_evidence_criterion_exemplar_evidence ON tbl_exemplar_evidence_criterion (exemplar_evidence_id);
CREATE INDEX ix_exemplar_evidence_criterion_rubric_criterion ON tbl_exemplar_evidence_criterion (rubric_criterion_id);

/*------------------------------------------------------------*/
CREATE TABLE tbl_exemplar_criterion_level (
id int UNSIGNED NOT NULL AUTO_INCREMENT COMMENT 'Sequential integer serving as surrogate key to the row',
	CONSTRAINT pk_exemplar_criterion_level PRIMARY KEY (id),
exemplar_id int UNSIGNED NOT NULL COMMENT 'Identifies the exemplar evidence',
	CONSTRAINT fk_exemplar_criterion_level_to_exemplar FOREIGN KEY (exemplar_id) REFERENCES tbl_exemplar (id),
rubric_criterion_id int UNSIGNED NOT NULL COMMENT 'Identifies the criterion',
	CONSTRAINT fk_exemplar_criterion_level_to_rubric_criterion FOREIGN KEY (rubric_criterion_id) REFERENCES tbl_rubric_criterion (id),
rubric_level_id int UNSIGNED NOT NULL COMMENT 'Identifies the criterion',
	CONSTRAINT fk_exemplar_criterion_level_to_rubric_level FOREIGN KEY (rubric_level_id) REFERENCES tbl_rubric_level (id),
row_last_update_time timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP  COMMENT 'The date and time one or more column values of the row changed'
) ENGINE=INNODB COMMENT='A evidence associated with a exemplar that can be assigned permission through licensing that exemplar';

CREATE ALGORITHM=MERGE VIEW exemplar_criterion_level AS SELECT * FROM tbl_exemplar_criterion_level;

CREATE INDEX ix_exemplar_criterion_level_exemplar ON tbl_exemplar_criterion_level (exemplar_id);
CREATE INDEX ix_exemplar_criterion_level_rubric_criterion ON tbl_exemplar_criterion_level (rubric_criterion_id);

/*------------------------------------------------------------*/
/* Views to support DAL queries */
/*------------------------------------------------------------*/

/* UMS */

/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW organization_extended AS
SELECT 
/* organization */
o.* #id, o.external_key, o.name, o.uses_new_platform, o.row_last_update_time
, ot.external_key as organization_type_external_key
/* address */
, a.address_line1, a.address_line2, a.address_city, a.address_state_code, a.address_territory, a.address_postal_code, a.address_country
/* organization contact */
, oc.name AS contact_name, oc.email_address, oc.contact_phone
FROM organization o 
JOIN organization_type ot ON ot.id = o.organization_type_id
LEFT OUTER JOIN organization_contact oc ON oc.organization_id = o.id
LEFT OUTER JOIN party_address AS pa ON pa.party_id = o.party_id AND pa.is_primary = 1
LEFT OUTER JOIN address a ON a.id = pa.address_id
;

/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW user_in_organization_role AS
SELECT
/* user */
u.* #id, u.external_key, u.row_last_update_time, u.username, u.user_email_address, u.is_active
/* role */
, r.external_key AS role_external_key, r.name AS role_name
/* organization */
, o.external_key as organization_external_key, o.name AS organization_name
/* person */
, p.first_name AS person_first_name, p.middle_name AS person_middle_name, p.last_name AS person_last_name, p.row_last_update_time AS person_row_last_update_time
FROM party_relationship pr
JOIN organization o ON o.party_id = pr.parent_id /* parent party is org */
JOIN user_profile u ON u.party_id = pr.child_id /* child party is user */
JOIN role r ON r.id = pr.role_id
LEFT OUTER JOIN person p ON p.party_id = pr.child_id /* child party may be person */
/* role has to be an org to user role */
WHERE r.parent_party_type_id = 2 /* org */ AND r.child_party_type_id = 3 /* user */
;

/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW role_user_in_organization AS
SELECT
/* role */
r.id, r.external_key, r.row_last_update_time, r.name AS role_name
/* user */
, u.external_key AS user_external_key, u.username, u.user_email_address, u.is_active, u.row_last_update_time AS user_row_last_update_time
/* organization */
, o.external_key as organization_external_key, o.name AS organization_name
/* person */
, p.first_name AS person_first_name, p.middle_name AS person_middle_name, p.last_name AS person_last_name, p.row_last_update_time AS person_row_last_update_time
FROM party_relationship pr
JOIN organization o ON o.party_id = pr.parent_id /* parent party is org */
JOIN role r ON r.id = pr.role_id
JOIN user_profile u ON u.party_id = pr.child_id /* child party is user */
LEFT OUTER JOIN person p ON p.party_id = pr.child_id /* child party may be person */
/* role has to be an org to user role */
WHERE r.parent_party_type_id = 2 /* org */ AND r.child_party_type_id = 3 /* user */
;

/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW role_in_organization
AS
SELECT r.external_key AS role_external_key, r.name AS role_name, o.name AS organization_name, o.external_key AS organization_external_key
FROM organization_role orgr
JOIN organization o ON o.id = orgr.organization_id
JOIN  role r ON r.id  = orgr.role_id
;

/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW role_in_organization_with_user_count
AS
SELECT
r.external_key AS role_external_key, r.name AS role_name, r.row_last_update_time
, o.external_key AS organization_external_key, o.name AS organization_name
, COUNT(*) AS number_of_users
FROM party_relationship pr
JOIN organization o ON o.party_id = pr.parent_id /* parent party is org */
JOIN role r ON r.id = pr.role_id
JOIN user_profile u ON u.party_id = pr.child_id /* child party is user */
/* role has to be an org to user role */
AND r.parent_party_type_id = 2 /* org */ AND r.child_party_type_id = 3 /* individual */
GROUP BY r.external_key, o.external_key 
;

/* document */
/*------------------------------------------------------------*/
CREATE ALGORITHM=MERGE VIEW document_extended AS
SELECT 
d.*
, u.external_key as contributing_user_external_key
, o.external_key as contributing_user_organization_external_key
, rd.external_key as root_document_external_key
, dm.external_key as document_medium_external_key
FROM document d
JOIN user_profile u ON u.id = d.contributing_user_id
LEFT OUTER JOIN organization o ON o.id = d.contributing_user_organization_id
LEFT OUTER JOIN document rd ON rd.id = d.root_document_id
LEFT OUTER JOIN document_medium dm ON dm.id = d.document_medium_id
;

/*------------------------------------------------------------*/
/* Populate reference tables with constants
/*------------------------------------------------------------*/
/* Metadata */

INSERT data_type (id, name, description) VALUES 
	(1, 'integer', 'Any whole number, positive or negative')
  , (2, 'string', 'An array of bytes that can be displayed as a single text field')
  , (3, 'date', 'A calendar date')
  , (4, 'datetime', 'A calendar date and time at least to the second')
  , (5, 'timestamp', 'A calendar date and time to the most granular level available')
;

INSERT exception_severity (id, name, description) VALUES 
	(3, 'informational', 'The exception did not necessarily cause any problems')
  , (2, 'warning', 'The exception may have caused a problem but the process did not abort')
  , (1, 'fatal', 'The exception caused a problem and the process aborted')
;

INSERT database_exception (id, name, description, exception_severity_id) VALUES 
	(1, 'primary_record_not_found', 'The record for the primary entity was not found', 1)
  , (2, 'update_operation_failed', 'An update operation failed', 1)
  , (3, 'transaction_insert_failed', 'Creating the transaction failed', 2)
  , (4, 'dirty_read', 'A record was changed by another process since being read', 2)
  , (5, 'invalid_arguments', 'Invalid arguments were passed to the database', 1)
  , (6, 'organization_role_missing', 'The procedure attempted to add a user to a role that was invalid for the organization', 1)
;

INSERT configuration (id, configuration_key, description, configuration_value, data_type_id) VALUES 
	(1, 'current_database_version', 'Current version of the database objects', '0.0.0', 2)
;


INSERT party_type (id, name, label, description, external_key) VALUES 
	(1, 'teachscape', 'Teachscape', 'Organization that provides global applications and content', UUID())
  , (2, 'organization', 'organization', 'An organized body of people with a particular purpose, such as an educational institution or a government', UUID())
  , (3, 'individual', 'Individual', 'A person, user or other individual', UUID());

INSERT license_model (id, name, label, description, external_key) VALUES 
	(1, 'per_seat', 'Per Seat', 'The license permits a specified number of users to the product.  Users may be added or dropped as desired so long as the total does not exceed the number of seats.', UUID())
  , (2, 'single_user', 'Single User', 'The license permits a specified set of users to the product and seats cannot be transferred between users.', UUID())
  , (3, 'site', 'Site', 'The license permits all users within the organization to the product.', UUID());

INSERT transaction_status (id, name, label, description, external_key) VALUES 
	(1, 'pending', 'Pending', 'The transaction has not begun execution', UUID())
  , (2, 'executing', 'Executing', 'The transaction has begun but has not completed', UUID())
  , (3, 'successful', 'Successful', 'The transaction completed successfully', UUID())
  , (4, 'error', 'Error', 'The transaction encountered an error', UUID())
  , (5, 'aborted', 'Aborted', 'The transaction had begun but was aborted', UUID());

INSERT transaction_type (id, name, label, description, external_key) VALUES 
	(1, 'create', 'Create', 'Create a new entity instance', UUID())
  , (2, 'delete', 'Delete', 'Delete an existing entity instance', UUID())
  , (3, 'update', 'Update', 'Update an entity instance', UUID())
  , (4, 'activate', 'Activate', 'Activate an entity instance', UUID())
  , (5, 'deactivate', 'Deactivate', 'Deactivate an entity instance', UUID())
  , (6, 'add', 'Add', 'Add a member to a collection', UUID())
  , (7, 'remove', 'Remove', 'Remove a member from a collection', UUID())
  , (8, 'extend', 'Extend', 'Extend the duration of an association, membership or other time-bounded instance', UUID())
  , (9, 'hide', 'hide', 'Prevent users from viewing', UUID())
  , (10, 'unhide', 'unhide', 'Allow users to view', UUID())
  , (11, 'publish', 'publish', 'Officially release a something, allowing others to access', UUID())
  , (12, 'share', 'share', 'Share something with other parties', UUID())
  , (13, 'view', 'view', 'View something', UUID())
  , (14, 'comment', 'comment', 'Comment on something', UUID())
  , (15, 'favorite', 'favorite', 'Mark something as a favorite', UUID())
  , (16, 'login', 'login', 'Login to Teachscape or an application', UUID())
;

INSERT resource_type (id, name, label, description, requires_role_permission, requires_license_permission, external_key) VALUES 
	(1, 'teachscape_application', 'Teachscape Application', 'A software application or subsystem that can be licensed through Teachscape', 0, 1, UUID())
  , (2, 'task', 'Task', 'A task, function, or operation to which a role can be permitted', 1, 0, UUID())
  , (3, 'application_widget', 'Widget', 'A page, tab, or other UI element to which a role can be permitted', 1, 0, UUID())
  , (4, 'document_type', 'Document Type', 'A type of document (evaluation template, rubric, observation evidence form, etc) to which a role can be permitted', 1, 0, UUID())
  , (5, 'licensed_role_resource', 'Licensed Role Resource', 'A resource that can be licensed through Teachscape available only to specific roles', 1, 1, UUID())
;

INSERT address_type (id, name, label, description, external_key) VALUES 
	(1, 'undeclared', 'Undeclared', 'An address that was entered without specifying any other type', UUID())
;

/* applications */
INSERT application (id, name, label, description, is_external, external_key) VALUES 
	(1, 'teachscape', 'Teachscape', '', 0, UUID())
  , (2, 'ums', 'UMS', '', 0, UUID())
  , (3, 'focus', 'Focus', '', 0, UUID())
  , (4, 'learn', 'Learn', '', 0, UUID())
  , (5, 'reflect', 'Reflect', '', 0, UUID())
  , (6, 'saba', 'Saba', '', 1, UUID())
  , (7, 'salesforce', 'Salesforce', '', 1, UUID())
  , (8, 'txl', 'TXL', '', 0, UUID());

INSERT grade_range (id, name, label, description, external_key) VALUES
	  (1, 'All Grades (K-12)', 'All Grades (K-12)', 'All Grades (K-12)', UUID())
	, (2, 'Elementary (K-5)', 'Elementary (K-5)', 'Elementary (K-5)', UUID())
	, (3, 'Elementary-Middle (K-8)', 'Elementary-Middle (K-8)', 'Elementary-Middle (K-8)', UUID())
	, (4, 'High (9-12)', 'High (9-12)', 'High (9-12)', UUID())
	, (5, 'Middle (6-8)', 'Middle (6-8)', 'Middle (6-8)', UUID())
;


INSERT organization_type (id, name, label, description, external_key) VALUES
   (1, 'Building', 'Building',  'Building', UUID())
 , (2, 'ConsultingGroup', 'ConsultingGroup',  'ConsultingGroup', UUID())
 , (3, 'Coop', 'Coop',  'Coop', UUID())
 , (4, 'Country', 'Country',  'Country', UUID())
 , (5, 'Department', 'Department',  'Department', UUID())
 , (6, 'District', 'District',  'District', UUID())
 , (7, 'EducationServiceCenter', 'EducationServiceCenter',  'EducationServiceCenter', UUID())
 , (8, 'Location', 'Location',  'Location', UUID())
 , (9, 'OrganizationGroup', 'OrganizationGroup',  'OrganizationGroup', UUID())
 , (10, 'Other', 'Other',  'Other', UUID())
 , (11, 'PartnerUniversity', 'PartnerUniversity',  'PartnerUniversity', UUID())
 , (12, 'Region', 'Region',  'Region', UUID())
 , (13, 'School', 'School',  'School', UUID())
 , (14, 'State', 'State',  'State', UUID())
 , (15, 'Teachscape', 'Teachscape',  'Teachscape', UUID())

;

INSERT document_metadata_type (id, name, label, description, is_organization_specific, allow_multiple_values, data_type_id, is_identifier, referenced_entity, referenced_entity_label_attribute, external_key) VALUES 
	(1, 'grade', 'Grade', 'A school grade or range of grades', 0, 1, 2, 0, NULL, NULL, UUID())
  , (2, 'subject', 'Subject', 'An educational subject or topic', 0, 1, 2, 0, NULL, NULL, UUID())
  , (3, 'keyword', 'Keyword', 'Text by which a document can be tagged', 1, 1, 2, 0, NULL, NULL, UUID())
  , (4, 'framework', 'Framework', 'A teaching framework', 1, 1, 2, 0, NULL, NULL, UUID())
  , (5, 'organization', 'Organization', 'A school, district or other educational institution', 1, 0, 1, 1, 'organization', 'name', UUID())
  , (6, 'teacher', 'Teacher', 'A teacher', 1, 0, 1, 1, 'person', 'CONCAT(first_name, \' \', last_name)', UUID())
;

INSERT document_medium (id, name, label, description, external_key) VALUES 
	(1, 'video', 'Video', 'Video', UUID())
  , (2, 'document', 'Document', 'A type of document that can be opened by a specific application', UUID())
  , (3, 'image', 'Image', 'An image document', UUID())
;

INSERT document_party_relationship_type (id, name, label, description, external_key) VALUES 
	(1, 'contributor', 'Contributor', 'The party uploaded or otherwise contributed the document', UUID())
  , (2, 'share', 'Shared', 'The contributor shared the document with the party', UUID())
  , (3, 'favorite', 'Favorites', 'The party marked the document as a favorite', UUID())
  , (4, 'channel', 'Channel', 'The party added the document to a channel', UUID())
  , (5, 'TBD', 'TBD', 'This is the USER channel, not sure what it means', UUID());

INSERT document_relationship_type (id, name, label, description, external_key) VALUES 
	(1, 'artifact_system', 'System', 'The child document is a document that can be opened by a specific application', UUID())
  , (2, 'artifact_framework', 'framework', 'framework', UUID())
  , (3, 'artifact_teachscape_framework', 'teachscape_framework', 'teachscape_framework', UUID())
  , (4, 'artifact_image', 'image', 'image', UUID())
  , (5, 'artifact_BINARY', 'BINARY', 'BINARY', UUID())
  , (6, 'clip', 'clip', 'clip', UUID())
;

INSERT focus_module (id, name, title, description, external_key) VALUES 
	(1, 'practice', 'Practice', 'Observer training and practice', UUID())
  , (2, 'assessment', 'assessment', 'The school year that runs from fall 2015 through sring 2016', UUID())
  , (3, 'calibration', 'Calibration', 'The school year that runs from fall 2016 through sring 2017', UUID())
  , (4, 'recertification', 'Recertification', 'The school year that runs from fall 2016 through sring 2017', UUID())
;

INSERT school_year (id, name, title, description, external_key) VALUES 
	(1, '2014-2015', '2014-2015', 'The school year that runs from fall 2014 through sring 2015', UUID())
  , (2, '2015-2016', '2015-2016', 'The school year that runs from fall 2015 through sring 2016', UUID())
  , (3, '2016-2017', '2016-2017', 'The school year that runs from fall 2016 through sring 2017', UUID())
;
