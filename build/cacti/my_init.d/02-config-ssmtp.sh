#!/bin/bash

SSMTP_CONFIG_FILE="/etc/ssmtp/ssmtp.conf"


echo "#######################"
echo "Configuring SSMTP"
echo "#######################"

# Update SSMTP Settings for Mail Communication
sed -i "s/mailhub=.*/mailhub=${CACTI_MAILHOST}/" ${SSMTP_CONFIG_FILE}
sed -i "s/hostname=.*/hostname=${CACTI_HOSTNAME}/" ${SSMTP_CONFIG_FILE}

