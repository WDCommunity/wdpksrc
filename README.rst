wdpksrc
=======
This project contains the source and tools for software packages for Western Digital My Cloud (OS3) NAS devices. The packages are made available via the `WDCommunity website`_. Most of the packages are simply scripts to fetch the applications from the official sources and configure them with a sensible default. Only a few packages were compiled with the OS3 toolchain with the help of the `SynoCommunity`_ project tools.

Most of the packages are published on the WD `community forum`_ in their own thread. Use the search bar.

Setup Development Environment
-----------------------------

mksapkg setup
^^^^^^^^^^^^^

For simple script based apps (most of the current packages), you only need mksapkg to create a binary.

On Ubuntu 16.04:

.. code::

    apt-get install libxml2:i386
    
Ensure you have openssl v1.0.x, not openssl v1.1+ (as is the case on Ubuntu 18).

Docker
^^^^^^

The build environment is also available in a docker image.

.. code::

    docker build -t wdpk .    
    docker run -it -v $(pwd):/wdpksrc wdpk /bin/bash    
    cd wdpk/<somepackage>    
    ./build.sh
    
Build and deploy test
^^^^^^^^^^^^^^^^^^^^^

.. code::

    ./build_and_install.sh  <package>  <host>

This will build the package, install it on a PR4100 host device and run a sanity check if a test is available.

Native apps
^^^^^^^^^^^

If you want to compile native apps, you'll need a complete wdpksrc / spksrc toolchain.  

Currently, these custom WD targets are available in this `SynoCommunity fork`_

* wdx64 - WD PR2100/PR4100/DL2100/DL4100
* wdpro - WD PR2100 / PR4100 with 4.1.9 kernel
* wddl - WD DL2100 / DL4100 with 3.10.28 kernel
* wdarm - all other devices (firmware version 2.x only!)

**UPDATE**: it now creates WD binary packages right away. Some installer script changes might be necessary.

* add xor_checksum to your PATH (copy it to /usr/local/bin)
* ``cd wdpk/someapp``
* ``make apkg-wdarm``
* packages are available in ``packages`` directory

Once you have a development environment set up , you can start building packages, create new ones, or improve upon existing packages while making your changes available to other people.
See the `Developers HOW TO`_ for information on how to use spksrc.

Note that spksrc creates synology SPK packages... these need to be *simplified* to WD apps. 

* Rename the .spk package with the .tar extension
* Unpack with `tar xf somepackage.tar`
* Move the bins and libs to your wdpk somepackage
* Modify the start/stop scripts as necessary into the wdpk format, stripped from all synology specific logistics. In OS3, basically everything runs as root.

Donate
------
Feel free to donate to the SynoCommunity project, the major inspiration for this project.

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
