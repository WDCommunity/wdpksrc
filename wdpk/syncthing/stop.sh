#!/bin/sh

# stop daemon
APKG_DIR=$(readlink -f $1)
. ${APKG_DIR}/env

pkill ${BINARY}

p=$(pidof ${BINARY} > /dev/null)
while [ -n "$p" ] ; do
	echo "Stopping ${APKG_NAME}"
	kill $p
	sleep 1
	p=$(pidof ${BINARY} > /dev/null)
do

