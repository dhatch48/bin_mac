#!/bin/bash

#The second way is by testing the last exit status returned. The exit status is stored in the shell variable $?. For example:
ls mysillyfilename

if [ $? = 0 ] ; then
    echo "File exists."
else
    echo "exit status is: $?"
fi

# 3rd way by chaining with && - if 1st is true then do next
ls mysillyfilename && echo "File exists." || echo "exit status is: $?"
