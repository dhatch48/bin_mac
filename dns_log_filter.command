#!/bin/bash
#set -x

logFileOrig='/Volumes/c$/dns.log'
mountDir="${logFileOrig%/*}"
mountLocation='//dc4/c$'
logFileDestination="$HOME/Downloads/dns.log"
dnsLookupFileOrig='/Volumes/c$/dnsEntries.txt'
dnsLookupFile="$HOME/Downloads/dnsEntries.txt"
filterList=$(cat /Volumes/c\$/dns_whitelist_filter_list.txt)
#filterList='apple akamai google dottek adobe webroot paycomonline gmail'


# Mount smb location if not already mounted
if ! mount | fgrep "dc4/c$ on $mountDir" > /dev/null; then
    mkdir "$mountDir"
    mount_smbfs "$mountLocation" "$mountDir" && echo "$mountLocation mounted"
fi

# Make a local copy
cp "$logFileOrig" "$logFileDestination"
awk '{print $4,$1}' "$dnsLookupFileOrig" | grep '^[1-9]' | sort -u > "$dnsLookupFile"


# Prepare filterList for use in sed
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

# Filter and format file
awk '
    BEGIN {OFS="\t"}
    FNR==NR{arr[$1]=$2;next}
    /^[0-9]/ && $9 ~ /^1/ && $NF !~ /^.+'"$filterWords"'.+$/ {print $1,$2,$3,$9,arr[$9],$NF}
' "$dnsLookupFile" "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}"

#grep -Ev -e '^[^0-9]' -e '[2-9][0-9]*\.[0-9]+\.[0-9]+\.[0-9]+' -e "$filterWords" "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}" 
#sed -E '
#/^[^0-9]/ d
#/[2-9][0-9]*\.[0-9]+\.[0-9]+\.[0-9]+/ d
#/('"$filterWords"')/ d' < "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}"
# Lookup hostnames from ip. Format tab seperated

# Old slow way of lookups
#while read -r line; do
#    ipAddress=$(echo $line | awk '{ print $9 }')
#    if [[ $lastIpAddress != $ipAddress ]]; then
#        hostName=$(fgrep -w $ipAddress "$dnsLookupFile" | awk '{ print $1 }')
#    fi
#    lastIpAddress="$ipAddress"
#    echo "$line" | awk '{print $1,$2,$3,$9,host,$NF}' OFS="\t" host="$hostName" >> "${logFileDestination/.log/_log_tsv.txt}"
#done
