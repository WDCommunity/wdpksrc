#!/bin/sh
[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

/opt/bin/opkg remove zerotier

rm -rf $path
rm -rf "/var/www/apps/zerotier/"
