# cert-scanner
Scans [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency) (CT) logs for CA&ndash;signed certificates containing public keys with known cryptographic vulnerabilities (via [Sectigo](https://www.sectigo.com/)'s log monitoring tool [crt.sh](https://crt.sh)).

## Summary

The scripts in this repo were provided to me by [Hanno Bock](https://hboeck.de/en/), and are designed to work in concert with [a tool](https://github.com/badkeys/badkeys) he developed to test public keys for known vulnerabilities. They run daily on an EC2 instance in the AWS free tier.

I have adapted the scripts in various ways, as described in the following sections:

## Storage Optimization
So as not to exceed free&ndash;tier storage limits, runtime and certificate logs are confined to the most recent 10 log units (i.e., log files and/or the directories containing them). All units older than this are permanently deleted on a daily basis. There is one exception to this rule, and that is for the vulnerability logs (i.e., those reporting keys with vulnerabilities). These are kept in perpetuity, and must be deleted manaully from time to time.

## Compute Optimization
There is a one&ndash;to&ndash;many relationship between public keys and the certificates that contain them. There are various reasons for this. Perhaps the most prevalent is the practice by CAs of issuing pre&ndash;certificates before their corresponding leaf certificates (according to the canonical [CT use case](https://certificate.transparency.dev/howctworks/)). Another reason is the practice by some hosting companies of reusing public keys across the certificates of multiple domains they host.

Additionally, the wider the range of rows fetched in the query, the greater the proportion of duplicate keys in the row set (about 10-15% of the records in a row set containing 10000 consecutive crt.sh IDs contain duplicate keys).

I have optimized the [query](https://github.com/dchampion/cert-scanner/blob/main/sql/get_range_no_dups.sql) to account for these facts.