#!/bin/bash

# WodPress install require WP Cli

# Colors for the outputs uses tput
GREEN="$(tput setaf 2)"
CLEAR="$(tput sgr0)"
BOLD="$(tput bold)"

# User input path for the installation folder
read -e -p 'Path to install WP (absolute) : ' -i '/srv/http/' wppath

# Database creation
echo 'Lest create a database for WordPress'
read -p 'Name of the database : ' dbname
read -p 'User of the database : ' dbuser
read -p 'Password for the database : ' dbpassword
read -p 'Password for mysql root user : ' mysqlpassword

SQL1="CREATE DATABASE $dbname;"
SQL2="CREATE USER '$dbuser'@'localhost' IDENTIFIED BY '$dbpassword';"
SQL3="GRANT ALL PRIVILEGES ON $dbname.* TO '$dbuser'@'localhost' IDENTIFIED BY '$dbpassword';"
SQL4="FLUSH PRIVILEGES;"

mysql -h localhost -u root -p$mysqlpassword -Bse "$SQL1$SQL2$SQL3$SQL4"

echo $BOLD$GREEN'Database created correctly'$CLEAR

# cd in the target folder for the WP installation
cd $wppath

# Download WP
read -e -p 'Locale for the WordPress installation : ' -i 'es_ES' wplocale
wp core download --locale=$wplocale

# Generate wp-config.php
PREFIX=$(echo  "${dbname}" | head -c2)
read -e -p 'Prefix for the database tables (Do not use wp_) : ' -i "$PREFIX"'_' wpprefix
wp config create --dbname=$dbname --dbuser=$dbuser --dbpass=$dbpassword --locale=$wplocale --dbprefix=$wpprefix

# Install WP
read -p 'URL for the WordPress installation : ' wpurl
read -p 'Title for the WordPress installation : ' wptitle
read -p 'User name for admin user : ' wpadmin
read -p 'Email of the admin user : ' wpadminemail
read -p 'Password for the admin user : ' wpadminpassword 
wp core install --url=$wpurl --title=$wptitle --admin_user=$wpadmin --admin_password='$wpadminpassword' --admin_email=$wpadminemail

echo $BOLD$GREEN'Wordpress installed correctly, lets install some plugins ...'$CLEAR

# WordPress Plugins
read -p 'Do you want to install Timber (y/n) : ' installtimber

if [ $installtimber = 'y' ]
then
	read -p 'Name for the Timber Starter Theme : ' timbertheme
	wp plugin install timber-library --activate
	cp -r $wppath'/wp-content/plugins/timber-library/timber-starter-theme' $wppath'/wp-content/themes'
	mv $wppath'/wp-content/themes/timber-starter-theme' $wppath'/wp-content/themes/'$timbertheme
	sed -i -e 's/My Timber Starter Theme/'$timbertheme'/g'  $wppath'/wp-content/themes/'$timbertheme'/style.css'
	sed -i -e 's/Starter Theme to use with Timber/'$wptitle'/g'  $wppath'/wp-content/themes/'$timbertheme'/style.css'
	sed -i -e 's/Upstatement and YOU!/'$wpadminemail'/g'  $wppath'/wp-content/themes/'$timbertheme'/style.css'
	wp theme activate $timbertheme
fi
