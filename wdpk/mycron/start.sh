#!/bin/sh

LOG=/tmp/debug_apkg

function log {
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}

# log entry
log "Script called: $0 $@"

# create user mycron
# -D        Don't assign a password
# -H		Don't create home directory
# -G root	Add to group "root"
adduser -D -H www-data

# set crontab
crontab -u www-data "$1"/bin/cron.entry

