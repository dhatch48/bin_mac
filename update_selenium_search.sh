#!/bin/bash
#set -x

wordListFile="$HOME/bin/tech_wordlist.txt"
scriptFile="$HOME/bin/selenium_test_38.html"

# Get index from 1st line of file and then increment
read -r index < "$wordListFile"
(( index++ ))

# Loop the word list when the last word is used
lineCount=$(wc -l "$wordListFile" | awk '{print $1}')
if [[ $index -gt $lineCount ]];then
    index=2
fi

# Get the new word from that line index
newWord="$(sed -n ''$index' p' <"$wordListFile")"

# Replace script with new search word and update index in wordlist
sed -i.bak "27 s/>.*</>$newWord</" "$scriptFile" && sed -i.bak '1 s/^.*$/'$index'/' "$wordListFile"
