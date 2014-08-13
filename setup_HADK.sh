#!/bin/bash

# This script is supposed to be run in the Mer SDK environment
if [ -d "/parentroot" ]; then
  if [ ! -d "/parentroot/parentroot" ]; then
    sudo zypper in android-tools createrepo zip

    echo "Downloading and extracting the ubuntu-trusty-android-rootfs"
    hadk
    mkdir -p $TEMP
    cd $TEMP
    TARBALL=ubuntu-trusty-android-rootfs.tar.bz2
    curl -O http://img.merproject.org/images/mer-hybris/ubu/$TARBALL
    UBUNTU_CHROOT=$MER_ROOT/sdks/ubuntu
    sudo mkdir -p $UBUNTU_CHROOT
    sudo tar --numeric-owner -xvjf $TARBALL -C $UBUNTU_CHROOT > /dev/null
    cd - > /dev/null
  else
    echo "Error: Don't run this script in the HABuildSDK chroot environment"
    exit 1
  fi
else
  echo "Error: Run this script in the Mer SDK chroot environment"
  exit 1
fi
