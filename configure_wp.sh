#!/bin/bash

echo "<?php" > ./wp_config.php
echo "define('FS_METHOD', 'direct');" >> ./wp_config.php

# Check we have variables we need
if [ -z ${db_name+x} ]; 
then 
	echo "Create a new mysql database name:";
	read db_name;
else 
	echo "db_name is set to $db_name"; 
fi
echo "define('DB_NAME', '$db_name');" >> ./wp_config.php

if [ -z ${db_user_name+x} ]; 
then 
	echo "Create mysql user name:";
	read db_user_name;
else 
	echo "db_user_name is set to $db_user_name"; 
fi
echo "define('DB_USER', '$db_user_name');" >> ./wp_config.php

if [ -z ${db_user_pw+x} ]; 
then 
	echo "Create mysql user's pw:";
	read -s db_user_pw;
else 
	echo "db_user_pw is set"; 
fi
echo "define('DB_PASSWORD', '$db_user_pw');" >> ./wp_config.php

echo "define('DB_HOST', 'localhost');" >> ./wp_config.php
echo "define('DB_CHARSET', 'utf8');" >> ./wp_config.php
echo "define('DB_COLLATE', '');" >> ./wp_config.php

curl -s https://api.wordpress.org/secret-key/1.1/salt/ > ./keys
cat keys >> ./wp_config.php

echo "\$table_prefix  = 'wp_';" >> ./wp_config.php
echo "define('WP_DEBUG', false);" >> ./wp_config.php
echo "if ( !defined('ABSPATH') )" >> ./wp_config.php
echo "   define('ABSPATH', dirname(__FILE__) . '/');" >> ./wp_config.php
echo "require_once(ABSPATH . 'wp-settings.php');" >> ./wp_config.php

sudo chown root:root ./wp_config.php
sudo cp ./wp_config.php /var/www/html/wp-config.php
sudo rm ./wp_config.php
rm ./keys


