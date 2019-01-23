#!/bin/sh

[[ -f /tmp/debug_apkg ]] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APKG_PATH=$1

# invalidate old entware installation leftovers
# restore them if necessary
ENTWARE_ROOT=/shares/Volume_1/entware
BACKUP=${ENTWARE_ROOT}.bak
[[ -d ${ENTWARE_ROOT} ]] && mv ${ENTWARE_ROOT} ${BACKUP}
