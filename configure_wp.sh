#!/bin/bash

# Check we have variables we need
if [ -z ${db_name+x} ]; 
then 
	echo "Create a new mysql database name:";
	read db_name;
else 
	echo "db_name is set to $db_name"; 
fi
cat /var/www/html/wp-config.php | sed "s/define('DB_NAME', 'database_name_here');/define('DB_NAME', '$db_name');/g" > ./temp1

if [ -z ${db_user_name+x} ]; 
then 
	echo "Create mysql user name:";
	read db_user_name;
else 
	echo "db_user_name is set to $db_user_name"; 
fi
cat ./temp1 | sed "s/define('DB_USER', 'username_here');/define('DB_USER', '$db_user_name');/g" > ./temp2
rm ./temp1

if [ -z ${db_user_pw+x} ]; 
then 
	echo "Create mysql user's pw:";
	read -s db_user_pw;
else 
	echo "db_user_pw is set to $db_user_pw"; 
fi
cat ./temp2 | sed "s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$db_user_pw');/g" > ./temp3
rm temp2

cd ~
curl -s https://api.wordpress.org/secret-key/1.1/salt/ > ./keys

auth_key=grep "define('AUTH_KEY'" ./keys
cat ./temp3 | sed "s/define('AUTH_KEY',         'put your unique phrase here');/$auth_key/g" > ./temp4
rm temp3

sec_auth_key=grep "define('SECURE_AUTH_KEY'" ./keys
cat ./temp4 | sed "s/define('SECURE_AUTH_KEY',         'put your unique phrase here');/$sec_auth_key/g" > ./temp5
rm temp4

li_key=grep "define('LOGGED_IN_KEY'" ./keys
cat ./temp5 | sed "s/define('LOGGED_IN_KEY',         'put your unique phrase here');/$li_key/g" > ./temp6
rm temp5

nonce_key=grep "define('NONCE_KEY'" ./keys
cat ./temp6 | sed "s/define('NONCE_KEY',         'put your unique phrase here');/$nonce_key/g" > ./temp7
rm temp6

auth_salt=grep "define('AUTH_SALT'" ./keys
cat ./temp7 | sed "s/define('AUTH_SALT',         'put your unique phrase here');/$auth_salt/g" > ./temp8
rm temp7

sec_auth_salt=grep "define('SECURE_AUTH_SALT'" ./keys
cat ./temp8 | sed "s/define('SECURE_AUTH_SALT',         'put your unique phrase here');/$sec_auth_salt/g" > ./temp9
rm temp8

li_salt=grep "define('LOGGED_IN_SALT'" ./keys
cat ./temp9 | sed "s/define('LOGGED_IN_SALT',         'put your unique phrase here');/$li_salt/g" > ./temp10
rm temp9

nonce_salt=grep "define('NONCE_SALT'," ./keys
cat ./temp10 | sed "s/define('NONCE_SALT',         'put your unique phrase here');/$nonce_salt/g" > ./temp11
rm temp10

"define('FS_METHOD', 'direct');" >> ./temp11

sudo chown root:root ./temp11
sudo cp ./temp11 /var/www/html/wp-config.php
sudo rm ./temp11
rm ./keys


