#!/bin/bash
# @name: systemd-explain
# @desc: Lists all timer definitions and their descriptions

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
timers_dir="$(dirname "${real_path}")/timers"

print_timers() {
    local label="$1"
    local dir="$2"

    if [ ! -d "${dir}" ]; then
        return
    fi

    local has_timers=false
    local output
    output=$(
        echo "NAME|SCHEDULE|DESCRIPTION"
        for subdir in "${dir}"/*/; do
            [ -d "${subdir}" ] || continue
            local name
            name="$(basename "${subdir}")"
            local timer_file="${subdir}/${name}.timer"
            [ -f "${timer_file}" ] || continue

            local tname="" desc="" schedule=""
            while IFS= read -r line; do
                case "${line}" in
                    "# @name: "*) tname="${line#\# @name: }" ;;
                    "# @desc: "*) desc="${line#\# @desc: }" ;;
                    "# @schedule: "*) schedule="${line#\# @schedule: }" ;;
                    "["*) break ;;
                esac
            done < "${timer_file}"

            if [ -n "${tname}" ] && [ -n "${desc}" ]; then
                echo "${tname}|${schedule:-N/A}|${desc}"
            fi
        done
    )

    # Only print if we have more than the header line
    if [ "$(echo "${output}" | wc -l)" -gt 1 ]; then
        echo "${label} TIMERS"
        echo "==================="
        echo "${output}" | column -t -s '|'
    fi
}

print_timers "USER" "${timers_dir}/user"
echo ""
print_timers "SYSTEM" "${timers_dir}/system"
