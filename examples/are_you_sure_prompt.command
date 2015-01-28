#!/bin/bash

read -n 1 -p 'Are you sure you want to do this? (Y/N) ' answer
echo

if [[ $answer == [yY] ]]; then
    echo "ok, done"
fi
