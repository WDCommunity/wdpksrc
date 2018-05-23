#!/bin/sh

echo "APKG_DEBUG: starting emby" >> /tmp/debug_apkg

APP_DIR=$1

export EMBY_DATA=${APP_DIR}/appdata
PID_FILE=/var/run/emby-server.pid


$APP_DIR/bin/emby-server -p $PID_FILE -m
