#!/bin/bash

if [ "$1" = "-verbose" ] ; then
    VERBOSE=true
    . `dirname $0`/setenv.sh
    $JAVACMD -classpath "${GS_JARS}"  com.gigaspaces.admin.cli.RuntimeInfo
else
    VERBOSE=false
    . `dirname $0`/setenv.sh
    $JAVACMD -classpath "${GS_JARS}"  com.j_spaces.kernel.PlatformVersion
fi
