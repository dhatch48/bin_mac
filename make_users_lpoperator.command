#!/bin/bash

# Adds domain users group to be "Print Operator". This allows users to pause
# and resume print queue.

dseditgroup -o edit -u administrator -p -a "DOTTEK\Domain Users" -t group _lpoperator
