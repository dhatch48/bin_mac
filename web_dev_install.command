#!/bin/bash
set -x

# This script requires admin privilege
if [[ $(groups | grep -wq 'admin'; echo $?) -ne 0 ]] ; then
    echo "$USER is not in admin group" 
    exit 1
fi

function installApache {
    sudo apachectl start

    if [[ ! -d ~/Sites ]]; then
        mkdir ~/Sites
    fi
    echo "<?php phpinfo(); ?>" > ~/Sites/phpinfo.php

    userConfFile="/etc/apache2/users/$USER.conf"
    if [[ ! -e $userConfFile ]]; then
        data="
<Directory \"/Users/$USER/Sites/\">
    Options Indexes MultiViews
    AllowOverride All
    Order allow,deny
    Allow from all
</Directory>"
        
        echo "$data" | sudo tee "$userConfFile" > /dev/null
        sudo chmod 644 "$userConfFile"

    fi
}

function installBrew {

    xcode-select --install
    read -p "Press [Return] when Xcode succussfully installs..."

    if which brew; then 
        brew update
        brew upgrade
    else 
        ruby -e "$(curl -fsSL https://raw.github.com/Homebrew/homebrew/go/install)" && brew doctor
    fi
}

function installPhp {
    
    brew tap homebrew/dupes
    brew tap homebrew/versions
    brew tap homebrew/homebrew-php

    brew install php54 --with-gmp
    brew install php54-xcache

    # add php to start on user login
    mkdir -p ~/Library/LaunchAgents
    ln -sf /usr/local/opt/php54/*.plist ~/Library/LaunchAgents

    # edit httpd.conf to turn on vhosts and php and AllowOverride all
    sudo sed -Ei.orig '
    s/^#(Include.*vhosts\.conf)$/\1/
    s/^(LoadModule php5_module libexec.*)$/#\1/
    217,220 s/^(.*AllowOverride).*$/\1 all/
    /LoadModule php5_module libexec.*$/ a\
    LoadModule php5_module /usr/local/opt/php54/libexec/apache2/libphp5.so
    ' /etc/apache2/httpd.conf

    # edit php.ini and add timezone and xcache config
    phpIni="/usr/local/etc/php/5.4/php.ini"
    sudo sed -Ei.orig 's:^;(date\.timezone =).*$:\1 UTC:' "$phpIni"
    echo '
[xcache]
xcache.cacher =on
xcache.size = 128M
xcache.var_size = 64M
xcache.mmap_path = "/tmp/xcache"' | sudo tee -a "$phpIni" > /dev/null


    # Try to find ip address
    try1="$(ifconfig en0 | fgrep '10.93.0' | cut -d ' ' -f 2)"
    try2="$(ifconfig en4 | fgrep '10.93.0' | cut -d ' ' -f 2)"
    try3="$(ifconfig | fgrep '10.93.0' | head -1 | cut -d ' ' -f 2)"

    for var in "$try1" "$try2" "$try3"; do
        if [[ $var = 10.93.0.* ]]; then
            ip="$var"
            break
        fi
    done
    if [[ -z $ip ]]; then
        echo "can't find ip address for vhosts config"
        exit 1
    fi
        

    vhostsData="
#<VirtualHost *:80>
#    ServerAdmin webmaster@dummy-host2.example.com
#    DocumentRoot '/usr/docs/dummy-host2.example.com'
#    ServerName dummy-host2.example.com
#    ErrorLog '/private/var/log/apache2/dummy-host2.example.com-error_log'
#    CustomLog '/private/var/log/apache2/dummy-host2.example.com-access_log' common
#</VirtualHost>


<VirtualHost *:80>
    DocumentRoot '/Users/$USER/Sites'
    ServerName test.127.0.0.1

#    This should be omitted in the production environment
    SetEnv APPLICATION_ENV development

    <Directory '/Users/$USER/Sites'>
        Options Indexes MultiViews FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

</VirtualHost>

<VirtualHost *:80>
    DocumentRoot '/Users/$USER/Sites/unified/public'
    ServerName unified.127.0.0.1

#    This should be omitted in the production environment
    SetEnv APPLICATION_ENV development

    <Directory '/Users/$USER/Sites/unified/public'>
        Options Indexes MultiViews FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

</VirtualHost>

<VirtualHost *:80>
    DocumentRoot '/Users/$USER/Sites/unified/public'
    ServerName $ip

#    This should be omitted in the production environment
    SetEnv APPLICATION_ENV development

    <Directory '/Users/$USER/Sites/unified/public'>
        Options Indexes MultiViews FollowSymLinks
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>

</VirtualHost>"
    vhostsFile="/etc/apache2/extra/httpd-vhosts.conf"
    sudo sed -Ei.orig '27,$d' "$vhostsFile"
    echo "$vhostsData" | sudo tee -a "$vhostsFile" > /dev/null

    hostsFile="/private/etc/hosts"
    sudo cp "$hostsFile"{,.orig}
    echo '127.0.0.1   unified.127.0.0.1
127.0.0.1   test.127.0.0.1' | sudo tee -a "$hostsFile" > /dev/null
}

function installMysql {
    brew install mysql55

    /usr/local/opt/mysql55/bin/mysql.server start

    mkdir -p ~/Library/LaunchAgents
    ln -sf /usr/local/opt/mysql55/*.plist ~/Library/LaunchAgents
}

installApache
installBrew
installPhp
installMysql

