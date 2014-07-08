USE db_000;

/********************************************/
/* products - these are actually "license" products functioning as both now*/
/********************************************/
CREATE TEMPORARY TABLE IF NOT EXISTS _product AS 
(
	SELECT distinct product_code 
	FROM um_view.um_license
	ORDER BY product_code
);
INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT @rownum := @rownum + 1 as id, product_code, product_code, '', (SELECT id FROM application WHERE name = 'teachscape')
, CASE WHEN product_code LIKE 'learn%' OR product_code LIKE 'focus-observer%' THEN 2 ELSE 1 END
, 0
, CASE WHEN product_code LIKE 'learn%' THEN 0 ELSE 1 END
, UUID()
FROM _product, (select @rownum := 0) r;
DROP TEMPORARY TABLE IF EXISTS _product;

UPDATE product p
INNER JOIN application a ON substring(a.name, 1 ,5) = substring(p.name, 1 ,5)
SET p.application_id = a.id;

UPDATE product p
SET application_id = 5 WHERE name = 'advance';

/* learn sub-products */
INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT id + 100, code, name, name, (SELECT id FROM application WHERE name = 'learn')
, 2 /* single user */, 0, 1
, UUID()
from um_view.um_library;

INSERT product_relationship (parent_id, child_id, row_last_update_time)
SELECT (SELECT id FROM product WHERE name = 'learn-all'), id, curdate()
FROM product
WHERE default_license_model_id = 2 
AND must_include_all_subproducts = 0 
AND is_assignable_as_resource = 1
AND name NOT LIKE 'focus-observer%';

/********************************************/
/* roles */
/********************************************/

CREATE TEMPORARY TABLE IF NOT EXISTS _role AS 
(
	SELECT distinct name 
	FROM um_view.um_group
	WHERE type = 'RoleGroup'
	ORDER BY name
);
INSERT role (id, name, label, parent_party_type_id, child_party_type_id, description, external_key)
SELECT @rownum := @rownum + 1 as id, name, name, 2 /* org */, 3 /* user */, '', UUID()
FROM _role, (select @rownum := 0) r;
DROP TEMPORARY TABLE IF EXISTS _role;

INSERT role (id, name, label, parent_party_type_id, child_party_type_id, description, external_key)
SELECT MAX(id) + 1, 'Focus Super Administrator', 'Focus Super Administrator', 2 /* org */, 3 /* user */, 'Focus Super Administrator', UUID()
FROM role;

INSERT role (id, name, label, parent_party_type_id, child_party_type_id, description, external_key)  
SELECT MAX(id) + 1, 'administering_organization', 'Administering', 2 /* org */, 2 /* org */, 'The parent organization administers the child organization', UUID()
FROM role;

INSERT role (id, name, label, parent_party_type_id, child_party_type_id, description, external_key)  
SELECT MAX(id) + 1, 'managing', 'Manager', 3 /* user */, 3 /* user */, 'The parent user manages the child user', UUID()
FROM role;

/********************************************/
/* resources */
/********************************************/
INSERT resource (id, product_id, name, label, description, resource_type_id, external_key)
SELECT id, id, name, label, description, CASE WHEN name LIKE '%-all%' THEN 1 ELSE 2 END, UUID()
FROM product;

/* role resource permissions */

/* focus resources */
INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT MAX(id) + 1, 'focus_asessment_module', 'Focus Asessment Module', 'Focus Asessment Module'
, (SELECT id FROM application WHERE name = 'focus'), 2 /* single user */, 0, 1, UUID()
FROM product;

INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT MAX(id) + 1, 'focus_scoring_sheet', 'Focus Scoring Sheet', 'Focus Scoring Sheet'
, (SELECT id FROM application WHERE name = 'focus'), 2 /* single user */, 0, 1, UUID()
FROM product;

/* reflect resources */
INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT MAX(id) + 1, 'reflect_evaluation_template', 'Reflect Evaluation Template', 'Reflect Evaluation Template'
, (SELECT id FROM application WHERE name = 'reflect'), 1 /* per seat */, 0, 1, UUID()
FROM product;

INSERT product (id, name, label, description, application_id, default_license_model_id
, must_include_all_subproducts, is_assignable_as_resource, external_key )
SELECT MAX(id) + 1, 'reflect_survey', 'Reflect Survey', 'Reflect Survey'
, (SELECT id FROM application WHERE name = 'reflect'), 1 /* per seat */, 0, 1, UUID()
FROM product;


INSERT resource (id, product_id, name, label, description, resource_type_id, external_key)
SELECT id, id, name, label, description, 2, UUID()
FROM product WHERE name ='focus_asessment_module';

INSERT resource (id, product_id, name, label, description, resource_type_id, external_key)
SELECT id, id, name, label, description, 2, UUID()
FROM product WHERE name = 'focus_scoring_sheet';

