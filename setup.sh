#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mapfile -t scripts < <(find "${script_dir}/src" -iname "*.sh" -type f)

for script in "${scripts[@]}";
do
    dir_name="$(basename "$(dirname "${script}")")"
    script_link="${HOME}/.bin/${dir_name}-$(basename "${script}")"

    if [ ! -f "${script_link}" ]; then
        echo "Creating soft link ${script_link}"
        ln -s "${script}" "${script_link}"
    fi
done
