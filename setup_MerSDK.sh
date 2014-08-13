#!/bin/bash

# This script is supposed to be run in a native terminal on your Linux host computer
if [ -d "/parentroot" ]; then
  echo "Error: Don\'t run this script in a chroot environment"
  exit 1
fi

MER_ROOT=/srv/mer
TEMP=$HOME/temp
VENDOR=asus
DEVICE=grouper
ANDROID_ROOT=$MER_ROOT/android/droid

echo 
echo "Mer root directory will be "$MER_ROOT
echo "Downloading chroot env from merproject.org"
mkdir -p $TEMP
cd $TEMP
curl -k -O https://img.merproject.org/images/mer-sdk/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd - > /dev/null

echo "Extracting Mer SDK to "$MER_ROOT"/sdks/sdk"
sudo mkdir -p $MER_ROOT/sdks/sdk
cd $MER_ROOT/sdks/sdk
sudo tar --numeric-owner -p -xjf $TEMP/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd - > /dev/null

echo "Finishing Mer SDK setup"
echo "export MER_ROOT=$MER_ROOT" >> $HOME/.bashrc
echo "alias mersdk=$MER_ROOT/sdks/sdk/mer-sdk-chroot" >> $HOME/.bashrc

cat <<'EOF' >> $HOME/.mersdk.profile
export PS1="MerSDK $PS1"
if [ -d /etc/bash_completion.d ]; then
   for i in /etc/bash_completion.d/*;
   do
    . $i
   done
fi
EOF

cat <<EOF > $HOME/.mersdk.env
export MER_ROOT=/parentroot$MER_ROOT
export ANDROID_ROOT=/parentroot$ANDROID_ROOT
export VENDOR=$VENDOR
export DEVICE=$DEVICE
export TEMP=$TEMP
EOF

echo "Setting up HADK environment"
cat <<EOF > $HOME/.hadk.env
export MER_ROOT=/parentroot/parentroot$MER_ROOT
export ANDROID_ROOT=/parentroot/parentroot$ANDROID_ROOT
export VENDOR=$VENDOR
export DEVICE=$DEVICE
EOF

cat <<'EOF' >> $HOME/.mersdkubu.profile
function hadk() { source $HOME/.hadk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
export PS1="HABuildSDK [\${DEVICE}] $PS1"
hadk
EOF

cat <<'EOF' >> $HOME/.mersdk.profile
function hadk() { source $HOME/.mersdk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
function hadk-chroot() { ubu-chroot -r /parentroot$MER_ROOT/sdks/ubuntu ; }
hadk
EOF

exec bash

