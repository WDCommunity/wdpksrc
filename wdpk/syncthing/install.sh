#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$(readlink -f $1)
. ${INSTALL_DIR}/env

NAS_PROG=$(readlink -f $2)

log=/tmp/debug_apkg

APKG_PATH="${NAS_PROG}/${APKG_NAME}"

# move package data
mv ${INSTALL_DIR} ${NAS_PROG}

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
VERSION="v1.1.0"

MAINDIR="syncthing-linux-${PLATFORM}-${VERSION}"
PACKAGE="${MAINDIR}.tar.gz"
URL="https://github.com/syncthing/syncthing/releases/download/${VERSION}/${PACKAGE}"

/usr/bin/wget ${URL}

[[ ! $? -eq 0 ]] && exit 1

tar xf ${PACKAGE} -C ${APKG_PATH}

[[ ! $? -eq 0 ]] && exit 2

rm ${PACKAGE}

mv ${APKG_PATH}/${MAINDIR} ${APKG_PATH}/${APKG_NAME}

# TODO: restore config
