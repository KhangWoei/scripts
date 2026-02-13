#!/bin/bash
# @name: help-tools
# @desc: Lists installed tools matching a category keyword with descriptions

if [[ -z "$1" ]]; then
    echo "Usage: help-tools <category>"
    echo "Search installed packages by category keyword and display descriptions."
    echo ""
    echo "Examples:"
    echo "  help-tools monitor      # monitoring tools"
    echo "  help-tools network      # networking tools"
    echo "  help-tools disk         # disk utilities"
    echo "  help-tools categories   # list common category keywords"
    exit 0
fi

if [[ "$1" == "categories" ]]; then
    echo "CATEGORY KEYWORDS (by package count)"
    echo "=================================="
    pacman -Qi 2>/dev/null \
        | sed -n 's/^Description *: //p' \
        | tr '[:upper:]' '[:lower:]' \
        | tr -cs 'a-z' '\n' \
        | awk 'length >= 4 && !/^(with|that|from|based|this|your|they|also|into|than|were|been|have|their|which|when|will|each|make|like|over|such|some|most|more|used|uses|using|free|open|cross|source|other|does|very|well|just|only|both|same|allows|provides|written|simple|various|including|between|within|without|lightweight|build|full|part|high|large|fast|small|easy|many|multiple|common)$/' \
        | sort | uniq -c | sort -rn \
        | awk 'NR <= 40 && $1 >= 5 {printf "  %-20s (%d packages)\n", $2, $1}'
    exit 0
fi

category="$1"

mapfile -t packages < <(pacman -Qs "$category" 2>/dev/null | sed -n 's|^local/\([^ ]*\) .*|\1|p')

if [[ ${#packages[@]} -eq 0 ]]; then
    echo "No installed packages found matching '$category'."
    exit 1
fi

get_description() {
    local pkg="$1"
    local desc

    desc=$(whatis "$pkg" 2>/dev/null | head -1 | sed 's/^[^-]*- //')
    if [[ -n "$desc" ]]; then
        echo "$desc"
        return
    fi

    desc=$(pacman -Qi "$pkg" 2>/dev/null | sed -n 's/^Description *: //p')
    echo "${desc:-(no description)}"
}

echo "INSTALLED TOOLS: $category"
echo "=================================="
{
    echo "TOOL|DESCRIPTION"
    for pkg in "${packages[@]}"; do
        desc=$(get_description "$pkg")
        echo "$pkg|$desc"
    done
} | column -t -s '|'
