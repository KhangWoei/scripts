#!/bin/bash
# @name: aur-search
# @desc: Searches for AUR packages by keyword

if [ -z "$1" ]; then
    echo "Usage: aur-search <keyword>"
    exit 1
fi

yay -Ss "$1"
