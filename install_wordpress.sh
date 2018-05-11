#!/bin/bash

source ./mysql_setup.sh

# Adjust Nginx's Configuration to Correctly Handle WordPress
ip=$(ifconfig eth0 | grep "inet adr" | cut -d ':' -f 2 | cut -d ' ' -f 1)
cat ./nginx_sites_available_default | sed "s/server_name _;/server_name $ip;/g" > ./default
sudo chown root:root ./default
sudo cp ./default /etc/nginx/sites-available/default
sudo rm ./default
sudo nginx -t
sudo systemctl reload nginx

# Install Additional PHP Extensions
sudo apt-get -y install php-curl php-gd php-mbstring php-mcrypt php-xml php-xmlrpc
sudo systemctl restart php7.0-fpm

# Download wp
mkdir tmp
cd /tmp
curl -O https://wordpress.org/latest.tar.gz
tar xzvf latest.tar.gz
cp ./wordpress/wp-config-sample.php ./wordpress/wp-config.php
mkdir ./wordpress/wp-content/upgrade
sudo cp -a ./wordpress/. /var/www/html
cd ..

# Configure the WordPress Directory
sudo chown -R $(whoami):www-data /var/www/html
sudo find /var/www/html -type d -exec chmod g+s {} \;
sudo chmod g+w /var/www/html/wp-content
sudo chmod -R g+w /var/www/html/wp-content/themes
sudo chmod -R g+w /var/www/html/wp-content/plugins

# Setting up the WordPress Configuration File
source ./configure_wp.sh


