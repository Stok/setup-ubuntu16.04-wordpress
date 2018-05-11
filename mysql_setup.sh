#!/bin/bash

echo "Enter mysql root pw:"
read -s sql_pw
echo "Create a new mysql database name:"
read db_name
echo "Create mysql user name:"
read db_user_name
echo "Create mysql user's pw:"
read -s db_user_pw
mysql -u root -p$sql_pw -e "CREATE DATABASE $db_name DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci"
mysql -u root -p$sql_pw -e "GRANT ALL ON $db_name.* TO '$db_user_name'@'localhost' IDENTIFIED BY '$db_user_pw'"
mysql -u root -p$sql_pw -e "FLUSH PRIVILEGES"
