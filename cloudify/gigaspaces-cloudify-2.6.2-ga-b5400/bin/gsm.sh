#!/bin/bash
#
# This script is a wrapper around the "gs" script, and provides the command line instruction
# to start the GigaSpaces Grid Service Monitor and autonomous Lookup service
# 		GSM_JAVA_OPTIONS 	- Extended java options that are proprietary defined for GSM such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
#							- These settings can be overridden externally to this script.

command_line=$*
services="com.gigaspaces.start.services=\"LH,GSM\""

# GSM_JAVA_OPTIONS=; export GSM_JAVA_OPTIONS
COMPONENT_JAVA_OPTIONS="${GSM_JAVA_OPTIONS}"
export COMPONENT_JAVA_OPTIONS

`dirname $0`/gs.sh start $services $command_line
