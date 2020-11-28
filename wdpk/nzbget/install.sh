#!/bin/bash

[ -f /tmp/debug_apkg] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="nzbget"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/nzbget.conf"
APKG_BACKUP_DIR="${path_dst}/${APKG_MODULE}_backup"
APKG_BACKUP_CONFIG="${APKG_BACKUP_DIR}/nzbget.conf"

# install all package scripts to the proper location
mv $path_src $path_dst

# setup secure http
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

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
if [ -d ${APKG_BACKUP_DIR} ]
then
   echo "Addon ${APKG_MODULE} (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -rf ${APKG_BACKUP_DIR}
else
   # setup default MainDir
   sed -i "s|^MainDir=.*|MainDir=/shares/Public/nzbget|" ${APKG_CONFIG}
   #sed -i "s|^DaemonUsername=.*|DaemonUsername=1001|" ${APKG_CONFIG}
   sed -i "s|^UMask=1000|UMask=000|" ${APKG_CONFIG}
fi
echo "Addon NZBget (install.sh) done" >> $log

