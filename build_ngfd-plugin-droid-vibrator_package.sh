#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

PKG=ngfd-plugin-droid-vibrator
SPEC=$PKG

cd $MER_ROOT/devel/mer-hybris
if [ ! -d $PKG ]; then
	git clone https://github.com/mer-hybris/$PKG.git
else
	git pull
fi

cd $PKG
mb2 -s rpm/$SPEC.spec -t $VENDOR-$DEVICE-armv7hl build

if [ $(ls RPMS/*.rpm | wc -l) -eq 0 ]; then
	echo "Error: No RPMs found for $PKG"
	exit 1
fi

mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG

createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install zypper ref
