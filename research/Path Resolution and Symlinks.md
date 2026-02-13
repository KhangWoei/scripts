# Path Resolution and Symlinks

## 1. BASH_SOURCE and Symlinks

`${BASH_SOURCE[0]}` returns the path used to invoke the script, not the real file path.
When run through a symlink, it returns the symlink path.

```
# Given: ~/.bin/help-scripts.sh -> /home/khang/Projects/scripts/src/help/scripts.sh

${BASH_SOURCE[0]}  # Returns ~/.bin/help-scripts.sh (the symlink)
dirname ...         # Returns ~/.bin
```

This breaks any relative path logic that depends on the script's real location.

### Fix: readlink -f

```
real_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(dirname "${real_path}")"
```

`readlink -f` follows all symlinks and returns the canonical absolute path.

Note: on macOS, `readlink -f` requires coreutils. The portable alternative is `realpath`.

## 2. $0 vs BASH_SOURCE

`$0` and `${BASH_SOURCE[0]}` behave differently when a script is sourced.

```
# script.sh
echo "\$0 = $0"
echo "BASH_SOURCE = ${BASH_SOURCE[0]}"
```

```
# Executed directly:
$0           = ./script.sh
BASH_SOURCE  = ./script.sh

# Sourced (source script.sh):
$0           = bash        (the parent shell)
BASH_SOURCE  = script.sh   (still the script)
```

Use `BASH_SOURCE` when you need the script path regardless of how it was invoked.

## 3. cd -P (Resolve Symlinked Directories)

`cd` follows symlinks by default, so `pwd` may return a symlinked directory path.

```
cd -P /some/symlinked/dir
pwd  # Returns the real physical path
```

A common pattern that handles both symlinks and directory resolution:

```
real_path="$(readlink -f "${BASH_SOURCE[0]}")"
script_dir="$(cd -P "$(dirname "${real_path}")" && pwd)"
```

## 4. Symlinks and Relative Paths in General

Any script that builds paths relative to its own location will break under symlinks.
This includes sourcing other files, reading configs, or referencing sibling directories.

```
# Breaks under symlink
config="${script_dir}/../config.ini"

# Safe
real_path="$(readlink -f "${BASH_SOURCE[0]}")"
config="$(dirname "$(dirname "${real_path}")")/config.ini"
```

Rule of thumb: if a script uses its own location for anything, resolve symlinks first.
