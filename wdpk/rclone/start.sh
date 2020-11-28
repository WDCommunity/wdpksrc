#!/bin/sh

cd $(dirname $0)
source ./env

[ ! -f /usr/bin/rclone ] echo "rclone not found" >> /tmp/debug_apkg

[ -f /tmp/debug_apkg ] echo "APKG_DEBUG: starting Rclone" >> /tmp/debug_apkg



ADDRESS=$(sed -n '/ip/ {s/.*<ip>\(\S*\)<\/ip>/\1/p;q}' /etc/NAS_CFG/config.xml )

# TODO: get user and pw from file
rclone rcd --rc-web-gui --rc-addr ${ADDRESS}:${PORT:-5582} --rc-user ${RCLONE_USER:-mycloud} --rc-pass ${RCLONE_PW:-mycloud}
