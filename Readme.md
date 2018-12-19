Freifunk Karlsruhe Firmware
===========================

How To Build
------------

This is building FFKA firmware in a nutshell. For more on options or building specific branches please refer to the build script, [the official Gluon repository](https://github.com/freifunk-gluon/gluon) at GitHub, or [the official Gluon documentation](http://gluon.readthedocs.org/).

To compile the firmware you need a working build environment and packages for git, subversion, gawk, unzip, ncurses headers and zlib headers.

On Debian GNU/Linux, install like this:

    sudo apt-get install git subversion python build-essential gawk unzip libz-dev libncurses-dev libssl-dev

Then download and build as follows:

    git clone git://github.com/freifunk-gluon/gluon.git         # Get the official Gluon repository
    cd gluon
    git clone https://github.com/ffka/site-ffka site   			# Get the Freifunk Karlsruhe site repository
    make update                                                 # Fetch all repositories
    ./site/build.sh

In order to get a more verbose output, e.g. in case of build errors, you can call

    ./site/build.sh -v

**Note** since gluon 2015.1 the firmware is built for multiple targets. Now you need at least 45 GB of free space!
