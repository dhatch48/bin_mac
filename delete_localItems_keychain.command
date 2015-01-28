#!/bin/bash
#set -x

parentDir="$HOME/Library/Keychains"
match="????????-????-????-????-*"

localItemsFolder="$(echo $parentDir/$match)"

read -n 1 -p "Are you sure you want to want to remove $localItemsFolder? (Y/N) " answer
echo

if [[ $answer == [yY] ]]; then
    rm -rf "$localItemsFolder" && echo "folder removed. Please restart immediately"
fi
