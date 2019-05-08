#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APP=cops
WEBPATH="/var/www/$APP"

# remove webdir symlink
rm $WEBPATH
