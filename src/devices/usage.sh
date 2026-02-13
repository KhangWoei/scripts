#!/bin/bash
# @name: devices-usage
# @desc: Lists mounted drives and their disk usage

df -h --output=source,fstype,size,used,avail,pcent,target -x tmpfs -x devtmpfs -x efivarfs | column -t
