#!/bin/bash
[ -f /tmp/debug_apkg ] && echo "APKG_DEBUG: $0 $@ $PWD" >> /tmp/debug_apkg

export ZEROTIER_HOME=/mnt/HD/HD_a2/.systemfile/zerotier
mkdir -p "$ZEROTIER_HOME"

$1/bin/zerotier-one -d
