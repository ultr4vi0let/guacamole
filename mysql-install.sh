#!/bin/bash

dbpass="mySQLPassw0rd"

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
        mysqlrootpwd=$(echo $arg_mysqlrootpwd | base64 -d)
else
    echo "Please specify the mysql root password using the parameter -m or --mysqlrootpwd"
    exit 1
fi

# Install Mysql
export DEBIAN_FRONTEND=noninteractive
debconf-set-selections <<< "mysql-server mysql-server/root_password password $dbpass"
debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $dbpass"

apt-get install mysql-server mysql-client mysql-common mysql-utilities -y
