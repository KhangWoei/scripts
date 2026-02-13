#!/bin/bash
# @name: permissions-groups
# @desc: Lists all system groups with their GID and members

filter="$1"

if [ -n "$filter" ]; then
    data=$(getent group | grep -i "$filter")
else
    data=$(getent group)
fi

if [ -z "$data" ]; then
    echo "No groups found"
    exit 1
fi

{
    echo "GROUP|GID|MEMBERS"
    echo "$data" | while IFS=: read -r name _ gid members; do
        echo "${name}|${gid}|${members}"
    done | sort -t'|' -k2 -n
} | column -t -s '|'
