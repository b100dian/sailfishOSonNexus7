#!/bin/bash

. common_functions

# This script is supposed to be run in the HABuild SDK (Android build chroot)
checkHABuildSDK

cd $ANDROID_ROOT

# Check if kernel config is suitable for mer


# Now build the kernel, initrd, bionic libc and other stuff needed for mer
make -j4 hybris-hal

