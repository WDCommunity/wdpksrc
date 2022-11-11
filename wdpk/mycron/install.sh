#!/bin/sh

LOG=/tmp/debug_apkg
UPLOAD_PATH=$1
INST_PATH=$2

function log {
    TIME=$(date '+%Y-%m-%d %H:%M:%S')
    [ -f $LOG ] && echo "$TIME [mycron] [$(basename $0)] $1" >> $LOG
}


# log entry
log "Script called: $0 $@"

# move from upload path to install path
mv $UPLOAD_PATH $INST_PATH


# create user mycron
# -D        Don't assign a password
# -H		Don't create home directory
# -G root	Add to group "root"
adduser -D -H www-data

# make SUID copy of sudo binary
cp /usr/bin/sudo $INST_PATH/mycron/bin/sudo
chmod 4755 $INST_PATH/mycron/bin/sudo
