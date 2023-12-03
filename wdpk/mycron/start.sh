#!/bin/sh

APPDIR=$1
LOG=/tmp/debug_apkg
CRONTAB_FILE="/var/spool/cron/crontabs/www-data"
BACKUP_FILE="/usr/local/config/crontab_www-data"
SAMPLE_FILE="$APPDIR/bin/cron.entry"
SUDO_FILE="$APPDIR/bin/sudo"

function log {
    touch $LOG
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}

# log entry
log "Script called: $0 $@"

# Western Digital thankfully left an entry for a user "www-data" in the sudoers file 
#cat /etc/sudoers | grep "www-data ALL=(ALL) NOPASSWD: ALL"

# The user "www-data" doesn't exst, so we create it
# -D        Don't assign a password
# -H		Don't create home directory
adduser -D -H www-data

#  set crontab
if test -f "$BACKUP_FILE"; then
    # restore crontab file when existent
    log "Restore $BACKUP_FILE to $CRONTAB_FILE"
    cp $BACKUP_FILE $CRONTAB_FILE
else
    # use sample crontab
    log "Set $SAMPLE_FILE as crontab of user www-data"
    crontab -u www-data "$SAMPLE_FILE"
fi


# if sudo binary was updated: make new SUID copy
if cmp /usr/bin/sudo $SUDO_FILE; then
  log "SUDO binary not updated, skip"
else
  log "SUDO binary was updated, create new SUID copy"
  cp /usr/bin/sudo $SUDO_FILE
  chmod 4755 $SUDO_FILE
fi
