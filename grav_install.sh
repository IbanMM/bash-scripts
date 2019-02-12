#!/bin/bash

# Grav install requires Composer

# Colors for the outputs uses tput
GREEN="$(tput setaf 2)"
CLEAR="$(tput sgr0)"
BOLD="$(tput bold)"

# User input path for the installation folder
read -e -p 'Path to install Grav (absolute, no / at the end) : ' -i '/home/veiss/historico3/' gravpath

# cd in the target folder for the Grav installation
cd $gravpath

# Clone Grav git repository
git clone -b master https://github.com/getgrav/grav.git .

# Install width Composer
composer install --no-dev -o

# Install the plugin and theme dependencies by using the Grav CLI application
bin/grav install

# Install admin plugin and dependencies
bin/gpm install admin

# Apache user
APACHE_USER=$(ps axho user,comm|grep -E "httpd|apache"|uniq|grep -v "root"|awk 'END {if ($1) print $1}')

# Set Up
touch setup.php
echo "<?php" > setup.php
sed -i -e '$aumask(0002);' setup.php

# Fix Permissions
sudo chown -R $USER':'$APACHE_USER .
find . -type f | xargs chmod 664
find ./bin -type f | xargs chmod 775
find . -type d | xargs chmod 775
find . -type d | xargs chmod +s

echo $BOLD$GREEN'All done OK, permissions fixed, your GRAV site is ready'$CLEAR
