#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$(readlink -f $1)
NAS_PROG=$(readlink -f $2)

source ${INSTALL_DIR}/env

PKG_PATH="${NAS_PROG}/${PKG_NAME}"
#PKG_CONFIG="${PKG_PATH}/config.ini"
#PKG_CONFIG_BACKUP="/mnt/HD/HD_a2/.systemfile/${PKG_NAME}.ini"
#DATA_DIR="${PKG_PATH}/data"
#DATA_DIR_BACKUP="/mnt/HD/HD_a2/.systemfile/${PKG_NAME}_data/"  # note the trailing slash

# install all package scripts to the proper location
cp -rf ${INSTALL_DIR} ${NAS_PROG}

# setup secure downloads
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

# install transmission from entware
/opt/bin/opkg install transmission-daemon
[ ! $? -eq 0 ] && exit 2

# restore config
if [ -f ${PKG_CONFIG_BACKUP} ]; then
  echo "Restore ${PKG_MODULE} config"
  cp ${PKG_CONFIG_BACKUP} ${PKG_CONFIG}
  cp -r ${DATA_DIR_BACKUP} ${DATA_DIR}
fi

echo "Addon ${PKG_MODULE} (install.sh) done" >> $log

