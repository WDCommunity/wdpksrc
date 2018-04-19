#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

rm -rf $path

# remove bin
rm -f /opt/etc/init.d/S90CouchPotato

# remove lib

# remove web
rm -rf /var/www/couchpotato
