#!/bin/bash
# 		JTX_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for Jini Transaction Manager such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
#							- These settings can be overridden externally to this script.

echo Starting a Mahalo Jini Transaction Manager instance
command_line=$*
services="com.gigaspaces.start.services=\"TM\""

# JTX_JAVA_OPTIONS=; export JTX_JAVA_OPTIONS
COMPONENT_JAVA_OPTIONS="${JTX_JAVA_OPTIONS}"
export COMPONENT_JAVA_OPTIONS

`dirname $0`/gs.sh start $services $command_line
