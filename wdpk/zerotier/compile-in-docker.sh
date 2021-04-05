#!/bin/bash
set -e
docker build -t zerotier .
docker run \
    -v $PWD/bin:/usr/src/bin --rm -it \
    -e ME="$(id -u):$(id -g)" \
    zerotier \
    bash -exc 'cd /usr/src/ZeroTier* && make -j8 ZT_DISABLE_COMPRESSION=1 && cp zerotier-one /usr/src/bin/ && chown -R $ME /usr/src/bin/'

cd bin
for link in zerotier-cli zerotier-idtool;
do
    ln -sf zerotier-one $link
done
cd ..
