#!/bin/bash
# @name: permissions-membership
# @desc: Shows group membership for a given user

user="${1:-$(whoami)}"

if ! id "$user" &>/dev/null; then
    echo "Error: user '$user' not found"
    exit 1
fi

primary=$(id -gn "$user")
all_groups=$(groups "$user" | cut -d: -f2 | sed 's/^ //')
uid=$(id -u "$user")

echo "User:            $user (UID $uid)"
echo "Primary group:   $primary"
echo "All groups:      $all_groups"

if echo "$all_groups" | grep -qw "wheel\|sudo"; then
    echo "Sudo access:     yes"
else
    echo "Sudo access:     no"
fi
