#!/bin/bash

verlte() {
    [  "$1" = "$(printf "$1\n$2" | sort -V | head -n1)" ]
}

verlt() {
    [ "$1" = "$2" ] && return 1 || verlte $1 $2
}

verlte 2.5.7 2.5.6 && echo "yes" || echo "no" # no
verlt 2.4.10 2.4.9 && echo "yes" || echo "no" # no
verlt 2.4.8 2.4.10 && echo "yes" || echo "no" # yes
verlte 2.5.6 2.5.6 && echo "yes" || echo "no" # yes
verlt 2.5.6 2.5.6 && echo "yes" || echo "no" # no
