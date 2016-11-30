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
export COMPOSE_PROJECT_NAME="${COMPOSE_PROJECT_NAME:-${PWD##*/}}" # Set ProjectName to curent folder
export COMPOSE_DOCKER_DATA="${DOCKER_DATA:-/opt/docker_data}" # Storage Location for Containers to Put Data
export COMPOSE_DOCKER_CONFIG="${DOCKER_CONFIG:-/opt/docker_config}" # Storage Location for Containers to Put Configuration Files
export COMPOSE_FLUENTD_SERVER="${FLUENTD_SERVER:-1.1.1.1}" # FluentD Server for Docker to Send Logs to
export COMPOSE_DOCKER_SERVER_IP="$(/sbin/ifconfig eth0 | grep 'inet ' | grep -Eow '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)" # IP of Docker Server
export COMPOSE_DOCKER_SERVER_HOSTNAME="$(hostname -f)" # Hostname of Docker Server

#############
## CACTI
#############

export COMPOSE_CACTI_HOSTNAME="${COMPOSE_CACTI_HOSTNAME:-$COMPOSE_DOCKER_SERVER_HOSTNAME}" # Hostname to use by Cacti Container
export COMPOSE_CACTI_MAILHOST="${COMPOSE_CACTI_MAILHOST:-mail.changeme.com}" # Mailhost to use by Cacti Container
export COMPOSE_CACTI_MYSQL_USERNAME="${COMPOSE_CACTI_MYSQL_USERNAME:-cacti}" # Cacti MySQL Username
export COMPOSE_CACTI_MYSQL_PASSWORD="${COMPOSE_CACTI_MYSQL_PASSWORD:-cactipw!}" # Cacti MySQL Password
export COMPOSE_CACTI_MYSQL_HOST="${COMPOSE_CACTI_MYSQL_HOST:-mysql}" # Cacti MySQL Host
export COMPOSE_CACTI_MYSQL_DATABASE="${COMPOSE_CACTI_MYSQL_DATABASE:-cacti}" # Cacti MySQL Database

##############
## MYSQL
##############

export COMPOSE_MYSQL_MEM10=$(echo|awk -v MEM=`free -m -t | egrep -i ^total | awk '{print $2}'` '{printf "%.0f",MEM*.10}')M
export COMPOSE_MYSQL_MEM25=$(echo|awk -v MEM=`free -m -t | egrep -i ^total | awk '{print $2}'` '{printf "%.0f",MEM*.25}')M
export COMPOSE_MYSQL_MEM50=$(echo|awk -v MEM=`free -m -t | egrep -i ^total | awk '{print $2}'` '{printf "%.0f",MEM*.50}')M

#####

# Run Standard Docker-Compose with Arguments
docker-compose "$@"







