#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)
. ${APKG_PATH}/env

LOG=/tmp/${APKG_NAME}.log

echo "INIT linking files from path: ${APKG_PATH}" >> $LOG

# create directory for the webpage TODO FIX ME
WEBDIR="/var/www/${APKG_NAME}/"
mkdir -p ${WEBDIR}
ln -sf ${APKG_PATH}/web/* ${WEBDIR}

