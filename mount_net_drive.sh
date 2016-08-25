#!/bin/bash
# takes one arg specifying a drive letter
# validate input to be one of the drives available in $drive array
set -x

mount_smbDrive() {
    drive[0]="smb://vm2/F - Data"
    drive[1]="smb://vm2/G - Art Department"
    drive[2]="smb://vm2/H - Honor Life"
    drive[3]="smb://vm2/I - Developement"
    drive[4]="smb://vm2/J - Archives"
    drive[5]="smb://vm2/M - MAS"
    drive[6]="smb://vm2/O - OS"
    drive[7]="smb://vm2/R - Resources"
    drive[8]="smb://vm2/S - Sales"
    drive[9]="smb://vm3/T - FTP"
    drive[10]="smb://vm2/web"

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
        mountGood=$(osascript -e "try 
            mount volume \"$smbLocation\"
            set mountGood to true
        on error
            set mountGood to false
        end try")
        [[ $mountGood == true ]] && echo "$smbLocation mounted"
    else 
        printf "%s" "$1 is not a valid option. Valid options are: "
        for netDrive in "${drive[@]}"; do
            printf "%s " "${netDrive:10:1}"
        done
        echo
        echo "These map to the following locations:"
        printf "%s\n" "${drive[@]//\%20/ }"
    fi
}
mount_smbDrive "$1"
