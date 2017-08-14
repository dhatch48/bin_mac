#!/bin/bash

LOOP=0

while [[ $LOOP -lt 20 ]]; do

    # The next line is explained in the math chapter.
    VAL=$(($LOOP % 10))

    [[ $LOOP == 10 ]] && echo
    case "$VAL" in

        ( 0 ) echo "ZERO" ;;
        ( 1 ) echo "ONE" ;;
        ( 2 ) echo "TWO" ;;
        ( 3 ) echo "THREE" ;;
        ( 4 ) echo "FOUR" ;;
        ( 5 ) echo "FIVE" ;;
        ( 6 ) echo "SIX" ;;
        ( 7 ) echo "SEVEN" ;;
        ( 8 ) echo "EIGHT" ;;
        ( 9 ) echo "NINE" ;;
        ( * ) echo "This shouldn't happen." ;;

    esac

    # The next line is explained in the math chapter.
    LOOP=$((LOOP + 1))

done
