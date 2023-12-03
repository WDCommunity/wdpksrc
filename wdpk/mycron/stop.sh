#!/bin/sh

LOG=/tmp/debug_apkg

function log {
    touch $LOG
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}

# log entry
log "Script called: $0 $@"

# backup crontab
CRONTAB_FILE="/var/spool/cron/crontabs/www-data"
TMP_FILE="/usr/local/config/crontab_www-data"
log "Backup $CRONTAB_FILE to $TMP_FILE"
cp $CRONTAB_FILE $TMP_FILE

# remove crontab
log "Remove crontab of user www-data"
crontab -u www-data -r
