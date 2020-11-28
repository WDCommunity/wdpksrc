#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

# create a backup of the config
APKG_CONFIG="${path}/nzbget.conf"
APKG_BACKUP_CONFIG="/mnt/HD/HD_a2/.systemfile/nzbget.conf"
cp ${APKG_CONFIG} ${APKG_BACKUP_CONFIG}

rm -rf $path

# remove bin
rm -f /usr/bin/nzbget

# remove lib

# remove web
rm -rf /var/www/nzbget
