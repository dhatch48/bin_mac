#!/bin/bash

read -n 1 -p 'Are you sure you want to remove all printers? (Y/N) ' answer

if [[ $answer == [yY] ]]; then
    allPrinterNames=$(lpstat -a | cut -d ' ' -f 1)

    for printer in $allPrinterNames; do
        lpadmin -x "$printer" && echo "$printer removed"
    done
fi

