#!/bin/bash

. common_functions

# This script is supposed to be run in the HABuild SDK (Android build chroot)
checkHABuildSDK

if [ ! -d $ANDROID_ROOT ]; then
  echo "Error: CyanogenMod sources for mer-hybris not yet cloned locally, please use load_mer-hybris.sh to do so."
  exit 1
fi

cd $ANDROID_ROOT

# Check if kernel config is suitable for mer
KERNEL_CHECK=$(hybris/mer-kernel-check/mer_verify_kernel_config out/target/product/grouper/obj/KERNEL_OBJ/.config)
if [ -n "$KERNEL_CHECK" ]; then
  echo "Kernel config is not suitable for mer please correct below issues in $ANDROID_ROOT/kernel/asus/grouper/arch/arm/configs/cyanogenmod_grouper_defconfig"""
  echo
  echo $KERNEL_CHECK
  exit 1
fi

# Now build the kernel, initrd, bionic libc and other stuff needed for mer
echo "Kernel config is ok, build hybris-hal now"

source build/envsetup.sh
export USE_CCACHE=1
breakfast $DEVICE
rm .repo/local_manifests/roomservice.xml
make -j4 hybris-hal
