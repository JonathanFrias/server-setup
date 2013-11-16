#!/bin/bash
#
# This script is a wrapper around the "gs" script, and provides the command line instruction
# to start the GigaSpaces Grid Service Monitor and autonomous Lookup service
# 		GSA_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for GSA such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
#							- These settings can be overridden externally to this script.

command_line=$*
services="com.gigaspaces.start.services=\"GSA\""

# GSA_JAVA_OPTIONS=; export GSA_JAVA_OPTIONS
COMPONENT_JAVA_OPTIONS="${GSA_JAVA_OPTIONS}"

if [ "${GSA_RESERVATION_ID}" = "" ] ; then
GSA_RESERVATION_ID=; export GSA_RESERVATION_ID
else
COMPONENT_JAVA_OPTIONS="${COMPONENT_JAVA_OPTIONS} -Dcom.gs.agent.reservationid=${GSA_RESERVATION_ID}"
fi
export COMPONENT_JAVA_OPTIONS

`dirname $0`/gs.sh start $services $command_line
