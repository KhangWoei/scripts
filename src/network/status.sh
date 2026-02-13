#!/bin/bash
# @name: network-status
# @desc: Shows active network interfaces, IPs, and default gateway

echo "INTERFACES"
echo "=========="
ip -br addr show | grep -v "^lo"

echo ""
echo "DEFAULT GATEWAY"
echo "==============="
ip route show default
