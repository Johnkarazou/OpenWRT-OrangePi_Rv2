include $(TOPDIR)/rules.mk

PKG_NAME:=iptables-wrappers
PKG_VERSION:=1.0
PKG_RELEASE:=1

include $(INCLUDE_DIR)/package.mk

define Package/iptables-wrappers
  SECTION:=net
  CATEGORY:=Network
  SUBMENU:=Firewall
  TITLE:=iptables-nft compatibility wrappers
  DEPENDS:=+iptables-nft
  PKGARCH:=all
endef

define Package/iptables-wrappers/description
  Provides missing ip4tables and ip6tables wrapper scripts for iptables-nft.
endef

define Build/Compile
	# Nothing to compile - we're just installing shell scripts
endef

define Package/iptables-wrappers/install
	$(INSTALL_DIR) $(1)/usr/sbin
	$(INSTALL_BIN) ./files/ip4tables $(1)/usr/sbin/
	$(INSTALL_BIN) ./files/ip6tables $(1)/usr/sbin/
endef

$(eval $(call BuildPackage,iptables-wrappers))
