#!/bin/sh

PATH="/opt/bin:/opt/sbin:$PATH"
SCRIPT=/opt/etc/init.d/S62Cuberite

[ ! -f $SCRIPT ] && echo "Cuberite startup script not found" >> /tmp/debug_apkg

$SCRIPT start
