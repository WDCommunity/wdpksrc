#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKGDIR=$(readlink -f $1)
log=/tmp/debug_apkg

echo "INIT linking files from path: $APKGDIR" >> $log

# create link to binary

# create folder for the redirecting webpage
WEBPATH="/var/www/cops"
ln -sf $APKGDIR/web $WEBPATH >> $log 2>&1

