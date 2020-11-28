#!/bin/sh

[[ ! -f /usr/bin/nzbget ]] && echo "nzbget not found" >> /tmp/debug_apkg

[[ -f /tmp/debug_apkg ]] && echo "APKG_DEBUG: starting NZBget in Daemon mode" >> /tmp/debug_apkg
nzbget -D
