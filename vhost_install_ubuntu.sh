#!/bin/bash

# Colors for the outputs uses tput
GREEN="$(tput setaf 2)"
CLEAR="$(tput sgr0)"
BOLD="$(tput bold)"

# Enable a virtual host in Historico 3

read -p 'Nombre del proyecto (sin .local, sin espacios en blanco ni caracteres raros): ' sitename
read -e -p 'IP local, si es localhost dejar esta : ' -i '127.0.0.1' siteip

# Add the register in /etc/hosts:
sed -i -e '$a'$siteip' '$sitename /etc/hosts

# Check if folder exist if not create it
if [ ! -d /home/veiss/historico3/$sitename ]; then

	cp -rp /home/veiss/historico3/_plantilla /home/veiss/historico3/$sitename
	chown -R veiss:www-data /home/veiss/historico3/$sitename

else

	echo $BOLD$GREEN'El directorio ya existe y no ha sido creado'$CLEAR

fi

# Virtual Host
if [ ! -f /etc/apache2/sites-available/$sitename.local.conf ]; then

	cp /etc/apache2/sites-available/1-plantilla.local.conf /etc/apache2/sites-available/$sitename.local.conf
	# Search and replace in the created conf file
	sed -i -e 's/____nombreproyecto____/'$sitename'/g' /etc/httpd/conf/vhosts/$sitename
	# Enable site for apache2
	a2ensite $sitename.local.conf

	# Reload apache service
	service apache2 restart

	echo $BOLD$GREEN'Virtual Host Creado correctamente --> http://'$sitename$CLEAR
	echo $BOLD$GREEN'Este es el status de Apache: '$CLEAR

	# Output apache status
	service apache2 status

else

	echo $BOLD$GREEN'El Virtual Host ya existe y no ha sido creado'$CLEAR

fi


