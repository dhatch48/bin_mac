#!/bin/bash

set -x

[ "abc" != "def" ];echo $?

test -d "$HOME" ;echo $?


if [[ $1 -eq 1 ]]; then
    echo "it is $1"
elif [[ "$1" = 2 ]]; then
    echo "it is $1"
elif [[ "$1" = 3 ]]; then
    echo "it is $1"
elif [[ "$1" = 4 ]]; then
    echo "it is $1"
fi
