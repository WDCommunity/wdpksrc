FROM debian:buster
LABEL maintainer="WDCommunity <https://github.com/wdcommunity>"

ENV LANG C.UTF-8

RUN apt-get update; \
    apt-get install openssl git wget cmake libxml2 -y

COPY mksapkg-OS* /usr/bin/

# Volume pointing to spksrc sources
VOLUME /wdpksrc

WORKDIR /wdpksrc
