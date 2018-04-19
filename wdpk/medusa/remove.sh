#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

rm -rf $path

# remove bootscript
rm -f /opt/etc/init.d/S91Medusa

# remove lib

# remove web
rm -rf /var/www/medusa
