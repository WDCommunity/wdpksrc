#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$(readlink -f $1)
NAS_PROG=$(readlink -f $2)

log=/tmp/debug_apkg

APKG_MODULE="tautulli"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/config.ini"
APKG_CONFIG_BACKUP="/mnt/HD/HD_a2/.systemfile/${APKG_MODULE}.ini"
DATA_DIR="${APKG_PATH}/data"
DATA_DIR_BACKUP="/mnt/HD/HD_a2/.systemfile/${APKG_MODULE}_data/"  # note the trailing slash

# install all package scripts to the proper location
cp -rf ${INSTALL_DIR} ${NAS_PROG}

# setup secure downloads
curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
mv cacert.pem /etc/ssl/cert.pem

# install pip to get pkg_resources module
/opt/bin/opkg install python3-light python3-pip git git-http
[ ! $? -eq 0 ] && exit 2

# get the Tautulli source code
cd ${APKG_PATH}
/opt/bin/git clone https://github.com/Tautulli/Tautulli.git
[ ! $? -eq 0 ] && exit 3

# checkout current supported version. feel free to update afterwards.
cd Tautulli
/opt/bin/git checkout v2.6.1
cd ..

# restore config
if [ -f ${APKG_CONFIG_BACKUP} ]; then
  echo "Restore ${APKG_MODULE} config"
  cp ${APKG_CONFIG_BACKUP} ${APKG_CONFIG}
  cp -r ${DATA_DIR_BACKUP} ${DATA_DIR}
fi

echo "Addon ${APKG_MODULE} (install.sh) done" >> $log

