#!/bin/bash

# This script is supposed to be run in the Mer SDK environment
if [ -d "/parentroot" ]; then
  if [ ! -d "/parentroot/parentroot"]; then
    sudo zypper in android-tools createrepo zip

    hadk
    TARBALL=ubuntu-trusty-android-rootfs.tar.bz2
    curl -O http://img.merproject.org/images/mer-hybris/ubu/$TARBALL
    UBUNTU_CHROOT=/parentroot$MER_ROOT/sdks/ubuntu
    sudo mkdir -p $UBUNTU_CHROOT
    sudo tar --numeric-owner -xvjf $TARBALL -C $UBUNTU_CHROOT
  else
    echo "Error: Don\'t run this script in the HABuildSDK chroot environment"
    exit 1
  fi
else
  echo "Error: Run this script in the Mer SDK chroot environment"
  exit 1
fi
