-- suffix to "WHERE ID BETWEEN $start AND $end"
  GROUP BY PUBKEY
     )
    SELECT regexp_replace(encode(CERTIFICATE, 'base64'), E'\\n', '', 'g'),
           ID
      FROM certificate
     WHERE ID IN (SELECT ID FROM no_dups)
