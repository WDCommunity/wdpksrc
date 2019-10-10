#!/bin/sh
#
# Copyright (C) 2019 Stefaan Ghysels
#
# This is free software, licensed under the GNU General Public License v2
# See /LICENSE for more information.
#

INSTALL_DIR=$(readlink -f $1)
. ${INSTALL_DIR}/env

NAS_PROG=$(readlink -f $2)

APKG_PATH="${NAS_PROG}/${APKG_NAME}"

echo "move package data" >> $LOG
mv ${INSTALL_DIR} ${NAS_PROG} 2>&1 >> $LOG

# setup secure downloads
if [ ! -e /etc/ssl/cert.pem ]; then
    curl --remote-name --time-cond cacert.pem https://curl.haxx.se/ca/cacert.pem
    mv cacert.pem /etc/ssl/cert.pem
fi

echo "Install a ton of dependencies" >> $LOG
/opt/bin/opkg update
/opt/bin/opkg install \
	coreutils-stat \
	bzip2 \
	openssl-util \
	nginx \
	mariadb-server \
	mariadb-server-extra \
	php7-cgi \
	php7-cli \
	php7-fpm \
	php7-mod-ctype \
	php7-mod-curl \
	php7-mod-dom \
	php7-mod-fileinfo \
	php7-mod-gd \
	php7-mod-hash \
	php7-mod-iconv \
	php7-mod-json \
	php7-mod-mbstring \
	php7-mod-pcntl \
	php7-mod-pdo \
	php7-mod-pdo-sqlite \
	php7-mod-pdo-mysql \
	php7-mod-session \
	php7-mod-simplexml \
	php7-mod-sqlite3 \
	php7-mod-xml \
	php7-mod-xmlwriter \
	php7-mod-xmlreader \
	php7-mod-openssl \
	php7-mod-intl \
	php7-mod-zip \
	php7-pecl-redis \
	redis-server >> $LOG

[[ ! $? -eq 0 ]] && exit 1

ARCHIVE="${APKG_NAME}-${VERSION}.zip"
URL="https://download.nextcloud.com/server/releases/${ARCHIVE}"

cd ${APKG_PATH}
echo "Download archive" >> $LOG
curl -L -s ${URL} -o ${ARCHIVE} 2>&1 >> $LOG

[[ ! $? -eq 0 ]] && exit 2

echo "Setup web root and unpack assets" >> $LOG
WWWDIR="/opt/var/www"
mkdir -p ${WWWDIR}
unzip -o ${ARCHIVE} -d ${WWWDIR} 2>&1 >> $LOG

[[ ! $? -eq 0 ]] && exit 3

echo "Add cloud user and share" >> $LOG
id cloud 2>&1 > /dev/null
[[ ! $? -eq 0 ]] && addUser.sh cloud 0 "Cloudy McCloud" >> $LOG

echo "Setup persistent data directory" >> $LOG
DATADIR=/shares/cloud/nextcloud_data

# INITIALIZE NEXTCLOUD
if [ ! -d ${DATADIR} ]; then

mkdir -p ${DATADIR}
chown -R cloud:cloudholders ${DATADIR}

echo "Setup ${APKG_NAME} config" >> $LOG
WEBDIR=${WWWDIR}/${APKG_NAME}
CONFIGDIR=${WEBDIR}/config
CONFIG=${CONFIGDIR}/config.php

# OS3 already has an older mysqldb running
# so we need to use another port
echo "Setup mysql" >> $LOG
MYSQLCFG=/opt/etc/mysql/conf.d/50-server.cnf
sed -i "s#^pid-file = *#pid-file = /var/run/mysqld.pid#" ${MYSQLCFG}
sed -i "s#^socket = *#socket = /var/run/mysqld.sock#" ${MYSQLCFG}
sed -i "s#^port = *#port = 3307#" ${MYSQLCFG}
sed -i "s#^PIDFILE=*#PIDFILE=/var/run/mysqld.pid#" /opt/etc/init.d/S70mysqld
sed -i "s#^mysql.default_socket=*#mysql.default_socket=/var/run/mysqld.sock#" /opt/etc/php7/20_pdo_mysql.ini

sed -i "s#^pid =*#pid = /var/run/php7-fpm.pid#" /opt/etc/php7-fpm.conf
sed -i "s#^doc_root = *#doc_root = /opt/var/www#" /opt/etc/php.ini

/opt/bin/mysql_install_db --force >> $LOG

MYSQL_ROOT_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
#MYSQL_ADMIN_PASSWORD=$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;)
MYSQL_ADMIN_PASSWORD=nextcloud
sed -i "s#@@ROOT_PWD@@#${MYSQL_ROOT_PASSWORD}#" nc_setup.sql
sed -i "s#@@ADMIN_PWD@@#${MYSQL_ADMIN_PASSWORD}#" nc_setup.sql
sed -i "s#@@ADMIN_PWD@@#${MYSQL_ADMIN_PASSWORD}#" config.php
cp ${APKG_DIR}/config.php ${CONFIG}

/opt/bin/mysqld --pid-file /var/run/mysqld.pid &
sleep 1

echo "Secure MySQL root password and add nextcloud user" >> $LOG
/usr/bin/mysql -P 3307 -S /var/run/mysqld.sock < nc_setup.sql

# reload to activate new root password
/opt/etc/init.d/S70mysqld restart

echo "Setup nginx and certificates"

# UPGRADE NEXTCLOUD
else

fi
