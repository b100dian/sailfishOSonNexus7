#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

PKG=sensorfw
SPEC=sensorfw-qt5-hybris
OTHER_RANDOM_NAME=hybris-libsensorfw-qt5

cd $MER_ROOT/devel/mer-hybris
git clone https://github.com/mer-hybris/$PKG.git
cd $PKG
mb2 -s rpm/$SPEC.spec -t $VENDOR-$DEVICE-armv7hl build
mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG

createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install zypper ref

