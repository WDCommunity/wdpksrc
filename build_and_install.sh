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
#    target: the host to install it on
#
# It's recommended to setup entware + ssh keys first
#    ssh-copy-id root@host
#
# Author: TFL

PACKAGE=$1
# TODO: add docstring / help
# TODO: check if this docker image exists

# create packages
docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash -c "cd wdpk/$PACKAGE; ./build.sh; chown -R 1000:1000 ../../packages/$PACKAGE"

# find latest package
PRODUCT="PR4100"  # TODO: use env

BINARY=$(find -name "*$PRODUCT*$PACKAGE*.bin" | sort | head -n1)
echo "Created $BINARY"

TARGET=$2

[[ -z $TARGET ]] && exit 0

# upload the app
scp $BINARY root@$TARGET:/mnt/HD/HD_a2/.systemfile/upload/app.bin

cssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'

# install the app
$cssh root@$TARGET "/usr/local/modules/usrsbin/upload_apkg -rapp.bin -d -f1 -g1"

# run test hooks
cd wdpk/$PACKAGE
./test.sh
