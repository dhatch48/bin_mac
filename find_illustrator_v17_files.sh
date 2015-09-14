#!/bin/bash

# version 16 is CS6 
# version 17 is CC 

# Find illustrator files that are saved in CC version
fgrep -l '%%Creator: Adobe Illustrator(R) 17.0' *.ai
