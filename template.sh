#!/usr/bin/env bash

set -eo pipefail    # Turns on strict error options - exit on first error.

#/ Usage: template.sh [OPTION] FILE
#/ Description:
#/ Examples:
#/ Options:
#/      -h: Display this help message
#/      -d: debug mode

# Basic helpers
out() { echo "$(date '+%Y-%m-%d %H:%M:%S') $@"; }
err() { out "[ERROR] $@" 1>&2; echo; }
die() { out "[FATAL] $1" && [ "$2" ] && [ "$2" -ge 0 ] && exit "$2" || exit 1; }
usage() { grep '^#/' "$0" | cut -c4- ; exit 0 ; }

# Parse options
while getopts "dh" opt; do
    case "$opt" in
        d) DEBUG=1 ;;
        h) usage ;;
    esac
done
shift $((OPTIND-1))

[ "$DEBUG" ] && set -x
# Script start
###############################################################################

