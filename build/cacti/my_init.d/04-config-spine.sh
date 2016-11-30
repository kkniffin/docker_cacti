#!/bin/bash

SPINE_CONFIG_FILE="/etc/spine.conf"

echo "########################"
echo "#### Configure SPINE ####"
echo "#########################"

sed -i "s/^DB_User.*/DB_User\t\t${CACTI_MYSQL_USERNAME}/" ${SPINE_CONFIG_FILE}
sed -i "s/^DB_Pass.*/DB_Pass\t\t${CACTI_MYSQL_PASSWORD}/" ${SPINE_CONFIG_FILE}
sed -i "s/^DB_Host.*/DB_Host\t\t${CACTI_MYSQL_HOST}/" ${SPINE_CONFIG_FILE}
sed -i "s/^DB_Database.*/DB_Database\t\t${CACTI_MYSQL_DATABASE}/" ${SPINE_CONFIG_FILE}
