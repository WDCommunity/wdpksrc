#!/bin/bash

LOG=/tmp/entware_install

echo "APKG_DEBUG: $0 $@" | tee -a $LOG

path_src=$1
NAS_PROG=$2

APKG_MODULE="entware"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"

# copy the WD entware package to App
cp -rf ${path_src} ${NAS_PROG}

# create the entware root in a location that is not shared by samba
OPT_ROOT="/shares/Volume_1/${APKG_MODULE}"
mkdir -p ${OPT_ROOT}
echo "APKG_DEBUG: mount $OPT_ROOT to /opt" | tee -a $LOG
mount --bind ${OPT_ROOT} /opt 2>&1 | tee -a $LOG

ARCH="$(uname -m)"
if [ ${ARCH} = "x86_64" ]; then
    ENT_ARCH="x64"
elif [ ${ARCH} = "armv5tel" ]; then
    ENT_ARCH="armv5sf"
else
    ENT_ARCH="armv7sf"
fi

echo "APKG_DEBUG: download and install entware-ng for $ARCH" | tee -a $LOG
wget -O - "http://bin.entware.net/${ENT_ARCH}-k3.2/installer/generic.sh" | /bin/sh 2>&1 | tee -a $LOG

/opt/bin/opkg update 2>&1 | tee -a $LOG
/opt/bin/opkg upgrade 2>&1 | tee -a $LOG

echo "APKG_DEBUG: keep old WD reboot" | tee -a $LOG
ln -sf ${APKG_PATH}/sbin/reboot /opt/sbin/reboot 2>&1 | tee -a $LOG

echo "Restore WD service module paths" | tee -a $LOG
WDOPT=/usr/local/modules/opt/wd
ln -sf ${WDOPT} /opt/wd 2>&1 | tee -a $LOG

echo "Unmount again" | tee -a $LOG
umount /opt 2>&1 | tee -a $LOG

echo "APKG_DEBUG: entware-ng install.sh ready" | tee -a $LOG

