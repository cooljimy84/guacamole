#!/bin/bash

# This is an Entry Point Script that will execute nginx-install.sh and guac-install.sh

# Get the required script arguments for non-interactive mode
while [ "$1" != "" ]; do
    case $1 in
        -m | --mysqlpwd )       shift
                                argmysqlpwd="$1" # base64 encoded, MySQL root password
                                ;;
        -g | --guacpwd )        shift
                                argguacpwd="$1"  # base64 encoded, Guacamole_user database password
                                ;;
        -f | --fqdn )           shift
                                argfqdn="$1"
                                ;;
        -e | --email )          shift
                                argemail="$1"
    esac
    shift
done

if [ -n "$argmysqlpwd" ] && [ -n "$argguacpwd" ] && [ -n "$argfqdn" ] && [ -n "$argemail" ]; then
        mysqlrootpassword=$argmysqlpwd
        guacdbuserpassword=$argguacpwd
        certbotfqdn=$argfqdn
        certbotemail=$argemail
else
  echo "Error: You must provide the following script arguments: --mysqlpwd --guacpwd --fqdn --email"
  exit 1
fi

# Install some missing packages
sudo apt-get install software-properties-common dos2unix -y
dos2unix -q *.sh

./nginx-install.sh --fqdn $certbotfqdn --email $certbotemail                   # Install Nginx
./guac-install.sh --mysqlpwd $mysqlrootpassword --guacpwd $guacdbuserpassword  # Install Guacamole
