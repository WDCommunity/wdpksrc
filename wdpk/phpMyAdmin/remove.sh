#!/bin/sh

path=$1
APKG_PATH=$1
APKG_WWW_DIR="/var/www/phpMyAdmin"
APKG_MODULE="phpMyAdmin"
APKG_MODULE_WEB_DIR="phpMyAdmin-4.0.10.20"
APKG_MODULE_SettingFile="config.inc.php"
APKG_BACKUP_PATH=${APKG_PATH}/../${APKG_MODULE}_backup

#stop daemon

#remove link
rm -rf $APKG_WWW_DIR

#remove mysql user
if [ ! -d ${APKG_BACKUP_PATH} ] ; then
	mysql --user=root --password=XP4VddgD0zd8IbKQ < $path/del_admin.sql
fi

#remove intstalled directory
rm -rf $path

