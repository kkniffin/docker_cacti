#!/bin/bash

# PLEASE NOTE: NO CHANGES NEED TO MEED TO THIS FILE IF YOU WANT TO CUSTOMIZE VARIABLES.
# PLEASE USE THE OVERRIDES.ENV FILE SO THAT YOUR CUSTOMIZATIONS WONT BE LOST ON A GIT PULL

# Load Overrides File for overwriting Environment Variables in this file
# This will allow git pulls as they will overwrite this file, but not the overrides.env
# Format is VARIABLE=DATA
if ! [ -f ./overrides.env ]; then
	touch ./overrides.env
fi
. ./overrides.env

##########################
##### Set Variables ######
##########################

#############
## General
#############
export COMPOSE_PROJECT_NAME="docker-graylog2-standalone"
export COMPOSE_DOCKER_DATA="${DOCKER_DATA:-/opt/docker_data}"
export COMPOSE_DOCKER_CONFIG="${DOCKER_CONFIG:-/opt/docker_config}"
export COMPOSE_FLUENTD_SERVER="${FLUENTD_SERVER:-1.1.1.1}"
export COMPOSE_DOCKER_SERVER_IP="$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)"
export COMPOSE_DOCKER_SERVER_HOSTNAME="$(hostname -f)"

#####

# Run Standard Docker-Compose with Arguments
docker-compose "$@"







