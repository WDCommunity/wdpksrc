#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1
log=/tmp/debug_apkg

echo "INIT linking files from path: $path" >> $log

# create link to binary

# create folder for the redirecting webpage
WEBPATH="/var/www/cops"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH >> $log 2>&1

