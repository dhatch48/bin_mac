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

# This disables backslash escaping but it still removes the leading space
printf '%s\n' "$text" |
while read -r line; do 
    printf '%s\n' "[$line]"
done
echo

echo "Good - while read"
printf '%s\n' "$text" |
while IFS= read -r line; do
    printf '%s\n' "[$line]"
done
echo
# Note how we set IFS specifically for the duration of the read built-in. The
# IFS= read -r line sets the environment variable IFS (to an empty value)
# specifically for the execution of read.



### Another way using for loop and modifying IFS
### If IFS is not set, the shell shall behave as if the value of IFS is default
### (<space><tab><newline>)

echo "Good - for loop"
IFS='
'
for line in $text; do
    printf '%s\n' "[$line]"
done
echo

echo "IFS back to normal"
unset IFS

### This doesn't work right because IFS is unset and therefore default again.
for line in $text; do
    printf '%s\n' "[$line]"
done
