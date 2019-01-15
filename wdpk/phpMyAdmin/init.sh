#!/bin/sh

path=$1
APKG_WWW_DIR="/var/www/phpMyAdmin"
APKG_MODULE_WEB_DIR="phpMyAdmin-4.0.10.20-all-languages"
APKG_ICON_FILE_NAME="phpMyAdmin.png"
APKG_MULTI_LANG_DESC_XML="desc.xml"

#remove link
rm -rf $APKG_WWW_DIR  2> /dev/null

#create link
ln -sf $path/web/* ${APKG_WWW_DIR}

