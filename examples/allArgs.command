#!/bin/bash

# Correct way - handles spaces correctly
echo '"$@"'
for var in "$@"; do
    echo "$var"
done
echo

# Doesn't
echo '$@'
for var in $@; do
    echo "$var"
done
echo

# Combines all args into one arg
echo '"$*"'
for var in "$*"; do
    echo "$var"
done
echo

# same as $@ with no quotes - doesn't handle spaces correctly
echo '$*'
for var in $*; do
    echo "$var"
done
