#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="medusa"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/settings.conf"
APKG_BACKUP_CONFIG="/mnt/HD/HD_a2/.systemfile/medusa.conf"

# create backup of medusa configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $path_dst 

echo "install requirements" >> $log
opkg install busybox git git-http python python-pyopenssl >> $log 2>&1

ORIG_DIR=$(pwd)
cd $APKG_PATH

echo "get the latest stable version from github" >> $log
git clone git://github.com/pymedusa/Medusa >> $log 2>&1

echo "update the bootscript to the local git repo" >> $log
sed -i "s|^PKG_DIR=.*|PKG_DIR=$APKG_PATH|" $APKG_PATH/bootscript 

# restore previous config
if [ -f $APKG_BACKUP_CONFIG ]
then
   echo "Addon Medusa (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -f ${APKG_BACKUP_CONFIG}
fi
echo "Addon Medusa (install.sh) done" >> $log

