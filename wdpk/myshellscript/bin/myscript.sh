#!/bin/sh
. $(dirname $0)/common.sh

log "inside myscript.sh"

# EXAMPLE: run own SSH deamon, e.g. with custom "AuthorizedKeysFile" option
#pkill sshd
#/usr/sbin/sshd -p 2222 -E /var/log/sshd.log -f /usr/local/config/sshd_config

# EXAMPLE: access MyCloud via port 443
#sed -i 's/httpsPort = 8543/httpsPort = 443/g' /etc/nasAdmin.toml

# EXAMPLE: use own certificate (see https://blog.pavel-pi.de/blog/mycloud-custom-cert/)
#cp /mnt/HD/HD_a2/restsdk-info/data/crypto2/prod/mycert /mnt/HD/HD_a2/restsdk-info/data/crypto2/prod/device-local-<GUID>.remotewd.com 2>/dev/null

# EXAMPLE: restart web service to let above changes (port, certificate) take effect 
#/usr/sbin/nasAdmin.sh restart