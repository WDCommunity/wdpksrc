#!/bin/sh

echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NASPROG=$2

log=/tmp/debug_apkg

APKG_MODULE="duplicati"
APKG_PATH="${NASPROG}/${APKG_MODULE}"
DUPLICATI_HOME="${NASPROG}/duplicati_conf"

# install all package scripts to the proper location
cp -rf $path_src $NASPROG

cd "${APKG_PATH}"

# ensure we have mono installed
MONO_DIR="${NASPROG}/mono"
MONO_LIB="${MONO_DIR}/lib"
MONO="${MONO_DIR}/bin/mono"

$MONO --version >> $log

# setup secure downloads
curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
mv cacert.pem /etc/ssl/cert.pem

echo "Download the official duplicati package for synology" >> $log
/usr/bin/wget https://github.com/duplicati/duplicati/releases/download/v2.0.4.10-2.0.4.10_canary_2018-12-29/duplicati-2.0.4.10_canary_2018-12-29.spk

# extract the spk archive
mv duplicati*.spk duplicati.tar
tar xf duplicati.tar 
PACKAGE_DIR="${APKG_PATH}/package"
mkdir -p ${PACKAGE_DIR}
tar xf package.tgz -C "${PACKAGE_DIR}" >> $log
rm package.tgz

# create config directory
if [ ! -d "${DUPLICATI_HOME}" ]; then
    mkdir -p ${DUPLICATI_HOME}
fi

echo "Addon ${APKG_MODULE} (install.sh) done" >> $log

