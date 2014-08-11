#!/bin/bash

sudo zypper in android-tools createrepo zip

hadk
TARBALL=ubuntu-trusty-android-rootfs.tar.bz2
curl -O http://img.merproject.org/images/mer-hybris/ubu/$TARBALL
UBUNTU_CHROOT=/parentroot$MER_ROOT/sdks/ubuntu
sudo mkdir -p $UBUNTU_CHROOT
sudo tar --numeric-owner -xvjf $TARBALL -C $UBUNTU_CHROOT
