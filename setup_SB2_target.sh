#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

SFFE_SB2_TARGET=$MER_ROOT/targets/$VENDOR-$DEVICE-armv7hl
TARBALL_URL=http://releases.sailfishos.org/sdk/latest/targets/targets.json

echo "Set up SB2 target in Mer SDK"
cd $TEMP
TARBALL=$(curl $TARBALL_URL | grep 'armv7hl.tar.bz2' | cut -d\" -f4)
curl -O $TARBALL
mkdir -p $SFFE_SB2_TARGET
sudo tar --numeric-owner -pxjf $(basename $TARBALL) -C $SFFE_SB2_TARGET
sudo chown -R $USER $SFFE_SB2_TARGET
cd $SFFE_SB2_TARGET
grep :$(id -u): /etc/passwd >> etc/passwd
grep :$(id -g): /etc/group >> etc/group
sb2-init -d -L "--sysroot=/" -C "--sysroot=/" \
-c /usr/bin/qemu-arm-dynamic -m sdk-build \
-n -N -t / $VENDOR-$DEVICE-armv7hl \
/opt/cross/bin/armv7hl-meego-linux-gnueabi-gcc
cd - > /dev/null

sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R rpm --rebuilddb
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ar \
-G http://repo.merproject.org/releases/mer-tools/rolling/builds/armv7hl/packages/ \
mer-tools-rolling
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref --force

echo "Set the SB2 target to use an up-to-date repo"
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R ssu domain sales
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R ssu dr sdk
