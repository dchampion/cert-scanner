-- This is an example for testing that combines the contents of pre_range.sql and post_range.sql with fixed ID values.
WITH no_dups AS (
    SELECT min(ID) ID,
           x509_tbscert_strip_ct_ext(CERTIFICATE) STRIPPED_CERT,
           x509_serialNumber(CERTIFICATE) SERIAL,
           ISSUER_CA_ID
      FROM certificate
     WHERE ID BETWEEN 11042438000 AND 11042438999
  GROUP BY STRIPPED_CERT, SERIAL, ISSUER_CA_ID
     )
    SELECT regexp_replace(encode(CERTIFICATE, 'base64'), E'\\n', '', 'g'),
           ID 
      FROM certificate 
     WHERE ID IN (SELECT ID FROM no_dups)