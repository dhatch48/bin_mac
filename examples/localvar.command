#!/bin/bash

HELLO=Hello

function hello {
    local HELLO=World
    echo "local: $HELLO"
}
echo "global: $HELLO"

hello

# Subshell
(HELLO="hello world!"; echo "subshell: $HELLO")

# Subshell 2
(HELLO="hello world 2!"; echo "subshell2: $HELLO")

echo "global: $HELLO"
