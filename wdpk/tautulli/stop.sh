#!/bin/sh

# stop daemon
/opt/etc/init.d/S43Tautulli.sh stop

kill `cat /var/run/plexpy.pid`
