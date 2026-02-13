#!/bin/bash
# @name: devices-health
# @desc: Runs SMART health checks on all drives

if ! command -v smartctl &> /dev/null; then
    echo "Error: smartctl not found, install smartmontools"
    exit 1
fi

mapfile -t drives < <(lsblk -dnpo NAME -e 7,11)

for drive in "${drives[@]}"; do
    echo "=== ${drive} ==="
    sudo smartctl -H "${drive}" 2>/dev/null | grep -A 1 "SMART overall"
    echo ""
done
