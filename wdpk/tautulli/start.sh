#!/bin/sh

echo "APKG_DEBUG: starting PlexPy on port 8282" >> /tmp/debug_apkg

APPDIR=$1

cd "${APPDIR}/Tautulli-master"
python ./PlexPy.py --port 8282 --daemon --pidfile /var/run/plexpy.pid
