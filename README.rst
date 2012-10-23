Created by `Renato Cunha <http://twitter.com/trovao>`

========
Overview
========

There seems to be too many sources of (mis)information around the Internet
regarding the building of FFmpeg for Android. This *very simple* script is my
take on that issue. Hopefully, this will enable more people to test and start
developing with FFmpeg for Android.

If you just want to get started and don't want to build anything else, check
the `download page`_.

Setup
=====

You will need the `Android NDK`_ version r8 or later to use this script. In
addition to that, you will need mercurial to clone this repository and git to
download the source code of FFmpeg and libx264.

- On Debian/Ubuntu, "apt-get install git mercurial yasm bash make gawk" should
  get you going.
- On Arch Linux, you can install the `NDK from the AUR`_. If you use yaourt,
  "yaourt -S android-ndk git mercurial yasm bash make gawk" should do the
  trick.

Once the dependencies are installed, just enter this directory and type::

    $ ./build.sh

If everything goes well, you should have the latest version of FFmpeg for
ARMv6, ARMv7a, and ARMv7a with NEON support in the dist directory.

Features
========

There aren't many, really. Here they are:

- All you get is FFmpeg + libx264 for Android ARM;
- The script only downloads the last version of FFmpeg and libx264;
- The script is straightforward.

Sources of inspiration
======================

- https://github.com/guardianproject/android-ffmpeg
- https://github.com/tito/ffmpeg-android

.. LINKS

.. _`Android NDK`: http://developer.android.com/tools/sdk/ndk/index.html
.. _`NDK from the AUR`: https://aur.archlinux.org/packages.php?ID=27656
.. _`download page`: https://bitbucket.org/trovao/ffmpeg-android/downloads

