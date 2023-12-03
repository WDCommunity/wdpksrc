#!/bin/sh

APPDIR=$1
LOG=/tmp/debug_apkg

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
CRONTAB_FILE="/var/spool/cron/crontabs/www-data"
TMP_FILE="/usr/local/config/crontab_www-data"
if test -f "$TMP_FILE"; then
    # restore crontab file when existent
    log "Restore $TMP_FILE to $CRONTAB_FILE"
    cp $TMP_FILE $CRONTAB_FILE
else
    # use sample crontab
    log "Set $1/bin/cron.entry as crontab of user www-data"
    crontab -u www-data "$1"/bin/cron.entry
fi


# if sudo binary was updated: make new SUID copy
if cmp /usr/bin/sudo $APPDIR/bin/sudo; then
  log "sudo binary not updated, skip"
else
  log "sudo binary was updated, create new SUID copy"
  cp /usr/bin/sudo $APPDIR/bin/sudo
  chmod 4755 $APPDIR/bin/sudo
fi
