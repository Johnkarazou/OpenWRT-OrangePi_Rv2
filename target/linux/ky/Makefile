# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk

BOARD:=ky
BOARDNAME:=Ky
FEATURES:=ext4 audio usb usbgadget display gpio fpu pci pcie rootfs-part boot-part squashfs
SUBTARGETS:=riscv64

KERNEL_PARTSIZE:=64
ROOTFS_PARTSIZE:=256

KERNEL_PATCHVER:=6.6

define Target/Description
	Build firmware image for Ky SoC devices.
endef

include $(INCLUDE_DIR)/target.mk

# For easy usage
DEFAULT_PACKAGES.tweak:=\
	bash \
	block-mount \
	fdisk \
	parted \
	f2fs-tools \
	f2fsck \
	resize2fs \
	losetup \
	mount-utils \
	kmod-nf-nathelper \
	kmod-nf-nathelper-extra \
	luci \
	luci-compat \
	luci-lib-base \
	luci-lib-fs \
	luci-lib-ipkg

DEFAULT_PACKAGES += uboot-envtools partx-utils e2fsprogs mkf2fs kmod-gpio-button-hotplug
DEFAULT_PACKAGES += ky-resize-rootfs
DEFAULT_PACKAGES += $(DEFAULT_PACKAGES.tweak)

KERNELNAME:=Image dtbs

$(eval $(call BuildTarget))
