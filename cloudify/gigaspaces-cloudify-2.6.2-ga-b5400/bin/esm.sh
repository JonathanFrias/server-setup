#!/bin/bash
#
# This script is a wrapper around the "gs" script, and provides the command line instruction
# to start the GigaSpaces Elastic Grid Service Manager
# 		ESM_JAVA_OPTIONS 	- Extended java options that are proprietary defined for ESM such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
#							- These settings can be overridden externally to this script.

command_line=$*
services="com.gigaspaces.start.services=\"ESM\""

# ESM_JAVA_OPTIONS=; export ESM_JAVA_OPTIONS
COMPONENT_JAVA_OPTIONS="${ESM_JAVA_OPTIONS}"
export COMPONENT_JAVA_OPTIONS

`dirname $0`/gs.sh start $services $command_line
