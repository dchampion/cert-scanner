# cert-scanner
Tests cryptographic keys embedded in public&ndash;key certificates for known vulnerabilities. All certificates issued by [Certificate Authorities](https://en.wikipedia.org/wiki/Certificate_authority) (CAs) that participate in the [Certificate Transparency](https://en.wikipedia.org/wiki/Certificate_Transparency) (CT) program are tested against [Sectigo](https://www.sectigo.com/)'s CT log using its [crt.sh](https://crt.sh) API. The tests run daily on an EC2 instance in the AWS free tier.

## Summary

The scripts in this project were provided to me by [Hanno Bock](https://hboeck.de/en/), and are designed to work  with [a tool](https://github.com/badkeys/badkeys) he developed to test public keys for known vulnerabilities.

I have adapted the scripts as follows:

## Storage Optimization
So as not to exceed free&ndash;tier storage limits, runtime and certificate logs are confined to the most recent 10 log units (i.e., log files and/or the directories containing them). All units older than this are permanently deleted on a daily basis.

There is one exception to this rule, and that is for the vulnerability logs (i.e., those reporting keys with vulnerabilities). These are kept in perpetuity, and must be deleted manaully from time to time.

## Compute Optimization
There is a one&ndash;to&ndash;many relationship between public keys and the certificates that contain them. There are various reasons for this. Perhaps the most prevalent is the practice by CAs of issuing pre&ndash;certificates before their corresponding leaf certificates (according to the canonical [CT use case](https://certificate.transparency.dev/howctworks/)).

Another reason is the practice by some hosting companies of reusing public keys across the certificates of multiple domains they host.

Additionally, the wider the range of rows fetched in the query, the greater the proportion of duplicate keys in the row set (about 10-15% of the records in a row set containing 10000 consecutive crt.sh IDs contain duplicate keys).

I have optimized the [query](https://github.com/dchampion/cert-scanner/blob/main/sql/get_range_no_dups.sql) to account for these facts.

# Update as of July 31, 2024
On August 1, 2024, this project was shut down for cost reasons (specifically, the one&ndash;year time period on the AWS free&ndash;tier account under which it ran expired).

In the year during which this project was active, it failed to identify a single public key containing a cryptographic vulnerabilty. During that time, nearly 4-billion public key certificates were signed and issued by Certificate Authorities, every one of which was tested for vulnerabilities by this project.

This astonishing success rate is due likely to the CAs themselves testing publicly&ndash;submitted keys, and rejecting those that are vulnerable.