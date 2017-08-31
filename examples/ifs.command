#!/bin/bash

# IFS affects the read statement and variable expansion
# Change IFS to newline. Default is space characters

LIST="a A
b B
c C
d D
e E"

n=1

IFS='
'
for i in $LIST ; do
    echo "$((n++)). $i"
done

# Reset IFS back to default for the rest of script
unset IFS
