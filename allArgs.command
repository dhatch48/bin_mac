#!/bin/bash

echo '"$@"'
for var in "$@"; do
    echo "$var"
done
echo

echo '$@'
for var in $@; do
    echo "$var"
done
echo

echo '"$*"'
for var in "$*"; do
    echo "$var"
done
echo

echo '$*'
for var in $*; do
    echo "$var"
done
