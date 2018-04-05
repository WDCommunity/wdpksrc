FROM debian:jessie
MAINTAINER WDCommunity <https://github.com/wdcommunity>

ENV LANG C.UTF-8

# Manage i386 arch
RUN dpkg --add-architecture i386

# Install required packages
RUN apt-get update \
    apt-get install libxml2:i386 \
                    automake
                    cmake
                    curl

# Volume pointing to spksrc sources
VOLUME /wdpksrc

WORKDIR /wdpksrc
