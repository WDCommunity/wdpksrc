#!/bin/sh
DEBUG_FILE=/dev/null
[ -f /tmp/debug_apkg ] && DEBUG_FILE=/tmp/debug/apkg echo "APKG_DEBUG: $0 $@" >> $DEBUG_FILE

INSTALL_DIR=$(readlink -f $1)
NAS_PROG=$(readlink -f $2)

# install all package scripts to the proper location
cp -rfv ${INSTALL_DIR} ${NAS_PROG} &2>&1 >> $DEBUG_FILE

/opt/bin/opkg install zerotier &2>&1 >> $DEBUG_FILE
