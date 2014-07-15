#!/bin/bash

# Uses current running script location for plist SHLOCATION
# Therefore, copy this script to proper location prior to running the
# '--install' parameter

#Use for for debbuging, shows commands executed
set -x

#Kill background process, if any on exit
trap 'kill $(jobs -p)' EXIT

# Vars used in install and uninstall functions
scriptDir=$( cd $(dirname $0) ; pwd -P )
plistLocation="$HOME/Library/LaunchAgents/com.memorialorders.open_illustrator.plist"
PIPELOCATION="$scriptDir/illustratorFilePipe"

# Mount if needed the smb drive of passed file
function mountSmbDrive {
    targetFile="$1"
    pcName=$(echo "$targetFile" | awk -F "/" '{print $3}')
    firstFolder=$(echo "$targetFile" | awk -F "/" '{print $4}')
    testdir="/Volumes/$firstFolder"
    testdir_url="//$pcName/${firstFolder// /%20}"

    echo "mounting to $testdir_url $testdir"

    if ! mount | grep "on $testdir" > /dev/null; then
        mkdir "$testdir"
        mount_smbfs "$testdir_url" "$testdir" && echo "volume mounted"
        sleep 1
    fi
}

# Open passed file in Illustrator
function openIllustratorFile {
    targetFile="$1"
    echo "PC NAME IS $pcName"
    open -a "Adobe Illustrator" "${targetFile/smb:\/\/$pcName\///Volumes/}"
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
    echo "$plistData">"$plistLocation"
    echo "Daemon installed - manually load or logoff and logon"
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
        openIllustratorFile "$THEFILE"
    done < "$PIPELOCATION"
}

# Check for args passed to modify script behavior
if [[ $# -eq 0 ]]; then 
    illustratorLoop
elif [[ $1 = --install ]]; then 
    installDaemon
elif [[ $1 = --uninstall ]]; then
    uninstallDaemon
fi
