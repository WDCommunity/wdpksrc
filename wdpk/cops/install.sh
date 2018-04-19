#!/bin/bash

[ -f /tmp/debug_apkg] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
path_dst=$2

log=/tmp/debug_apkg

APKG_MODULE="cops"
APKG_PATH="${path_dst}/${APKG_MODULE}"

# install all package scripts to the proper location
cp -rf $path_src $path_dst

# download the latest Calibre COPS release from github
# unfortunately, the builtin wget is not able to check certificates
RELEASE_PATH="$(wget --no-check-certificate "https://github.com/seblucas/cops/releases/latest" -q -O- | grep 'releases/download' | cut -d'"' -f2)"
RELEASE="$(echo ${RELEASE_PATH} | cut -d'/' -f7)"
wget --no-check-certificate "https://github.com${RELEASE_PATH}" -P "${APKG_PATH}"

result=$?
echo "Download ${APKG_MODULE} RC: $result" >> $log

# unpack
APKG_WEB="${APKG_PATH}/web"
mkdir -p "${APKG_WEB}"
unzip "${APKG_PATH}/${RELEASE}" -d "${APKG_WEB}"
result=$?
echo "Unpack RC: $result" >> $log

# remove the archive
rm "${APKG_PATH}/${RELEASE}"

# setup config to Public dir
APKG_CFG="${APKG_WEB}/config_local.php"
cp "${APKG_WEB}/config_local.php.example" "${APKG_CFG}"
sed -i "s#calibre_directory'] = '.*'#calibre_directory'] = '/shares/Public/'#" "${APKG_CFG}"

echo "Addon Calibre COPS (install.sh) done" >> $log

