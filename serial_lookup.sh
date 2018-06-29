#!/bin/bash
#set -x

# Mac OSX file paths
if [[ "$OSTYPE" == "darwin"* ]]; then
    file='/Volumes/I - Developement/My Docs/Reference/Our Serial Numbers.txt'
    if [[ ! -e $file ]]; then
        # If file doesn't exist then try to mount the share
        if type mount_net_drive.sh &>/dev/null; then
           mount_net_drive.sh i
        else
           echo -e "Error: Can't find file: $file \nPlease mount '//vm2/I - Developement' then try again"
           exit 2
       fi
    fi

# Cygwin file paths
elif [[ "$OSTYPE" == "cygwin" ]]; then
    file='/cygdrive/i/My Docs/Reference/Our Serial Numbers.txt'
fi

if [[ -n $* ]]; then
    grep -Ei --color=auto "$*" "$file"
else
    echo "Error: Requires at least 1 param used to search with"
    exit 1
fi
