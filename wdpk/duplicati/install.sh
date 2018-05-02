#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NASPROG=$2

log=/tmp/debug_apkg

APKG_MODULE="duplicati"
APKG_PATH="${NASPROG}/${APKG_MODULE}"

# install all package scripts to the proper location
cp -rf $path_src $NASPROG

cd "${APKG_PATH}"

# ensure we have mono installed
MONO_DIR="${NASPROG}/mono"
MONO_LIB="${MONO_DIR}/lib"
MONO="${MONO_DIR}/bin/mono"
if [ ! -d "${MONO_DIR}/bin/mono"]; then
    ARCH="uname -r"
    
    # download the mono build based from the synocommunity project
    wget https://github.com/WDCommunity/wdpksrc/releases/tag/duplicati/mono-$ARCH-6.1_5.8.0.108-11.tar --no-check-certificate
    mkdir -p "${MONO_DIR}"
    tar xf mono*.tar -C "${MONO_DIR}"
    tar xf "${MONO_DIR}/package.tgz" -C "${MONO_DIR}"
    rm "${MONO_DIR}/package.tgz"
    rm mono*.tar
fi

# download the official duplicati package for synology
wget https://github.com/duplicati/duplicati/releases/download/v2.0.3.6-2.0.3.6_canary_2018-04-23/duplicati-2.0.3.6_canary_2018-04-23.spk --no-check-certificate

# extract the spk archive
mv duplicati*.spk duplicati.tar
tar xf duplicati.tar 
PACKAGE_DIR="${APKG_PATH}/package"
mkdir -p ${PACKAGE_DIR}
tar xf package.tgz -C "${PACKAGE_DIR}"
rm package.tgz

echo "Addon ${APKG_MODULE} (install.sh) done" >> $log

