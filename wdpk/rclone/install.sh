#!/bin/bash

[ -f /tmp/debug_apkg] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="rclone"
APKG_PATH="${path_dst}/${APKG_MODULE}"
APKG_CONFIG="${APKG_PATH}/env"
APKG_BACKUP_CONFIG="/shares/Volume_1/Nas_Prog/rclone.env"

# install all package scripts to the proper location
mv $path_src $path_dst

# setup secure http
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

cd $path_dst/rclone

# download the latest rclone installer
if [ "$(uname -m)" = "x86_64" ]; then
    PLF=amd64
else
    PLF=arm
fi

curl -O https://downloads.rclone.org/rclone-current-linux-${PLF}.zip
unzip rclone-current-linux-${PLF}.zip
chmod +x rclone-*-linux-${PLF}/rclone 

# remove the installer
rm rclone-current-linux-${PLF}.zip

# restore previous config
if [ -f "${APKG_BACKUP_CONFIG}" ]
then
   echo "Addon NZBget (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -f ${APKG_BACKUP_CONFIG}
fi
echo "Addon rclone (install.sh) done" >> $log

