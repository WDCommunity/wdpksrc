#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)

source ${APKG_PATH}/env

log=/tmp/debug_apkg

echo "INIT linking files from path: ${APKG_PATH}" >> $log

# create folder for the redirecting webpage
WEBPATH="/var/www/${APPNAME}/"
mkdir -p $WEBPATH
ln -sf ${APKG_PATH}/web/* $WEBPATH

