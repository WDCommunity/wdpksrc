#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APPDIR=$(readlink -f $1)
APP=cuberite
LOG=/tmp/${APP}.log

echo "INIT linking files from path: ${APPDIR}" >> $LOG

# setup startup script to ensure entware clean takes it down
ln -sf ${APPDIR}/bootscript /opt/etc/init.d/S62Cuberite

# create directory for the webpage TODO FIX ME
WEBDIR="/var/www/${APP}/"
mkdir -p $WEBDIR
ln -sf ${APPDIR}/web/* $WEBDIR

