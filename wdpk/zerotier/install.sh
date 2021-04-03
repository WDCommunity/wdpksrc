#!/bin/sh
[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$(readlink -f $1)
NAS_PROG=$(readlink -f $2)

# install all package scripts to the proper location
cp -rf ${INSTALL_DIR} ${NAS_PROG}

/opt/bin/opkg install zerotier
