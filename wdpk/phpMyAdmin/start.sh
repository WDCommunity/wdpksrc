#!/bin/sh
path=$1
APKG_WWW_DIR="/var/www/phpMyAdmin/"
APKG_MODULE_WEB_DIR="phpMyAdmin-4.0.10.20-all-languages"
#start daemon
rm -rf $APKG_WWW_DIR  2> /dev/null
ln -sf $path/$APKG_MODULE_WEB_DIR/* $APKG_WWW_DIR

#cmd on start daemon

