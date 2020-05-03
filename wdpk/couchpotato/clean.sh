#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

WEBPATH="/var/www/couchpotato"

# remove lib

# remove web
rm -rf $WEBPATH
