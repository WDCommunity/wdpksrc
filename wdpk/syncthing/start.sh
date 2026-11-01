#!/bin/sh

log=/tmp/debug_apkg

APKG_PATH=$1
. ${APKG_PATH}/env

# finds first user in the admin group
ADMIN_USER=$(awk -F: '$1 == "administrators" { split($4, users, ","); print users[1]; exit }' /etc/group)

# Bind the GUI to every NAS interface. The former IP-address parser was not
# portable to the WD shell and could pass an invalid (empty) GUI address.
GUI_ADDRESS="http://0.0.0.0:${PORT}"

# start the binary as ADMIN_USER
sudo -H -u "$ADMIN_USER" env STNODEFAULTFOLDER=1 "${APKG_PATH}/syncthing/syncthing" \
    --no-browser \
    --home="${ST_HOME}" \
    --gui-address="${GUI_ADDRESS}" 2>&1 >> $log
