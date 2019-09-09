#!/bin/sh
path=$1
APKG_WWW_DIR="/var/www/phpMyAdmin"
APKG_MODULE_WEB_DIR="phpMyAdmin-4.0.10.20-all-languages"
APKG_ICON_FILE_NAME="phpMyAdmin.png"
APKG_MULTI_LANG_DESC_XML="desc.xml"

# stop daemon
rm -rf $APKG_WWW_DIR

# re-add the icon
mkdir ${APKG_WWW_DIR}
ln -s $path/web/* ${APKG_WWW_DIR}
