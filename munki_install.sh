#!/bin/bash

cat <<EOF

**************************
** Munki auto-installer **
**************************

EOF
runDir="$(dirname "$0")"

cd "$runDir"
curl \
    -sfO \
    --connect-timeout 30 \
    https://munkibuilds.org/3.5.2.3637/munkitools-3.5.2.3637.pkg
    #https://munkibuilds.org/munkitools3-latest.pkg
package=(munkitools-*.pkg)

# install munki package
sudo installer -pkg "$package" -target /

# update install/update munki config
"$runDir/munki_config_update.sh"

echo
echo 'Please reboot to complete installaion'
