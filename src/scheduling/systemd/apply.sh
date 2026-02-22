#!/bin/bash
# @name: systemd-apply
# @desc: Installs systemd timer/service pairs from the timers directory

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
timers_dir="$(dirname "${real_path}")/timers"

filter="${1:-all}"

apply_timers() {
    local label="$1"
    local dir="$2"
    local scope="$3"

    if [ ! -d "${dir}" ]; then
        echo "No ${label,,} timers directory found at ${dir}"
        return 1
    fi

    local found=false
    for subdir in "${dir}"/*/; do
        [ -d "${subdir}" ] || continue
        local name
        name="$(basename "${subdir}")"
        local timer_file="${subdir}/${name}.timer"
        local service_file="${subdir}/${name}.service"

        if [ ! -f "${timer_file}" ] || [ ! -f "${service_file}" ]; then
            continue
        fi

        found=true

        echo "================================================"
        echo "  ${name}"
        echo "================================================"
        echo ""
        echo "--- ${name}.timer ---"
        cat "${timer_file}"
        echo ""
        echo "--- ${name}.service ---"
        cat "${service_file}"
        echo ""

        read -rp "Apply ${name}? [y/N] " confirm
        if [[ "$confirm" != [yY] ]]; then
            echo "Skipped."
            echo ""
            continue
        fi

        if [ "${scope}" = "user" ]; then
            local dest="${HOME}/.config/systemd/user"
            mkdir -p "${dest}"
            cp "${timer_file}" "${dest}/"
            cp "${service_file}" "${dest}/"
            systemctl --user daemon-reload
            systemctl --user enable --now "${name}.timer"
        else
            sudo cp "${timer_file}" /etc/systemd/system/
            sudo cp "${service_file}" /etc/systemd/system/
            sudo systemctl daemon-reload
            sudo systemctl enable --now "${name}.timer"
        fi

        echo "${name} installed and enabled."
        echo ""
    done

    if [ "${found}" = false ]; then
        echo "No timer/service pairs found in ${dir}"
    fi
}

case "$filter" in
    user)
        apply_timers "USER" "${timers_dir}/user" "user"
        ;;
    system)
        apply_timers "SYSTEM" "${timers_dir}/system" "system"
        ;;
    all)
        apply_timers "USER" "${timers_dir}/user" "user"
        echo ""
        apply_timers "SYSTEM" "${timers_dir}/system" "system"
        ;;
    *)
        echo "Usage: systemd-apply [user|system|all]"
        exit 1
        ;;
esac
