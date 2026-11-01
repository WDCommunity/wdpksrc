#!/bin/sh
set -e

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} version ${VERSION}"

MODELS="WDMyCloud WDMyCloudEX4100 WDMyCloudDL4100 WDMyCloudEX2100 WDMyCloudDL2100 WDMyCloudMirror MyCloudEX2Ultra MyCloudPR4100 MyCloudPR2100"
RELEASE_DIR="../../packages/${APP_NAME}"
mkdir -p "${RELEASE_DIR}"

for model in $MODELS; do
  ../../mksapkg-OS5 -E -s -m $model > /dev/null
  for f in ../${model}_${APP_NAME}_*.bin*; do
    [ -f "$f" ] || exit 1
    mv "$f" "${RELEASE_DIR}/$(basename "${f%.bin*}").bin"
  done
done

echo "Bundle sources"
SRC_TAR="${RELEASE_DIR}/${APP_NAME}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR .
