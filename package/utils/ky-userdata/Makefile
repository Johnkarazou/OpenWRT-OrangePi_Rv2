include $(TOPDIR)/rules.mk

PKG_NAME:=ky-userdata
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/ky-userdata
  SECTION:=utils
  CATEGORY:=Utilities
  TITLE:=Auto-create userdata partition on first boot
  DEPENDS:=+block-mount +e2fsprogs +fdisk
endef

define Package/ky-userdata/description
  Automatically detects remaining unallocated disk space on the boot drive
  and creates an ext4 /userdata partition on first boot.
endef

define Build/Compile
endef

define Package/ky-userdata/install
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_BIN) ./files/99-auto-userdata $(1)/etc/uci-defaults/
endef

$(eval $(call BuildPackage,ky-userdata))
