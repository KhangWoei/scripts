#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mapfile -t scripts < <(find "${script_dir}/src" -iname "*.sh" -type f)

for script in "${scripts[@]}"
do
    script_link="${HOME}/.bin/$(basename ${script})"

    if [ -f "${script_link}" ]; then
        echo "Removing ${script_link}"
        rm ${script_link}
    fi
done
