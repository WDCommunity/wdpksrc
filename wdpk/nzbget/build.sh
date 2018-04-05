#!/bin/sh

APP_DIR="nzbget"
CWD="$(pwd)"
VERSION="$(awk '/Version/{print $NF}' apkg.rc)"
echo "Building version ${VERSION}"

../mksapkg -E -s -m MyCloudPR2100
../mksapkg -E -s -m MyCloudPR4100

echo "Move binaries"
cd ..
mkdir -p packages
mv MyCloud* packages

echo "Bundle sources"
SRC_TAR="${APP_DIR}_src_${VERSION}.tar.gz"
tar -czf $SRC_TAR $APP_DIR

cd "$APP_DIR"
