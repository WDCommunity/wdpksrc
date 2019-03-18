#!/bin/bash
#
# Builds packages and installs it on a target platform
#
# Usage:
#
#  ./build_and_install package target
#
# with
#    package: a wdpk e.g. entware
#    target: the ssh host to install it on (defined in .ssh/config)
#
# It's recommended to setup entware + ssh keys first
#    ssh-copy-id root@host
#
# Author: TFL

PACKAGE=$1
# TODO: add docstring / help
# TODO: check if this docker image exists

# create packages
docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash -c "cd wdpk/$PACKAGE; ./build.sh ; chown -R 1000:1000 ../../packages/$PACKAGE"

# find latest package
PRODUCT="PR4100"  # TODO: use env

BINARY=$(find packages/$PACKAGE -name "*$PRODUCT*$PACKAGE*.bin" | sort | tail -n1)
echo "Created $BINARY"

TARGET=$2

[[ -z $TARGET ]] && exit 0

echo
echo "Upload the app"
scp $BINARY $TARGET:/mnt/HD/HD_a2/.systemfile/upload/app.bin

#cssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
cssh=ssh

echo
echo "Install the app"
$cssh $TARGET /bin/sh -c "/usr/sbin/upload_apkg -rapp.bin -d -f1 -g1 && echo OK!"


TEST=tests/$PACKAGE/test.sh
if [ -e $TEST ]; then
	echo
	echo "Run test hooks"
	export PACKAGE=$PACKAGE 
	export TARGET=$TARGET
    $TEST
else
	echo "No test found for $PACKAGE"
fi
