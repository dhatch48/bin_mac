#!/bin/bash

# Finds all .ai files saved in the specified version (in current directory)
# @param illustrator version in CS or decimal format
# @return list of filenames

versionLookup='CS 11
CS2 12
CS3 13
CS4 14
CS5 15
CS6 16
CC 17'

# Check for param
if [[ -n $1 ]]; then

    # Bypass lookup if version 8, 9, or 10
    if [[ $1 = 10 || $1 = 9 || $1 = 8 ]]; then
        version="$1"
    else
        # Look for param match in versionLookup
        version=$(echo "$versionLookup" | grep -iw $1)

        # substing last 2 characters to get just the decimal version from lookup
        version="${version: -2}"
    fi
else
    echo 'No version speceified. Please specify illustrator version as argument ex: cs6'
    exit 1
fi

# Find illustrator files that are saved in chosen version and output filenames
if [[ -n $version ]]; then
    LC_ALL=C fgrep -l "%%Creator: Adobe Illustrator(R) $version" *.ai
else
    echo "'$1' is not a supported version. Supported versions are:
    8, 9, 10, CS, CS2, CS3, CS4, CS5, CS6, CC"
    exit 2
fi
