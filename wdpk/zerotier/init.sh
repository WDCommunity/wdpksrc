#!/bin/sh
[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$(readlink -f $1)
WEBPATH="/var/www/apps/zerotier/"
mkdir -p $WEBPATH
ln -sf ${APKG_PATH}/web/* $WEBPATH
