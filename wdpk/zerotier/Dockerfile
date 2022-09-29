FROM rustembedded/cross:arm-unknown-linux-gnueabihf
# renovate: datasource=github-releases depName=zerotier/ZeroTierOne
ENV ZEROTIER_VERSION=1.10.1
ENV ZEROTIER_URL="https://github.com/zerotier/ZeroTierOne/archive/refs/tags/${ZEROTIER_VERSION}.tar.gz"
RUN cd /usr/src \
    && curl -sL "$ZEROTIER_URL" -o zerotier.tar.gz \
    && tar zxvf zerotier.tar.gz --strip-components=1 \
    && rm zerotier.tar.gz
ENV CC=arm-linux-gnueabihf-gcc
ENV CXX=arm-linux-gnueabihf-g++
ENV STRIP=arm-linux-gnueabihf-strip
