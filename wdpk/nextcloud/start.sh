#!/bin/sh

APKG_PATH=$1
. ${APKG_PATH}/env

echo "start cloud"
/opt/etc/init.d/S70redis restart
/opt/etc/init.d/S70mysqld restart
/opt/etc/init.d/S80nginx start

ln -sf /shares/cloud/nextcloud_data /clouddata

