#!/bin/bash
# @name: services-list
# @desc: Lists systemd services and their status

filter="${1:-active}"

case "$filter" in
  active|running)
    systemctl list-units --type=service --state=running --no-pager
    ;;
  inactive|stopped)
    systemctl list-units --type=service --state=inactive --no-pager
    ;;
  failed)
    systemctl list-units --type=service --state=failed --no-pager
    ;;
  enabled)
    systemctl list-unit-files --type=service --state=enabled --no-pager
    ;;
  disabled)
    systemctl list-unit-files --type=service --state=disabled --no-pager
    ;;
  static)
    systemctl list-unit-files --type=service --state=static --no-pager
    ;;
  masked)
    systemctl list-unit-files --type=service --state=masked --no-pager
    ;;
  all)
    systemctl list-units --type=service --no-pager
    ;;
  *)
    echo "Usage: services-list [active|inactive|failed|enabeled|disabled|static|masked|all]"
    exit 1
    ;;
esac
