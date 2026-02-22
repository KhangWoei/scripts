#!/bin/bash
# @name: cron-apply
# @desc: Applies cronjob definitions from the jobs directory

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "${real_path}")"
jobs_dir="${script_dir}/jobs"

filter="${1:-all}"

apply_jobs() {
  local label="$1"
  local dir="$2"
  local use_sudo="$3"

  if ! ls "${dir}"/*.cron &>/dev/null; then
    echo "No .cron files found in ${dir}"
    return 1
  fi

  if [ "${use_sudo}" = "true" ] && [ "$EUID" -ne 0 ]; then
    echo "System jobs require root privileges. Re-run with sudo."
    return 1
  fi

  local combined
  combined=$(cat "${dir}"/*.cron)

  echo "${label} CRONTAB"
  echo "================================================"
  echo "$combined"
  echo "================================================"
  echo ""

  read -rp "Apply ${label,,} jobs? [y/N] " confirm
  if [[ "$confirm" != [yY] ]]; then
    echo "Skipped."
    return 0
  fi

  if [ "${use_sudo}" = "true" ]; then
    echo "$combined" | sudo crontab -
  else
    echo "$combined" | crontab -
  fi

  echo "${label} crontab applied."
}

case "$filter" in
  user)
    apply_jobs "USER" "${jobs_dir}/user" "false"
    ;;
  system)
    apply_jobs "SYSTEM" "${jobs_dir}/system" "true"
    ;;
  all)
    apply_jobs "USER" "${jobs_dir}/user" "false"
    echo ""
    apply_jobs "SYSTEM" "${jobs_dir}/system" "true"
    ;;
  *)
    echo "Usage: cron-apply [user|system|all]"
    exit 1
    ;;
esac
