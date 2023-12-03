#!/bin/sh

LOG=/tmp/debug_apkg

function log {
    touch $LOG
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}


# log entry
log "Script called: $0 $@"

path=$1

# create directory for the webpage
log "Create directory for webpage"
# if CenterType is "1" (embedded), then the path will be /var/www/apps/<appname>
# if it is "0", then the path will be /var/www/<appname>
WEBDIR="/var/www/apps/mycron/"

command="mkdir -p $WEBDIR"
log "$command"
eval "$command"

command="ln -sf $path/web/* $WEBDIR"
log "$command"
eval "$command"
