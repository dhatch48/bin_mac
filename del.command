#!/bin/bash

function del() {
if [ -z "$1" ]; then 
    echo usage: $0 directory
    return 0
fi
for thisArg in "$@"; do
    mv -n "$thisArg" ~/.Trash
done
}
