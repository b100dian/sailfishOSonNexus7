#!/bin/bash

TEMP=$HOME/temp
SFFE_SB2_TARGET=/parentroot$MER_ROOT/targets/$VENDOR-$DEVICE-armv7hl
TARBALL_URL=http://releases.sailfishos.org/sdk/latest/targets/targets.json

echo "Set up SB2 target in Mer SDK"
hadk
cd $TEMP
TARBALL=$(curl $TARBALL_URL | grep 'armv7hl.tar.bz2' | cut -d\" -f4)
curl -O $TARBALL
sudo mkdir -p $SFFE_SB2_TARGET
sudo tar --numeric-owner -pxjf $(basename $TARBALL) -C $SFFE_SB2_TARGET
sudo chown -R $USER $SFFE_SB2_TARGET
cd $SFFE_SB2_TARGET
grep :$(id -u): /etc/passwd >> etc/passwd
grep :$(id -g): /etc/group >> etc/group
sb2-init -d -L "--sysroot=/" -C "--sysroot=/" \
-c /usr/bin/qemu-arm-dynamic -m sdk-build \
-n -N -t / $VENDOR-$DEVICE-armv7hl \
/opt/cross/bin/armv7hl-meego-linux-gnueabi-gcc

sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R rpm --rebuilddb
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ar \
-G http://repo.merproject.org/releases/mer-tools/rolling/builds/armv7hl/packages/ \
mer-tools-rolling
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref --force

echo " Building the droid-hal-device package"
ANDROID_ROOT=/parentroot/srv/mer/sdks/ubuntu/srv/mer/android/droid
cd $ANDROID_ROOT

# THE COMMAND BELOW WILL FAIL. It's normal, carry on with the next one.
# Explanation: force installing of build-requirements by specifying the
# .inc file directly, but build-dependencies will be pulled in via
# zypper, so that the next step has all macro definitions loaded
mb2 -t $VENDOR-$DEVICE-armv7hl -s rpm/droid-hal-device.inc build
mb2 -t $VENDOR-$DEVICE-armv7hl -s rpm/droid-hal-$DEVICE.spec build

echo "Create a local rpm repository"
mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/droid-hal-*rpm
mv RPMS/*${DEVICE}* $ANDROID_ROOT/droid-local-repo/$DEVICE
createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE

echo "Add local RPM repo to Target"
sb2 -t $VENDOR-$DEVICE-armv7hl -R -m sdk-install \
ssu ar local-$DEVICE-hal file://$ANDROID_ROOT/droid-local-repo/$DEVICE

echo "Package droid-hal-config into rpm package"
mb2 -t $VENDOR-$DEVICE-armv7hl \
-s hybris/droid-hal-configs/rpm/droid-hal-configs.spec \
build
