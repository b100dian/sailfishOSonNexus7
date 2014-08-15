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

PKG=libhybris

echo "Building package for $PKG"
sudo mkdir -p $MER_ROOT/devel/mer-hybris
sudo chown -R $USER $MER_ROOT/devel/mer-hybris

cd $MER_ROOT/devel/mer-hybris
git clone https://github.com/mer-hybris/$PKG.git
cd $PKG
git submodule update
cd $PKG

mb2 -t $VENDOR-$DEVICE-armv7hl -s ../rpm/$PKG.spec build

mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG

createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref

sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-build -R zypper rm mesa-llvmpipe
