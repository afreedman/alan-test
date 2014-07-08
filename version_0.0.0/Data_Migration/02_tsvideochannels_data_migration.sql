USE db_000;

/* ------------------------------ */
/* METADATA */
/* ------------------------------ */

INSERT document_metadata (id, label, organization_id, document_metadata_type_id, external_key)
SELECT tag_id, tag_text, district_id
, CASE WHEN tc.tag_category_text = 'Grade' THEN 1 
	   WHEN tc.tag_category_text = 'Subject' THEN 2 
	   WHEN tc.tag_category_text = 'Keyword' THEN 3
	   WHEN tc.tag_category_text = 'Framework Component' THEN 4
	   WHEN tc.tag_category_text = 'School' THEN 5
	   WHEN tc.tag_category_text = 'Teacher' THEN 6
  END AS document_metadata_type_id
, UUID()
FROM tsvideochannels.tag t
JOIN tsvideochannels.tag_category tc ON tc.tag_category_id = t.tag_category_id
;


/* ------------------------------ */
/* CHANNELS */
/* ------------------------------ */
/* user */
INSERT document_channel (id, party_id, title, description, external_key)
SELECT c.channel_id,  u.party_id
, c.title, COALESCE(c.description, ct.type_text)
, UUID()
FROM tsvideochannels.channel c
JOIN tsvideochannels.channel_type ct ON ct.channel_type_id = c.channel_type_id
JOIN db_000.user_profile u ON u.id = c.user_id
WHERE  ct.type_text  IN ('User', 'Folder')
;


/* organization */
INSERT document_channel (id, party_id, title, description, external_key)
SELECT c.channel_id,  o.party_id
, c.title, c.description
, UUID()
FROM tsvideochannels.channel c
JOIN db_000.organization o ON o.id = c.district_id
WHERE c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'District')
;

/* Teachscape */
INSERT document_channel (id, party_id, title, description, external_key)
SELECT c.channel_id,  o.party_id
, c.title, COALESCE(c.description, c.title)
, UUID()
FROM tsvideochannels.channel c
JOIN db_000.organization o ON o.name = 'Teachscape' 
JOIN db_000.organization_type ot ON ot.id = o.organization_type_id AND ot.name = 'Teachscape'
WHERE c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'Teachscape')
;

/* ------------------------------ */
/* DOCUMENTS */
/* ------------------------------ */

/* videos */
INSERT document (is_primary, id, contributing_user_id
, contributing_user_organization_id, root_document_id, document_medium_id, title, description, contribution_date, publish_date, degenerate_video_id, degenerate_artifact_id, external_key)
SELECT 1, video_id, author_id
, COALESCE((SELECT o.id FROM db_000.party_relationship pr JOIN db_000.organization o ON o.id = pr.parent_id WHERE pr.child_id = v.author_id LIMIT 1), 39)
, video_id, 1, title, description, COALESCE(create_date, publish_date, '2001-01-01'), publish_date, video_id, NULL, UUID()
FROM tsvideochannels.video v
;


/* artifacts */
INSERT document (is_primary, contributing_user_id
, contributing_user_organization_id
, root_document_id, document_medium_id, title, description, contribution_date, publish_date, degenerate_video_id, degenerate_artifact_id, external_key)
SELECT 0, a.author_id
, COALESCE((SELECT o.id FROM db_000.party_relationship pr JOIN db_000.organization o ON o.id = pr.parent_id WHERE pr.child_id = a.author_id LIMIT 1),39)
, va.video_id, 1, a.title, a.description, a.create_date, a.create_date, NULL, a.artifact_id, UUID()
FROM tsvideochannels.artifact a
JOIN tsvideochannels.video_has_artifact va ON va.artifact_id = a.artifact_id
;

INSERT document_relationship (parent_id, child_id, child_degenerate_artifact_id, document_relationship_type_id)
SELECT DISTINCT va.video_id, d.id, va.artifact_id, t.id 
FROM tsvideochannels.artifact a
JOIN tsvideochannels.video_has_artifact va ON va.artifact_id = a.artifact_id
JOIN document d ON d.degenerate_artifact_id = a.artifact_id
JOIN document_relationship_type t ON t.label = a.artifact_type
;


