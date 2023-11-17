-- prefix to "WHERE ID BETWEEN $start AND $end"
WITH no_dups AS (
    SELECT min(ID) ID,
           x509_publicKey(CERTIFICATE) PUBKEY
      FROM certificate
