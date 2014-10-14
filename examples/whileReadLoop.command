#!/bin/bash

text=' hello  world\
foo\bar
Some File Name.ai
Some File 2014-10-14'

# escapes baskslashes and therefore removes them
printf '%s\n' "$text" | 
while read line; do 
    printf '%s\n' "[$line]"
done
echo

# This diables backslash escaping but it still removes the leading space
printf '%s\n' "$text" |
while read -r line; do 
    printf '%s\n' "[$line]"
done
echo

# Good - nothing missing
printf '%s\n' "$text" |
while IFS= read -r line; do
    printf '%s\n' "[$line]"
done
# Note how we set IFS specifically for the duration of the read built-in. The
# IFS= read -r line sets the environment variable IFS (to an empty value)
# specifically for the execution of read.
