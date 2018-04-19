#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

# DO NOT REMOVE
# I don't know if it's required for backward compatibility
# I don't have time to figure it out
APKG_MODULE="NZBget"

APKG_PATH=""
