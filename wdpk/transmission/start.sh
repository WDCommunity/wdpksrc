#!/bin/sh

# use entware/optware python when available
export PATH=/opt/bin:/opt/sbin:$PATH

echo "APKG_DEBUG: starting PlexPy on port 8282" >> /tmp/debug_apkg

/opt/etc/init.d/S43Tautulli.sh start
