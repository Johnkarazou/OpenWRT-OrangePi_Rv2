#!/bin/sh

# Grow the rootfs partition to fill the boot device — safely, on first boot.
# Strictly handles SquashFS + Overlay only. ext4 factory images are excluded by design.

FDISK=$(command -v fdisk) || exit 0
PARTX=$(command -v partx) || exit 0

roottype=$(findmnt -n -o FSTYPE /)

case "${roottype}" in
overlay)
	rootsource=$(findmnt -n -o SOURCE /rom)
	;;
squashfs)
	rootsource=$(findmnt -n -o SOURCE / | sed 's~\[.*\]~~')
	;;
*)
	# Exit immediately if it's ext4 or anything else not designed for auto-expansion
	exit 0
	;;
esac

if [ "$rootsource" = "/dev/root" ]; then
    if [ -L /dev/root ]; then
        rootsource=$(readlink -f /dev/root)
    else
        majmin=$(stat -c "%t:%T" /dev/root | awk '{printf "%d:%d\n", "0x"$1, "0x"$2}')
        devname=$(cat /sys/dev/block/${majmin}/uevent 2>/dev/null | grep DEVNAME | cut -d= -f2)
        [ -n "$devname" ] && rootsource="/dev/${devname}"
    fi
fi

# POSIX-compliant extraction of base device and partition number
partnum=$(echo "$rootsource" | awk '{match($0, /[0-9]+$/); print substr($0, RSTART, RLENGTH)}')
if [ -z "$partnum" ]; then
    exit 0
fi

rootdevice=$(echo "$rootsource" | sed "s/${partnum}$//")
# Handle /dev/mmcblk0p -> /dev/mmcblk0 (but leave /dev/sda as /dev/sda)
case "$rootdevice" in
    *p) rootdevice="${rootdevice%p}" ;;
esac

diskname=$(basename "${rootdevice}")
partname=$(basename "${rootsource}")

diskline=$(${FDISK} -l ${rootdevice} 2>/dev/null | awk -v d="${rootdevice}:" '$1 == "Disk" && $2 == d')
partline=$(${FDISK} -l ${rootdevice} 2>/dev/null | awk -v p="${rootsource}" '$1 == p')

lastsector=$(echo "${diskline}" | awk '{print $7 - 1}')
startfrom=$(echo "${partline}" | awk '{print $2}')
partend=$(echo "${partline}" | awk '{print $3}')

[ -n "${lastsector}" ] && [ -n "${startfrom}" ] && [ -n "${partend}" ] || exit 0

# Only ever grow
[ "${lastsector}" -gt "${partend}" ] || exit 0

# Rewrite the partition entry
(echo d; echo ${partnum}; echo n; echo p; echo; echo ${startfrom}; echo ${lastsector}; echo w;) | ${FDISK} ${rootdevice} >/dev/null 2>&1

# Ask the kernel to adopt the new size right now
${PARTX} -u "${rootdevice}" >/dev/null 2>&1

# Verify the kernel adopted the new partition size
want=$((lastsector - startfrom + 1))
have=$(cat "/sys/block/${diskname}/${partname}/size" 2>/dev/null || echo 0)
if [ "${have}" -lt "${want}" ]; then
	sync
	reboot -f
	exit 0
fi

if [ "${roottype}" = "overlay" ]; then
    root_maj_min=$(stat -c "%t:%T" "${rootsource}" | awk '{printf "%d:%d\n", "0x"$1, "0x"$2}')
	for l in $(losetup -n -O NAME,BACK-MAJ:MIN 2>/dev/null | awk -v r="${root_maj_min}" '$2 == r {print $1}'); do
		losetup -c "${l}" >/dev/null 2>&1
		off=$(losetup -n -O OFFSET "${l}")
		off=$((off / 512))
		lsz=$(cat "/sys/block/$(basename "${l}")/size" 2>/dev/null || echo 0)
		[ "${lsz}" -ge $((want - off)) ] || { sync; reboot -f; }
	done
fi

sync
exit 0
