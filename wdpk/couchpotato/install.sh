#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="couchpotato"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/couchpotato.conf"
APKG_BACKUP_CONFIG="/mnt/HD/HD_a2/.systemfile/couchpotato.conf"

# create backup of couchpotato configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $path_dst 

echo "install requirements" >> $log
opkg install busybox git git-http python python-pyopenssl >> $log 2>&1

ORIG_DIR=$(pwd)
cd $APKG_PATH

echo "get the latest stable version from github" >> $log
git clone git://github.com/couchpotato/CouchPotatoServer >> $log 2>&1

echo "update the bootscript to the local git repo" >> $log
sed -i "s|^CP_ROOTDIR=.*|CP_ROOTDIR=$APKG_PATH|" $APKG_PATH/bootscript 

# restore previous config
if [ -f $APKG_BACKUP_CONFIG ]
then
   echo "Addon NZBget (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -f ${APKG_BACKUP_CONFIG}
else
   echo "Setup default MainDir" >> $log
   sed -i "s|^MainDir=.*|MainDir=/shares/Public/CouchPotato|" ${APKG_CONFIG}
   sed -i "s|^DaemonUsername=.*|DaemonUsername=1001|" ${APKG_CONFIG}
   sed -i "s|^UMask=1000|Umake=000|" ${APKG_CONFIG}
fi
echo "Addon CouchPotato (install.sh) done" >> $log

