#!/bin/sh
path=$1
APKG_WWW_DIR="/var/www/phpMyAdmin"

# remove link
rm -rf ${APKG_WWW_DIR}  2> /dev/null

