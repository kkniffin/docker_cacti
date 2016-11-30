#!/bin/bash

CACTI_CONFIG_FILE="/opt/cacti/include/config.php"

echo "###########################"
echo "#### Configuring Cacti ####"
echo "###########################"

#sed -i "s/\(\/\/\)\{0,2\}\$database_type .*/\$database_type = \"mysqli\";/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$database_default.*/\$database_default = \"${CACTI_MYSQL_DATABASE}\";/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$database_hostname.*/\$database_hostname = \"${CACTI_MYSQL_HOST}\";/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$database_username.*/\$database_username = \"${CACTI_MYSQL_USERNAME}\";/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$database_password.*/\$database_password = \"${CACTI_MYSQL_PASSWORD}\";/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$url_path/\$url_path/" ${CACTI_CONFIG_FILE}
sed -i "s/\(\/\/\)\{0,2\}\$cacti_session_name/\$cacti_session_name/" ${CACTI_CONFIG_FILE}

# Check if SQL Server is Up
until mysql -u${CACTI_MYSQL_USERNAME} -s -p${CACTI_MYSQL_PASSWORD} -h${CACTI_MYSQL_HOST} -e "show databases" --silent 2>/dev/null; do
	echo "#### MYSQL IS NOT UP YET, WAITING 10 SECS"
	sleep 10;
done

# If Tables in Database Doesnt Exist, Create Them
echo "#### CHECK IF ${CACTI_MYSQL_DATABASE} EXISTS AND HAS TABLES"
if ! mysql -u${CACTI_MYSQL_USERNAME} -s -p${CACTI_MYSQL_PASSWORD} -h${CACTI_MYSQL_HOST} ${CACTI_MYSQL_DATABASE} -e "select * from sites" --silent 2>/dev/null; then
	echo "#### CACTI DB DOESNT EXIST, CREATING..."
	mysql -u${CACTI_MYSQL_USERNAME} -p${CACTI_MYSQL_PASSWORD} -h${CACTI_MYSQL_HOST} ${CACTI_MYSQL_DATABASE} --silent 2>/dev/null < /opt/cacti/cacti.sql
else
	echo "#### CACTI DB EXISTS ALREADY"
fi
