#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1
log=/tmp/couchpotato.log

echo "INIT linking files from path: $path" >> $log

# create link to binary 
cp $path/bootscript /opt/etc/init.d/S90CouchPotato

# create folder for the webpage
WEBPATH="/var/www/couchpotato/"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH

