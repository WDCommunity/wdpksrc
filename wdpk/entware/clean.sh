#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

# ensure services are stopped
/opt/etc/init.d/rc.unslung stop

rm /etc/profile

# backup home dir
APPDIR=$1
rm -rf "${APPDIR}/home"
rsync -a /home/root/ "${APPDIR}/home"

# umount, the original /opt mount becomes visible again
umount /shares/Volume_1/entware

# remove bin

# remove lib

# remove web
rm -rf /var/www/entware
