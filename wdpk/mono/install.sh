#!/bin/bash

LOG=/tmp/entware_install

echo "APKG_DEBUG: $0 $@" | tee -a $LOG

path_src=$1
NAS_PROG=$2

APKG_MODULE="mono"
APKG_PATH="${NAS_PROG}/${APKG_MODULE}"

# copy the WD entware package to App
mv ${path_src} ${NAS_PROG}

# unpack the archive
tar xf mono.tar.gz

# rm the archive
rm mono.tar.gz

# setup certificates
