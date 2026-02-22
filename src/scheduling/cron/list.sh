#!/bin/bash
# @name: cron-list
# @desc: Lists cronjobs from all sources on the system

filter="${1:-all}"

case "$filter" in
  user)
    echo "USER CRONTAB ($(whoami))"
    echo "========================"
    crontab -l 2>/dev/null || echo "No crontab for $(whoami)"
    ;;
  system)
    echo "SYSTEM CRONTAB (/etc/crontab)"
    echo "============================="
    cat /etc/crontab 2>/dev/null

    echo ""
    echo "CRON.D (/etc/cron.d/)"
    echo "====================="
    for f in /etc/cron.d/*; do
      [ -f "$f" ] || continue
      echo "--- $f ---"
      cat "$f"
      echo ""
    done
    ;;
  timers)
    echo "SYSTEMD TIMERS"
    echo "=============="
    systemctl list-timers --all --no-pager
    ;;
  all)
    "$0" user
    echo ""
    "$0" system
    echo ""
    "$0" timers
    ;;
  *)
    echo "Usage: cron-list [user|system|timers|all]"
    exit 1
    ;;
esac
