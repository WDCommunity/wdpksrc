#!/bin/sh

echo "APKG_DEBUG: starting emby" >> /tmp/debug_apkg

PID_FILE=/var/run/emby-server.pid

APP_DIR=$1
$APP_DIR/bin/emby-server -p $PID_FILE -m
