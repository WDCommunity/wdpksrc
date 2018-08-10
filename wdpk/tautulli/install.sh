#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="tautulli"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/${APKG_MODULE}.conf"
APKG_BACKUP_CONFIG="/mnt/HD/HD_a2/.systemfile/{APKG_MODULE}.conf"

# create backup of nzbget configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $path_dst

# setup secure downloads
curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
mv cacert.pem /etc/ssl/cert.pem

# download the latest PlexPy package from github
wget https://github.com/Tautulli/Tautulli/archive/master.zip -P "${APKG_PATH}" 2>&1 >> $log

result=$?
echo "Download ${APKG_MODULE} RC: $result" >> $log

# unpack plexpy-master
unzip "${APKG_PATH}/master.zip" -d "${APKG_PATH}" 2>&1 >> $log

result=$?
echo "Unpack RC: $result" >> $log

# remove the archive
rm "${APKG_PATH}/master.zip"

# install pip to get pkg_resources module
wget https://bootstrap.pypa.io/get-pip.py
/opt/bin/opkg install python-light
/opt/bin/python get-pip.py
rm get-pip.py

echo "Addon Tautulli (install.sh) done" >> $log

