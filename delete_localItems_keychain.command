#!/bin/bash
set -x

parentDir="$HOME/Library/Keychains"
match="????????-????-????-????-*"

localItemsFolder="$(echo $parentDir/$match)"

rm -rf "$localItemsFolder" && echo "local items folder removed. Please reboot immediately"
