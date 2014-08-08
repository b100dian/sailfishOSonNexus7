#!/bin/bash
MER_ROOT=/srv/mer
TEMP=$HOME/temp
VENDOR=asus
DEVICE=grouper
ANDROID_ROOT=/srv/mer/android/droid

echo 
echo "Mer root directory will be "$MER_ROOT
echo "Downloading chroot env from merproject.org"
mkdir -p $TEMP
cd $TEMP
curl -k -O https://img.merproject.org/images/mer-sdk/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd -

echo "Extracting Mer SDK to "$MER_ROOT"/sdks/sdk"
sudo mkdir -p $MER_ROOT/sdks/sdk
cd $MER_ROOT/sdks/sdk
sudo tar --numeric-owner -p -xjf $TEMP/mer-i486-latest-sdk-rolling-chroot-armv7hl-sb2.tar.bz2 > /dev/null
cd -

echo "Finishing Mer SDK setup"
echo "export MER_ROOT=$MER_ROOT" >> $HOME/.bashrc
echo 'alias mersdk=$MER_ROOT/sdks/sdk/mer-sdk-chroot' >> $HOME/.bashrc
exec bash

cat <<'EOF' >> $HOME/.mersdk.profile
export PS1="MerSDK $PS1"
if [ -d /etc/bash_completion.d ]; then
   for i in /etc/bash_completion.d/*;
   do
    . $i
   done
fi
EOF

echo "Setting up HADK environment"
cat <<EOF > $HOME/.hadk.env
export MER_ROOT=$MER_ROOT
export ANDROID_ROOT=\$MER_ROOT/android/droid
export VENDOR=$VENDOR
export DEVICE=$DEVICE
EOF

cat <<'EOF' >> $HOME/.mersdkubu.profile
function hadk() { source $HOME/.hadk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
export PS1="HABUILD_SDK [\${DEVICE}] $PS1"
hadk
EOF

cat <<'EOF' >> $HOME/.mersdk.profile
function hadk() { source $HOME/.hadk.env${1:+.$1}; echo "Env setup for $DEVICE"; }
function hadk-chroot() { ubu-chroot -r /parentroot$MER_ROOT/sdks/ubuntu ; }
hadk
EOF
