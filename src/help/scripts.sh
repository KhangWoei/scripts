#!/bin/bash
# @name: help-scripts
# @desc: Lists all available scripts and their descriptions

real_path="$(readlink -f "${BASH_SOURCE[0]}")"
src_dir="$(dirname "$(dirname "${real_path}")")"

mapfile -t scripts < <(find "${src_dir}" -iname "*.sh" -type f | sort)

echo "AVAILABLE SCRIPTS"
echo "=================="
{
    echo "SCRIPT|DESCRIPTION"
    for script in "${scripts[@]}"; do
        name="" desc=""
        while IFS= read -r line; do
            case "${line}" in
                "# @name: "*) name="${line#\# @name: }" ;;
                "# @desc: "*) desc="${line#\# @desc: }" ;;
            esac
            [ -n "${name}" ] && [ -n "${desc}" ] && break
        done < "${script}"
        if [ -n "${name}" ] && [ -n "${desc}" ]; then
            echo "${name}|${desc}"
        fi
    done
} | column -t -s '|'
