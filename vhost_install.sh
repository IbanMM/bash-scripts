#!/bin/bash

# Enable a virtual host in my Antegos system

read -p 'Name of the site : ' sitename
read -e -p 'IP of the site : ' -i '127.0.0.1' siteip

# Add the register in /etc/hosts:
sed -i -e '$a'$siteip' '$sitename /etc/hosts

# Check if /etc/httpd/conf/vhosts exist if not create
if [ ! -d /etc/httpd/conf/vhosts ]; then
	mkdir /etc/httpd/conf/vhosts
fi

# Copy conf file to vhosts directory
cp virtualhost_conf /etc/httpd/conf/vhosts/$sitename

# Search and replace in the created conf file
sed -i -e 's/_site_/'$sitename'/g' /etc/httpd/conf/vhosts/$sitename

# Include the conf file to /etc/httpd/conf/httpd.conf
sed -i -e '$aInclude conf/vhosts/'$sitename /etc/httpd/conf/httpd.conf

# Create folder for public files
mkdir /srv/http/$sitename

# Folder permissions
chown http:http /srv/http/$sitename

# Reload apache service
systemctl restart httpd

echo 'Virtual Host Created --> http://'$sitename
echo 'Here is Apache status'

# Output apache status
systemctl status httpd
