#!/bin/bash

# Uses current running script location for plist SHLOCATION
# Therefore, copy this script to proper location prior to running the
# '--install' parameter

#Use for for debbuging, shows commands executed
#set -x

# Vars used in install and uninstall functions
scriptDir=$( cd $(dirname $0) ; pwd -P )
plistLocation="$HOME/Library/LaunchAgents/com.memorialorders.open_illustrator.plist"
PIPELOCATION="$scriptDir/illustratorFilePipe"

# Find path to newest photoshop app. Used in openArtworkFile function
photoshopVersion="$(find /Applications -name "Adobe Photoshop CC*.app" -maxdepth 3 -print0 | xargs -0 stat -f "%m%t%N" | sort -rn | head -1 | cut -f2-)"

# Mount if needed the smb drive of passed file
function mountSmbDrive {
    targetFile="$1"
    pcName=$(echo "$targetFile" | awk -F "/" '{print $3}')
    firstFolder=$(echo "$targetFile" | awk -F "/" '{print $4}')
    smbLocation="smb://$pcName/$firstFolder"

    if ! mount | grep "on /Volumes/$firstFolder" > /dev/null; then
        echo "Connecting to $smbLocation"
        mountGood=$(osascript -e "try 
            mount volume \"$smbLocation\"
            set mountGood to true
        on error
            set mountGood to false
        end try")
        [[ $mountGood == true ]] && echo "Connected!"
    fi
}

# Open passed file in Illustrator
function openArtworkFile {
    targetFile="$1"
    applicationToRun="Adobe Illustrator"
    if echo "$targetFile" | grep -i "\.psd\s*"; then
        applicationToRun="$photoshopVersion"
    fi
    echo "PC NAME IS $pcName"
    open -a "$applicationToRun" "${targetFile/smb:\/\/$pcName\///Volumes/}"
}


# Create LaunchAgent plist file and install in user Library
# Once installed plist file will be loaded on next user login
function installDaemon {
    echo "Installing Daemon"
    shLocation="$scriptDir/${0##*/}"
    read -d '' plistData <<EOL
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.memorialorders.open_illustrator</string>
    <key>ProgramArguments</key>
    <array>
        <string>SHLOCATION</string>
    </array>
    <key>KeepAlive</key>
    <true/>
</dict>
</plist>
EOL
    plistData=$(echo "$plistData" | sed "s#SHLOCATION#$shLocation#g")
    if [[ ! -d "${plistLocation%/*}" ]]; then
        mkdir "${plistLocation%/*}"
    fi
    echo "$plistData">"$plistLocation" && launchctl load "$plistLocation"
    echo "Daemon install complete."
}

# Unloads active daemon and removes plist file
function uninstallDaemon {
    plistBasename="${plistLocation##*/}"
    plistSearchname="${plistBasename%.plist}"

    if launchctl list | grep "$plistSearchname"; then
        launchctl unload "$plistLocation"
    fi
    [[ -f "$plistLocation" ]] && rm "$plistLocation"

    [[ -p "$PIPELOCATION" ]] && rm "$PIPELOCATION"
    echo "Daemon uninstall complete"
}

# Setup named pipe and netcat listener
# opens illustrator file when proper data is received
function illustratorLoop {
    #make a pipe, and run background nectcat server to listen for input
    [ ! -p "$PIPELOCATION" ]  && mkfifo "$PIPELOCATION"
    nc -l -d -k 9995 1> $PIPELOCATION&

    #Just keep reading the next file that comes
    #into the pipe and try to open illustrator
    while read THEFILE; do
        echo READ THEFILE;
        mountSmbDrive "$THEFILE"
        openArtworkFile "$THEFILE"
    done < "$PIPELOCATION"
}

# Check for args passed to modify script behavior
if [[ $# -eq 0 ]]; then 
    # Kill background process, if any on exit
    trap 'kill $(jobs -p)' EXIT

    # Run listener
    illustratorLoop
elif [[ $1 = --install ]]; then 
    installDaemon
elif [[ $1 = --uninstall ]]; then
    uninstallDaemon
fi
