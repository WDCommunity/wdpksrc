#!/bin/sh
set -eu

# Run as root in a disposable Debian container, not on a NAS.
apt-get update -qq
DEBIAN_FRONTEND=noninteractive apt-get install -y -qq ca-certificates curl sudo procps >/dev/null
useradd -m wdadmin
groupadd administrators
usermod -a -G administrators wdadmin
mkdir -p /tmp/staging /tmp/nas /tmp/mock

cp -a /wdpksrc/wdpk/syncthing /tmp/staging/syncthing
printf '#!/bin/sh\necho unsupported\n' > /tmp/mock/uname
chmod +x /tmp/mock/uname
if PATH="/tmp/mock:$PATH" sh /tmp/staging/syncthing/install.sh /tmp/staging/syncthing /tmp/nas; then
    echo 'Unsupported architecture was accepted' >&2
    exit 1
fi
test -d /tmp/staging/syncthing
rm /tmp/mock/uname

printf '#!/bin/sh\nexit 1\n' > /tmp/mock/curl
chmod +x /tmp/mock/curl
if PATH="/tmp/mock:$PATH" sh /tmp/staging/syncthing/install.sh /tmp/staging/syncthing /tmp/nas; then
    echo 'Failed download was accepted' >&2
    exit 1
fi
rm -rf /tmp/nas/syncthing
rm /tmp/mock/curl

cp -a /wdpksrc/wdpk/syncthing /tmp/staging/syncthing
sh /tmp/staging/syncthing/install.sh /tmp/staging/syncthing /tmp/nas
test -x /tmp/nas/syncthing/syncthing/syncthing
test ! -e /tmp/nas/syncthing/download
su -s /bin/sh wdadmin -c 'test -w /tmp/nas/syncthing/syncthing && test -w /tmp/nas/syncthing/syncthing/syncthing'
package_version=$(awk '$1 == "Version:" { print $2; exit }' /wdpksrc/wdpk/syncthing/apkg.rc)
installed_version=$(/tmp/nas/syncthing/syncthing/syncthing --version)
echo "$installed_version"
case "$installed_version" in
    "syncthing v${package_version} "*) ;;
    *) echo "Installed version does not match package version ${package_version}" >&2; exit 1 ;;
esac

sh /tmp/nas/syncthing/start.sh /tmp/nas/syncthing &
launcher=$!
trap 'kill "$launcher" 2>/dev/null || :; pkill syncthing 2>/dev/null || :' EXIT
count=0
until curl -fsS -o /dev/null http://127.0.0.1:8384/; do
    count=$((count + 1))
    if [ "$count" -ge 90 ]; then
        cat /tmp/debug_apkg >&2
        exit 1
    fi
    sleep 1
done
sh /tmp/nas/syncthing/stop.sh /tmp/nas/syncthing
printf '#!/bin/sh\nexit 1\n' > /tmp/mock/nc
printf '#!/bin/sh\nexit 0\n' > /tmp/mock/sleep
chmod +x /tmp/mock/nc /tmp/mock/sleep
if (cd /wdpksrc && PATH="/tmp/mock:$PATH" PACKAGE=syncthing TARGET=invalid bash tests/syncthing/test.sh >/dev/null 2>&1); then
    echo 'Unreachable server was reported as reachable' >&2
    exit 1
fi
echo 'Installer and startup passed'
