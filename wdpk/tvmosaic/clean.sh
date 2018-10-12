#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APP=tvmosaic
WEBPATH="/var/www/$APP"

# remove lib

# remove web
rm -rf $WEBPATH
