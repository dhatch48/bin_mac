#!/bin/bash
#set -x
if [[ $USER != "david" ]]; then
    echo "Current user is not valid"
    exit 1
fi

newFontLocation="/Volumes/R - Resources/Fonts/Bar code fonts/Free3of9.otf"
newFontName="${newFontLocation##*/}"

cd /Library/Fonts
# Delete bad barcode font
echo "Deleted files:"
sudo find . -iname 'free*3*9*' -exec rm -fv '{}' \;
echo

# Connect to font resource
. "${0%/*}/mount_net_drive.command" r

# Install new barcode font
cp -f "$newFontLocation" . 
chmod +r ./"$newFontName"
sudo chown root:wheel ./"$newFontName"
echo "New file:"
ls -lah ./"$newFontName"
