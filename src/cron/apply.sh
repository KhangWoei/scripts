#!/bin/bash
# @name: cron-apply
# @desc: Applies cronjob definitions from the jobs directory

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "${real_path}")"
jobs_dir="${script_dir}/jobs"

if ! ls "${jobs_dir}"/*.cron &>/dev/null; then
  echo "No .cron files found in ${jobs_dir}"
  exit 1
fi

combined=$(cat "${jobs_dir}"/*.cron)

echo "The following will be installed as your crontab:"
echo "================================================"
echo "$combined"
echo "================================================"
echo ""

read -rp "Apply? [y/N] " confirm
if [[ "$confirm" != [yY] ]]; then
  echo "Aborted."
  exit 0
fi

echo "$combined" | crontab -
echo "Crontab applied."
