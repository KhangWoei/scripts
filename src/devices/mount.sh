#!/bin/bash
# @name: devices-mount
# @desc: Mounts a drive to /mnt/<label>

device="$1"
label="$2"

if [ -z "${device}" ] || [ -z "${label}" ]; then
    echo "Usage: devices-mount <device> <label>"
    echo "Example: devices-mount /dev/sdb1 usb"
    exit 1
fi

if [ ! -b "${device}" ]; then
    echo "Error: ${device} is not a valid block device"
    exit 1
fi

mount_point="/mnt/${label}"

if mount | grep -q "${device}"; then
    echo "${device} is already mounted"
    mount | grep "${device}"
    exit 0
fi

sudo mkdir -p "${mount_point}"
echo "Mounting ${device} to ${mount_point}..."
sudo mount "${device}" "${mount_point}" && echo "Mounted successfully"
