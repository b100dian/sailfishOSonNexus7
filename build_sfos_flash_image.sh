#!/bin/bash
# Usage e.g.: build_sfos_flash_image.sh 1.0.8.19

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

echo "Building an flash image with MIC"
# always aim for the latest Sailfish OS version which comes from the command line
RELEASE=$1

# WARNING: EXTRA_NAME currently does not support '.' dots in it!
EXTRA_NAME=-$EXTRA_STRING-$(date +%Y%m%d%H%M)
sudo mic create fs --arch armv7hl \
--tokenmap=ARCH:armv7hl,RELEASE:$RELEASE,EXTRA_NAME:$EXTRA_NAME \
--record-pkgs=name,url \
--outdir=sfa-$DEVICE-ea-$RELEASE$EXTRA_NAME \
--pack-to=sfa-$DEVICE-ea-$RELEASE$EXTRA_NAME.tar.bz2 \
$ANDROID_ROOT/tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks
