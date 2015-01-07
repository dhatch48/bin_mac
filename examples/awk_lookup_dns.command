#!/bin/bash
awk '# lookup -- reads local glossary file and prompts user for query
#0
BEGIN {  OFS = "\t"
    # prompt user
    printf("Enter a hostname: ")
}
#1 read local file named dnsEntries.txt
FILENAME == "/tmp/dnsEntries.txt" {
    # load each ipAddress into an array indexed by hostname
    hosts[$1] = $2
    next
}
#2 scan for command to exit program
$0 ~ /^(quit|[qQ]|exit|[Xx])$/ { exit }
#3 process any non-empty line
$0 != "" {
    if ( $0 in hosts ) {
        # it is there, print definition
        print hosts[$0]
    } else
    print $0 " not found"
}
#4 prompt user again for another term
{
    printf("Enter another hostname (q to quit): ")
}' /tmp/dnsEntries.txt -
