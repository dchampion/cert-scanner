# cert-scanner
Scans [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency) logs for CA&ndash;signed certificates containing public keys with known cryptographic vulnerabilities (via [Sectigo](https://www.sectigo.com/)'s log monitoring tool [crt.sh](https://crt.sh)).

## Summary

The scripts in this repo were provided to me by [Hanno Bock](https://hboeck.de/en/), and are designed to work in concert with [a tool](https://github.com/badkeys/badkeys) he developed to test public keys for known vulnerabilities. They run daily on an EC2 instance in the AWS free tier.

I have adapted the scripts in various ways, as described in the following sections:

## Storage Optimization
So as not to exceed free&ndash;tier storage limits, runtime and certificate logs are confined to the most recent 10 log units (i.e., log files and/or the directories containing them). All units older than this are permanently deleted on a daily basis. There is one exception to this rule, and that is for the vulnerability logs (i.e., those reporting keys with vulnerabilities). These are kept in perpetuity, and must be deleted manaully from time to time.

## Compute Optimization
There is a one&ndash;to&ndash;many relationship between public keys and the certificates that contain them. This is due primarily to the issuance of pre&ndash;certificates preceding their corresponding leaf certificates (according to the canonical [CT use case](https://certificate.transparency.dev/howctworks/)). As a result, de&ndash;duplication logic was added to the query that fetches certs from [crt.sh](https://crt.sh), as all I am concerned with is public keys (not the certs containing them). Also, the wider the range of rows fetched in the query, the greater the proportion of duplicate keys present in the row set. The query was further optimized to account for this fact.