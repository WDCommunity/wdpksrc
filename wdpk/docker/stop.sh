#!/bin/sh

APPDIR=$1
LOG=/tmp/debug_apkg

echo 'DOCKER stop: stop daemon'
"$APPDIR/daemon.sh" shutdown >> $LOG 2>&1

sleep 1

echo "Remaining mounts:"
echo "$(cat /proc/self/mounts | grep docker)"

#echo 'DOCKER stop: unmount the BTRFS volume'
#umount /var/lib/docker

#/sbin/losetup -d /dev/loop1
