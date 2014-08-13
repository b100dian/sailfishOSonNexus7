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

echo "Install the droid-hal-device headers into SB2"
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R \
zypper install droid-hal-$DEVICE-devel
