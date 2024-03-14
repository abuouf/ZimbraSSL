#!/bin/bash

echo "backup old certificate"

cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/letsencrypt/privkey.pembk
cp /opt/zimbra/ssl/letsencrypt/cert.pem  /opt/zimbra/ssl/letsencrypt/cert.pembk
cp /opt/zimbra/ssl/letsencrypt/chain.pem /opt/zimbra/ssl/letsencrypt/chain.pembk
cp /opt/zimbra/ssl/letsencrypt/fullchain.pem  /opt/zimbra/ssl/letsencrypt/fullchain.pembk 
cp /opt/zimbra/ssl/zimbra/commercial/commercial.key /opt/zimbra/ssl/zimbra/commercial/commercial.keybk

echo " find the new certificate files"
cd /etc/letsencrypt/archive/email.goemail.ca/

privkey=$(find . -type f -name "priv*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)
cert=$(find . -type f -name "cert*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)
chain=$(find . -type f -name "chain*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)
full=$(find . -type f -name "full*" -printf "%T@ %p\n" | sort -n | tail -n 1 | cut -d' ' -f 2-)

echo "copy new certificate file to the ssl path"

cp /etc/letsencrypt/archive/email.goemail.ca/$privkey /opt/zimbra/ssl/letsencrypt/privkey.pem
cp /etc/letsencrypt/archive/email.goemail.ca/$cert /opt/zimbra/ssl/letsencrypt/cert.pem 
cp /etc/letsencrypt/archive/email.goemail.ca/$chain /opt/zimbra/ssl/letsencrypt/chain.pem
cp /etc/letsencrypt/archive/email.goemail.ca/$full /opt/zimbra/ssl/letsencrypt/fullchain.pem 
cp /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/zimbra/commercial/commercial.key


echo "add root to fullchain"

newfullchain="/opt/zimbra/ssl/letsencrypt/fullchain.pem"  

cat <<EOF > "$newfullchain"
$(echo "-----BEGIN CERTIFICATE-----
MIIFazCCA1OgAwIBAgIRAIIQz7DSQONZRGPgu2OCiwAwDQYJKoZIhvcNAQELBQAw
TzELMAkGA1UEBhMCVVMxKTAnBgNVBAoTIEludGVybmV0IFNlY3VyaXR5IFJlc2Vh
cmNoIEdyb3VwMRUwEwYDVQQDEwxJU1JHIFJvb3QgWDEwHhcNMTUwNjA0MTEwNDM4
WhcNMzUwNjA0MTEwNDM4WjBPMQswCQYDVQQGEwJVUzEpMCcGA1UEChMgSW50ZXJu
ZXQgU2VjdXJpdHkgUmVzZWFyY2ggR3JvdXAxFTATBgNVBAMTDElTUkcgUm9vdCBY
MTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBAK3oJHP0FDfzm54rVygc
h77ct984kIxuPOZXoHj3dcKi/vVqbvYATyjb3miGbESTtrFj/RQSa78f0uoxmyF+
0TM8ukj13Xnfs7j/EvEhmkvBioZxaUpmZmyPfjxwv60pIgbz5MDmgK7iS4+3mX6U
A5/TR5d8mUgjU+g4rk8Kb4Mu0UlXjIB0ttov0DiNewNwIRt18jA8+o+u3dpjq+sW
T8KOEUt+zwvo/7V3LvSye0rgTBIlDHCNAymg4VMk7BPZ7hm/ELNKjD+Jo2FR3qyH
B5T0Y3HsLuJvW5iB4YlcNHlsdu87kGJ55tukmi8mxdAQ4Q7e2RCOFvu396j3x+UC
B5iPNgiV5+I3lg02dZ77DnKxHZu8A/lJBdiB3QW0KtZB6awBdpUKD9jf1b0SHzUv
KBds0pjBqAlkd25HN7rOrFleaJ1/ctaJxQZBKT5ZPt0m9STJEadao0xAH0ahmbWn
OlFuhjuefXKnEgV4We0+UXgVCwOPjdAvBbI+e0ocS3MFEvzG6uBQE3xDk3SzynTn
jh8BCNAw1FtxNrQHusEwMFxIt4I7mKZ9YIqioymCzLq9gwQbooMDQaHWBfEbwrbw
qHyGO0aoSCqI3Haadr8faqU9GY/rOPNk3sgrDQoo//fb4hVC1CLQJ13hef4Y53CI
rU7m2Ys6xt0nUW7/vGT1M0NPAgMBAAGjQjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNV
HRMBAf8EBTADAQH/MB0GA1UdDgQWBBR5tFnme7bl5AFzgAiIyBpY9umbbjANBgkq
hkiG9w0BAQsFAAOCAgEAVR9YqbyyqFDQDLHYGmkgJykIrGF1XIpu+ILlaS/V9lZL
ubhzEFnTIZd+50xx+7LSYK05qAvqFyFWhfFQDlnrzuBZ6brJFe+GnY+EgPbk6ZGQ
3BebYhtF8GaV0nxvwuo77x/Py9auJ/GpsMiu/X1+mvoiBOv/2X/qkSsisRcOj/KK
NFtY2PwByVS5uCbMiogziUwthDyC3+6WVwW6LLv3xLfHTjuCvjHIInNzktHCgKQ5
ORAzI4JMPJ+GslWYHb4phowim57iaztXOoJwTdwJx4nLCgdNbOhdjsnvzqvHu7Ur
TkXWStAmzOVyyghqpZXjFaH3pO3JLF+l+/+sKAIuvtd7u+Nxe5AW0wdeRlN8NwdC
jNPElpzVmbUq4JUagEiuTDkHzsxHpFKVK7q4+63SM1N95R1NbdWhscdCb+ZAJzVc
oyi3B43njTOQ5yOf+1CceWxG1bQVs5ZufpsMljq4Ui0/1lvh+wjChP4kqKOJ2qxq
4RgqsahDYVvTH9w7jXbyLeiNdd8XM2w9U/t7y0Ff/9yi0GE44Za4rF2LN9d11TPA
mRGunUHBcnWEvgJBQl9nJEiU0Zsnvgc/ubhPgXRR4Xq37Z0j4r7g1SgEEzwxA57d
emyPxgcYxn/eR44/KJ4EBs+lVDR3veyJm+kXQ99b21/+jh5Xos1AnX5iItreGCc=
-----END CERTIFICATE-----") 
EOF

echo $CERTIFICATE >> /opt/zimbra/ssl/letsencrypt/fullchain.pem 

echo " change owner of certificate to zimbra"

cd /opt/zimbra/ssl/letsencrypt/
chown zimbra cert.pem
chown zimbra fullchain.pem
chown zimbra chain.pem
chown zimbra privkey.pem

echo " verify certificate"

sudo su - zimbra -c '/opt/zimbra/bin/zmcertmgr verifycrt comm /opt/zimbra/ssl/letsencrypt/privkey.pem /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/fullchain.pem'

echo " deploy certificate"

sudo su - zimbra -c '/opt/zimbra/bin/zmcertmgr deploycrt comm /opt/zimbra/ssl/letsencrypt/cert.pem /opt/zimbra/ssl/letsencrypt/fullchain.pem'

echo "restart zimbra server"

sudo su - zimbra -c 'zmcontrol restart'
