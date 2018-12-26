#!/bin/bash

set -e

mkdir -p cache
mkdir -p build

BUILD_DIR=build/linux-4.19.12
CONFIG_DIR=configs/4.19.12

if [ ! -d $BUILD_DIR ]; then
  if [ ! -f cache/linux-4.19.12.tar.xz ]; then
    curl -o cache/linux-4.19.12.tar.xz https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.19.12.tar.xz
  fi

  rm -rf $BUILD_DIR
  tar xf cache/linux-4.19.12.tar.xz -C build
fi

cp ${CONFIG_DIR}/rockchip_linux_defconfig ${BUILD_DIR}/arch/arm64/configs/rockchip_linux_defconfig
cp ${CONFIG_DIR}/rk3328-rock64.dts ${BUILD_DIR}/arch/arm64/boot/dts

cd $BUILD_DIR

make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- rockchip_linux_defconfig
make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- bindeb-pkg -j8

cd -
