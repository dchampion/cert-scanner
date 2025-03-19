## To-Do

1. Get cert with vulnerable key added to CT logs to see if it will show up in daily scan.
    - Create vulnerable key
        - Done via crypto `api.rsa_w` module. Modified source code to enable creation of an RSA key `rsa_private_key.pem` with Fermat factorization vulnerability.
    - Register new domain
        - Registered `divaconhamdip.org` on squarespace ($12USD).
    - Generate CSR containing vulnerable key for new domain
        - Done via openssl (in recently&ndash;updated git bash): `openssl req -new -key rsa_private_key.pem -out rsa_key.csr`.
        - Transfer `rsa_key.csr` to EC2 instance framework-demo.
    - Send bad CSR to Let's Encrypt
        - Installed certbot on framework-demo and issued request to Let's Encrypt using certbot CLI: `sudo certbot certonly -v --csr rsa_key.csr --manual --preferred-challenges dns`.
        - Created DNS TXT record, as instructed by certbot, where name/host=`_acme-challenge.divaconhamdip.org` and value=`<nonce-generated-by-certbot-CLI>`. However, squarespace forbids creating subdomains with leading underscores. <b>This is a stowstopper, so I am punting squarespace</b>.
    - Issued domain transfer request to squarespace
        - Got confirmation email with auth-code.
        - Cancelled auto-renew domain.
    - Transfer domain to AWS route 53
        - Tried transferring `divaconhamdip.org` from squarespace to route 53. There is a 60-day waiting period to do this, presumably to discourage fraud.
    - Register new domain
        - Registered `divaconhamdip.net` on route 53 ($11USD).
    - Generate bad CSR for new domain
        - Done via openssl: `openssl req -new -key rsa_key_fermat_vuln.pem -out rsa_key_fermat_vuln.csr -reqexts v3_req -config san_config.cnf`. The `san_config.cnf` file (in the root of the crypto repo) contains the SANs `divaconhamdip.net` and `*.divaconhamdip.net`.
    - Send bad CSR to Let's Encrypt
        - Created DNS TXT record according to certbot instructions in route 53.
        - Certbot complains that the exponent (3) is too small (Yay! Progress!)
        - Generated several CSRs, using keys with other known vulnerabilities, starting with fermat factorization vulnerability (but also weak Debian keys, including SSH variants).
        - Certbot stops all of them in their tracks. So, at least it appears Let's Encrypt is doing the right thing.
    - Giving up at this point, since the only point of this exercise is to test the efficacy of the daily scan; i.e., will it catch a vulnerable key contained in a cert logged in CT?

2. Dig in to public&ndash;key reuse
    - crt.sh forum post from Matthew McPherrin indicates pycon.org, mlauren.com and ndnminh.com&mdash;all of which share the same public key&mdash;are all hosted by the same provider: https://pages.github.com. However, https://lookup.icann.org reports different registrars for each of these domains. What makes him think this?
        - All these certs were issued/signed by Let's Encrypt (LE).
        - It is highly doubtful these certs originated as CSRs; rather, they were in all likelihood generated automatically by LE.
        - If the last statement is correct, then it is LE who are reusing public keys, not the web hosts (why would the webhosts bother with generating CSRs when LE automates the whole process anyway?).
    - Obtain a certificate from LE _without_ supplying a CSR
        - Requested a cert from LE for `www.divaconhamdip.net` (hoted by route 53 on AWS) with the following command: `sudo certbot certonly -v -d www.divaconhamdip.net --manual --preferred-challenges dns`.
        - Added the TXT record and got the cert (the certbot output indicates this cert will not be updated automatically in 90 days).
        - The cert was saved at `/etc/letsencrypt/live/www.divaconhamdip.net/fullchain.pem`, and private key at `/etc/letsencrypt/live/www.divaconhamdip.net/privkey.pem`, on framework-demo.
        - The cert contains an ECDSA, not an RSA key. There is no apparent duplication.
        - Try certbot again, but this time specify that the key be RSA: `sudo certbot certonly -v -d www.divaconhamdip.net --manual --preferred-challenges dns --key-type RSA`.
    