#!/bin/sh

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} version ${VERSION}"

MODELS="WDMyCloudEX4 WDMyCloudEX2 WDMyCloudEX4100 WDMyCloudDL4100 WDMyCloudEX2100 WDMyCloudDL2100 MyCloudEX2Ultra MyCloudPR4100 MyCloudPR2100"

for model in $MODELS; do
  ../../mksapkg -E -s -m $model > /dev/null
done

echo "Move binaries"

mkdir -p ../../packages
find .. -maxdepth 1 -name "*.bin*" -exec rename 's#\('$DATE'\)##' {} \;
mv ../*.bin ../../packages

echo "Bundle sources"
SRC_TAR="../../packages/${APP_NAME}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR .


