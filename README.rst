wdpksrc
=======
wdpksrc is a cross compilation framework intended to compile and package software for Western Digital NAS devices. Packages are made available via the `WDCommunity website`_. This is a fork of `SynoCommunity`_.

WDCommunity provides packages for Western Digital-branded NAS devices.
Packages are provided for free and made by developers on their free time. See how you can contribute.

Many packages are published on the WD `community forum`_.

Contributing
------------
Before opening a new issue, check the `FAQ`_ and search open issues.
If you can't find an answer, or if you want to open a package request, read `CONTRIBUTING`_ to make sure you include all the information needed for contributors to handle your request.


Setup Development Environment
-----------------------------

mksapkg setup
^^^^^^^^^^^^^

For simple script based apps (like most of the current packages), you only need mksapkg to create a binary.

On Ubuntu 16.04:

    apt-get install libxml2:i386
    
Ensure you have openssl v1.0.x, not openssl v1.1+.

Docker
^^^^^^

The build environment is also available in a docker image.

    docker build -t wdpk .
    docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash
    cd wdpk/<somepackage>
    ./build.sh

Native apps
^^^^^^^^^^^

If you want to compile native apps, you'll need a complete wdpksrc / spksrc toolchain. Then follow the 

Currently, these custom WD targets are available in this `SynoCommunity fork`_

* wdx64 - WD PR2100/PR4100/DL2100/DL4100
* wdpro - WD PR2100 / PR4100 with 4.1.9 kernel
* wddl - WD DL2100 / DL4100 with 3.10.28 kernel
* wdarm - all other devices (firmware version 2.x only!)

Usage
-----
Once you have a development environment set up , you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people.
See the `Developers HOW TO`_ for information on how to use spksrc.

Note that spksrc creates synology SPK packages. 

* rename the .spk package with the .tar extension
* unpack with `tar xf somepackage.tar`
* move the bins and libs to your wdpk somepackage
* modify the start/stop scripts as necessary into the wdpk format, stripped from all synology specific logics.

Donate
------
Feel free to donate to the SynoCommunity project.

License
-------
When not explicitly set, files are placed under a `3 clause BSD license`_


.. _3 clause BSD license: http://www.opensource.org/licenses/BSD-3-Clause
.. _community forum: https://community.wd.com/c/network-attached-storage/wd-pro-series
.. _bug tracker: https://github.com/WDCommunity/wdpksrc/issues
.. _CONTRIBUTING: https://github.com/WDCommunity/wdpksrc/blob/master/CONTRIBUTING.md
.. _Developers HOW TO: https://github.com/WDCommunity/wdpksrc/wiki/Developers-HOW-TO
.. _Docker installation: https://docs.docker.com/engine/installation
.. _FAQ: https://github.com/WDCommunity/wdpksrc/wiki/Frequently-Asked-Questions
.. _Install Docker with wget: https://docs.docker.com/linux/step_one
.. _SynoCommunity: https://github.com/SynoCommunity/spksrc
.. _SynoCommunity fork: https://github.com/stefaang/spksrc
.. _WDCommunity website: http://www.wdcommunity.com
