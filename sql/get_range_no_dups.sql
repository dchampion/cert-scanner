-- This is an example for testing that combines the contents of pre_range.sql and post_range.sql.
-- Replace START_OF_ID_RANGE with the starting ID of the range, and END_OF_ID_RANGE
-- with the ending ID of the range, to define the range of rows to fetch.
WITH no_dups AS (
    SELECT min(ID) ID,
           x509_publicKey(CERTIFICATE) PUBKEY
      FROM certificate
     WHERE ID BETWEEN START_OF_ID_RANGE AND END_OF_ID_RANGE
  GROUP BY PUBKEY
     )
    SELECT regexp_replace(encode(CERTIFICATE, 'base64'), E'\\n', '', 'g'),
           ID 
      FROM certificate 
     WHERE ID IN (SELECT ID FROM no_dups)