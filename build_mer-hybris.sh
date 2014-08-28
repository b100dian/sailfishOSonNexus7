#!/bin/bash

. common_functions

# This script is supposed to be run in the HABuild SDK (Android build chroot)
checkHABuildSDK

if [ ! -d $ANDROID_ROOT ]; then
  echo "Error: CyanogenMod sources for mer-hybris not yet cloned locally, please use load_mer-hybris.sh to do so."
  exit 1
fi

cd $ANDROID_ROOT

# Now build the kernel, initrd, bionic libc and other stuff needed for mer
echo "Kernel config is ok, build hybris-hal now"

source build/envsetup.sh
export USE_CCACHE=1
breakfast $DEVICE
rm .repo/local_manifests/roomservice.xml
make -j4 hybris-hal

# Check if kernel config is suitable for mer
KERNEL_CHECK=$(hybris/mer-kernel-check/mer_verify_kernel_config out/target/product/grouper/obj/KERNEL_OBJ/.config 2>/dev/null)
if [ -n "$KERNEL_CHECK" ]; then
  echo
  echo "Kernel config is not suitable for Sailfish OS. Please correct below issues in $ANDROID_ROOT/kernel/asus/grouper/arch/arm/configs/cyanogenmod_grouper_defconfig"
  echo
  echo -e "$KERNEL_CHECK"
  exit 1
else
echo
  echo "Kernel config is ok. You can continue with building rpm packages."
  echo
  exit 0
fi
