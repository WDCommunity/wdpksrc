#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NAS_PROG=$2

log=/tmp/debug_apkg

APKG_MODULE="medusa"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/settings.conf"
APKG_BACKUP="${NAS_PROG}/${APKG_MODULE}_backup"
APKG_BACKUP_CONFIG="${APKG_BACKUP}/settings.conf"

# create backup of medusa configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $NAS_PROG

echo "install requirements" >> $log
opkg install busybox git git-http python python-pyopenssl >> $log 2>&1

ORIG_DIR=$(pwd)
cd $APKG_PATH

echo "get the latest stable version from github" >> $log
git clone https://github.com/pymedusa/Medusa >> $log 2>&1

echo "update the bootscript to the local git repo" >> $log
sed -i "s|^PKG_DIR=.*|PKG_DIR=$APKG_PATH|" $APKG_PATH/bootscript 

# restore previous config
if [ -f $APKG_BACKUP_CONFIG ] ; then
   echo "Addon Medusa (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -rf ${APKG_BACKUP}
fi
echo "Addon Medusa (install.sh) done" >> $log

