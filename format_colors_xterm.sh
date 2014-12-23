#!/bin/bash
#set -x

tempLocation="/tmp"

# Takes option -m to specify minttyrc format otherwise outputs xterm format
format=0;
if [[ $1 = -m ]]; then
    format=1;
    shift;  # $1 is implied if no arg is given
fi

grep -o '#[0-9a-fA-F]\{6\}' $1 > "$tempLocation/hexColors.txt"

formatMintty () {
echo 'ForegroundColour=
BackgroundColour=
CursorColour=
Black=
Red=
Green=
Yellow=
Blue=
Magenta=
Cyan=
White=
BoldBlack=
BoldRed=
BoldGreen=
BoldYellow=
BoldBlue=
BoldMagenta=
BoldCyan=
BoldWhite=' > "$tempLocation/mintty_colors_template.txt"

awk '
    FNR==NR { a[FNR""] = $0; next } 
    { print a[FNR""]$0 }
' "$tempLocation/mintty_colors_template.txt" "$tempLocation/hexColors.txt" 
}

formatXterm () {
echo "echo -ne '\e]10;,#000000,\a'    # foreground
echo -ne '\e]11;,#C0C0C0,\a'    # background
echo -ne '\e]12;,#00FF00,\a'    # cursor
echo -ne '\e]4;0;,#000000,\a'   # black
echo -ne '\e]4;1;,#BF0000,\a'   # red
echo -ne '\e]4;2;,#00BF00,\a'   # green
echo -ne '\e]4;3;,#BFBF00,\a'   # yellow
echo -ne '\e]4;4;,#0000BF,\a'   # blue
echo -ne '\e]4;5;,#BF00BF,\a'   # magenta
echo -ne '\e]4;6;,#00BFBF,\a'   # cyan
echo -ne '\e]4;7;,#BFBFBF,\a'   # white (light grey really)
echo -ne '\e]4;8;,#404040,\a'   # bold black (i.e. dark grey)
echo -ne '\e]4;9;,#FF4040,\a'   # bold red
echo -ne '\e]4;10;,#40FF40,\a'  # bold green
echo -ne '\e]4;11;,#FFFF40,\a'  # bold yellow
echo -ne '\e]4;12;,#6060FF,\a'  # bold blue
echo -ne '\e]4;13;,#FF40FF,\a'  # bold magenta
echo -ne '\e]4;14;,#40FFFF,\a'  # bold cyan
echo -ne '\e]4;15;,#FFFFFF,\a'  # bold white" > "$tempLocation/xterm_colors_template.txt"

awk '
    BEGIN {FS = ","}
    FNR==NR { a[FNR""] = $0; next } 
    { print $1a[FNR""]$3 }
' "$tempLocation/hexColors.txt" "$tempLocation/xterm_colors_template.txt" 
}

if (( $format == 1 )); then
    formatMintty
else
    formatXterm
fi
