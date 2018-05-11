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
	echo "db_user_pw is set"; 
fi
cat ./temp2 | sed "s/define('DB_PASSWORD', 'password_here');/define('DB_PASSWORD', '$db_user_pw');/g" > ./temp3
rm temp2

curl -s https://api.wordpress.org/secret-key/1.1/salt/ > ./keys

cat ./temp3 | sed "s/define('AUTH_KEY',         'put your unique phrase here');//g" > ./temp4
rm temp3

cat ./temp4 | sed "s/define('SECURE_AUTH_KEY',         'put your unique phrase here');//g" > ./temp5
rm temp4

cat ./temp5 | sed "s/define('LOGGED_IN_KEY',         'put your unique phrase here');//g" > ./temp6
rm temp5

cat ./temp6 | sed "s/define('NONCE_KEY',         'put your unique phrase here');//g" > ./temp7
rm temp6

cat ./temp7 | sed "s/define('AUTH_SALT',         'put your unique phrase here');//g" > ./temp8
rm temp7

cat ./temp8 | sed "s/define('SECURE_AUTH_SALT',         'put your unique phrase here');//g" > ./temp9
rm temp8

cat ./temp9 | sed "s/define('LOGGED_IN_SALT',         'put your unique phrase here');//g" > ./temp10
rm temp9

cat ./temp10 | sed "s/define('NONCE_SALT',         'put your unique phrase here');//g" > ./temp11
rm temp10

cat keys >> ./temp11
echo "define('FS_METHOD', 'direct');" >> ./temp11

sudo chown root:root ./temp11
sudo cp ./temp11 /var/www/html/wp-config.php
sudo rm ./temp11
rm ./keys


