-- prefix to "WHERE ID BETWEEN $start AND $end"
WITH no_dups AS (
    SELECT min(ID) ID,
           x509_tbscert_strip_ct_ext(CERTIFICATE) STRIPPED_CERT,
           x509_serialNumber(CERTIFICATE) SERIAL,
           ISSUER_CA_ID
      FROM certificate
