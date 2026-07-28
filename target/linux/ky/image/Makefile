# SPDX-License-Identifier: GPL-2.0-only

include $(TOPDIR)/rules.mk
include $(INCLUDE_DIR)/image.mk

DEVICE_VARS += UBOOT_DEVICE_NAME

define Build/Compile
	$(CP) $(LINUX_DIR)/COPYING $(KDIR)/COPYING.linux
endef

### Image scripts ###
define Build/boot-common
	# This creates a new folder copies the dtb (as rockchip.dtb) 
	# and the kernel image (as kernel.img)
	rm -fR $@.boot
	mkdir -p $@.boot

	$(CP) $(DTS_DIR)/$(DEVICE_DTS).dtb $@.boot/ky.dtb
	$(CP) $(IMAGE_KERNEL) $@.boot/kernel.img
	#$(CP) $(STAGING_DIR_IMAGE)/uInitrd $@.boot/uInitrd
endef

define Build/boot-script
	# Make an U-boot image and copy it to the boot partition
	mkimage -A riscv -O linux -T script -C none -a 0 -e 0 -d $(if $(1),$(1),default).bootscript $@.boot/boot.scr
endef

define Build/ky-sd-img
	# Creates the final SD/eMMC images, 
	# combining boot partition, root partition as well as the u-boot bootloader

	# Generate a new partition table in $@ with 16 MiB (32768 sectors) of 
	# alignment padding for the bootloader components to fit.
	PADDING=1 $(SCRIPT_DIR)/gen_image_generic.sh \
		$@ \
		$(CONFIG_TARGET_KERNEL_PARTSIZE) $@.boot \
		$(CONFIG_TARGET_ROOTFS_PARTSIZE) $(IMAGE_ROOTFS) \
		32768

	# Copy the bootloader components to the image at their respective sectors
	dd if="$(STAGING_DIR_IMAGE)"/bootinfo_sd.bin of="$@" seek=0 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/FSBL.bin of="$@" seek=256 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/u-boot-env-default.bin of="$@" seek=768 conv=notrunc
	dd if="$(STAGING_DIR_IMAGE)"/u-boot-opensbi.itb of="$@" seek=1664 conv=notrunc
endef

### Devices ###
define Device/Default
  PROFILES := Default
  KERNEL = kernel-bin
  BOOT_SCRIPT := orangepi-rv2
  IMAGES := factory.img.gz sysupgrade.img.gz
  IMAGE/factory.img.gz = boot-common | boot-script $$(BOOT_SCRIPT) | ky-sd-img | gzip
  IMAGE/sysupgrade.img.gz = boot-common | boot-script $$(BOOT_SCRIPT) | ky-sd-img | gzip | append-metadata
  DEVICE_DTS = ky/$$(SOC)_$(lastword $(subst _, ,$(1)))
  UBOOT_DEVICE_NAME = $(lastword $(subst _, ,$(1)))-$$(SOC)
endef

include $(SUBTARGET).mk

$(eval $(call BuildImage))
