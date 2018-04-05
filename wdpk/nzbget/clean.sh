#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

WEBPATH="/var/www/nzbget"

# remove bin
rm -f /usr/bin/nzbget

# remove lib

# remove web
rm -rf $WEBPATH
