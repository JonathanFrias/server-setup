#!/bin/bash
# 		LUS_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for LUS such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
#							- These settings can be overridden externally to this script.

echo Starting a Reggie Jini Lookup Service instance
command_line=$*
services="com.gigaspaces.start.services=\"LH\""

# LUS_JAVA_OPTIONS=; export LUS_JAVA_OPTIONS
COMPONENT_JAVA_OPTIONS="${LUS_JAVA_OPTIONS}"
export COMPONENT_JAVA_OPTIONS

`dirname $0`/gs.sh start $services $command_line
