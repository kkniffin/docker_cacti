#!/bin/bash

APACHE_CONFIG_FILE="/etc/apache2/apache2.conf"
APACHE_SITE_CONFIG_FILE="/etc/apache2/sites-enabled/default-ssl.conf"
APACHE_PORTS_CONFIG_FILE="/etc/apache2/ports.conf"

echo "#############################"
echo "#### Configuring Apache2 ####"
echo "#############################"

sed -i '/<Directory \/usr\/lib\/cgi-bin>/,/<\/Directory>/d' ${APACHE_SITE_CONFIG_FILE} # Remove Unneeded CGI
sed -i 's/SSLCertificateKeyFile.*//g' ${APACHE_SITE_CONFIG_FILE} # Remove Key File as all is contained in PEM
sed -i 's/Listen 80//' ${APACHE_PORTS_CONFIG_FILE} # Stop Listening on Port 80


# Redirect Root to Cacti Subdirectory if not already configured
if ! grep -i 'RedirectMatch \^\/\$' ${APACHE_SITE_CONFIG_FILE}; then
	sed -i '/DocumentRoot.*/Ia \\n\t\t# Redirect Root to Cacti Subdirectory\n\t\tRedirectMatch \^\/\$ \/cacti\/' ${APACHE_SITE_CONFIG_FILE}
fi

# Put HostName that is passed through as a variable
if ! egrep -iq "^ServerName" ${APACHE_CONFIG_FILE}; then
	echo "ServerName ${CACTI_HOSTNAME}" >> ${APACHE_CONFIG_FILE}
fi
