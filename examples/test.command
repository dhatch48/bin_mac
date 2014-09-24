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

# Correct extended test - var expansion happens prior to test
if [[ 'what the heck' = $var ]]; then
    echo "It's equal"
else
    echo "nope"
fi
