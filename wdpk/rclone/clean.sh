#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

WEBPATH="/var/www/rclone"

# remove bin
rm -f /usr/bin/rclone

# remove lib

# remove web
rm -rf $WEBPATH
