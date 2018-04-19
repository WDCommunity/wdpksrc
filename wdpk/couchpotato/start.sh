#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"
SCRIPT=/opt/etc/init.d/S90CouchPotato

[ ! -f $SCRIPT ] echo "Couchpotato startup script not found" >> /tmp/debug_apkg

$SCRIPT start
