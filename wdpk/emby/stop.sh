#!/bin/sh

APP_DIR=$1
PID_FILE=/var/run/emby-server.pid

kill $(cat $PID_FILE)
sleep 1
# TODO: kill any remains
