# ANNOUNCEMENT AUG 2020

I (Stefaan / TFL) am refactoring this repo for compatibility with OS5. Please use issues tab if something is broken.

Several OS5 packages are now available on CloudSmith. The wdcommunity website is still to be updated.

[![Hosted By: Cloudsmith](https://img.shields.io/badge/OSS%20hosting%20by-cloudsmith-blue?logo=cloudsmith&style=for-the-badge)](https://cloudsmith.com)


# wdpksrc

This project contains the source and tools for software packages for Western Digital My Cloud (OS3) NAS devices. The packages are made available via the [WDCommunity website][WDCommunity]. Most of the packages are simply scripts to fetch the applications from the official sources and configure them with a sensible default. Only a few packages were compiled with the OS3 toolchain with the help of the [SynoCommunity][SynoCommunity] project tools.

Most of the packages are published on the WD `community forum`_ in their own thread. Use the search bar.

# Setup Development Environment

## mksapkg setup

For simple script based apps (most of the current packages), you only need mksapkg to create a binary.

On Ubuntu 18.04:

.. code::

    apt-get install libxml2 openssl

## Docker

The build environment is also available in a docker image.

.. code::

    docker build -t wdpk .    
    docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash    
    cd wdpk/<somepackage>    
    ./build.sh
    
### Build and deploy test

.. code::

    ./build_and_install.sh  <package>  <host>

This builds the package, installs it on a PR4100 host device and runs a sanity check if a test is available.

### Native apps

If you want to compile native apps, you'll need a complete wdpksrc / spksrc toolchain.  

Currently, these custom WD targets are available in this `SynoCommunity fork`_

* wdx64 - WD PR2100/PR4100/DL2100/DL4100
* wdpro - WD PR2100 / PR4100 with 4.1.9 kernel
* wddl - WD DL2100 / DL4100 with 3.10.28 kernel
* wdarm - all other devices (firmware version 2.x only!)

**UPDATE**: it now creates WD binary packages right away. 

* add xor_checksum to your PATH (copy it to /usr/local/bin)
* ``cd wdpk/someapp``
* ``make apkg-wdarm``
* packages are available in ``packages`` directory

Some installer script changes might be necessary.


# Hosting

Package repository hosting is graciously provided by  [Cloudsmith](https://cloudsmith.com).
Cloudsmith is the only fully hosted, cloud-native, universal package management solution, that
enables your organization to create, store and share packages in any format, to any place, with total
confidence.


# Donate

Thanks, but I'm good. Feel free to donate to these other projects instead

* [Allester Fox](https://fox-exe.ru/)
* * [SynoCommunity][SynoCommunity] project
* some charity

# License

When not explicitly set, files are placed under a [3 clause BSD license](http://www.opensource.org/licenses/BSD-3-Clause)


[community forum]: https://community.wd.com/c/network-attached-storage/wd-pro-series
[bug tracker]: https://github.com/WDCommunity/wdpksrc/issues
[CONTRIBUTING]: https://github.com/WDCommunity/wdpksrc/blob/master/CONTRIBUTING.md
[Developers HOW TO]: https://github.com/WDCommunity/wdpksrc/wiki/Developers-HOW-TO
[Docker installation]: https://docs.docker.com/engine/installation
[FAQ]: https://github.com/WDCommunity/wdpksrc/wiki/Frequently-Asked-Questions
[Install Docker with wget]: https://docs.docker.com/linux/step_one
[SynoCommunity]: https://github.com/SynoCommunity/spksrc
[SynoCommunity fork]: https://github.com/stefaang/spksrc
[WDCommunity]: http://www.wdcommunity.com
