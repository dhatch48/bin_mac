#!/bin/bash

# IFS affects the read statement and variable expansion
# Change IFS to newline. Default is space characters
IFS='
'

LIST="a A
b B
c C
d D
e E"

n=1

for i in $LIST ; do
    echo "$((n++)). $i"
done
