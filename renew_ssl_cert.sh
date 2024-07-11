#!/bin/bash

#Abdallah Abuouf

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

cat ~/root.pem >> /opt/zimbra/ssl/letsencrypt/fullchain.pem 

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
