#!/bin/bash
#set -x

# Move files to Trash but don't overwrite existing files
function del() {
    for thisArg in "$@"; do
        mv -n "$thisArg" ~/.Trash
    done
}
del "$@"
