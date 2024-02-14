#!/bin/bash

# Display help message
function display_help() {
    echo "Usage: g PATTERN DIRECTORY"
    echo
    echo "Searches for a PATTERN recursively in the specified DIRECTORY, excluding specific file types."
    echo "The PATTERN is basic regular expression."
    echo
    echo "Arguments:"
    echo "  PATTERN         The pattern to search for. Please enclose in a pair of single quotes."
    echo "  DIRECTORY       The directory path to search in."
    echo
    echo "Options:"
    echo "  -h, --help      Display this help message and exit."
    echo
    echo "Example:"
    echo "  g 'main()' ../ion-open-source-4.1.2/"
    echo "      Searches for the 'main()' pattern in the ../ion-open-source-4.1.2/ directory."
    echo
    exit 1
}

# Check for help option or insufficient arguments
if [[ $1 == "-h" ]] || [[ $1 == "--help" ]] || [ $# -lt 2 ]; then
    display_help
fi

# Input validation
PATTERN=$1
DIRECTORY=$2

if [[ -z "$PATTERN" ]]; then
    echo "Error: Empty search pattern."
    exit 1
fi

if [[ -z "$DIRECTORY" ]]; then
    echo "Error: Directory path not provided."
    exit 1
fi

if [ ! -d "$DIRECTORY" ]; then
    echo "Error: Directory does not exist or is not a directory."
    exit 1
fi

# Main search command
grep -rn "$PATTERN" "$DIRECTORY" --exclude=*.text --exclude=*.js --exclude=*.cpp --exclude=*.supp --exclude=*.pod --exclude=*.css --exclude=*.py --exclude=*.hs

# Exit the script successfully
exit 0
