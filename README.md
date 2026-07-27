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

The easiest and most reliable way to build OpenWrt across any OS (Ubuntu, Fedora, Arch Linux, macOS, Windows/WSL) is by using the provided Docker environment. You only need to have [Docker](https://docs.docker.com/get-docker/) installed.

### Quickstart

# 1. Clone the repository

```
git clone https://github.com/Johnkarazou/OpenWRT-OrangePi_Rv2 -b 24.10
cd OpenWRT-OrangePi_Rv2
```

# 2. Build and run the Docker environment

Build the container image and start an interactive session. The current directory is mounted inside the container so all your build artifacts are saved to your host machine.

```
docker build -t openwrt-build-env -f Dockerfile.debian13 .
docker run -it -v $(pwd):/home/builduser/openwrt openwrt-build-env
```

> **Troubleshooting Docker Errors:**
> - If you get `failed to connect to the docker API` or `daemon not running`, start the Docker service on your host machine (e.g., `sudo systemctl start docker`).
> - If you get `permission denied`, you may need to run the docker commands with `sudo` or [add your user to the docker group](https://docs.docker.com/engine/install/linux-postinstall/).

> **Note:** Run all the following commands **inside** the Docker container.

# 3. Update and install feeds

```
./scripts/feeds update -a
./scripts/feeds install -a
```

# 4. Apply Orange Pi RV2 configuration

```
cp orangepi_rv2_defconfig .config
make defconfig
```

# 5. Download sources and build

```
make -j $(nproc) download
make -j $(($(nproc)+1))
```

# 6. Connect to the Router

Once the firmware is flashed, the default IP address to connect to the router (via SSH or the LuCI web interface) is `192.168.2.1`.

## Custom Configuration Includes:

### Kernel Configuration
- **Kernel Partition Size:** 128MB
- **Root Filesystem Partition Size:** 2048MB

### Custom Package Additions (Compared to Xunlong Default)

**System & Monitoring**
- zram-swap
- btop
- htop
- sudo
- nano
- vim
- bash

**Docker & Containers**
- docker
- docker-compose
- dockerd
- containerd
- runc

**PHP8 & Modules**
- php8 (along with php8-cgi and php8-fpm)
- php8-mod-* (curl, gd, intl, mbstring, mysqli, pdo, xml, zip, and more)

**Database**
- mariadb-server
- libmariadb

**Networking & Firewall**
- dnsmasq-full (with dnssec, dhcpv6, ipset, etc.)
- firewall4 & iptables-wrappers
- wireguard-tools & luci-proto-wireguard
- pbr & luci-app-pbr (Policy Based Routing)
- ip-full
- dropbear

**Web Interface**
- luci-theme-material
- luci-app-uhttpd

**Utilities & Storage**
- e2fsprogs / btrfs-progs / f2fs-tools
- fdisk / parted
- nvme-cli
- swap-utils
- lz4 / unzip / xz-utils

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
