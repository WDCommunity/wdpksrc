#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APP=plexpy
WEBPATH="/var/www/$APP"

# remove bin
# it just uses python

# remove lib

# remove web
rm -rf $WEBPATH
