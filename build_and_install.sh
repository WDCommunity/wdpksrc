#!/bin/bash

PACKAGE=$1


# create packages
docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash -c "cd wdpk/$PACKAGE; ./build.sh; chown -R 1000:1000 ../../packages/$PACKAGE"

# find latest package
PRODUCT="PR4100"  # TODO: use env

BINARY=$(find -name "*$PRODUCT*$PACKAGE*.bin" | sort | head -n1)
echo "Created $BINARY"

TARGET=$2

[[ -z $TARGET ]] && exit 0

scp $BINARY root@$TARGET:/mnt/HD/HD_a2/.systemfile/upload/app.bin
cssh='ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null'
$cssh root@$TARGET "/usr/local/modules/usrsbin/upload_apkg -rapp.bin -d -f1 -g1"


