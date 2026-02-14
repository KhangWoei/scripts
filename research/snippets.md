# Useful Snippets

## Get the directory of the current script (resolves symlinks)

```bash
real_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "${real_path}")"
```

Follows symlinks to the real file location, then takes the directory. Use this when the script is invoked via a symlink and you need paths relative to the actual source.

## Get the directory of the current script (without resolving symlinks)

```bash
script_dir=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
```

Resolves the directory of however the script was called, but does **not** follow symlinks. If called via a symlink in `~/.bin/`, this returns `~/.bin/` rather than the real location. Useful when you don't care about symlinks and just want an absolute path.

## Check if a command exists

```bash
if command -v foo &>/dev/null; then
  echo "foo is available"
fi
```

Preferred over `which`, `command -v` is a shell builtin, portable across shells, and doesn't depend on an external binary. Returns 0 if the command is found, 1 if not.

## Default variable values

```bash
name="${1:-default}"   # use "default" if $1 is unset or empty
name="${1:=default}"   # same, but also assigns "default" to $1
```

`:-` provides a fallback without modifying the variable. `:=` provides a fallback **and** assigns it. There are also variants without the colon (`-`, `=`) that only trigger when the variable is truly unset, not when it's set to an empty string.

## Strict mode

```bash
set -euo pipefail
```

- `set -e` — exit immediately if any command fails
    - Does not catch commands in `if` conditions, `||`/`&&` chains
    - Subshells don't trigger this
- `set -u` — treat unset variables as errors
- `set -o pipefail` — a pipeline fails if any command in it fails, not just the last one

## Trap for cleanup

```bash
tmpfile=$(mktemp)
trap 'rm -f "$tmpfile"' EXIT

# ... use $tmpfile ...
```

The `trap` command runs the given command when the script exits, whether it finishes normally, hits an error, or is interrupted with Ctrl+C. Common signals: `EXIT` (any exit), `INT` (Ctrl+C), `TERM` (kill).

## Read a file line by line

```bash
while IFS= read -r line; do
  echo "$line"
done < file.txt
```

- `IFS=` — prevents stripping of leading/trailing whitespace
- `-r` — prevents backslash interpretation

## Check if running as root

```bash
if (( EUID == 0 )); then
  echo "running as root"
fi
```

`EUID` is a bash builtin variable containing the effective user ID. Cleaner than parsing `whoami` or `id` output.

## Parameter expansion

### Strip prefix

```bash
path="/home/khang/scripts"
echo "${path#*/}"          # home/khang/scripts  (shortest match)
echo "${path##*/}"         # scripts             (longest match)
```

- `${var#pattern}` — removes the shortest match of `pattern` from the **start**
- `${var##pattern}` — removes the longest match of `pattern` from the **start**

The `#` itself is the operator, so to match a literal `#` in the pattern, escape it: `${line#\# @name: }`.

### Strip suffix

```bash
file="backup.tar.gz"
echo "${file%.*}"          # backup.tar          (shortest match)
echo "${file%%.*}"         # backup              (longest match)
```

- `${var%pattern}` — removes the shortest match of `pattern` from the **end**
- `${var%%pattern}` — removes the longest match of `pattern` from the **end**

### Substitution

```bash
msg="hello world"
echo "${msg/world/bash}"   # hello bash          (first match)
echo "${msg//l/L}"         # heLLo worLd         (all matches)
```

- `${var/pattern/replacement}` — replaces the first match
- `${var//pattern/replacement}` — replaces all matches

### Substring

```bash
str="abcdefgh"
echo "${str:2:3}"          # cde                 (offset 2, length 3)
echo "${str:4}"            # efgh                (offset 4 to end)
```

### Length

```bash
str="hello"
echo "${#str}"             # 5
```

### Case conversion

```bash
str="Hello World"
echo "${str,,}"            # hello world         (all lowercase)
echo "${str^^}"            # HELLO WORLD         (all uppercase)
echo "${str,}"             # hello World         (first char lowercase)
echo "${str^}"             # Hello World         (first char uppercase)
```
