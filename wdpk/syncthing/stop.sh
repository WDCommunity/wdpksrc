#!/bin/sh

# stop daemon
APKG_DIR=$(readlink -f $1)
. ${APKG_DIR}/env 

if pidof ${BINARY} > /dev/null ; then
	echo "Stopping ${APKG_NAME}"
	kill $(pidof ${BINARY})
fi
