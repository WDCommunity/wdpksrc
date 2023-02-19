#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

NAS_PROG="/shares/Volume_1/Nas_Prog"

APKG_MODULE="syncthing"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"
APKG_BACKUP_PATH="${NAS_PROG}/${APKG_MODULE}_backup"
APKG_CONFIG="${APKG_PATH}/settings.conf"

# backup config files and user settings
if [ -f $APKG_CONFIG ] ; then
    # copy config to /tmp
    mkdir -p ${APKG_BACKUP_PATH}
    mv -f ${APKG_CONFIG} ${APKG_BACKUP_PATH}
fi
