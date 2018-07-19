#!/bin/bash

# Update package lists
apt-get update

# Read arguments
while [ "$1" != "" ]; do
    case $1 in
        -m | --mysqlrootpwd )       shift
                                arg_mysqlrootpwd="$1";;
    esac
    shift
done

# Get MySQL root password
if [ -n "$arg_mysqlrootpwd" ]; then
        mysqlrootpwd=$arg_mysqlrootpwd
else
    echo "Please specify the mysql root password using the parameter -m or --mysqlrootpwd"
    exit 1
fi

echo $mysqlrootpwd

# Install Mysql
export DEBIAN_FRONTEND=noninteractive
echo mysql-server mysql-server/root_password password $mysqlrootpwd | debconf-set-selections
echo mysql-server mysql-server/root_password_again password $mysqlrootpwd | debconf-set-selections
apt-get install mysql-server mysql-client mysql-common mysql-utilities -y
