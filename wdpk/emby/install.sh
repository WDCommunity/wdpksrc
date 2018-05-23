#!/bin/bash

[ -f /tmp/debug_apkg] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="emby"
APKG_PATH="${path_dst}/${APKG_MODULE}"

# install all package scripts to the proper location
cp -rf $path_src $path_dst

# download the latest Emby release from github
# unfortunately, the builtin wget is not able to check certificates
if [ "x86_64" = $(uname -m) ] ; then
   PLF="amd64"
else
   PLF="armhf"
fi

RELEASE_PATH="$(wget --no-check-certificate "https://github.com/MediaBrowser/Emby/releases/latest" -q -O- \
               | grep 'releases/download' | grep "server-deb_.*_$PLF" | cut -d'"' -f2)"
RELEASE="$(echo ${RELEASE_PATH} | cut -d'/' -f7)"
wget --no-check-certificate "https://github.com${RELEASE_PATH}" -P "${APKG_PATH}"

result=$?
echo "Download ${APKG_MODULE} RC: $result" >> $log
if [ result -ne 0 ]; then
    exit 1
fi

# unpack the .deb archive
cd ${APKG_PATH}
ar x ${RELEASE} 2>&1 >> $log

# unpack the binaries and libraries from data.tar.xz
/opt/bin/opkg install p7zip
7za x data.tar.xz && tar xf data.tar 2>&1 >> $log
rm data.tar*

# unpack the scripts from control.tar.gz
tar xf control.tar.gz
rm control.tar.gz

# adjust APP_DIR to APKG_DIR
mv opt/emby-server/* .
sed -i "s#APP_DIR=.*#APP_DIR=${APKG_DIR}#" bin/emby-server

# remove the archive
rm "${APKG_PATH}/${RELEASE}"

# setup config to Public dir
# TODO: restore config

echo "Addon Emby (install.sh) done" >> $log

