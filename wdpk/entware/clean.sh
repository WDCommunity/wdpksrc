#!/bin/sh

LOG=/tmp/debug_apkg

echo "APKG_DEBUG: $0 $@" >> $LOG

# ensure services are stopped
/opt/etc/init.d/rc.unslung stop

rm /etc/profile

# remove symlink to home dir
rm /home/root
mkdir /home/root
chown root:root /home/root

# umount, the original /opt mount becomes visible again
umount /opt

if [ ! $? eq 0 ] ; then
   echo "Entware clean umount failed" >> $LOG
   fuser -cv /opt | tee -a $LOG
   echo "Kill them all" >> $LOG
   fuser -ck /opt
   sleep 2
   umount /opt
fi

# remove bin

# remove lib

# remove web
rm -rf /var/www/entware
