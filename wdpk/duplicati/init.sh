#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

echo "INIT linking files from path: $path" >> /tmp/debug_apkg

# create folder for the webpage
WEBPATH="/var/www/duplicati/"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH

