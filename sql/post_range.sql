  GROUP BY STRIPPED_CERT, SERIAL, ISSUER_CA_ID
     )
    SELECT regexp_replace(encode(CERTIFICATE, 'base64'), E'\\n', '', 'g'),
           ID
      FROM certificate
     WHERE ID IN (SELECT ID FROM no_dups) order by 2
