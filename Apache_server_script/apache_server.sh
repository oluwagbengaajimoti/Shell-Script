#!/bin/bash

# Update and upgrade Ubuntu server packages
sudo apt-ger update && sudo apt-get upgrade -y

# Install all neccessary packages(apache server, php)
sudo apt-get install  \
apache2 \
php \
libapache2-mod-php \

# Move website code into /var/www/html directory
sudo mv html/* /var/www/html/

# Move Configuration file into the /etc/apache2/sites-availabe/default.conf
sudo mv html.conf /etc/apache2/sites-available/

# Disable the default configuration
sudo a2dissite 000-default.conf

# Enable new configuration file
sudo a2ensite html.conf

# Set appropriate permission
sudo chown -R www-data:www-data /var/www/html/
sudo chmod -R 755 /var/www/html/

# systemctl start apache server
sudo systemctl start apache2