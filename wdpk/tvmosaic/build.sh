#!/bin/sh

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} x64 version ${VERSION}"

MODELS="WDMyCloudDL4100 WDMyCloudDL2100 MyCloudPR4100 MyCloudPR2100"

# curl -L syno_x64_tarball -o pkg.tar.gz
# tar xf pkg.tar.gz
# tar xf package.tar.xz

for model in $MODELS; do
  ../../mksapkg -E -s -m $model > /dev/null
done

# cleanup

# curl -L syno_arm_tarball

echo "Building ${APP_NAME} arm version ${VERSION}"

MODELS=""

echo "Move binaries"

RELEASE_DIR="../../packages/${APP_NAME}"
mkdir -p "${RELEASE_DIR}"
find .. -maxdepth 1 -name "*.bin*" -exec rename 's#\('$DATE'\)##' {} \;
mv ../*.bin "${RELEASE_DIR}"

echo "Bundle sources"
SRC_TAR="${RELEASE_DIR}/${APP_NAME}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR .


