#!/bin/bash

# simple phone ext lookup
# -EOF ignores leading tabs only
if [[ -n $1 ]]; then
    grep -i $1 <<-'EOF'
	mike x.123
	joe x.234
	sue x.555
	pete x.818
	sara x.822
	bill x.919
    EOF
fi


#Turn off the shell scripting features inside the here-document by escaping any or all of the characters in the ending marker:
# solution use \EOF or 'EOF'
if [[ -n $2 ]]; then
grep -i $2 <<\EOF
pete $100
joe $200
sam $ 25
bill $ 9
EOF
fi

# Another way with variable
varLookup='pete $500
joe $400
sam $ 55
bill $ 19'
if [[ -n $1 ]]; then
    echo "$varLookup" | grep -i $1
fi
