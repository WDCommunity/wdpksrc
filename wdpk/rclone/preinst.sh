#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$1

APKG_MODULE="rclone"
APKG_BACKUP_PATH=${APKG_PATH}/../${APKG_MODULE}_backup


# backup config files and user settings
if [ ! -d ${APKG_BACKUP_PATH}] ; then
    # move config to backup path
    mkdir -p ${APKG_BACKUP_PATH}
    mv -f ${APKG_PATH}/rclone.config ${APKG_BACKUP_PATH}
fi
