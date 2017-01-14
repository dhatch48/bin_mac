#!/bin/bash
#set -x

### This script adds network printers and mounts vm3 for required drivers.
### Takes one or more param which specifies which printer groups to add.

### *Configured ppd files are saved in /etc/cups/ppd/
### Installed printer drivers are usually here /Library/Printers/PPDs/Contents/Resources/

ppdLocation='/Volumes/_Drivers/Printers/PPDs/Mac'

function mountVm3Drivers {
    smbLocation='smb://vm3/_Drivers'
    mountLocation='/Volumes/_Drivers'
    if  ! mount | grep -F "on $mountLocation" > /dev/null; then
        mountGood=$(osascript -e "try 
            mount volume \"$smbLocation\"
            set mountGood to true
        on error
            set mountGood to false
        end try")
        [[ $mountGood == true ]] && echo "$smbLocation mounted"
    fi
}

function addShippingPrinter {
    mountVm3Drivers || exit 1
    lpadmin -p "Shipping" -E \
        -v "smb://vm3/Shipping" \
        -P "$ppdLocation/Shipping.ppd" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
    && echo 'Shipping printer added'
}

function addITPrinter {
    mountVm3Drivers || exit 1
    lpadmin -p "IT" -E \
        -v "smb://vm3/IT" \
        -P "$ppdLocation/IT.ppd" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
    && echo 'IT printer added'
}

function addAccountingPrinter {
    mountVm3Drivers || exit 1
    lpadmin -p "Accounting" -E \
        -v "smb://vm3/Accounting" \
        -P "$ppdLocation/Accounting.ppd" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
    && echo 'Accounting printer added'
}

### SoftRIP printer queues
function addSoftripPrinters {
    mountVm3Drivers || exit 1

    lpadmin -p "Epson_1_720px_Layout" -E \
        -v "lpd://rip2-pc/1" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_1_720px_Standard" -E \
        -v "lpd://rip2-pc/4" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_1_1440px" -E \
        -v "lpd://rip2-pc/4/2880x1440" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_1_2880px" -E \
        -v "lpd://rip2-pc/4/2880x2880" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_2_720px_Standard" -E \
        -v "lpd://rip2-pc/2" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_2_1440px" -E \
        -v "lpd://rip2-pc/2/2880x1440" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_2_2880px" -E \
        -v "lpd://rip2-pc/2/2880x2880" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_3_720px_Standard" -E \
        -v "lpd://rip2-pc/3" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_3_1440px" -E \
        -v "lpd://rip2-pc/3/2880x1440" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false
    lpadmin -p "Epson_3_2880px" -E \
        -v "lpd://rip2-pc/3/2880x2880" \
        -P "$ppdLocation/es70670.ppd" \
        -o printer-is-shared=false \
    && echo 'softRIP printers added'
}

### Copiers
function addCopiers {
    mountVm3Drivers || exit 1

    lpadmin -p "Copier_1st_Floor_PS" -E \
        -v "smb://vm3.dottek.com/Copier_1st_Floor" \
        -P "$ppdLocation/Copier_1st_Floor_PS.ppd" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
    && echo 'Copier_1st_Floor_PS added'

    lpadmin -p "Copier_2nd_Floor_PS" -E \
        -v "smb://vm3.dottek.com/Copier_2nd_Floor" \
        -P "$ppdLocation/Copier_2nd_Floor_PS.ppd" \
        -o printer-is-shared=false -o printer-op-policy="authenticated" \
    && echo 'Copier_2nd_Floor_PS added'

    #lpadmin -p "Copier_1st_Floor" -E \
    #    -v "smb://vm3.dottek.com/Copier_1st_Floor" \
    #    -P "$ppdLocation/Copier_1st_Floor.ppd" \
    #    -o printer-is-shared=false -o printer-op-policy="authenticated" \
    #&& echo 'Copier_1st_Floor added'

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
        -o printer-is-shared=false \
    && echo 'Ceramic printers added'
}

options="
ceramic
softrip
copier
shipping
it
accounting
"

if [[ -z $@ ]]; then
    read -p "Specify at least one printer group and press [enter] Options are: $options" answer
    echo 
fi

### Use answer of else original passed params
vars="${answer:-$@}"

for param in $vars; do
    case $param in
        [Cc]eramic*) addCeramicPrinters ;;
        [Ee]pson*|[Ss]oft[Rr]*) addSoftripPrinters ;;
        [Cc]opier*) addCopiers ;;
        [Ss]hipping*) addShippingPrinter ;;
        it|IT*) addITPrinter ;;
        [Aa]ccounting*) addAccountingPrinter ;;
        *) echo "$param is not a defined printer group. Options are:$options" ;;
    esac
done
