#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)
. ${APKG_PATH}/env

WEBPATH="/var/www/${APKG_NAME}"

# remove lib

# remove web
rm -rf $WEBPATH
