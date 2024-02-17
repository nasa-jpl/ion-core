#!/bin/bash

# Get the full path to the directory containing the script
SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Change directory to the script's directory
cd "$SCRIPT_DIR" || exit

# Update the noextensions.c file
head -n 56 ../inc/noextensions.c > temp
cat clean_noex.txt >> temp
cp temp ../inc/noextensions.c
rm temp
exit
