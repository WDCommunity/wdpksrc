#!/bin/sh

LOG=/tmp/debug_apkg
CRONTAB_FILE="/var/spool/cron/crontabs/www-data"
BACKUP_FILE="/usr/local/config/crontab_www-data"

function log {
    touch $LOG
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}

# log entry
log "Script called: $0 $@"

# backup crontab
log "Backup $CRONTAB_FILE to $BACKUP_FILE"
cp $CRONTAB_FILE $BACKUP_FILE

# disable crontab
log "Remove crontab of user www-data"
crontab -u www-data -r
