#!/usr/bin/env bash
# Republish bin/ as the orphan `packages` branch.
# Run after every build you flash — kmods must come from the matching build.
# Serving: raw.githubusercontent.com (what routers' customfeeds point at;
# CONFIG_VERSION_REPO in orangepi_rv2_defconfig matches this layout).
set -euo pipefail
SRC="$(cd "$(dirname "$0")" && pwd)"
REMOTE="${1:-origin}"

[ -f "$SRC/bin/packages/riscv64_generic/base/packages.adb" ] || { echo "No built indexes under bin/ — run a build first." >&2; exit 1; }
REV="$(head -1 "$SRC/bin/targets/ky/riscv64/version.buildinfo")"
[ -n "$REV" ] || { echo "No bin/targets/ky/riscv64/version.buildinfo — run a build first." >&2; exit 1; }

TMP="$(mktemp -d /tmp/rv2-pub.XXXXXX)"
trap 'rm -rf "$TMP"' EXIT
git clone -q -b packages "git@github.com:Johnkarazou/OpenWRT-OrangePi_Rv2.git" "$TMP" || true
FIRMWARE_VER=$(grep CONFIG_VERSION_NUMBER "$SRC/.config" | cut -d '"' -f 2 || true)
if [ -z "$FIRMWARE_VER" ] || [ "$FIRMWARE_VER" = "SNAPSHOT" ]; then
    FIRMWARE_VER="snapshots"
fi

mkdir -p "$TMP/$FIRMWARE_VER/packages/riscv64_generic" "$TMP/$FIRMWARE_VER/targets/ky/riscv64"
cp -a "$SRC/bin/packages/riscv64_generic/." "$TMP/$FIRMWARE_VER/packages/riscv64_generic/"
cp -a "$SRC/bin/targets/ky/riscv64/packages" "$TMP/$FIRMWARE_VER/targets/ky/riscv64/"

cat > "$TMP/README.md" <<EOF
# OpenWrt ky/riscv64 package repository — Orange Pi RV2

Self-hosted APK feeds for the custom ky/riscv64 target (not upstream).

- Built from: branch 25.12, revision $REV
- Published: $(date -u +%Y-%m-%dT%H:%MZ)
- Kmods require the matching image (flash the sysupgrade image from the same build)
- Indexes are signed; the verifying key ships inside the images (/etc/apk/keys/public-key.pem)

Device setup: see "Package repository" in the main branch README.
EOF
touch "$TMP/.nojekyll"

cd "$TMP"
git init -q -b packages
git add -A
git -c user.name="$(git -C "$SRC" config user.name || echo Johnkarazou)" \
      -c user.email="$(git -C "$SRC" config user.email || echo Johnkarazou@users.noreply.github.com)" \
      commit -qm "packages: publish $REV — $(date -u +%Y-%m-%d)"
git remote add "$REMOTE" "$(git -C "$SRC" remote get-url "$REMOTE")" || true
git push -q "$REMOTE" packages
echo "Published $REV to the packages branch."
