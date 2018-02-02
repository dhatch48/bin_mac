#!/bin/bash

installer=$(ls -dt /Applications/Install*.app/ | head -1)

sourceLocation="$installer"Contents/Resources/createinstallmedia
destination=$(ls -d /Volumes/Install\ macOS*/)


read -n 1 -p "Found install file: $installer
Found destination:
$(df -h |awk 'NR==1 {print}; /Volumes\/Install mac/ {print}')

Please confirm to continue (Y/N) " answer
echo

if [[ $answer == [yY] ]]; then
    sudo "$sourceLocation" --volume "$destination" --nointeraction && say Boot Installer Complete
fi

exit
