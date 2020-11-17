#!/bin/sh

log=/tmp/debug_apkg

APKG_PATH=$1
. ${APKG_PATH}/env

# get first match for IP address
ADDRESS=$(sed -n '/ip/ {s/.*<ip>\(\S*\)<\/ip>/\1/p;q}' /etc/NAS_CFG/config.xml )

# disable creation of default folder
export STNODEFAULTFOLDER=0

# start the binary
${APKG_PATH}/syncthing/syncthing -no-browser -home=${ST_HOME} -gui-address="http://${ADDRESS}:${PORT}" 2>&1 >> $log

