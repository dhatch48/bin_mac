#!/bin/bash

i=1

while [[ $i -le 3 ]] ; do

    echo "I is $i"

    i=$(expr $i '+' 1)

done
