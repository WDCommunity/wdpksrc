#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

echo "INIT linking files from path: $path" >> /tmp/debug_apkg

# setup links to mono
ln -sf /shares/Volume_1/Nas_Prog/mono /usr/local/mono

# ensure the certificates are up to date
/usr/local/mono/bin/cert-sync /etc/ssl/certs/ca-certificates.crt

# create folder for the webpage
WEBPATH="/var/www/duplicati/"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH

