#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APPDIR=$1
LOG=/tmp/debug_apkg

echo "Entware init.sh linking files from path: $APPDIR" >> $LOG

# create link to binary...
OPKG=/opt/bin/opkg
OPTROOT=/shares/Volume_1/entware
if [ ! -f $OPKG ]; then
	[ ! -d $OPTROOT ] && echo "Entware root dir not found!" >> $LOG && exit 1
	mount --bind $OPTROOT /opt
	echo "Mounted Entware root to /opt" >> $LOG
fi

# add wd opt dir again
WDOPT=/usr/local/modules/opt/wd
ln -sf $WDOPT /opt/wd

# update profile
PROFILE=/etc/profile
[ ! -f $PROFILE ] && cp $APPDIR/profile $PROFILE

# restore home dir
HOME=/home/root
NEWHOME=${APPDIR}/home
if [ ! -L ${HOME} ]
then
	echo "Setup persistent home directory"
	rm -rf ${HOME}
	mkdir -p ${NEWHOME}
	ln -sf ${NEWHOME} /home/root
	chown -R root:root ${HOME}
	chown -R root:root ${NEWHOME}
fi

# link web to /var/www just for the app icon
WEBPATH=/var/www/entware/
mkdir -p $WEBPATH
ln -sf $APPDIR/web/* $WEBPATH
echo "Created Entware web dir symlink" > $LOG
