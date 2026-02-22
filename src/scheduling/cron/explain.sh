#!/bin/bash
# @name: cron-explain
# @desc: Lists all cronjob definitions and their descriptions

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
jobs_dir="$(dirname "${real_path}")/jobs"

print_jobs() {
    local label="$1"
    local dir="$2"

    mapfile -t jobs < <(find "${dir}" -iname "*.cron" -type f 2>/dev/null | sort)

    if [ ${#jobs[@]} -eq 0 ]; then
        return
    fi

    echo "${label} JOBS"
    echo "==================="
    {
        echo "NAME|SCHEDULE|DESCRIPTION"
        for job in "${jobs[@]}"; do
            name="" desc="" schedule=""
            while IFS= read -r line; do
                case "${line}" in
                    "# @name: "*) name="${line#\# @name: }" ;;
                    "# @desc: "*) desc="${line#\# @desc: }" ;;
                    "# @schedule: "*) schedule="${line#\# @schedule: }" ;;
                esac
                [ -n "${name}" ] && [ -n "${desc}" ] && [ -n "${schedule}" ] && break
            done < "${job}"
            if [ -n "${name}" ] && [ -n "${desc}" ]; then
                echo "${name}|${schedule:-N/A}|${desc}"
            fi
        done
    } | column -t -s '|'
}

print_jobs "USER" "${jobs_dir}/user"
echo ""
print_jobs "SYSTEM" "${jobs_dir}/system"
