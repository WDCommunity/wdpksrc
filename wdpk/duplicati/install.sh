#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NASPROG=$2

log=/tmp/debug_apkg

APKG_MODULE="duplicati"
APKG_PATH="${NASPROG}/${APKG_MODULE}"
DUPLICATI_HOME="${NASPROG}/duplicati_conf"

# install all package scripts to the proper location
cp -rf $path_src $NASPROG

cd "${APKG_PATH}"

# setup secure downloads
if [ ! -f /etc/ssl/cert.pem ]; then
	curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
	mv cacert.pem /etc/ssl/cert.pem
fi

# ensure we have mono installed
MONO_DIR="${NASPROG}/mono"
MONO_LIB="${MONO_DIR}/lib"
MONO="${MONO_DIR}/bin/mono"

if [ ! -d "${MONO_DIR}" ]; then
    ARCH="$(uname -m)"
    echo "Download the mono $ARCH build based on the synocommunity project" >> $log
    wget "https://github.com/WDCommunity/wdpksrc/releases/download/duplicati/mono-${ARCH}-6.1_5.8.0.108-11.tar" -O mono.tar
#    wget https://usdl.synology.com/download/Package/spk/Mono/4.6.2-0096/Mono-$ARCH-4.6.2-0096.spk -O mono.tar
    [[ "$?" -ne 0 ]] && exit 1
    mkdir -p "${MONO_DIR}"
    tar xf mono.tar -C "${MONO_DIR}" >> $log
    tar xf "${MONO_DIR}/package.tgz" -C "${MONO_DIR}" >> $log
    rm "${MONO_DIR}/package.tgz"
    rm mono.tar
else
    echo "Mono dir already exists" >> $log
fi

echo "Download the official duplicati package for synology" >> $log
wget https://github.com/duplicati/duplicati/releases/download/v2.0.4.10-2.0.4.10_canary_2018-12-29/duplicati-2.0.4.10_canary_2018-12-29.spk

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

