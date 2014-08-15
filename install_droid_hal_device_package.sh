#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

echo "Install the droid-hal-device headers into SB2"
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R \
zypper install droid-hal-$DEVICE-devel

