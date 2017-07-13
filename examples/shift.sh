#!/bin/bash
# shft.sh: Using 'shift' to step through all the positional parameters.
#  Name this script something like shft.sh,
#+ and invoke it with some parameters.
#+ For example:
#             sh shft.sh a b c def 83 barndoor
until [ -z "$1" ]; do  # Until all parameters used up . . .
    echo "$1"
    shift
done

exit 0
