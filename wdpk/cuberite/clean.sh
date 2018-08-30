#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

WEBPATH="/var/www/cuberite"

# remove bootscript
/opt/etc/init.d/S62Cuberite stop
rm -f /opt/etc/init.d/S62Cuberite

# remove lib

# remove web
rm -rf $WEBPATH
