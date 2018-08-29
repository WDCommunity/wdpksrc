#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$1

rm -rf ${APKG_PATH}

# keep config
APKG_MODULE="tautulli"
APKG_CONFIG="${APKG_PATH}/config.ini"
APKG_CONFIG_BACKUP="/mnt/HD/HD_a2/.systemfile/{APKG_MODULE}.ini"
DATA_DIR="${APKG_PATH}/data"
DATA_DIR_BACKUP="/mnt/HD/HD_a2/.systemfile/{APKG_MODULE}_data"

cp ${APKG_CONFIG} ${APKG_CONFIG_BACKUP}
cp -r ${DATA_DIR} ${DATA_DIR_BACKUP}

# remove bin

# remove lib

# remove web
rm -rf /var/www/tautulli
