#!/bin/bash

set -x
echo "Enter a Name"
read A

if [[ "$A" = "foo" ]] ; then
    echo "foo"
elif [[ "$A" = "bar" ]] ; then
    echo "bar"
elif [[ "$A" = "bash" ]] ; then
    echo "bash"
else
    echo "Other: $A"
fi
