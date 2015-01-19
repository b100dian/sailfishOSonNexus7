#!/bin/bash

. common_functions

# This script is supposed to be run in a native terminal on your Linux host computer
checkNativeTerminal

MER_ROOT=$HOME/mer-root
TEMP=$HOME/temp
VENDOR=asus
DEVICE=tilapia
ANDROID_ROOT=$MER_ROOT/android/droid
IMAGE_DEST=$MER_ROOT/sfos-image/$DEVICE
EXTRA_STRING=jobe

echo 
echo "Mer root directory will be "$MER_ROOT
echo "Downloading chroot env from merproject.org"
mkdir -p $TEMP
cd $TEMP
curl -k -O https://img.merproject.org/images/mer-sdk/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd - > /dev/null

echo "Extracting Mer SDK to "$MER_ROOT"/sdks/sdk"
mkdir -p $MER_ROOT/sdks/sdk
cd $MER_ROOT/sdks/sdk
sudo tar --numeric-owner -p -xjf $TEMP/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd - > /dev/null

echo "Setting up Mer environment"
sed -i '/export MER_ROOT=/d' ~/.bashrc
echo "export MER_ROOT=$MER_ROOT" >> $HOME/.bashrc
sed -i '/alias mersdk=/d' ~/.bashrc
echo "alias mersdk=$MER_ROOT/sdks/sdk/mer-sdk-chroot" >> $HOME/.bashrc

cat <<EOF > $HOME/.hadk.env
export MER_ROOT=$MER_ROOT
export ANDROID_ROOT=$ANDROID_ROOT
export VENDOR=$VENDOR
export DEVICE=$DEVICE
export TEMP=$TEMP

export IMAGE_DEST=$IMAGE_DEST
export EXTRA_STRING=$EXTRA_STRING
EOF

cat <<'EOF' > $HOME/.mersdkubu.profile
function hadk() { source $HOME/.hadk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
export PS1="\[\e[0;33m\]HABuildSDK [\${DEVICE}] $PS1\[\e[0m\]"
hadk
EOF

cat <<'EOF' > $HOME/.mersdk.profile
export PS1="\[\e[0;32m\]MerSDK [\${DEVICE}] \W$\[\e[0m\] "
if [ -d /etc/bash_completion.d ]; then
   for i in /etc/bash_completion.d/*;
   do
    . $i
   done
fi

function hadk() { source $HOME/.hadk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
function hadk-chroot() { ubu-chroot -r $MER_ROOT/sdks/ubuntu ; }
hadk
EOF

exec bash

