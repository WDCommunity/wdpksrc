#!/bin/sh

log=/tmp/debug_apkg

APKG_PATH=$1
. ${APKG_PATH}/env

# get first match for IP address
ADDRESS=$(sed -n '/ip/ {s/.*<ip>\(\S*\)<\/ip>/\1/p;q}' /etc/NAS_CFG/config.xml )

# finds first user in the admin group
ADMIN_USER=$(cat /etc/group | grep administrators | head -n 1 | awk -F: '{ print $4}')

# start the binary as ADMIN_USER
sudo -H -u $ADMIN_USER ${APKG_PATH}/syncthing/syncthing --no-default-folder -no-browser -home=${ST_HOME} -gui-address="http://${ADDRESS}:${PORT}" 2>&1 >> $log
