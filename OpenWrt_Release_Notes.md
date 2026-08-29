# OpenWrt 25.12 for Orange Pi RV2 (August 2026 Update)

The newest stable release of the custom OpenWrt firmware for the Orange Pi RV2 (Ky X1, riscv64).

This release introduces major quality-of-life improvements, including automatic root partition resizing on the first boot and a fully customized Attended Sysupgrade UI that integrates seamlessly with GitHub.

### 🌟 What's New in this Release

*   **Auto-Resizing Root Filesystem:**
    The firmware now includes the new `ky-resize-rootfs` package. On the very first boot, the system will automatically use `fdisk` and `partx` to expand the root partition to fill your entire SD or eMMC card before creating the writable overlay. (Note: This applies to **SquashFS** images only).
*   **GitHub-Integrated Attended Sysupgrade:**
    *(Note: This custom UI is currently experimental and may not work perfectly in all setups. If it fails, you can still upgrade manually via System -> Backup / Flash Firmware).*
    The LuCI Attended Sysupgrade page has been completely rewritten to support offline environments without an OpenWrt image builder. The router will now check this GitHub repository directly for new firmware releases and provide you with a direct download link when a new version is available!
*   **Kernel Fixes:**
    Restored `DEVTMPFS` kernel support that was dropped in recent upstream target updates, resolving the early boot kernel panics (`Attempted to kill init`).

### 📦 Which Image Should I Download?

Attached below are 4 firmware images. Choose the one that matches your situation:

#### 1. SquashFS vs Ext4
*   **SquashFS (Recommended):** Uses a read-only base system with a writable overlay. **Supports the new automatic full-card resize on first boot.** Also allows you to easily "factory reset" your router if you make a mistake.
*   **Ext4:** A traditional, fully-writable Linux filesystem. **Does NOT support the auto-resize feature** (it will remain exactly 2048 MB unless you manually resize it offline using GParted). Does not support factory resets.

#### 2. Factory vs Sysupgrade
*   **Factory (`*-factory.img.gz`):** Use this if you are flashing the SD card from scratch using a tool like balenaEtcher, Rufus, or `dd`.
*   **Sysupgrade (`*-sysupgrade.img.gz`):** Use this if you are already running an older version of this OpenWrt firmware and are updating via the LuCI web interface (System -> Backup / Flash Firmware). This will preserve your existing settings.

### ⚙️ Upgrade Instructions

**If upgrading from a previous OpenWrt build:**
1. Download the `openwrt-ky-riscv64-x1_orangepi-rv2-squashfs-sysupgrade.img.gz` (or ext4) file.
2. Log into your router's LuCI web interface.
3. Navigate to **System -> Backup / Flash Firmware**.
4. Scroll down to **Flash new firmware image**.
5. Upload the downloaded `.img.gz` file.
6. Ensure **"Keep settings and retain the current configuration"** is checked.
7. Click **Flash image...** and wait for the router to reboot.

*Remember to download the `sha256sums` file and verify your downloads before flashing!*
