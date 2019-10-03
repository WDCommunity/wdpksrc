#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

[ -n "$(pidof syncthing)" ] && pkill syncthing

APKG_PATH=$(readlink -f $1)
. ${APKG_PATH}/env

# remove app
rm -rf ${APKG_PATH}

# remove web
rm -rf /var/www/${APKG_NAME}
