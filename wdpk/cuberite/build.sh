#!/bin/sh

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} version ${VERSION}"

MODELS="WDMyCloudDL4100 WDMyCloudDL2100 MyCloudPR4100 MyCloudPR2100"

for model in $MODELS; do
  ../../mksapkg -E -s -m $model > /dev/null
done

echo "Move binaries"

RELEASE_DIR="../../packages/${APP_NAME}"
mkdir -p "${RELEASE_DIR}"
find .. -maxdepth 1 -name "*.bin*" -exec rename 's#\('$DATE'\)##' {} \;
mv ../*.bin "${RELEASE_DIR}"

echo "Bundle sources"
SRC_TAR="${RELEASE_DIR}/${APP_NAME}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR .


