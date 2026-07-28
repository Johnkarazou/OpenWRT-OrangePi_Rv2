# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2020 Sarah Maedel

# FIT will be loaded at 0x02080000. Leave 16M for that, align it to 2M and load the kernel after it.
KERNEL_LOADADDR := 0x03200000

define Device/x1_orangepi-rv2
  DEVICE_VENDOR := KY
  DEVICE_MODEL := Orange Pi RV 2
  SOC := x1
  DEVICE_PACKAGES := kmod-usb-net-rtl8152 u-boot-orangepi-rv2-x1
endef
TARGET_DEVICES += x1_orangepi-rv2

define Device/x1_orangepi-r2s
  DEVICE_VENDOR := KY
  DEVICE_MODEL := Orange Pi R2S
  SOC := x1
  DEVICE_PACKAGES := kmod-usb-net-rtl8152 kmod-r8169 u-boot-orangepi-r2s-x1
endef
TARGET_DEVICES += x1_orangepi-r2s
