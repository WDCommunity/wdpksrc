#!/bin/sh

# stop daemon

APPDIR=$1

"$APPDIR/start-stop-status" stop
