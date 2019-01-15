#!/bin/sh

path_src=$1
path_des=$2

APKG_WWW_DIR="/var/www/phpMyAdmin"
APKG_MODULE="phpMyAdmin"
APKG_MODULE_WEB_DIR="phpMyAdmin-4.0.10.20-all-languages"
ARCHIVE="${APKG_MODULE_WEB_DIR}.zip"
APKG_MODULE_SettingFile="config.inc.php"
APKG_PATH=${path_des}/${APKG_MODULE}
APKG_BACKUP_PATH=${APKG_PATH}/../${APKG_MODULE}_backup

mv $path_src/${APKG_MODULE} $path_des

# setup secure downloads
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

# download phpMyAdmin from the official website
cd ${APKG_PATH}
/usr/bin/wget https://files.phpmyadmin.net/phpMyAdmin/4.0.10.20/$ARCHIVE

# extract
unzip $ARCHIVE
rm $ARCHIVE

# restore config files if they are saved in preinst.sh (or before_apkg.sh)
if [ -d ${APKG_BACKUP_PATH} ] ; then
	#copy setting file
	cp -af ${APKG_BACKUP_PATH}/${APKG_MODULE_SettingFile} ${APKG_PATH}/${APKG_MODULE_WEB_DIR}/
	rm -rf ${APKG_BACKUP_PATH}
else
	mysql --user=root --password=XP4VddgD0zd8IbKQ < $path_des/phpMyAdmin/admin.sql
fi
