#!/bin/bash

. common_functions

# This script is supposed to be run in the HABuild SDK (Android build chroot)
checkHABuildSDK

sudo mkdir -p $ANDROID_ROOT
sudo chown -R $USER $ANDROID_ROOT
cd $ANDROID_ROOT
repo init -u git://github.com/mer-hybris/android.git -b hybris-10.1
repo sync
source build/envsetup.sh
export USE_CCACHE=1
breakfast $DEVICE
rm .repo/local_manifests/roomservice.xml
make -j4 hybris-hal

