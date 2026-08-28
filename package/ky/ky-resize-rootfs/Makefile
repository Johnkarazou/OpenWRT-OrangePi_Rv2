# SPDX-License-Identifier: GPL-2.0-only
#
# Copyright (C) 2026 Johnkarazou

include $(TOPDIR)/rules.mk

PKG_NAME:=ky-resize-rootfs
PKG_VERSION:=1.0
PKG_RELEASE:=1
PKGARCH:=all

include $(INCLUDE_DIR)/package.mk

define Package/ky-resize-rootfs
  SECTION:=base
  CATEGORY:=Base system
  TITLE:=Grow root partition to full card size on first boot
  DEPENDS:=@TARGET_ky +fdisk +partx-utils +losetup +mount-utils
endef

define Package/ky-resize-rootfs/description
  Runs at the earliest possible moment (preinit hook, before the fstools
  overlay is set up): grows the rootfs partition to fill the entire
  SD/eMMC card via fdisk + partx, so the writable overlay is created at
  full size on the very first boot. If the kernel cannot adopt the new
  partition size online, it force-reboots BEFORE the overlay would be
  formatted small. Never runs fsck on mounted filesystems.

  Disable it in "make menuconfig" if you prefer a fixed partition layout.
endef

define Build/Compile
endef

define Package/ky-resize-rootfs/install
	$(INSTALL_DIR) $(1)/usr/bin
	$(INSTALL_BIN) ./files/resize-rootfs.sh $(1)/usr/bin/resize-rootfs.sh
	$(INSTALL_DIR) $(1)/lib/preinit
	$(INSTALL_BIN) ./files/79_resize_rootfs $(1)/lib/preinit/
endef

$(eval $(call BuildPackage,ky-resize-rootfs))
