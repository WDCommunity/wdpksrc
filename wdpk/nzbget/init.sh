#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$(readlink -f $1)
log=/tmp/nzbget.log

echo "INIT linking files from path: $path" >> $log

# create link to binary
ln -sf $path/nzbget /usr/bin/nzbget

# create folder for the webpage
WEBPATH="/var/www/nzbget/"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH

