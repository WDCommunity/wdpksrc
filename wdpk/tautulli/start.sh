#!/bin/sh

# use entware/optware python when available
export PATH=/opt/bin:/opt/sbin:$PATH

echo "APKG_DEBUG: starting PlexPy on port 8282" >> /tmp/debug_apkg

APPDIR=$1

cd "${APPDIR}/Tautulli"
python ./PlexPy.py --port 8282 --daemon --pidfile /var/run/plexpy.pid
