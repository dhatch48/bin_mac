#!/usr/bin/awk -f

# lookup -- reads local glossary file and prompts user for query
#0
BEGIN {  OFS = "\t"
    # prompt user
    printf("Enter a term to lookup: ")
}
#1 read file for lookup. Must be 1st arg
FILENAME == ARGV[1] {
    # load each term and value into an array
    lookup[$1] = $2
    next
}
#2 scan for command to exit program
$0 ~ /^(quit|[qQ]|exit|[Xx])$/ { exit }
#3 process any non-empty line
$0 != "" {
    if ( $0 in lookup ) {
        # it is there, print definition
        print lookup[$0]
    } else
    print $0 " not found"
}
#4 prompt user again for another term
{
    printf("Enter another term (q to quit): ")
} 
