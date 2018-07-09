#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APPDIR=$1
log=/tmp/debug_apkg

echo "INIT linking files from path: $path" >> $log

# setup binaries in PATH before the original v1.7 binaries
ln -s $(readlink -f ${APPDIR})/docker/* /sbin

# disable default docker by moving the original start script
[ -L /usr/sbin/docker_daemon.sh ] && mv /usr/sbin/docker_daemon.sh /usr/sbin/docker_daemon.sh.bak
[ -L /usr/sbin/docker ] && mv /usr/sbin/docker /usr/sbin/docker.bak

# create folder for the redirecting webpage
WEBPATH="/var/www/docker/"
mkdir -p ${WEBPATH}
ln -sf ${APPDIR}/web/* $WEBPATH

