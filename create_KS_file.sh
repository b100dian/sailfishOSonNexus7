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
cd $ANDROID_ROOT
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
rpm/helpers/process_patterns.sh