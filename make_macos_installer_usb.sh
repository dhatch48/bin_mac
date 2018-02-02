#!/bin/bash

### Find newest installer
installer=$(ls -dt /Applications/Install\ *.app/ | head -1)

sourceLocation="$installer"Contents/Resources/createinstallmedia
destination=''

### Find the destination
x=1
IFS='
'
for line in $(df -h | grep disk); do
    devices[$x]=$line
    echo "$x. $line"
    (( x++ ))
done
unset IFS

read -p "Select destination volume...Enter number [1-$((x-1))]: " number
selection="${devices[$number]}"
destination="${selection/#*Volumes//Volumes}"
echo

read -n 1 -p "Install file: $installer
Destination: $destination

Please confirm to continue (Y/N) " answer
echo

if [[ $answer == [yY] ]]; then
    if [[ -d $destination ]]; then
        sudo "$sourceLocation" --volume "$destination" --nointeraction && say Boot Installer Complete
    else
        echo "Destination is not valid. Try again"
        exit 1
    fi
fi

exit 0
