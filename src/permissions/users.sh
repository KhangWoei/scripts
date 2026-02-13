#!/bin/bash
# @name: permissions-users
# @desc: Lists human users (UID >= 1000) plus root

show_all=false
if [ "$1" = "--all" ]; then
    show_all=true
fi

{
    echo "USER|UID|GROUP|SHELL|HOME"
    getent passwd | while IFS=: read -r name _ uid gid _ home shell; do
        if [ "$show_all" = true ] || [ "$uid" -ge 1000 ] || [ "$name" = "root" ]; then
            group=$(getent group "$gid" | cut -d: -f1)
            echo "${name}|${uid}|${group}|${shell}|${home}"
        fi
    done | sort -t'|' -k2 -n
} | column -t -s '|'
