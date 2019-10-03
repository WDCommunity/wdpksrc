#!/bin/sh

log=/tmp/debug_apkg

APKG_PATH=$1
. ${APKG_PATH}/env

ADDRESS=$(grep -m1 'Require ip' /usr/local/apache2/conf/httpd.conf | awk '{print $NF}' | cut -d/ -f1)

# disable creation of default folder
export STNODEFAULTFOLDER=0

# start the binary
${APKG_PATH}/syncthing/syncthing -no-browser -home=${ST_HOME} -gui-address="http://${ADDRESS}:${PORT}" 2>&1 >> $log

