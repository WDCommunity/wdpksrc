#!/bin/sh

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} version ${VERSION}"

MODELS="MyCloudEX2Ultra"

for model in $MODELS; do
  ../../mksapkg-OS5 -E -s -m $model > /dev/null
done

echo "Move binaries"

RELEASE_DIR="../../packages/${APP_NAME}"
mkdir -p "${RELEASE_DIR}"
find .. -maxdepth 1 -name "*.bin*" | while read f; do mv "$f" "${f%.bin*}.bin"; done
mv ../*_${APP_NAME}_* "${RELEASE_DIR}"

echo "Bundle sources"
SRC_TAR="${RELEASE_DIR}/${APP_NAME}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR .
