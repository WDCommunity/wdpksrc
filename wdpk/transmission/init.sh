#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)
log=/tmp/debug_apkg

echo "INIT linking files from path: ${APKG_PATH}" >> $log

# add app to init.d
ln -sf ${APKG_PATH}/bootscript /opt/etc/init.d/S43Tautulli.sh

# create folder for the redirecting webpage
WEBPATH="/var/www/tautulli/"
mkdir -p $WEBPATH
ln -sf ${APKG_PATH}/web/* $WEBPATH