INSERT resource (id, product_id, name, label, description, resource_type_id, external_key)
SELECT id, id, name, label, description, 2, UUID()
FROM product WHERE name = 'reflect_evaluation_template';

INSERT resource (id, product_id, name, label, description, resource_type_id, external_key)
SELECT id, id, name, label, description, 2, UUID()
FROM product WHERE name = 'reflect_survey';

/********************************************/
/* product resources */
/********************************************/
INSERT product_resource (product_id, resource_id)
SELECT id, id
FROM product
;

/********************************************/
/* admin resources
/********************************************/
ALTER TABLE tbl_resource AUTO_INCREMENT = 1;
INSERT resource (product_id, name, label, description, resource_type_id, external_key)
SELECT NULL, 'ums', 'User and Organization Administration', 'User and Organization Administration', 2, UUID()
;

/********************************************/
/* role resources
/********************************************/
DELETE FROM role_resource ;

INSERT role_resource (role_id, resource_id)
SELECT ro.id, r.id
FROM role ro, resource r
WHERE ro.name = 'Administrators' 
AND r.name = 'ums';
;

INSERT role_resource (role_id, resource_id)
SELECT ro.id, r.id
FROM role ro, resource r
WHERE ro.name = 'Focus Observers' 
AND r.name IN  ('focus_asessment_module', 'focus_scoring_sheet', 'focus-observer_training_2013', 'focus-scoring_practice_2013');

INSERT role_resource (role_id, resource_id)
SELECT ro.id, r.id
FROM role ro, resource r
WHERE ro.name = 'Focus Administrators' 
AND r.name LIKE  ('focus%') and r.name not like '%2011%' AND r.name not in ('focus-observer_training_2013', 'focus-scoring_practice_2013');


# Reflect Evaluators
INSERT role_resource (role_id, resource_id)
SELECT ro.id, r.id
FROM role ro, resource r
WHERE ro.name = 'Reflect Evaluators' 
AND r.name IN ('reflect_evaluation_template', 'reflect_survey');

INSERT role_resource (role_id, resource_id)
SELECT ro.id, r.id
FROM role ro, resource r
WHERE ro.name = 'Reflect Administrators' 
AND r.name LIKE  ('reflect%') and r.name not like '%2011%';


/********************************************/
/* Organizations */
/********************************************/
INSERT party (name, party_type_id, degenerate_id) 
SELECT o.name, 2 /* organization */, o.id
FROM um_view.um_organization o;

INSERT organization (id, party_id, name, organization_type_id, uses_new_platform, external_key) 
SELECT o.id, p.id, o.name, ot.id, o.migrated, UUID()
FROM um_view.um_organization o
JOIN party p ON p.degenerate_id = o.id AND p.party_type_id = 2
LEFT OUTER JOIN organization_type ot ON ot.label = o.type;

INSERT address (address_line1, address_line2, address_city, address_territory, address_postal_code, address_country, degenerate_organization_id, external_key)
SELECT SUBSTRING(address,1,100), SUBSTRING(address2,1,100), city, state, SUBSTRING(zipcode,1,10), country, o.id, UUID()
FROM um_view.um_organization o
;

INSERT party_address (party_id, address_id, address_type_id, is_primary)
SELECT p.id, a.id, 1 /* undeclared */, 1
FROM um_view.um_organization o
JOIN address a ON a.degenerate_organization_id = o.id
JOIN party p ON p.degenerate_id = o.id AND p.party_type_id = 2
;

/* Organization Relationships */
SELECT id INTO @administering_role_id FROM role WHERE name = 'administering_organization'; 
INSERT party_relationship (parent_id, child_id,  role_id, start_date)
SELECT p.id, c.id, @administering_role_id, curdate()
FROM um_view.um_organization o
JOIN party p ON p.degenerate_id = o.fk_parent_id AND p.party_type_id = 2
JOIN party c ON c.degenerate_id = o.id AND c.party_type_id = 2
WHERE o.fk_parent_id IS NOT NULL;

/* Organization applications */
INSERT party_application(party_id, application_id, external_id, customer_key, provisioning_name, site_name)
SELECT  (SELECT party_id FROM organization WHERE id = o.id), (select id from application where name = 'saba'),  external_id,  provisioning_customer_id, provisioning_customer_name, saba_site_name
FROM um_view.um_organization o
WHERE saba_site_name IS NOT NULL OR external_id IS NOT NULL OR provisioning_customer_id IS NOT NULL;

INSERT party_application(party_id, application_id, external_id, customer_key, provisioning_name, site_name)
SELECT  (SELECT party_id FROM organization WHERE id = o.id), (select id from application where name = 'salesforce'),  external_id, provisioning_customer_id, provisioning_customer_name, saba_site_name
FROM um_view.um_organization o
WHERE intacct_customer_number IS NOT NULL;

