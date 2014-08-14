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

echo "Generate and configure a kickstart file"
mkdir -p tmp
HA_REPO="repo --name=adaptation0-$DEVICE-@RELEASE@"
sed -e \
"s|^$HA_REPO.*$|$HA_REPO --baseurl=file://$ANDROID_ROOT/droid-local-repo/$DEVICE|" \
$ANDROID_ROOT/installroot/usr/share/kickstarts/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks \
> tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

MOBS_URI="http://repo.merproject.org/obs"
HA_REPO="repo --name=adaptation0-$DEVICE-@RELEASE@"
HA_REPO1="repo --name=adaptation1-$DEVICE-@RELEASE@ \
--baseurl=$MOBS_URI/sailfishos:/devel:/hw:/$DEVICE/sailfish_latest_@ARCH@/"
sed -i -e "/^$HA_REPO.*$/a$HA_REPO1" tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

echo "Process all patterns"
hadk
rpm/helpers/process_patterns.sh

echo "Building an flash image with MIC"
# always aim for the latest:
RELEASE=1.0.8.19
# WARNING: EXTRA_NAME currently does not support '.' dots in it!
EXTRA_NAME=-myfirst
sudo mic create fs --arch armv7hl \
--tokenmap=ARCH:armv7hl,RELEASE:$RELEASE,EXTRA_NAME:$EXTRA_NAME \
--record-pkgs=name,url \
--outdir=sfa-mako-ea-$RELEASE$EXTRA_NAME \
--pack-to=sfa-mako-ea-$RELEASE$EXTRA_NAME.tar.bz2 \
$ANDROID_ROOT/tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks
