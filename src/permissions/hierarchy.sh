#!/bin/bash
# @name: permissions-hierarchy
# @desc: Shows a tree-like view of groups and their member users

filter="$1"

getent group | while IFS=: read -r name _ gid members; do
    [ -z "$members" ] && continue
    if [ -n "$filter" ] && [ "$name" != "$filter" ]; then
        continue
    fi

    echo "$name (GID $gid)"
    IFS=',' read -ra users <<< "$members"
    for i in "${!users[@]}"; do
        if [ "$i" -eq $(( ${#users[@]} - 1 )) ]; then
            echo "  └── ${users[$i]}"
        else
            echo "  ├── ${users[$i]}"
        fi
    done
    echo ""
done
