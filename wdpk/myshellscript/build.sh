#!/bin/sh

APP_NAME="$(basename $(pwd))"
DATE="$(date +"%m%d%Y")"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"

echo "Building ${APP_NAME} version ${VERSION}"

RELEASE_DIR="../../packages/${APP_NAME}/OS5"
mkdir -p "${RELEASE_DIR}"

MODELS="WDMyCloudEX4100-EX4100 WDMyCloudDL4100-DL4100 WDMyCloudEX2100-EX2100 WDMyCloudDL2100-DL2100
        WDMyCloudMirror-MirrorG2 MyCloudEX2Ultra-EX2Ultra MyCloudPR4100-PR4100 MyCloudPR2100-PR2100"

for fullmodel in $MODELS; do
  model=${fullmodel%-*}
  name=${fullmodel#*-}
  echo "$model  $name"
  ../../mksapkg-OS5 -E -s -m $model
  mv ../${model}*.bin* "${RELEASE_DIR}/${APP_NAME}_${VERSION}_${name}.bin"
done

echo "Bundle sources"
SRC_TAR="${RELEASE_DIR}/${APP_NAME}_${VERSION}_src.tar.gz"
tar -czf $SRC_TAR .


