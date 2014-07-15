#!/bin/bash

# Old Version
#testdir="/Volumes/F - Data"
#testdir_uri="/Volumes/F%20-%20Data"
#if [ ! -d "$testdir" ]; then
#    mkdir "$testdir"
#    mount_smbfs //david@vm2/"${testdir_uri##*/}" "$testdir" && echo "volume mounted"
#fi
#
#fontList="$testdir/Utils/fonts_to_remove.txt"
#
#while read -r filename ; do echo "$filename" ; done < "$fontList"

list="/Library/Fonts/Algerian.TTF
/Library/Fonts/Army Condensed.ttf
/Library/Fonts/Army Expanded.ttf
/Library/Fonts/Army Hollow Condensed.ttf
/Library/Fonts/Army Hollow Expanded.ttf
/Library/Fonts/Army Hollow Thin.ttf
/Library/Fonts/Army Hollow Wide.ttf
/Library/Fonts/Army Hollow.ttf
/Library/Fonts/Army Thin.ttf
/Library/Fonts/Army Wide.ttf
/Library/Fonts/Army.ttf
/Library/Fonts/Black Chancery.TTF
/Library/Fonts/COMBULN.TTF
/Library/Fonts/DC120.TTF
/Library/Fonts/DC120_0.TTF
/Library/Fonts/DC155.TTF
/Library/Fonts/DC155_0.TTF
/Library/Fonts/DC20.TTF
/Library/Fonts/DC20_0.TTF
/Library/Fonts/DC52.TTF
/Library/Fonts/DC7.TTF
/Library/Fonts/HOBBYHOR.TTF
/Library/Fonts/Metallica.TTF
/Library/Fonts/QUIGLEYW.TTF
/Library/Fonts/SMARTF.TTF
/Library/Fonts/SMARTF_0.TTF
/Library/Fonts/Torhok Italic.TTF
/Library/Fonts/Victorias-Secre.TTF
/Library/Fonts/cats_MEOW.ttf
/Library/Fonts/chilipep.ttf
/Library/Fonts/cia.ttf
/Library/Fonts/cia_0.ttf
/Library/Fonts/cia_pn.ttf
/Library/Fonts/cia_pn_0.ttf
/Library/Fonts/dfmw5.ttf
/Library/Fonts/marigold.TTF
/Library/Fonts/marigold_0.TTF
/Library/Fonts/micr.ttf
/Library/Fonts/unical-blackletter-medievalceltic-bold-regular.ttf"

IFS=$'\n'
set -x
for file in $list; do
    sudo rm -f "$file"
done

