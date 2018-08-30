#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

INSTALL_DIR=$1
NAS_PROG=$2

log=/tmp/debug_apkg

APKG_NAME="cuberite"
APKG_PATH="${NAS_PROG}/${APKG_NAME}"
SERVER_DIR="${APKG_PATH}/Server"
SERVER_BIN="${SERVER_DIR}/Cuberite"
WORLD_DATA="/shares/Volume_1/${APKG_NAME}"

# install all package scripts to the proper location
cp -r ${INSTALL_DIR} ${NAS_PROG}

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
CHKSUM=$(openssl sha1 ${TARBALL} | cut -d' ' -f2)
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
                                                                      
echo "patch the server binary" >> $log                                
patchelf --set-rpath /opt/lib ${SERVER_BIN}                           
patchelf --set-interpreter /opt/lib/ld-linux-x86-64.so.2 ${SERVER_BIN}
                                                   
[[ ! $? -eq 0 ]] && exit 3                                                             
                                                                                       
# move the server binary out of the world directory                                    
# the Server directory remains as a reference for those who want to start a fresh world
mv ${SERVER_BIN} ${APKG_PATH}  
                                                                       
# restore previous worlds                                              
if [ -d ${WORLD_DATA} ] ; then                                         
   echo "Addon ${APKG_NAME} (install.sh) found existing worlds" >> $log
   # no need to setup a world data dir                         
else                                                                            
   echo "Addon ${APKG_NAME} (install.sh) fresh install" >> $log
   # setup a fresh world data dir                  
   cp -r ${SERVER_DIR} ${WORLD_DATA}               
fi

echo "Addon ${APKG_NAME} (install.sh) done" >> $log

