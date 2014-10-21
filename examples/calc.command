#!/bin/bash

# Trivial command line calculator
awk "BEGIN {print \"The answer is: \" $* }";
