#!/bin/bash

myArray=(first second third fourth)
echo ${myArray[0]}
# remove the 1st element
myArray=("${myArray[@]:1}")

# echo remaining elements in array
for arg in ${myArray[@]}; do
    echo "$arg"
done
