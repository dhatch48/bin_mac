#!/bin/bash

sourceLocation="$HOME/Downloads/Pastor"
drives=$(ls -d /Volumes/USB*/)
FAIL=0

IFS='
'
for drive in $drives; do
    if [ ! -d "$drive" ]; then
        echo "$drive is not a valid location"; continue
    fi
    echo "Cleaning $drive"
    rm -rf "$drive"*
    echo "Copying Files..."
    cp "$sourceLocation/"* "$drive" &
done

for job in $(jobs -p); do
    wait $job || let "FAIL+=1"
done

if [ "$FAIL" == "0" ];
then
    echo "File copy complete for all drives!"
else
    echo "Fils copy failed for $FAIL drive(s)"
fi

for drive in $drives; do
    diskutil unmount "$drive"
done
echo
echo "Batch complete"
osascript -e 'tell app "System Events" to display dialog "USB Batch Complete"'
