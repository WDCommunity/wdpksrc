#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APPDIR=$1
APP=medusa
LOG=/tmp/${APP}.log

echo "INIT linking files from path: ${APPDIR}" >> $LOG

# create link to binary 
cp ${APPDIR}/bootscript /opt/etc/init.d/S91Medusa

# create directory for the webpage
WEBDIR="/var/www/${APP}/"
mkdir -p $WEBDIR
ln -sf ${APPDIR}/web/* $WEBDIR

