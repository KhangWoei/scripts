#!/bin/bash
# @name: network-sockets
# @desc: Lists systemd socket units and their status

filter="${1:-active}"

case "$filter" in
  active|listening)
    systemctl list-units --type=socket --state=active --no-pager
    ;;
  inactive)
    systemctl list-units --type=socket --state=inactive --no-pager
    ;;
  all)
    systemctl list-units --type=socket --no-pager
    ;;
  *)
    echo "Usage: network-sockets [active|inactive|all]"
    exit 1
    ;;
esac
