#!/bin/sh

log=/tmp/debug_apkg

echo "APKG_DEBUG: $0 $@" >> $log

INSTALL_DIR=$(readlink -f $1)
. ${INSTALL_DIR}/env

NAS_PROG=$(readlink -f $2)

log=/tmp/debug_apkg

APKG_PATH="${NAS_PROG}/${APKG_NAME}"

case "$(uname -m)" in
    x86_64) PLATFORM=amd64 ;;
    armv7l|armv8l) PLATFORM=arm ;;
    *) echo "Unsupported architecture: $(uname -m)" >> "$log"; exit 2 ;;
esac

echo "move package data" >> $log
mv "${INSTALL_DIR}" "${NAS_PROG}" >> "$log" 2>&1 || exit 2

VERSION="v2.1.7"
MAINDIR="syncthing-linux-${PLATFORM}-${VERSION}"
DOWNLOAD_DIR="${APKG_PATH}/download"
mkdir -p "$DOWNLOAD_DIR" || exit 2
trap 'rm -rf "$DOWNLOAD_DIR"' EXIT
echo "Installing Syncthing ${VERSION}" >> "$log"
curl -fsSL "https://github.com/syncthing/syncthing/releases/download/${VERSION}/${MAINDIR}.tar.gz" -o "${DOWNLOAD_DIR}/release.tar.gz" >> "$log" 2>&1 || exit 2
tar xzf "${DOWNLOAD_DIR}/release.tar.gz" -C "$DOWNLOAD_DIR" >> "$log" 2>&1 || exit 2
[ -x "${DOWNLOAD_DIR}/${MAINDIR}/syncthing" ] || exit 2
"${DOWNLOAD_DIR}/${MAINDIR}/syncthing" --version >> "$log" 2>&1 || {
    echo "Syncthing ${VERSION} cannot run on this device" >> "$log"
    exit 2
}
mv "${DOWNLOAD_DIR}/${MAINDIR}" "${APKG_PATH}/${APKG_NAME}" >> "$log" 2>&1 || exit 2

# create syncthing home dir
mkdir -p "${ST_HOME}" || exit 2
# finds first user in the admin group
ADMIN_USER=$(awk -F: '$1 == "administrators" { split($4, users, ","); print users[1]; exit }' /etc/group)

if [ -z "${ADMIN_USER}" ]; then
    echo "Could not determine the WD administrators user" >> $log
    exit 2
fi

# Syncthing runs as the WD administrator user. On a reinstall the state
# directory may already contain root- or another-user-owned data, so fix the
# entire tree instead of only its top-level directory.
chown -R "${ADMIN_USER}" "${ST_HOME}" 2>&1 >> $log || exit 2
chmod -R u+rwX "${ST_HOME}" 2>&1 >> $log || exit 2
# Syncthing replaces its executable in place during automatic upgrades.
chown -R "${ADMIN_USER}" "${APKG_PATH}/${APKG_NAME}" >> "$log" 2>&1 || exit 2
chmod u+rwx "${APKG_PATH}/${APKG_NAME}" >> "$log" 2>&1 || exit 2
