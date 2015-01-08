#!/bin/bash
#set -x

# Mac OSX file paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    logFileOrig='/Volumes/c$/dns.log'
    mountDir="${logFileOrig%/*}"
    mountLocation='//dc4/c$'
    dnsLookupFileOrig='/Volumes/c$/dnsEntries.txt'
    dnsWhiteList='/Volumes/c$/dns_whitelist_filter_list.txt'

# Cygwin file paths
elif [[ "$OSTYPE" == "cygwin" ]]; then
    logFileOrig='//dc4/c$/dns.log'
    dnsLookupFileOrig='//dc4/c$/dnsEntries.txt'
    dnsWhiteList='//dc4/c$/dns_whitelist_filter_list.txt'
fi

logFileDestination="/tmp/dns.log"
dnsLookupFile="/tmp/dnsEntries.txt"

# Mount smb location if not already mounted. Only for OSX
if [[ "$OSTYPE" == "darwin"* ]] && ! mount | fgrep "dc4/c$ on $mountDir" > /dev/null; then
    mkdir "$mountDir"
    mount -t smbfs "$mountLocation" "$mountDir" && echo "$mountLocation mounted"
fi

# Make a local copy
cp "$logFileOrig" "$logFileDestination"
awk '$2 ~ /^[1-9]/ {print $2,substr($1, 1, length($1)-11)}' "$dnsLookupFileOrig" | sort -u > "$dnsLookupFile"

# Prepare filterList for use as regex
# tr is used to remove carriage returns in case its dos format
filterList=$(cat $dnsWhiteList | tr -d '\r')
#for word in $filterList; do
#    filterWords="$filterWords[^[:alnum:]]$word[^[:alnum:]]|"
#done
if [[ -n $filterList ]]; then
    for word in $filterList; do
        filterWords="$filterWords$word|"
    done
    filterWords="${filterWords%|}"
else
    echo "Can't find whitelist filter file" && exit 1
fi

# Filter, add hostnames, and format as tab seperated
awk '
    BEGIN {OFS="\t"}
    FNR==NR{arr[$1]=$2;next}
    /^[0-9]/ && $9 ~ /^1/ && $NF !~ /^.+'"$filterWords"'.+$/ {print $1,$2,$3,$9,arr[$9],$NF}
' "$dnsLookupFile" "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}"
