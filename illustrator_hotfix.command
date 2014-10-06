#!/bin/bash

testdir="/Volumes/O - OS"
testdir_uri="/Volumes/O%20-%20OS"
if [ ! -d "$testdir" ]; then
    mkdir "$testdir"
    mount_smbfs //vm2/"${testdir_uri##*/}" "$testdir" && echo "$testdir mounted"
fi

rm_folder="/Applications/Adobe/Adobe Illustrator CC/Adobe Illustrator.app/Contents/Frameworks/dvaui.framework"
source_folder="/Volumes/O - OS/Applications/Adobe/Adobe_Illustrator_CC_Hotfix/AdobeIllustratorCC_HotFix_on_17.1.0/dvaui.framework"

mv "$rm_folder" ~/.Trash/ && echo "$rm_folder in trash"
cp -r "$source_folder" "$rm_folder" && echo "copied to $rm_folder"