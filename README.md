# OpenWrt — Orange Pi RV2 (Ky X1, riscv64)

Custom OpenWrt fork for the **Orange Pi RV2** router: `ky/riscv64` target, Ky X1 SoC,
kernel 6.6. Based on [xunlong/openwrt](https://github.com/orangepi-xunlong/openwrt)
on top of [openwrt/openwrt](https://github.com/openwrt/openwrt). GPL-2.0, as upstream.

The `ky` target does not exist upstream, so there are no official images or package
repositories for it. This repo builds both and hosts its own package repository
(see [Package repository](#package-repository)).

## Build

Build dependencies (Debian 13):

```bash
sudo apt install -y asciidoc bash binutils bzip2 cmake flex git g++ gcc time \
  util-linux gawk gzip help2man intltool libelf-dev zlib1g-dev make libncurses-dev \
  libssl-dev patch perl-modules libthread-queue-any-perl python3-dev swig unzip wget \
  gettext xsltproc libboost-dev libxml-parser-perl libusb-dev sharutils gcc-multilib \
  rsync zip device-tree-compiler clang bison file jq
```

```bash
git clone https://github.com/Johnkarazou/OpenWRT-OrangePi_Rv2.git -b 25.12
cd OpenWRT-OrangePi_Rv2
./scripts/feeds update -a
./scripts/feeds install -a
cp orangepi_rv2_defconfig .config   # or orangepi_rv2_full_defconfig
make defconfig
make -j$(nproc) download
make -j$(($(nproc)+1))
```

Images land in `bin/targets/ky/riscv64/`, packages in `bin/packages/riscv64_generic/`.
CI (`.github/workflows/build_rv2.yml`, manual dispatch) builds the same configuration
on ubuntu-latest.

## What's in the image (vs stock)

- Kernel partition 128 MB, rootfs 2048 MB; `ky-userdata` formats the remaining
  SD/NVMe space as `/userdata` on first boot.
- Baked-in performance tuning: RPS on all interface RX queues, performance CPU
  governor, packet steering across cores, `txqueuelen 10000` on WireGuard ifup.
- Two defconfigs: `orangepi_rv2_defconfig` (default) is minimal, derived from
  what actually runs on the device — LuCI with material theme, package-manager,
  ttyd and uhttpd apps, dnsmasq-full, adblock + https-dns-proxy + ddns-scripts,
  PPPoE, PHP 8 (fpm) and Python 3 + uwsgi for custom /www services, zram and
  CLI tooling. `orangepi_rv2_full_defconfig` keeps the older maximal set
  (MariaDB, WireGuard + pbr, banip, adblock-fast, sensors, ...). Anything else
  installs on demand from the package repository (`apk add banip`, ...).

## Package repository

The built feeds are published on the `packages` branch (orphan branch, replaced
on every publish) and served over HTTPS from this repo. Only `base`, `luci` and
`packages` have packages selected and therefore indexes; `routing`, `telephony`
and `video` build nothing for this config.

On a device running one of these images (the signing key is already in
`/etc/apk/keys/`):

```bash
cat > /etc/apk/repositories.d/customfeeds.list <<'EOF'
https://raw.githubusercontent.com/Johnkarazou/OpenWRT-OrangePi_Rv2/packages/targets/ky/riscv64/packages/packages.adb
https://raw.githubusercontent.com/Johnkarazou/OpenWRT-OrangePi_Rv2/packages/packages/riscv64_generic/base/packages.adb
https://raw.githubusercontent.com/Johnkarazou/OpenWRT-OrangePi_Rv2/packages/packages/riscv64_generic/luci/packages.adb
https://raw.githubusercontent.com/Johnkarazou/OpenWRT-OrangePi_Rv2/packages/packages/riscv64_generic/packages/packages.adb
EOF
apk update
```

New images point here automatically (`CONFIG_VERSION_REPO` in
`orangepi_rv2_defconfig`), so `distfeeds.list` comes out correct from first boot.

Kmods install only on the matching image build (kernel vermagic) — flash the
sysupgrade image from the same commit first.

Feeds are pinned in `feeds.conf.default` to the exact commits recorded in
`bin/targets/ky/riscv64/feeds.buildinfo`, so rebuilds are reproducible.

## Building your own fork

A fresh build generates its **own** signing keys (`key-build*`, `private-key.pem`),
so images you build trust only your key — this repo's published `packages.adb`
is signed with the maintainer's key and will fail signature verification on
your images. Fork → build → publish your own `packages` branch with
`./publish-packages.sh` → set `CONFIG_VERSION_REPO` in your defconfig to your
own raw URL. Never commit the generated keys.

## Signing

Indexes and images are signed with the keys generated at first build
(`key-build*`, `private-key.pem` — gitignored, never commit them). The public
halves are baked into `/etc/apk/keys/` of every image built with those keys.
Lose them and you reflash everything; leak them and you rotate.
