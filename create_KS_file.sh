#!/bin/bash

. common_functions

# This script is supposed to be run in the Mer SDK environment
checkMerSDK

echo "Generate and configure a kickstart file"
cd $ANDROID_ROOT
mkdir -p tmp
HA_REPO="repo --name=adaptation0-$DEVICE-@RELEASE@"
sed -e \
"s|^$HA_REPO.*$|$HA_REPO --baseurl=file://$ANDROID_ROOT/droid-local-repo/$DEVICE|" \
$ANDROID_ROOT/installroot/usr/share/kickstarts/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks \
> tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

# Don't take packages from Mer OBS repos
#MOBS_URI="http://repo.merproject.org/obs"
#HA_REPO="repo --name=adaptation0-$DEVICE-@RELEASE@"
#HA_REPO1="repo --name=adaptation1-$DEVICE-@RELEASE@ \
#--baseurl=$MOBS_URI/sailfishos:/devel:/hw:/mako/sailfish_latest_@ARCH@/"
#sed -i -e "/^$HA_REPO.*$/a$HA_REPO1" tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

# Add openrepos.net for warehouse client
HA_REPO="repo --name=adaptation0-$DEVICE-@RELEASE@"
OPENREPOS="repo --name=openrepos \
--baseurl=http://sailfish.openrepos.net/basil/personal/main/"
sed -i -e "/^$HA_REPO.*$/a$OPENREPOS" tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks
sed -i -e "/^%packages/aharbour-warehouse" tmp/Jolla-@RELEASE@-$DEVICE-@ARCH@.ks

# TODO: Enable 5 icons in a row in Homescreen
# /usr/share/lipstick-jolla-home-qt5/qml/launcher/LauncherGrid.qml
# property int column: 4 -> 5

#echo "Add grouper as new device"
#rpm/helpers/add_new_device.sh

echo "Process all patterns"
rpm/helpers/process_patterns.sh


