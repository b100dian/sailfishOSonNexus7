#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

echo " Building the droid-hal-device rpm package"

if [ ! -d $ANDROID_ROOT ]; then
  echo "Error: CyanogenMod sources for mer-hybris not yet cloned locally, please use load_mer-hybris.sh to do so."
  exit 1
fi

cd $ANDROID_ROOT
# THE COMMAND BELOW WILL FAIL. It's normal, carry on with the next one.
# Explanation: force installing of build-requirements by specifying the
# .inc file directly, but build-dependencies will be pulled in via
# zypper, so that the next step has all macro definitions loaded
#mb2 -t $VENDOR-$DEVICE-armv7hl -s rpm/droid-hal-device.inc build
mb2 -t $VENDOR-$DEVICE-armv7hl -s rpm/droid-hal-$DEVICE.spec build

echo "Create a local rpm repository"
if [ $(ls RPMS/*${DEVICE}* | wc -l) -eq 0 ]; then
  echo "Error: No RPMs found for droid-hal-$DEVICE"
  exit 1
fi

PKG=droid-hal-$DEVICE
mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/*.rpm
mv RPMS/*${DEVICE}* $ANDROID_ROOT/droid-local-repo/$DEVICE

createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE

echo "Add local RPM repo to Target"
sb2 -t $VENDOR-$DEVICE-armv7hl -R -m sdk-install \
ssu ar local-$DEVICE-hal file://$ANDROID_ROOT/droid-local-repo/$DEVICE

echo "Building the droid-hal-config rpm package"
mb2 -t $VENDOR-$DEVICE-armv7hl \
-s hybris/droid-hal-configs/rpm/droid-hal-configs.spec \
build

PKG=droid-hal-configs
mkdir -p $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/
rm -f $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG/*.rpm
mv RPMS/*.rpm $ANDROID_ROOT/droid-local-repo/$DEVICE/$PKG

createrepo $ANDROID_ROOT/droid-local-repo/$DEVICE
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref

