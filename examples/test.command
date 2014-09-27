#!/bin/bash

var='what the heck'

set -x
# not correct test - need to quote variables
if [ 'what the heck' = $var ]; then
    echo "It's equal"
else
    echo "nope"
fi

# Correct test
if [ 'what the heck' = "$var" ]; then
    echo "It's equal"
else
    echo "nope"
fi

# Correct extended test - no filename expansion or word splitting takes place
if [[ 'what the heck' = $var ]]; then
    echo "It's equal"
else
    echo "nope"
fi
