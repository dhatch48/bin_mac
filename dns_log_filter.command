#!/bin/bash
#set -x

logFileOrig='/Volumes/c$/dns.log'
mountDir="${logFileOrig%/*}"
mountLocation='//dc4/c$'
logFileDestination="$HOME/Downloads/dns.log"
dnsLookupFileOrig='/Volumes/c$/dnsEntries.txt'
dnsLookupFile="$HOME/Downloads/dnsEntries.txt"


# Mount smb location if not already mounted
if ! mount | fgrep "dc4/c$ on $mountDir" > /dev/null; then
    mkdir "$mountDir"
    mount_smbfs "$mountLocation" "$mountDir" && echo "$mountLocation mounted"
fi


# Make a local copy
cp "$logFileOrig" "$logFileDestination"
awk '$4 ~ /^[1-9]/ {print $4,$1}' "$dnsLookupFileOrig" | sort -u > "$dnsLookupFile"


# Prepare filterList for use as regex
filterList=$(cat /Volumes/c\$/dns_whitelist_filter_list.txt)
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
