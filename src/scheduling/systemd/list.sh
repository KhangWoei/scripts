#!/bin/bash
# @name: systemd-list
# @desc: Lists systemd timers (system and user)

filter="${1:-all}"

case "$filter" in
  active)
    echo "ACTIVE SYSTEM TIMERS"
    echo "===================="
    systemctl list-timers --no-pager
    ;;
  user)
    echo "USER TIMERS ($(whoami))"
    echo "========================"
    systemctl --user list-timers --all --no-pager
    ;;
  failed)
    echo "FAILED TIMERS"
    echo "============="
    systemctl list-timers --failed --no-pager
    echo ""
    echo "FAILED USER TIMERS"
    echo "=================="
    systemctl --user list-timers --failed --no-pager
    ;;
  all)
    echo "SYSTEM TIMERS"
    echo "============="
    systemctl list-timers --all --no-pager
    echo ""
    echo "USER TIMERS ($(whoami))"
    echo "========================"
    systemctl --user list-timers --all --no-pager
    ;;
  *)
    echo "Usage: systemd-list [active|user|failed|all]"
    exit 1
    ;;
esac
