#!/bin/sh

LOG=/tmp/debug_apkg

echo "APKG_DEBUG: $0 $@" >> $LOG

# ensure services are stopped
/opt/etc/init.d/rc.unslung stop

rm /etc/profile

# backup home dir
APPDIR=$1
rm -rf "${APPDIR}/home"
rsync -a /home/root/ "${APPDIR}/home"

# umount, the original /opt mount becomes visible again
umount /opt

if [ ! $? eq 0 ] ; then
   echo "Entware clean umount failed"
   fuser -cv /opt | tee -a $LOG
fi

# remove bin

# remove lib

# remove web
rm -rf /var/www/entware
