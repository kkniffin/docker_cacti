#!/bin/bash
# Variables
CACTI_PLUGINS_DIR="/opt/cacti/plugins"


echo "#############################################"
echo "#### Installing Cacti Plugins if Missing ####"
echo "#############################################"

# Install Weathermap
if [ ! -d ${CACTI_PLUGINS_DIR}/weathermap ]; then
	cd /usr/local/src
	curl -s -n https://api.github.com/repos/howardjones/network-weathermap/releases/latest | grep browser_download_url | grep .zip | cut -d'"' -f4 | wget -i - -O php-weathermap.zip
	unzip php-weathermap.zip
	mv weathermap /opt/cacti/plugins/
	if [ ! -d ${CACTI_PLUGINS_DIR}/weathermap/output ]; then
		mkdir ${CACTI_PLUGINS_DIR}/weathermap/output
	fi
	rm -f weathermap*
fi


if [ ! -d ${CACTI_PLUGINS_DIR}/autom8 ]; then
	# Install Autom8
	cd /usr/local/src
	wget http://docs.cacti.net/_media/plugin:autom8_v031.tgz -O autom8.tgz
	tar zxvf autom8.tgz
	mv autom8 /opt/cacti/plugins/
	rm -rf autom8*
fi