/* Individuals */ 
INSERT party (name, party_type_id, degenerate_id) 
SELECT p.username, 3 /* individual */, p.id
FROM um_view.um_person p;

INSERT INTO user_profile (id, party_id, username, job_code, job_name, position_code, hire_date, exit_date, is_active, title, user_email_address, external_key)
SELECT up.id, p.id, p.name, job_code, job_name, position_code, date_hire, date_exit, activated, title, email, UUID()
FROM um_view.um_person up
JOIN party p ON p.degenerate_id = up.id AND p.party_type_id = 3 /* user */;

INSERT INTO person (id, party_id, first_name, middle_name, last_name, person_email_address, external_key)
SELECT up.id, p.id, first_name, middle_name, last_name, email, UUID()
FROM um_view.um_person up
JOIN party p ON p.degenerate_id = up.id AND p.party_type_id = 3 /* user */;

/* People to Org relationships */
INSERT party_relationship (parent_id, child_id, start_date, end_date, role_id)
SELECT p.id, c.id, curdate(), NULL
, CASE WHEN po.role LIKE 'Focus Administrator%' THEN (SELECT id FROM role WHERE name = 'Focus Administrators')
	WHEN po.role IN ('Focus Observer', 'Focus Observers') THEN (SELECT id FROM role WHERE name = 'Focus Observers')
	WHEN po.role LIKE 'Reflect Evaluator%' THEN (SELECT id FROM role WHERE name = 'Reflect Evaluators')
	WHEN po.role LIKE 'Reflect Administrator%' THEN (SELECT id FROM role WHERE name = 'Reflect Administrators')
	WHEN po.role = 'Alternate Manager' THEN (SELECT id FROM role WHERE name = 'Alternate Managers')
	WHEN po.role = 'Video Channel Administrator' THEN (SELECT id FROM role WHERE name = 'Video Channel Administrators')
	WHEN po.role  IN ('Video Upload Administrator', 'Video Upload Administrators') THEN (SELECT id FROM role WHERE name = 'Video Upload Administrators')
 END 
FROM um_view.um_person_organization_role po
JOIN party p ON p.degenerate_id = po.fk_organization_id AND p.party_type_id = 2 /* org */
JOIN party c ON c.degenerate_id = po.fk_person_id AND c.party_type_id = 3 /* user */
WHERE  
(
	po.role LIKE 'Focus Administrator%'
	OR po.role IN ('Focus Observer', 'Focus Observers')
	OR po.role LIKE 'Reflect Evaluator%'
	OR po.role LIKE 'Reflect Administrator%'
	OR po.role = 'Alternate Manager'
	OR po.role = 'Video Channel Administrator'
	OR po.role  IN ('Video Upload Administrator', 'Video Upload Administrators')
) 
GROUP BY  po.fk_organization_id, po.fk_person_id
ORDER BY  po.fk_organization_id, po.fk_person_id;


# Disable removed accounts
UPDATE party_relationship 
SET start_date =  ADDDATE(curdate(), INTERVAL -3 MONTH), end_date = ADDDATE(curdate(), INTERVAL -1 MONTH)
WHERE parent_id = (SELECT id FROM party WHERE degenerate_id = 1151532 AND party_type_id = 2 /* org */);

INSERT organization_role (organization_id, role_id, start_date, end_date)
SELECT o.id, pr.role_id, MIN(start_date), NULL
FROM party_relationship pr
JOIN party p ON p.id = pr.parent_id AND p.party_type_id = 2 /* org */
JOIN party c ON c.id = pr.child_id AND c.party_type_id = 3 /* user */
JOIN organization o ON o.party_id = p.id
GROUP BY parent_id, role_id
;

/* Org Contacts */
INSERT organization_contact (organization_id, name, email_address, contact_phone, contact_sequence)
SELECT id, contact_name, contact_email, contact_phone, 1
FROM um_view.um_organization
WHERE contact_name IS NOT NULL;

/* User grade_range */
INSERT user_grade_range (user_id, grade_range_id, organization_id)
SELECT pg.userid, gr.id, 
(
	SELECT po.fk_organization_id 
	FROM um_view.um_person_organization_role po
	JOIN organization o ON o.id = po.fk_organization_id
	WHERE po.fk_person_id = pg.userid
	ORDER BY CASE WHEN po.role LIKE '%focus%' THEN 0 ELSE 1 END, po.role
	LIMIT 1
)
FROM um_view.view_persons_and_grades pg
JOIN grade_range gr ON gr.label = pg.name
WHERE EXISTS
(
	SELECT * 
	FROM um_view.um_person_organization_role po
	JOIN organization o ON o.id = po.fk_organization_id
	WHERE po.fk_person_id = pg.userid
)
;