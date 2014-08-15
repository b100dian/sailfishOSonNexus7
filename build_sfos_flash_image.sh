#!/bin/bash

# This script is supposed to be run in the Mer SDK environment
if [ ! -d "/parentroot" ]; then
  echo "Error: Run this script in the Mer SDK chroot environment"
  exit 1
fi
if [ -d "/parentroot/parentroot" ]; then
  echo "Error: Don't run this script in the HABuildSDK chroot environment"
  exit 1
fi

echo "Building an flash image with MIC"
# always aim for the latest Sailfish OS version which comes from the command line
RELEASE=$1

# WARNING: EXTRA_NAME currently does not support '.' dots in it!
EXTRA_NAME=-myfirst
sudo mic create fs --arch armv7hl \
--tokenmap=ARCH:armv7hl,RELEASE:$RELEASE,EXTRA_NAME:$EXTRA_NAME \
--record-pkgs=name,url \
--outdir=sfa-mako-ea-$RELEASE$EXTRA_NAME \
--pack-to=sfa-mako-ea-$RELEASE$EXTRA_NAME.tar.bz2 \
$ANDROID_ROOT/tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks
