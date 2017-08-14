#!/bin/bash

# Create Arrays
myArray=(first second 'third 3' fourth)

names=([0]='Bob' [1]='Peter' [20]="$USER" [21]="Big Bad John")

files=(*.sh)

IFS=', ' read -r -a myList <<< "Paris, France, Europe"

IFS='
' read -r -d '' -a myList <<< "Paris
France
Europe"


# Inspect variable content
declare -p myArray
declare -p myList
echo "${myArray[@]}"
echo

# Access individual items
echo "myArray[0]: ${myArray[0]}"
# Get last item
if [[ ${BASH_VERSINFO[0]} -ge 4 && ${BASH_VERSINFO[1]} -ge 2 ]]; then
    echo "${myList[-1]}"         # bash version => 4.2
fi
echo "${myList[@]: -1:1}"    # bash version > 2.05b

# Arrays are sparce so length won't be accurate for determining the last index
echo "myArray length: ${#myArray[@]}"
echo

# Add items to array
myArray+=('fifth')
names+=([10]='James')
echo "Added to myArray and names"
echo

# Delete items
unset myArray[0] && echo "Deleted myArray[0]"
echo "There is now no 0 index: "

declare -p myArray
echo

# Iterate through entire array
echo myArray:
for arg in "${myArray[@]}"; do
    echo "$arg"
done
echo

# Add "!" for access to indices
echo names:
for name in "${!names[@]}"; do
    echo "[$name]=${names[name]}"
done
echo

echo files:
for file in "${files[@]}"; do
    echo "$file"
done
echo

# With indices again
echo myList:
for i in "${!myList[@]}"; do
    echo "[$i]=${myList[i]}"
done
echo

# Associative Arrays if >= bash 4
if [[ ${BASH_VERSINFO[0]} -ge '4' ]]; then
    declare -A dict=([one]="first val" [two]=2 ['three 3']="third")
    declare -p dict
    echo "dict[one]: ${dict[one]}"
    echo

    i=''
    echo dict:
    for i in "${!dict[@]}"; do
        echo "[$i]=${dict[$i]}"
    done
fi
