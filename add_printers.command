#!/bin/bash
#set -x

# This script adds network printers and mounts vm3 for required drivers.
# Takes one or more param which specifies which group of printers to add.

# *Configured ppd files are saved in /etc/cups/ppd/

function mountVm3Drivers {
    mountLocation="/Volumes/_Drivers"
    if  ! mount | grep "on $mountLocation" > /dev/null; then
        mkdir "$mountLocation"
        mount_smbfs //vm3/"${mountLocation##*/}" "$mountLocation" && echo "volume mounted"
    fi
}

function addShippingPrinter {
    # remove printer named "Shipping"
    lpadmin -x Shipping || echo 'There is no "Shipping" printer'

    # Add shipping printer using windows share
    ppdPath='/Library/Printers/PPDs/Contents/Resources/HP LaserJet 4250.gz'
    lpadmin -p "Shipping" -E \
        -v "smb://vm3/Shipping" \
        -P "$ppdPath" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
        && echo 'Shipping printer added'
}

function addITPrinter {
    ppdPath='/Library/Printers/PPDs/Contents/Resources/HP LaserJet 4240.gz'
    lpadmin -p "IT" -E \
        -v "smb://vm3/IT" \
        -P "$ppdPath" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
        && echo 'IT printer added'
}

function addAccountingPrinter {
    ppdPath='/Library/Printers/PPDs/Contents/Resources/hp LaserJet 4200 Series.gz'
    lpadmin -p "Accounting" -E \
        -v "smb://vm3/Accounting" \
        -P "$ppdPath" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
        && echo 'Accounting printer added'
}

# Xitron Accuset 800 queues
function addAccusetPrinters {
    mountVm3Drivers    

    lpadmin -p "Accuset-8.5x14" -E \
        -v "smb://rip-pc/Accuset-8.5x14" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    lpadmin -p "Accuset-14x14" -E \
        -v "smb://rip-pc/Accuset-14x14" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    lpadmin -p "Accuset-14x20" -E \
        -v "smb://rip-pc/Accuset-14x20" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    lpadmin -p "Accuset-14x30" -E \
        -v "smb://rip-pc/Accuset-14x30" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    lpadmin -p "Accuset-14x40" -E \
        -v "smb://rip-pc/Accuset-14x40" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    lpadmin -p "Accuset-14x50" -E \
        -v "smb://rip-pc/Accuset-14x50" \
        -P "/Volumes/_Drivers/Printers/Agfa Accuset 800/Macintosh Navigator PPD/XitronRIP.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
}

# SoftRIP printer queues
function addSoftripPrinters {
    mountVm3Drivers

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
    lpadmin -p "Epson_SC_T7270_Mono" -E \
        -v "lpd://rip2-pc/4" \
        -P "/Volumes/_Drivers/Printers/PPDs/Mac/es70670.ppd" \
        -o printer-is-shared=false
}

# Copiers
function addCopiers {
    mountVm3Drivers

    lpadmin -p "Copier_1st_Floor" -E \
        -v "smb://vm3.dottek.com/Copier_1st_Floor" \
        -P "/Volumes/_Drivers/Printers/Konica Minolta bizhub 352c/Postscript Fiery X3e TY30C-KM WHQL v1.01/EF5M4127.PPD" \
        -o printer-is-shared=false -o printer-op-policy="authenticated"
    #lpadmin -p "Copier_2nd_Floor" -E \
    #    -v "dnssd://EFI%20Fiery%20E10%2050-45C-KM%20PS%20Color%20Server1.1%20(2)._pdl-datastream._tcp.local./?bidi" \
    #    -P "/Library/Printers/PPDs/Contents/Resources/en.lproj/Fiery E10 50-45C-KM PS1.1" \
    #    -o printer-is-shared=false
}

function addCeramicPrinters {
    lpadmin -p "Ceramic_Printer_Magenta" -E \
        -v "lpd://10.93.0.235/" \
        -P "/Library/Printers/PPDs/Contents/Resources/RICOH Aficio SP C430DN.gz" \
        -o printer-is-shared=false
    lpadmin -p "Ceramic_Printer_Selenium" -E \
        -v "lpd://10.93.0.234/" \
        -P "/Library/Printers/PPDs/Contents/Resources/RICOH Aficio SP C430DN.gz" \
        -o printer-is-shared=false
}

for param in $@; do
    case $param in
        [Cc]eramic*) addCeramicPrinters ;;
        [Ee]pson*|[Ss]oft[Rr]*) addSoftripPrinters ;;
        [Aa]ccuset*) addAccusetPrinters ;;
        [Cc]opier*) addCopiers ;;
        [Ss]hipping*) addShippingPrinter ;;
        [Ii][Tt]*) addITPrinter ;;
        [Aa]ccounting*) addAccountingPrinter ;;
        *) echo "$param is not a defined printer group" ;;
    esac
done
