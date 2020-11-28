#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1
log=/tmp/rclone.log

echo "INIT linking files from path: $path" >> $log

# create link to binary
ln -sf $path/rclone-*-linux-*/rclone /usr/bin/rclone

# create folder for the webpage
WEBPATH="/var/www/rclone/"
mkdir -p $WEBPATH
ln -sf $path/web/* $WEBPATH

