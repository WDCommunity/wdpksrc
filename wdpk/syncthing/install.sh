#!/bin/sh

log=/tmp/debug_apkg

echo "APKG_DEBUG: $0 $@" >> $log

INSTALL_DIR=$(readlink -f $1)
. ${INSTALL_DIR}/env

NAS_PROG=$(readlink -f $2)

log=/tmp/debug_apkg

APKG_PATH="${NAS_PROG}/${APKG_NAME}"

echo "move package data" >> $log
mv ${INSTALL_DIR} ${NAS_PROG} 2>&1 >> $log

# setup secure downloads
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

PLATFORM=$(uname -m)
if [ "${PLATFORM}" = "x86_64" ]; then
	PLATFORM="amd64"
else
	PLATFORM="arm"
fi
VERSION="v1.3.0"

MAINDIR="syncthing-linux-${PLATFORM}-${VERSION}"
PACKAGE="${MAINDIR}.tar.gz"
URL="https://github.com/syncthing/syncthing/releases/download/${VERSION}/${PACKAGE}"

curl -L -s ${URL} | tar zx -C ${APKG_PATH} 2>&1 >> $log

[[ ! $? -eq 0 ]] && exit 2

# strip the version from the app dir
mv ${APKG_PATH}/${MAINDIR} ${APKG_PATH}/${APKG_NAME}

# create syncthing home dir
mkdir -p ${ST_HOME}

