#!/bin/bash



# Install Weathermap
cd /usr/local/src
curl -s -n https://api.github.com/repos/howardjones/network-weathermap/releases/latest | grep browser_download_url | grep .zip | cut -d'"' -f4 | wget -i - -O php-weathermap.zip
unzip php-weathermap.zip
mv weathermap /opt/cacti/plugins/
mkdir /opt/cacti/plugins/weathermap/output
rm -f weathermap*


# Install Autom8
cd /usr/local/src
wget http://docs.cacti.net/_media/plugin:autom8_v031.tgz -O autom8.tgz
tar zxvf autom8.tgz
mv autom8 /opt/cacti/plugins/
