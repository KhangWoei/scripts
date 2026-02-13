#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mapfile -t scripts < <(find "${script_dir}/src" -iname "*.sh" -type f)

for script in "${scripts[@]}"
do
    if [ ! -x "${script}" ]; then
        echo "Making ${script} executable"
        chmod +x "${script}"
    fi
done
