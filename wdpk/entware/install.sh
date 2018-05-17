#!/bin/bash

LOG=/tmp/debug_apkg

echo "APKG_DEBUG: $0 $@" >> $LOG

path_src=$1
NAS_PROG=$2

APKG_MODULE="entware"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"

# copy the WD entware package to App
cp -rf ${path_src} ${NAS_PROG}

# create the entware root in a location that is not shared by samba
OPT_ROOT="/shares/Volume_1/${APKG_MODULE}"
mkdir -p ${OPT_ROOT}
echo "APKG_DEBUG: mount $OPT_ROOT to /opt" >> $LOG
mount --bind ${OPT_ROOT} /opt

ARCH="$(uname -m)"
if [ ${ARCH} = "x86_64" ]; then
    ENT_ARCH="x86-64"
else
    ENT_ARCH="armv7"
fi

echo "APKG_DEBUG: download and install entware-ng for $ARCH" >> $LOG
wget -O - "http://pkg.entware.net/binaries/${ENT_ARCH}/installer/entware_install.sh" | sh

echo "APKG_DEBUG: keep old WD reboot"
ln -s ${APKG_PATH}/sbin/reboot /opt/sbin/reboot

echo "Restore WD service module paths"
WDOPT=/usr/local/modules/opt/wd
ln -s ${WDOPT} /opt/wd

echo "Unmount again"
umount /opt

echo "APKG_DEBUG: entware-ng install.sh ready" >> $LOG

