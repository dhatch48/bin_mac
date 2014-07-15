#!/bin/bash

testdir="/Volumes/_Drivers"
if [ ! -d "$testdir" ]; then
    mkdir "$testdir"
    mount_smbfs //vm3/"${testdir##*/}" "$testdir" && echo "volume mounted"
    #echo "$testdir not mounted"; exit 1
fi
# Xitron Accuset 800 queues
#lpadmin -p "Accuset-8.5x14" -E \
#    -v "smb://rip-pc/Accuset-8.5x14" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"
#lpadmin -p "Accuset-14x14" -E \
#    -v "smb://rip-pc/Accuset-14x14" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"
#lpadmin -p "Accuset-14x20" -E \
#    -v "smb://rip-pc/Accuset-14x20" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"
#lpadmin -p "Accuset-14x30" -E \
#    -v "smb://rip-pc/Accuset-14x30" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"
#lpadmin -p "Accuset-14x40" -E \
#    -v "smb://rip-pc/Accuset-14x40" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"
#lpadmin -p "Accuset-14x50" -E \
#    -v "smb://rip-pc/Accuset-14x50" \
#    -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
#    -o printer-is-shared=false -o printer-op-policy="authenticated"

# SoftRIP printer queues
lpadmin -p "Epson_SP_7890_Mono" -E \
    -v "lpd://rip2-pc/1" \
    -P "/Volumes/_Drivers/Printers/PPDs/Mac/epsn7890.ppd" \
    -o printer-is-shared=false
lpadmin -p "Epson_SP_9880_Mono" -E \
    -v "lpd://rip2-pc/2" \
    -P "/Volumes/_Drivers/Printers/PPDs/Mac/epsn9880.ppd" \
    -o printer-is-shared=false
lpadmin -p "HP_DJ_800" -E \
    -v "lpd://rip2-pc/3" \
    -P "/Volumes/_Drivers/Printers/PPDs/Mac/HP800.ppd" \
    -o printer-is-shared=false

# Copiers
lpadmin -p "Copier_1st_Floor" -E \
    -v "smb://vm3.dottek.com/Copier_1st_Floor" \
    -P "/Volumes/_Drivers/Printers/Konica Minolta bizhub 352c/Postscript Fiery X3e TY30C-KM WHQL v1.01/EF5M4127.PPD" \
    -o printer-is-shared=false \
    -o printer-op-policy="authenticated"
#lpadmin -p "Copier_2nd_Floor" -E \
#    -v "dnssd://EFI%20Fiery%20E10%2050-45C-KM%20PS%20Color%20Server1.1%20(2)._pdl-datastream._tcp.local./?bidi" \
#    -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Fiery E10 50-45C-KM PS1.1" \
#    -o printer-is-shared=false
