#!/bin/bash
set -x

logFileOrig='/Volumes/c$/dns.log'
mountDir="${logFileOrig%/*}"
mountLocation='//dc4/c$'
logFileDestination="$HOME/Downloads/dns.log"
filterList='apple akamai google dottek adobe webroot paycomonline gmail'

# Mount smb location if not already mounted
if ! mount | fgrep "dc4/c$ on $mountDir" > /dev/null; then
    mkdir "$mountDir"
    mount_smbfs "$mountLocation" "$mountDir" && echo "$mountLocation mounted"
fi

# Make a local copy
#cp "$logFileOrig" "$logFileDestination"


# Prepare filterList for use in sed
#for word in $filterList; do
#    filterWords="$filterWords[^[:alnum:]]$word[^[:alnum:]]|"
#done
for word in $filterList; do
    filterWords="$filterWords$word|"
done
filterWords="${filterWords%|}"


# Filter and format file
realTab=$(echo -e "\t")
sed -E "
/^[^0-9]/ d
/^.*($filterWords).*$/ d
s/ +/$realTab/g" < "$logFileDestination" > "${logFileDestination/.log/_log_tsv.txt}"
