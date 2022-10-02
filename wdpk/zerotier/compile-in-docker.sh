#!/bin/bash
set -e
DOCKER="${DOCKER:-docker}"
mkdir -p bin
$DOCKER build -t zerotier .
$DOCKER run \
    -v $PWD/bin:/usr/src/bin --rm -it \
    -e ME="$(id -u):$(id -g)" \
    zerotier \
    bash -exc 'cd /usr/src/ \
    && make -j8 ZT_DISABLE_COMPRESSION=1 \
    && cp zerotier-one /usr/src/bin/ \
    && cd /usr/src/bin \
    && for link in zerotier-cli zerotier-idtool; do \
    ln -sf zerotier-one $link; \
    done \
    && chown -R $ME /usr/src/bin/'
