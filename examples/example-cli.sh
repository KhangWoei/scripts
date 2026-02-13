#!/bin/bash

# Example script demonstrating the CLI utilities

# Source the CLI utilities library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../src/utils/cli-utils.sh"

# Initialize the CLI with script name and description
cli_init "example-cli" "Example script showing how to use CLI utilities"

# Define flags (boolean options that don't take values)
cli_add_flag "verbose" "v" "verbose" "Enable verbose output"
cli_add_flag "debug" "d" "debug" "Enable debug mode"

# Define options (require values)
cli_add_option "output" "o" "output" "Output file path" "output.txt"
cli_add_option "format" "f" "format" "Output format (json|text|csv)" "text"

# Define positional arguments
cli_add_positional "input_file" "Input file to process" "true"
cli_add_positional "destination" "Destination directory" "false"

# Parse the command line arguments
cli_parse "$@"

# Now you can use the parsed values
echo "Script is running with the following configuration:"
echo "=================================================="

# Get flag values
if cli_flag "verbose"; then
    echo "Verbose mode: ENABLED"
else
    echo "Verbose mode: DISABLED"
fi

if cli_flag "debug"; then
    echo "Debug mode: ENABLED"
else
    echo "Debug mode: DISABLED"
fi

# Get option values
echo "Output file: $(cli_get "output")"
echo "Format: $(cli_get "format")"

# Get positional argument values
echo "Input file: $(cli_get "input_file")"

destination=$(cli_get "destination")
if [ -n "$destination" ]; then
    echo "Destination: $destination"
else
    echo "Destination: (not provided)"
fi

echo ""
echo "Script execution would happen here..."

# Example of using flags in logic
if cli_flag "verbose"; then
    echo "[VERBOSE] Processing file: $(cli_get "input_file")"
    echo "[VERBOSE] Using format: $(cli_get "format")"
fi

if cli_flag "debug"; then
    echo "[DEBUG] All parsed values:"
    for key in "${!CLI_PARSED[@]}"; do
        echo "[DEBUG]   $key = ${CLI_PARSED[$key]}"
    done
fi
