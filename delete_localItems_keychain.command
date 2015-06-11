#!/bin/bash
#set -x

parentDir="$HOME/Library/Keychains"
match="????????-????-????-????-*"

localItemsFolder="$(echo $parentDir/$match)"

echo
read -n 1 -p "Are you sure want to delete and restart? (y/n):" answer
echo

if [[ $answer == [yY] ]]; then
    rm -rf "$localItemsFolder" && osascript -e 'tell application "Finder" to restart' &
else 
    echo "Operation cancelled"
fi

osascript -e 'tell application "Terminal" to quit' &
exit 0
