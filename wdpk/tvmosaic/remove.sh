#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$1

# clean up
rm -rf ${APKG_PATH}

# remove bin

# remove lib

# remove web
rm -rf /var/www/tvmosaic
