#!/bin/bash

outFile="selenium_test_latest.html"
list='3
2
3
3
4
4
3
3
5
2
3
3
4
4
5
5
6
2
3
3
4
4
5
5
7
2
3
3
4
4
5
5
6
2
3
3
4
4
5'

# Generate proper li tag string from passed number
# @1 positive integer for number of li's
liTextGen () {
    liText='li'
    if [ -z "$1" ]; then
        exit 1
    else
        for (( i=1; i<$1; i++ )); do
            liText="$liText + li"
        done
    fi
    return 0
}

cat <<EOF > "$outFile"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head profile="http://selenium-ide.openqa.org/profiles/test-case">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="selenium.base" href="http://www.bing.com/" />
<title>selenium_test</title>
</head>
<body>
<table cellpadding="1" cellspacing="1" border="1">
<thead>
<tr><td rowspan="1" colspan="3">selenium_test</td></tr>
</thead><tbody>
<tr>
	<td>open</td>
	<td>/</td>
	<td></td>
</tr>
<tr>
	<td>click</td>
	<td>id=sb_form_q</td>
	<td></td>
</tr>
<tr>
	<td>type</td>
	<td>id=sb_form_q</td>
	<td>Web Development</td>
</tr>
<tr>
	<td>clickAndWait</td>
	<td>id=sb_form_go</td>
	<td></td>
</tr>
EOF


# loop
IFS=$'\n'
for n in $list; do
    liTextGen "$n"
    cat <<EOF >> "$outFile"
<tr>
	<td>pause</td>
    <td>$((RANDOM%4000+1000))</td>
	<td></td>
</tr>
<tr>
	<td>storeText</td>
	<td>css=li.b_ans ul.b_vList $liText a</td>
	<td>myResult</td>
</tr>
<tr>
	<td>type</td>
	<td>id=sb_form_q</td>
	<td>\${myResult}</td>
</tr>
<tr>
	<td>clickAndWait</td>
	<td>id=sb_form_go</td>
	<td></td>
</tr>
EOF
done
echo "Success! $outFile file created."
