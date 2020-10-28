#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path_src=$1
NAS_PROG=$2

# define docker version
VERSION="19.03.8"

log=/tmp/debug_apkg

APKG_MODULE="docker"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"
APPDIR="$APKG_PATH"

echo "Installing with APPDIR: ${APPDIR} / ${APKG_PATH}"

# install all package scripts to the proper location
cp -rf $path_src $NAS_PROG

# get current architecture
ARCH="$(uname -m)"

# download docker binaries
cd "${APKG_PATH}"
TARBALL="docker-${VERSION}.tgz"

if [ ${ARCH} != "x86_64" ]; then
    ARCH="armel"
    # JediNite provides custom docker packages for ARM
    # They are based on docker-runc without seccomp, as the kernel doesn't support it
    URL="https://github.com/JediNite/docker-ce-WDEX4100-binaries/releases/download/${VERSION}/${TARBALL}"
else
    URL="https://download.docker.com/linux/static/stable/${ARCH}/${TARBALL}"
fi

# download and extract the package
curl -L "${URL}" | tar xz >> $log 2>&1

if [ ! $? -eq 0 ]; then
	echo "Failed to download/extract docker package" | tee $log
	exit 1
fi

# stop original docker v1.7
if [ -e "${ORIG_DAEMONSH}" ]; then
    echo "Found orig daemon"
    /usr/sbin/docker_daemon.sh shutdown
    sleep 1
    mv /usr/sbin/docker_daemon.sh /usr/sbin/docker_daemon.sh.bak
else
    echo "No orig daemon found"
fi

# setup docker binaries in PATH so they are found before the 1.7 binaries
ln -s $(readlink -f ${APKG_PATH})/docker/* /sbin

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

# install portainer to manage docker, only if there is no container Portainer (running or not)
docker ps -a | grep portainer
if [ $? = 1 ]; then
    docker run -d -p 9000:9000 --restart always --name portainer \
               -v /var/run/docker.sock:/var/run/docker.sock \
               -v $(readlink -f ${APKG_PATH})/portainer:/data portainer/portainer-ce
fi

# install docker-compose
dc="${APKG_PATH}/docker/docker-compose"
curl -L https://github.com/docker/compose/releases/download/1.26.2/run.sh -o $dc
chmod +x $dc

# proof that everything works
docker ps >> $log 2>&1

echo "Addon Docker (install.sh) done" >> $log

