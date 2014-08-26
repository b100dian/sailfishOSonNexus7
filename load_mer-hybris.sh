#!/bin/bash

. common_functions

# This script is supposed to be run in the HABuild SDK (Android build chroot)
checkHABuildSDK

# checkout repo only if it does not exists locally
if [ ! -d $ANDROID_ROOT ]; then
  mkdir -p $ANDROID_ROOT
  cd $ANDROID_ROOT
  repo init -u git://github.com/mer-hybris/android.git -b hybris-10.1
else
  cd $ANDROID_ROOT
fi

repo sync
source build/envsetup.sh
export USE_CCACHE=1
breakfast $DEVICE
rm .repo/local_manifests/roomservice.xml

