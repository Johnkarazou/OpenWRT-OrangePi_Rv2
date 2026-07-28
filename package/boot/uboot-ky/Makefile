# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2024 Ky LTD.
#

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/u-boot.mk

PKG_SOURCE_PROTO:=git
PKG_SOURCE_URL=https://github.com/orangepi-xunlong/u-boot-orangepi
PKG_SOURCE_DATE:=2022-10-ky
PKG_SOURCE_VERSION:=89bff4a7e4cadfb5f130edb1ec44c39bff20a427
PKG_MIRROR_HASH:=f14299e993fc35dc68a2e1dde5bded44fabe718d4af00b065d34a9fa58c1436b

include $(INCLUDE_DIR)/package.mk

define U-Boot/Default
  BUILD_TARGET:=ky
  BUILD_DEVICES=$(1)
  BUILD_SUBTARGET:=riscv64
  UBOOT_IMAGE:=u-boot-opensbi.itb
  DEFAULT:=y
endef

define U-Boot/orangepi-r2s-x1
  NAME:=X1 Orange Pi R2S
  BUILD_DEVICES:=x1_orangepi-r2s
endef

define U-Boot/orangepi-rv2-x1
  NAME:=X1 Orange Pi RV2
  BUILD_DEVICES:=x1_orangepi-rv2
endef

UBOOT_TARGETS := \
	orangepi-r2s-x1 \
	orangepi-rv2-x1

define Build/Configure
	# $(call Build/Configure/U-Boot)
	$(MAKE) -C $(PKG_BUILD_DIR) x1_defconfig
endef

define Build/InstallDev
	$(INSTALL_DIR) $(STAGING_DIR_IMAGE)

	$(INSTALL_BIN) $(PKG_BUILD_DIR)/$(UBOOT_IMAGE) $(STAGING_DIR_IMAGE)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/FSBL.bin $(STAGING_DIR_IMAGE)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/bootinfo*.bin $(STAGING_DIR_IMAGE)/
	$(INSTALL_BIN) $(PKG_BUILD_DIR)/u-boot-env-default.bin $(STAGING_DIR_IMAGE)/

endef

$(eval $(call BuildPackage/U-Boot))
