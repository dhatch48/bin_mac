#!/usr/bin/env bash

set -eo pipefail    # Turns on strict error options - exit on first error.

#/ Usage: checkNetOS.sh [OPTION] [ipRangeStart] [ipRangeEnd]
#/ Description: Get H/W and OS info for Apple Computers by ip range
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

echo Running...
# Read Password
echo
echo -n "Please input password: "
read -s password
[ -z "$password" ] && exit 1

# Establish Default range of IPs
startIP=10.93.0.${1:-60}
endIP=${2:-210}
clientScript="ssh-run.cmd=system_profiler SPSoftwareDataType SPHardwareDataType SPNetworkDataType | sort"


# Check Network's Mac Info
echo
echo "Checking Network Range $startIP to $endIP"
echo
nmap -p 22 -oN - --script=ssh-run \
    --script-args="$clientScript, ssh-run.username=Administrator, ssh-run.password=$password" "$startIP-$endIP" \
    | awk '/(Computer Name|System Version|Model Identifier|Processor |Memory: [0-9]|IPv4 Addresses: 10.93.0.)/ {
        $1 = ""; 
        if($0 ~ /Computer/) printf"\n";
        sub(/\\x0D/, "", $0);
        print $0;
    }'
