#!/bin/bash
# takes one arg specifying a drive letter
# validate input to be one of the drives available in $drive array
# mount that smb drive if doesn't exist
#set -x

# Spaces must be escaped with %20
mount_smbDrive() {
    drive[0]="//vm2/F%20-%20Data"
    drive[1]="//vm2/G%20-%20Art%20Department"
    drive[2]="//vm2/H%20-%20Honor%20Life"
    drive[3]="//vm2/I%20-%20Developement"
    drive[4]="//vm2/J%20-%20Archives"
    drive[5]="//vm2/M%20-%20MAS"
    drive[6]="//vm2/O%20-%20OS"
    drive[7]="//vm2/R%20-%20Resources"
    drive[8]="//vm2/S%20-%20Sales"
    drive[9]="//vm3/T%20-%20FTP"
    drive[10]="//vm2/web"

    smbLocation=$(
        argToUpper=$(echo "$1" | tr '[:lower:]' '[:upper:]')
        case "$argToUpper" in
            ("F") echo "${drive[0]}" ;;
            ("G") echo "${drive[1]}" ;;
            ("H") echo "${drive[2]}" ;;
            ("I") echo "${drive[3]}" ;;
            ("J") echo "${drive[4]}" ;;
            ("M") echo "${drive[5]}" ;;
            ("O") echo "${drive[6]}" ;;
            ("R") echo "${drive[7]}" ;;
            ("S") echo "${drive[8]}" ;;
            ("T") echo "${drive[9]}" ;;
            ("W") echo "${drive[10]}" ;;
            (*) echo "" ;;
        esac
    )

    if [[ -n $smbLocation ]]; then
        mountLocation="${smbLocation///vm?/Volumes}"
        mountLocation="${mountLocation//%20/ }"
        if ! mount | grep "on $mountLocation" > /dev/null; then
            mkdir "$mountLocation"
            mount -t smbfs "$smbLocation" "$mountLocation" && echo "$smbLocation mounted"
        else
            echo "$smbLocation is already mounted"
        fi
    else 
        echo "$1 is not a valid smb Location"
    fi
}
mount_smbDrive "$1"
