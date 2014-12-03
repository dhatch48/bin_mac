#!/bin/bash

# Adds domain users group to be "Print Operator". This allows users to pause
# and resume print queue.
dseditgroup -o edit -u administrator -p -a "DOTTEK\Domain Users" -t group _lpoperator

# Make a user(david) Printer Admin
#dseditgroup -o edit -u administrator -p -a david -t user _lpadmin

# Explanation:
# -o specifies the operation (edit in this case)
# -n specifies the domain (another example is /LDAPv3/127.0.0.1 on an ODM)
# -u is the admin user to authenticate with (use diradmin for network domains)
# -p tells it to prompt for a password
# -a tells it to add a user or group
# -t specifies the type, user or group
