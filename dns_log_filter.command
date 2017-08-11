#!/bin/bash
#set -x

# Mac OSX file paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    logFileOrig='/Volumes/c$/dns.log'
    mountDir="${logFileOrig%/*}"
    smbLocation='smb://dc4/c$'
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
    mountGood=$(osascript -e "try 
        mount volume \"$smbLocation\"
        set mountGood to true
    on error
        set mountGood to false
    end try")
    if [[ $mountGood == true ]]; then
        echo "$smbLocation mounted"
    else
        echo "Mounting $smbLocation failed!"
        exit 1
    fi
fi

# Make a local copy
cp "$logFileOrig" "$logFileDestination"

# Create dns lookup file. Remove carriage return, and output ip and hostname only
awk '
    {sub("\r$", "")}
    $NF ~ /^1/ && $1 ~ /^[a-zA-Z]/ && $1 !~ /^(DomainDnsZones|ForestDnsZones|dottek)/ {print $NF,$1}
' "$dnsLookupFileOrig" | sort -u > "$dnsLookupFile"

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
' "$dnsLookupFile" "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}" \
&& echo "Formatted file saved here: ${logFileDestination/.log/_log_tsv.txt}"
