#!/bin/sh

echo "APKG_DEBUG: starting Docker and Portainer on port 9000" >> /tmp/debug_apkg

APPDIR=$1
LOG=/tmp/debug_apkg

#export PATH="$APPDIR/docker:$PATH"

echo 'DOCKER START: setup daemon'
"${APPDIR}/daemon.sh" setup >> $LOG 2>&1

#echo 'DOCKER START: mount btrfs volume'
#/sbin/losetup /dev/loop1 /shares/Volume_1/tfl_docker.img
#mount -t btrfs /dev/loop1 /var/lib/docker

echo 'DOCKER START: start daemon'
"${APPDIR}/daemon.sh" start >> $LOG 2>&1

sleep 3
echo "$(docker ps)"
