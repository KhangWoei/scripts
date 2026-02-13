#!/bin/bash
# @name: devices-reformat
# @desc: Reformats a disk with a specified filesystem

target_disk="$1"
new_fs="$2"
dry_run="$3"

if [ -z "${target_disk}" ] || [ -z "${new_fs}" ]; then
    echo "Usage: devices-reformat <target_disk> <filesystem> [dry_run]"
    echo "Example: devices-reformat /dev/sdb1 ext4 true"
    exit 1
fi

if [ ! -b "${target_disk}" ]; then
    echo "Error: ${target_disk} is not a valid block device"
    exit 1
fi

if ! command -v "mkfs.${new_fs}" &> /dev/null; then
    echo "Error: mkfs.${new_fs} not found, unsupported filesystem"
    exit 1
fi

echo "Target:     ${target_disk}"
echo "Filesystem: ${new_fs}"

if [ "${dry_run}" = "true" ]; then
    echo "[dry run] Would unmount ${target_disk}"
    echo "[dry run] Would run: mkfs.${new_fs} ${target_disk}"
    exit 0
fi

echo "This will erase all data on ${target_disk}."
read -r -p "Continue? [y/N] " confirm
if [ "${confirm}" != "y" ]; then
    echo "Aborted"
    exit 0
fi

if mountpoint -q "${target_disk}" 2>/dev/null || mount | grep -q "${target_disk}"; then
    echo "Unmounting ${target_disk}..."
    umount "${target_disk}" || { echo "Error: failed to unmount"; exit 1; }
fi

echo "Formatting ${target_disk} as ${new_fs}..."
mkfs."${new_fs}" "${target_disk}"
