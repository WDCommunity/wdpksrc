FROM ubuntu:16.04
LABEL maintainer="WDCommunity <https://github.com/wdcommunity>"

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386; \
    apt-get update; \
    apt-get install openssl libxml2:i386 -y

# Volume pointing to spksrc sources
VOLUME /wdpksrc

WORKDIR /wdpksrc
