#!/bin/sh

APP_DIR=docker
CWD=`pwd`
VERSION=`awk '/Version/{print $NF}' apkg.rc`
echo "Building version $VERSION"

mksapkg -E -s -m MyCloudPR2100
mksapkg -E -s -m MyCloudPR4100

echo "Move binaries outside of vagrant"
cd ..
mv MyCloud* /vagrant/bins
mv WDMy* /vagrant/bins

echo "Bundle sources"
SRC_TAR="${APP_DIR}_src_${VERSION}.tar.gz"
tar czf $SRC_TAR $APP_DIR

echo "Move source tar outside of vagrant"
mv $SRC_TAR /vagrant/bins
cd $APP_DIR
