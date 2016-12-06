#!/bin/bash
# Variables
CACTI_PLUGINS_DIR="/opt/cacti/plugins"


echo "#############################################"
echo "#### Installing Cacti Plugins if Missing ####"
echo "#############################################"

# Install Weathermap
if [ ! -d ${CACTI_PLUGINS_DIR}/weathermap ]; then
        cd /usr/local/src
        git clone -b database-refactor https://github.com/howardjones/network-weathermap.git
        mv network-weathermap ${CACTI_PLUGINS_DIR}/weathermap
        if [ ! -d ${CACTI_PLUGINS_DIR}/weathermap/output ]; then
                mkdir ${CACTI_PLUGINS_DIR}/weathermap/output
        fi
        rm -rf network-weathermap*
fi

# Plugin THOLD
if [ ! -d ${CACTI_PLUGINS_DIR}/thold ]; then
        cd /usr/local/src
        git clone https://github.com/Cacti/plugin_thold
        mv plugin_thold ${CACTI_PLUGINS_DIR}/thold
        rm -rf plugin_thold*
fi

# Plugin Maint
if [ ! -d ${CACTI_PLUGINS_DIR}/maint ]; then
        cd /usr/local/src
        git clone https://github.com/Cacti/plugin_maint
        mv plugin_maint ${CACTI_PLUGINS_DIR}/maint
        rm -rf plugin_maint*
fi


# Plugin RouterConfigs
if [ ! -d ${CACTI_PLUGINS_DIR}/routerconfigs ]; then
        cd /usr/local/src
        git clone https://github.com/Cacti/plugin_routerconfigs
        mv plugin_routerconfigs ${CACTI_PLUGINS_DIR}/routerconfigs
        rm -rf plugin_routerconfigs*
fi

# Plugin Monitor
if [ ! -d ${CACTI_PLUGINS_DIR}/monitor ]; then
        cd /usr/local/src
        git clone https://github.com/Cacti/plugin_monitor
        mv plugin_monitor ${CACTI_PLUGINS_DIR}/monitor
        rm -rf plugin_monitor*
fi