/* document- clips */
INSERT document_relationship (parent_id, child_id, child_degenerate_artifact_id, document_relationship_type_id)
SELECT DISTINCT clip_original_video_id, video_id, NULL, 6 /* clip */
FROM tsvideochannels.video
WHERE clip = 1
;

/* ------------------------------ */
/* DOCUMENT METADATA */
/* ------------------------------ */
INSERT document_metadata_relationship (document_id, document_metadata_id)
SELECT video_id, tag_tag_id
FROM tsvideochannels.video_has_tag 
;

/* ------------------------------ */
/* DOCUMENT COMMENTS */
/* ------------------------------ */
INSERT document_comment (id, document_id, user_id,  user_organization_id, comment_text, timestamp_in_milliseconds, comment_date)
SELECT c.comment_id, c.video_id, c.author_id
, (SELECT o.id FROM db_000.party_relationship pr JOIN db_000.organization o ON o.id = pr.parent_id WHERE pr.child_id = c.author_id LIMIT 1)
, c.comment_text, c.timestamp_in_milliseconds, coalesce(c.create_date, updated_date, now())
FROM tsvideochannels.comment c
JOIN db_000.user_profile u ON u.id = c.author_id # CHECK ORG?
;

/* ------------------------------ */
/* DOCUMENT AGGREGATE */
/* ------------------------------ */
INSERT document_aggregate (document_id, Number_of_views, Number_of_favorites)
SELECT video_id, views, favorites FROM tsvideochannels.video
;

/* ------------------------------ */
/* DOCUMENT PARTY RELATIONSHIPS   */
/* ------------------------------ */

/* document-user contributions */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT v.video_id, u.party_id, 1 /* contributor */, NULL
FROM tsvideochannels.video v
JOIN db_000.user_profile u ON u.id = v.updater_id
;

/* document-user shares */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT vs.video_id, u.party_id, 2 /*share */, NULL
FROM tsvideochannels.video_has_share vs
JOIN db_000.user_profile u ON u.id = vs.user_id
;

/* document-user favorites */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT cv.video_id, u.party_id, 3 /* favorite */, NULL
FROM tsvideochannels.channel_has_video cv
JOIN tsvideochannels.channel c ON c.channel_id = cv.channel_id AND c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'Favorites')
JOIN db_000.user_profile u ON u.id = c.user_id
;

/* document-user channels*/
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT cv.video_id, u.party_id, 4 /* channel */, c.channel_id
FROM tsvideochannels.channel_has_video cv
JOIN tsvideochannels.channel c ON c.channel_id = cv.channel_id AND c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'Folder')
JOIN db_000.user_profile u ON u.id = c.user_id
;

/* document-user */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT cv.video_id,  u.party_id, 5 /* TBD */, NULL
FROM tsvideochannels.channel_has_video cv
JOIN tsvideochannels.channel c ON c.channel_id = cv.channel_id AND c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'User')
JOIN db_000.user_profile u ON u.id = c.user_id
;

/* document-district channels */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT cv.video_id, o.party_id, 4 /* channel */, c.channel_id
FROM tsvideochannels.channel_has_video cv
JOIN tsvideochannels.channel c ON c.channel_id = cv.channel_id AND c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'District')
JOIN db_000.organization o ON o.id = c.district_id
;

/* document-district shares*/
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT vs.video_id, o.party_id, 2 /*share */, NULL
FROM tsvideochannels.video_organization_share vs
JOIN db_000.organization o ON o.id = vs.organization_id
;

/* teachscape documents */
INSERT document_party_relationship (document_id, party_id, relationship_type_id, document_channel_id)
SELECT 	DISTINCT cv.video_id, o.party_id, 4 /* channel */, NULL
FROM tsvideochannels.channel_has_video cv
JOIN tsvideochannels.channel c ON c.channel_id = cv.channel_id AND c.channel_type_id = (SELECT channel_type_id FROM tsvideochannels.channel_type WHERE type_text = 'Teachscape')
JOIN db_000.organization o ON o.name = 'Teachscape' 
JOIN db_000.organization_type ot ON ot.id = o.organization_type_id AND ot.name = 'Teachscape'
;

