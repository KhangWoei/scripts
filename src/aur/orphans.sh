#!/bin/bash
# @name: aur-orphans
# @desc: Lists orphaned packages with no dependents

orphans=$(yay -Qdt 2>/dev/null)

if [ -z "${orphans}" ]; then
    echo "No orphaned packages found"
    exit 0
fi

echo "Orphaned packages:"
echo "${orphans}"
