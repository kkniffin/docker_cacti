#!/bin/bash

############################################################################################
##### SAMPLE CONFIG FOR UPDATING CONFIGS FROM ENVIRONMENT VARIABLES ########################
############################################################################################

# If not run as root, exit as you will get privilege errors
if [ ! `whoami` == 'root' ]; then \
	exit 0
fi

echo '############################################################'
echo '############################################################'
echo '################# RUNNING ##################################'
echo `whoami`
echo '############################################################'
echo '############################################################'

CONFIGFILE=/etc/mysql/conf.d/cacti.cnf # Configuration File Location
ENV_VARIABLEPREFIX=MYCNF_ # Ex: CONFIGFILE_ anything starting with CONFIGFILE_ will be processed
SETTINGS_START_SEPERATOR='#<-- START SETTINGS -->' # Starting Seperator for identifying custom config
SETTINGS_END_SEPERATOR='#<-- END SETTINGS -->' # Ending Seperator for identifying custom config

# If File Doesn't Exist then Create it
if [ ! -f $CONFIGFILE ]; then
	touch $CONFIGFILE
fi

# Remove Existing Custom Config Starting at Seperator to end of file
sed -i "/${SETTINGS_START_SEPERATOR}.*/,$ d" $CONFIGFILE

# Start Custom Config Section
echo -e '[mysqld]' >> $CONFIGFILE
echo -e "${SETTINGS_START_SEPERATOR}" >> $CONFIGFILE

for ENVVARIABLE in `eval echo '${!'$ENV_VARIABLEPREFIX'*}'`
do

	# Remove Graylog_ Prefix from Environment Variables
        CONFIGVARIABLE="$(echo ${ENVVARIABLE,,} | sed "s/${ENV_VARIABLEPREFIX}//i")"
        # Get Value for Variable
        CONFIGVALUE="$(printenv $ENVVARIABLE)"

        # Check If Config Variable is in configuration and not commented out.
        if [[ $(egrep "^${CONFIGVARIABLE}" $CONFIGFILE) ]]; then
 	       # Comment it out so it can be added to the end of the file
               sed -i "s|^${CONFIGVARIABLE}|#${CONFIGVARIABLE}|g" $CONFIGFILE
	fi

	# Write Variable
	echo "${CONFIGVARIABLE} = ${CONFIGVALUE}" >> $CONFIGFILE

done

# End Custom Config Section
echo -e "${SETTINGS_END_SEPERATOR}" >> $CONFIGFILE

echo '#################################################'
echo '###### Updated MYSQL Configuration ##############'
echo '#################################################'
