FROM rustembedded/cross:arm-unknown-linux-gnueabihf
RUN cd /usr/src && curl -sLO https://github.com/zerotier/ZeroTierOne/archive/refs/tags/1.6.4.tar.gz && tar zxvf 1.6.4.tar.gz && rm 1.6.4.tar.gz
ENV CC=arm-linux-gnueabihf-gcc
ENV CXX=arm-linux-gnueabihf-g++
ENV STRIP=arm-linux-gnueabihf-strip
