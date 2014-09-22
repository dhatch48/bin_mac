#!/bin/bash
#set -x

function doSomething {
    echo 'hello'
    return 1
}
function doSomethingElse {
    echo 'yo'
}
doSomething && doSomethingElse
