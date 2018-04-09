#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

path=$1

# remove /opt from shell path
rm -f /etc/profile

# uncomment this to remove all your entware apps
#rm -rf /shares/Volume_1/entware

# remove init.d startup hook

# remove lib

# remove web
