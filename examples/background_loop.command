#!/bin/bash
for i in 1 2 3 4 5 6 7 8 9 10; do
  echo -n $i
done &

for i in a b c d e f g h i j k; do
  echo -n $i
done
echo 'Done!'
