#!/bin/bash

# This script is supposed to be run in the HABuildSDK environment
if [ -d "/parentroot/parentroot" ]; then
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
else
  echo "Error: Run this script in the HABuildSDK chroot environment"
  exit 1
fi

