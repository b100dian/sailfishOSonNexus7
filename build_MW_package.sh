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

cd $MER_ROOT/devel/mer-hybris
git clone https://github.com/mer-hybris/$PKG.git
git submodule update
cd $PKG

mb2 -t $VENDOR-$DEVICE-armv7hl -s ../rpm/$PKG.spec build

LOCAL_ANDROID_ROOT=/parentroot$ANDROID_ROOT
mkdir -p $LOCAL_ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $LOCAL_ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $LOCAL_ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG
createrepo $LOCAL_ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install zypper ref
