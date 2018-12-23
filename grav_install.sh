#!/bin/bash

# Grav install requires Composer

# Colors for the outputs uses tput
GREEN="$(tput setaf 2)"
CLEAR="$(tput sgr0)"
BOLD="$(tput bold)"

# User input path for the installation folder
read -p 'Path to install Grav (absolute, no / at the end) : ' -i '/srv/http/' gravpath

# cd in the target folder for the Grav installation
cd $gravpath

# Clone Grav git repository
git clone -b master https://github.com/getgrav/grav.git .

# Install width Composer
composer install --no-dev -o

# Install the plugin and theme dependencies by using the Grav CLI application
bin/grav install

# Install admin plugin and dependecies
bin/gpm install admin

echo $BOLD$GREEN'All done OK, your GRAV site is ready'$CLEAR