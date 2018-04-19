#!/bin/bash

[ -f /tmp/debug_apkg] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="nzbget"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/nzbget.conf"
APKG_BACKUP_CONFIG="/mnt/HD/HD_a2/.systemfile/nzbget.conf"

# create backup of nzbget configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $path_dst

# download the latest nzbget installer
wget -O - http://nzbget.net/info/nzbget-version-linux.json | \
  sed -n "s/^.*stable-download.*: \"\(.*\)\".*/\1/p" | \
  wget --no-check-certificate -i - -O ${path_dst}/nzbget-latest-bin-linux.run

result=$?
echo "Downloading nzbget RC: $result" >> $log

# make the installer executable and run it
cd $path_dst
chmod +x ./nzbget-latest-bin-linux.run
./nzbget-latest-bin-linux.run

result=$?
echo "Install RC: $result" >> $log

# remove the installer
rm ${path_dst}/nzbget-latest-bin-linux.run

# restore previous config
if [ -f /mnt/HD/HD_a2/.systemfile/nzbget.conf ]
then
   echo "Addon NZBget (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -f ${APKG_BACKUP_CONFIG}
else
   # setup default MainDir
   sed -i "s|^MainDir=.*|MainDir=/shares/Public/nzbget|" ${APKG_CONFIG}
   #sed -i "s|^DaemonUsername=.*|DaemonUsername=1001|" ${APKG_CONFIG}
   sed -i "s|^UMask=1000|UMask=000|" ${APKG_CONFIG}
fi
echo "Addon NZBget (install.sh) done" >> $log

