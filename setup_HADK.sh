#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

sudo zypper in android-tools createrepo zip

echo "Downloading and extracting the ubuntu-trusty-android-rootfs"
mkdir -p $TEMP
cd $TEMP
TARBALL=ubuntu-trusty-android-rootfs.tar.bz2
curl -O http://img.merproject.org/images/mer-hybris/ubu/$TARBALL
UBUNTU_CHROOT=$MER_ROOT/sdks/ubuntu
sudo mkdir -p $UBUNTU_CHROOT
sudo tar --numeric-owner -xvjf $TARBALL -C $UBUNTU_CHROOT > /dev/null
cd - > /dev/null

