#!/bin/bash

script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

mapfile -t scripts < <(find "${script_dir}" -iname "*.sh" -type f)

for script in "${scripts[@]}";
do
    ln -s "${script}" ~/.bin/$(basename ${script})
done
