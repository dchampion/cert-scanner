# cert-scanner
Scans [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency) (CT) logs for public keys with known cryptographic vulnerabilities (via [Sectigo](https://www.sectigo.com/)'s log monitoring tool [crt.sh](https://crt.sh)). These keys are contained in public&ndash;key certificates signed and issued by all Certificate Authorities (CAs) that participate in the CT program.

## Summary

The scripts in this repo were provided by [Hanno Bock](https://hboeck.de/en/), and adapted by me for efficiency (as described in this README). Hanno Bock is a German freelance journalist. He  writes primarily about climate and energy issues, but is also a highly respected IT security expert.

These scripts are designed to work in concert with [a tool](https://github.com/badkeys/badkeys) that tests public keys for known vulnerabilities. The scripts run daily on an EC2 instance in the AWS free tier.

# Update as of July 31, 2024
On August 1, 2024, this project will be shut down due to cost considerations (specifically, the one&ndash;year time period on the AWS free&ndash;tier account under which it runs will have expired).

# Adaptations

## Storage Optimization
So as not to exceed free&ndash;tier storage limits, runtime and certificate logs are confined to the most recent 10 log units (i.e., log files and/or the directories containing them). All units older than this are permanently deleted on a daily basis.

There is one exception to this rule, and that is for the vulnerability logs (i.e., those reporting keys with vulnerabilities). These are kept in perpetuity, and must be deleted manaully from time to time.

## Compute Optimization
There is a one&ndash;to&ndash;many relationship between public keys and the certificates that contain them. There are various reasons for this. Perhaps the most prevalent is the practice by CAs of issuing pre&ndash;certificates before their corresponding leaf certificates (according to the canonical [CT use case](https://certificate.transparency.dev/howctworks/)). Another reason is the practice by some hosting companies of reusing public keys across the certificates of multiple domains they host.

Additionally, the wider the range of rows fetched in the query, the greater the proportion of duplicate keys in the row set (about 10-15% of the records in a row set containing 10000 consecutive crt.sh IDs contain duplicate keys).

I have optimized the [query](https://github.com/dchampion/cert-scanner/blob/main/sql/get_range_no_dups.sql) to account for these facts.
