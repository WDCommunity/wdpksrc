#!/bin/sh

[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@" >> /tmp/debug_apkg

APP=docker
WEBPATH="/var/www/$APP"

# restore startup script
[ -f /usr/sbin/docker_daemon.sh.bak ] && mv -f /usr/sbin/docker_daemon.sh.bak /usr/sbin/docker_daemon.sh

# remove binaries

# remove lib symlink
rm -f /var/lib/docker

# remove web
rm -rf $WEBPATH
