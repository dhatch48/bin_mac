#!/bin/bash
# cookbook filename: use_up_option
#
# use and consume an option
#
# parse the optional argument
VERBOSE=0;
if [[ $1 = -v ]]; then
    VERBOSE=1;
    shift;  # $1 is implied if no arg is given
fi
#
# the real work is here
#
for FN in "$@"; do
    if (( $VERBOSE == 1 )); then
        echo changing $FN
    fi
    chmod 0750 "$FN"
done
