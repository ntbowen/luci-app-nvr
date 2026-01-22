include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-nvr
PKG_VERSION:=20230818
PKG_RELEASE:=2

LUCI_TITLE:=LuCI Support for Network Video Recorder
LUCI_DESCRIPTION:=A LuCI application for network video recording using IP cameras.
LUCI_DEPENDS:=+luci-base +lsblk +coreutils-stat
LUCI_PKGARCH:=all

include $(TOPDIR)/feeds/luci/luci.mk

define Package/luci-app-nvr/conffiles
/etc/config/nvr
endef

define Package/luci-app-nvr/install
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view
	$(INSTALL_DATA) ./luasrc/controller/nvr.lua $(1)/usr/lib/lua/luci/controller/
	$(INSTALL_DATA) ./luasrc/model/cbi/nvr.lua $(1)/usr/lib/lua/luci/model/cbi/
	$(INSTALL_DATA) ./luasrc/view/nvr_status.htm $(1)/usr/lib/lua/luci/view/
	$(INSTALL_DIR) $(1)/usr/nvr
	$(INSTALL_BIN) ./files/nvr/* $(1)/usr/nvr
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_CONF) ./files/nvr.conf $(1)/etc/config/nvr
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_BIN) ./files/nvr.init $(1)/etc/init.d/nvr
endef

$(eval $(call BuildPackage,luci-app-nvr))

