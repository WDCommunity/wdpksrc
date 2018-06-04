#!/bin/bash

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NAS_PROG=$2

log=/tmp/debug_apkg

APKG_MODULE="docker"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"
APPDIR="$APKG_PATH"

echo "Installing with APPDIR: ${APPDIR} / ${APKG_PATH}"

# install all package scripts to the proper location
cp -rf $path_src $NAS_PROG

# get current architecture
ARCH="$(uname -m)"
if [ ${ARCH} -ne "x86_64"]; then
    ARCH="armhf"
fi

# download docker binaries
cd "${APKG_PATH}"
wget "https://download.docker.com/linux/static/stable/${ARCH}/docker-18.03.1-ce.tgz" --no-check-certificate

# extract the package
tar xzf docker-18.03.1-ce.tgz >> $log 2>&1

# remove the package
rm docker-18.03.1-ce.tgz

# stop original docker v1.7
if [ -e "${ORIG_DAEMONSH}" ]; then
    echo "Found orig daemon"
    /usr/sbin/docker_daemon.sh shutdown
    sleep 1
    mv /usr/sbin/docker_daemon.sh /usr/sbin/docker_daemon.sh.bak
else
    echo "No orig daemon found"
fi

# copy binaries
cp "${APKG_PATH}"/docker/* /sbin

# setup persistent docker root directory
DROOT=${NAS_PROG}/_docker

if [ -d ${DROOT} ]; then
  if [ -d ${DROOT}/devicemapper ]; then
    echo "Found old docker devicemapper storage.. backup and create new docker root"
    mv "${DROOT}" "${DROOT}.bak"
    mkdir -p "${DROOT}"
  else
    echo "Found existing docker storage. Reusing."
  fi
else
  echo "Creating new docker root"
  mkdir -p "${DROOT}"
fi

# setup docker
"${APKG_PATH}/daemon.sh" setup

sleep 1

# start daemon
"${APKG_PATH}/daemon.sh" start

sleep 3

# install portainer to manage docker
docker ps | grep portainer
if [ $? = 1 ]; then
    docker run -d -p 9000:9000 --restart always \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v $(readlink -f ${APKG_PATH})/portainer:/data portainer/portainer
fi

# proof that everything works
docker ps >> $log 2>&1

echo "Addon Docker (install.sh) done" >> $log

