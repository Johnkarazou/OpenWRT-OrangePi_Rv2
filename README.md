![OpenWrt logo](include/logo.png)

OpenWrt Project is a Linux operating system targeting embedded devices. Instead
of trying to create a single, static firmware, OpenWrt provides a fully
writable filesystem with package management. This frees you from the
application selection and configuration provided by the vendor and allows you
to customize the device through the use of packages to suit any application.
For developers, OpenWrt is the framework to build an application without having
to build a complete firmware around it; for users this means the ability for
full customization, to use the device in ways never envisioned.

Sunshine!

## Download

Built firmware images are available for many architectures and come with a
package selection to be used as WiFi home router. To quickly find a factory
image usable to migrate from a vendor stock firmware to OpenWrt, try the
*Firmware Selector*.

* [OpenWrt Firmware Selector](https://firmware-selector.openwrt.org/)

If your device is supported, please follow the **Info** link to see install
instructions or consult the support resources listed below.

## 

An advanced user may require additional or specific package. (Toolchain, SDK, ...) For everything else than simple firmware download, try the wiki download page:

* [OpenWrt Wiki Download](https://openwrt.org/downloads)

## Development

To build your own firmware you need a GNU/Linux, BSD or macOS system (case
sensitive filesystem required). Cygwin is unsupported because of the lack of a
case sensitive file system.

### Requirements

You need the following tools to compile OpenWrt, the package names vary between
distributions. A complete list with distribution specific packages is found in
the [Build System Setup](https://openwrt.org/docs/guide-developer/build-system/install-buildsystem)
documentation.

```
asciidoc bash binutils bzip2 cmake flex git g++ gcc time util-linux gawk gzip help2man intltool libelf-dev zlib1g-dev make libncurses-dev libssl-dev patch perl-modules libthread-queue-any-perl python3-dev swig unzip wget gettext xsltproc libboost-dev libxml-parser-perl libusb-dev sharutils gcc-multilib openjdk-25-jdk-headless rsync zip device-tree-compiler
```
Copy-paste command below.
I use Debian 13:
```
sudo apt install -y asciidoc bash binutils bzip2 cmake flex git g++ gcc time util-linux gawk gzip help2man intltool libelf-dev zlib1g-dev make libncurses-dev libssl-dev patch perl-modules libthread-queue-any-perl python3-dev swig unzip wget gettext xsltproc libboost-dev libxml-parser-perl libusb-dev sharutils gcc-multilib openjdk-25-jdk-headless rsync zip device-tree-compiler
```
### Quickstart

# Clone and setup

```
git clone https://github.com/Johnkarazou/OpenWRT-OrangePi_Rv2 -b 25.12
cd OpenWRT-OrangePi_Rv2

```
# Update and install feeds

```
./scripts/feeds update -a
./scripts/feeds install -a

```
# Apply Orange Pi RV2 configuration

```
cp orangepi_rv2_defconfig .config
make defconfig

```
# Download sources and build

```
make -j $(nproc) download
make -j $(($(nproc)+1))

```
## Custom Configuration Includes:

### Kernel Configuration
- **Kernel Partition Size:** 64MB
- **Root Filesystem Partition Size:** 256MB
- **Auto-expanding Userdata:** Enabled via `ky-userdata` package (formats remaining NVMe/SD space as `/userdata`)

### Package Selection

**System & Monitoring**
- dnsmasq-full
- zram-swap
- btop
- htop
- lm-sensors
- sudo
- nano
- vim

**PHP8 & Modules**
- php8
- php8-cgi
- php8-fpm
- php8-mod-ctype
- php8-mod-curl
- php8-mod-gd
- php8-mod-intl
- php8-mod-mbstring
- php8-mod-mysqli
- php8-mod-mysql
- php8-mod-sqlite3
- php8-mod-xml
- php8-mod-zip

**Database**
- libmariadb
- mariadb-server-base
- mariadb-server

**LuCI & Web Interface**
- luci-app-adblock
- luci-app-ddns
- luci-app-ttyd
- luci-app-uhttpd
- luci-theme-material

**Networking & Protocols**
- luci-proto-wireguard
- pbr (Policy Based Routing)
- luci-app-pbr
- ip-full

**Utilities & Libraries**
- liblz4
- lz4
- unzip
- xz-utils
- blkid
- nvme-cli
- swap-utils

### Related Repositories

The main repository uses multiple sub-repositories to manage packages of
different categories. All packages are installed via the OpenWrt package
manager called `opkg`. If you're looking to develop the web interface or port
packages to OpenWrt, please find the fitting repository below.

* [LuCI Web Interface](https://github.com/openwrt/luci): Modern and modular
  interface to control the device via a web browser.

* [OpenWrt Packages](https://github.com/openwrt/packages): Community repository
  of ported packages.

* [OpenWrt Routing](https://github.com/openwrt/routing): Packages specifically
  focused on (mesh) routing.

* [OpenWrt Video](https://github.com/openwrt/video): Packages specifically
  focused on display servers and clients (Xorg and Wayland).

## Support Information

For a list of supported devices see the [OpenWrt Hardware Database](https://openwrt.org/supported_devices)

### Documentation

* [Quick Start Guide](https://openwrt.org/docs/guide-quick-start/start)
* [User Guide](https://openwrt.org/docs/guide-user/start)
* [Developer Documentation](https://openwrt.org/docs/guide-developer/start)
* [Technical Reference](https://openwrt.org/docs/techref/start)

### Support Community

* [Forum](https://forum.openwrt.org): For usage, projects, discussions and hardware advise.
* [Support Chat](https://webchat.oftc.net/#openwrt): Channel `#openwrt` on **oftc.net**.

### Developer Community

* [Bug Reports](https://bugs.openwrt.org): Report bugs in OpenWrt
* [Dev Mailing List](https://lists.openwrt.org/mailman/listinfo/openwrt-devel): Send patches
* [Dev Chat](https://webchat.oftc.net/#openwrt-devel): Channel `#openwrt-devel` on **oftc.net**.

## License

OpenWrt is licensed under GPL-2.0
