#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

WEBPATH="/var/www/medusa"

# remove bootscript
rm -f /opt/etc/init.d/S91Medusa

# remove lib

# remove web
rm -rf $WEBPATH
