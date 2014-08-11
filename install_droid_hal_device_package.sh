#!/bin/bash

echo "Install the droid-hal-device headers into SB2"
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R zypper ref
sb2 -t $VENDOR-$DEVICE-armv7hl -m sdk-install -R \
zypper install droid-hal-$DEVICE-devel
