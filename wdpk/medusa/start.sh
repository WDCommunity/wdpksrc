#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"
SCRIPT=/opt/etc/init.d/S91Medusa

[ ! -f $SCRIPT ] && echo "Medusa startup script not found" >> /tmp/debug_apkg

$SCRIPT start
