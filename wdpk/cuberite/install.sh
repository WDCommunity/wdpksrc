#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NAS_PROG=$2

log=/tmp/debug_apkg

APKG_NAME="cuberite"
APKG_PATH="${NAS_PROG}/${APKG_NAME}"
APKG_CONFIG="${APKG_PATH}/settings.conf"
APKG_BACKUP="${NAS_PROG}/${APKG_NAME}_backup"
APKG_BACKUP_CONFIG="${APKG_BACKUP}/settings.conf"

# create backup of medusa configuration
cp -f ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

# install all package scripts to the proper location
cp -rf $path_src $NAS_PROG

echo "install requirements" >> $log
opkg install patchelf >> $log 2>&1

# setup secure downloads
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

ORIG_DIR=$(pwd)
cd ${APKG_PATH}

echo "get the latest stable Cuberite version from the buildserver archive" >> $log
BUILDS="https://builds.cuberite.org/job/cuberite/job/master/job/linux-x64/job/release/lastSuccessfulBuild/artifact/cuberite"
TARBALL="Cuberite.tar.gz"
wget ${BUILDS}/${TARBALL}

[[ ! $? -eq 0 ]] && exit 1

echo "get the checksum" >> $log
wget ${BUILDS}/${TARBALL}.sha1

echo "validate the checksum" >> $log
CHKSUM=$(openssl sha1 ${TARBALL} | cut -d' ' -f1)
VALIDATE=$(cat ${TARBALL}.sha1 | cut -d' ' -f1)
if [ "$CHKSUM" != "$VALIDATE" ] ; then
    echo "Checksum failure!" >> $log
    exit 2
fi

echo "extract the server" >> $log
tar xf ${TARBALL}
# keep the tarball for when you'd want to setup a clean server later
# rm ${TARBALL}
rm ${TARBALL}.sha1

#echo "update the bootscript to the local git repo" >> $log
#sed -i "s|^PKG_DIR=.*|PKG_DIR=${APKG_PATH}|" ${APKG_PATH}/bootscript 

echo "patch the server" >> $log
patchelf --set-rpath /opt/lib Server/Cuberite
patchelf --set-interpreter /opt/lib/ld-linux-x86-64.so.2 Server/Cuberite

[[ ! $? -eq 0 ]] && exit 3



# restore previous config
if [ -f ${APKG_BACKUP_CONFIG} ] ; then
   echo "Addon ${APKG_NAME} (install.sh) restore configs" >> $log
   cp ${APKG_BACKUP_CONFIG} ${APKG_CONFIG}
   rm -rf ${APKG_BACKUP}
fi
echo "Addon ${APKG_NAME} (install.sh) done" >> $log

