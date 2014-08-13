#!/bin/bash

# This script is supposed to be run in the Mer SDK environment
if [ ! -d "/parentroot" ]; then
  echo "Error: Run this script in the Mer SDK chroot environment"
  exit 1
fi
if [ -d "/parentroot/parentroot"]; then
  echo "Error: Don\'t run this script in the HABuildSDK chroot environment"
  exit 1
fi

PKG=$1

echo "Building package for $PKG"
sudo mkdir -p /parentroot$MER_ROOT/devel/mer-hybris
sudo chown -R $USER /parentroot$MER_ROOT/devel/mer-hybris
cd /parentroot$MER_ROOT/devel/mer-hybris

PKG=libhybris

cd $MER_ROOT/devel/mer-hybris
git clone https://github.com/mer-hybris/$PKG.git
git submodule update
cd $PKG

mb2 -t $VENDOR-$DEVICE-armv7hl -s ../rpm/$PKG.spec build

TODO ---> check $ANDROID_ROOT below

mkdir -p /parentroot$ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG
createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install zypper ref
