#!/bin/sh

APP_DIR=$1
PID_FILE=/var/run/emby-server.pid

kill $(cat $PID_FILE)

# TODO: kill any remains
