#!/bin/bash

# This is an Entry Point Script that will execute nginx-install.sh and guac-install.sh

# Get the required script arguments for non-interactive mode
while [ "$1" != "" ]; do
    case $1 in
        -m | --mysqlpwd )       shift
                                argmysqlpwd="$1"
                                ;;
        -g | --guacpwd )        shift
                                argguacpwd="$1"
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
        mysqlrootpassword=$(printf '%q\n' $argmysqlpwd | base64 -d <<< $argmysqlpwd) # decode base64 string
        mysqlrootpassword=$(printf '%q' $mysqlrootpassword)                          # escape special characters

        guacdbuserpassword=$(printf '%q\n' $argguacpwd | base64 -d <<< $argguacpwd)  # decode base64 string
        guacdbuserpassword=$(printf '%q'$guacdbuserpassword)                         # escape special characters

        certbotfqdn=$argfqdn
        certbotemail=$argemail
else
  echo "Error: You must provide the following script arguments: --mysqlpwd --guacpwd --fqdn --email"
  exit 1
fi

./nginx-install.sh --fqdn $certbotfqdn --email $certbotemail
./guac-install.sh --mysqlpwd $mysqlrootpassword --guacpwd $guacdbuserpassword
