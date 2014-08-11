#!/bin/bash

echo "Install the droid-hal-device headers into SB2"
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install zypper ref
sb2 -t $VENDOR-$DEVICE-armv7hl -R -msdk-install \
zypper install droid-hal-$DEVICE-devel
