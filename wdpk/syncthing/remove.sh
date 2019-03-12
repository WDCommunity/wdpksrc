#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)
. ${APKG_PATH}/env

rm -rf ${APKG_PATH}

# remove lib

# remove web
rm -rf /var/www/${APKG_NAME}
