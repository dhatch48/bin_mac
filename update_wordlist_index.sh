#!/bin/bash
#set -x

wordListFile="$HOME/bin/tech_wordlist.txt"

# Get index from 1st line of file and then increment
read -r index < "$wordListFile"
(( index++ ))

# Loop the word list when the last word is used
lineCount=$(wc -l "$wordListFile" | awk '{print $1}')
if [[ $index -gt $lineCount ]];then
    index=2
fi

# Update index in wordlist
sed -i.bak '1 s/^.*$/'$index'/' "$wordListFile"
