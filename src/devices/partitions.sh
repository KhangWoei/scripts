#!/bin/bash
# @name: devices-partitions
# @desc: Lists partition layout for all drives

lsblk -o NAME,SIZE,TYPE,FSTYPE,MOUNTPOINT,LABEL
