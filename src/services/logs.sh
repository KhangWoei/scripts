#!/bin/bash
# @name: services-logs
# @desc: Shows recent logs for a systemd service

if [ -z "$1" ]; then
  echo "Usage: services-logs <service-name> [lines]"
  exit 1
fi

lines="${2:-50}"

journalctl -u "$1" -n "$lines" --no-pager
