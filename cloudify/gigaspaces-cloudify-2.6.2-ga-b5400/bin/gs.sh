#!/bin/bash
#
# This script provides the command and control utility for the
# GigaSpaces Technologies Inc. Service Grid

scriptDir="$(dirname $0)"
command_line=$*
start=

if [ "$1" = "start" ]; then
    start=1
    shift
    command_line=$*
fi

# The call to setenv.sh can be commented out if necessary.
. `dirname $0`/setenv.sh

# set bootclasspath
bootclasspath="-Xbootclasspath/p:$XML_JARS"

GS_LIB="$JSHOMEDIR/lib"

# Function to find a file
getPathForFile() {
    filename="$1"
    if [ -f "$GS_LIB/platform/boot/$filename" ] ; then
	located="$GS_LIB/platform/boot/$filename"
    else
    echo "Cannot locate $filename in the expected directory structure, exiting"
    exit 1
    fi
}

# Locate the boot strapping jars
getPathForFile gs-boot.jar
gsboot=$located

# If the command is to start the Service Grid, invoke the SystemBoot facility.
# Otherwise invoke the CLI to interafce with the product
if [ "$start" = "1" ]; then
    NATIVE_DIR="$GS_LIB/platform/native"
    # Check for running on OS/X
    opSys=`uname -s`
    if [ $opSys = "Darwin" ] ; then
        export DYLD_LIBRARY_PATH=$EXT_LD_LIBRARY_PATH${CPS}$LD_LIBRARY_PATH${CPS}$NATIVE_DIR
    else
        export LD_LIBRARY_PATH=$EXT_LD_LIBRARY_PATH${CPS}$LD_LIBRARY_PATH${CPS}$NATIVE_DIR
    fi
# CPP Environment setup
    if [ -f "${JSHOMEDIR}/cpp/setenv.sh" ]; then
        . ${JSHOMEDIR}/cpp/setenv.sh
        libpath="-Djava.library.path=$CPP_SPACE_LIB_PATH"
    fi

    script_classpath="-cp $PRE_CLASSPATH:$SIGAR_JARS:$JSHOMEDIR:$gsboot:$POST_CLASSPATH"
    launchTarget=com.gigaspaces.start.SystemBoot
    "$JAVACMD" ${JAVA_OPTIONS} -DagentId=${AGENT_ID} -DgsaServiceID=${GSA_SERVICE_ID} -DenableDynamicLocators=${ENABLE_DYNAMIC_LOCATORS} $bootclasspath $script_classpath ${RMI_OPTIONS} $libpath ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} -Dcom.gs.logging.debug=false ${GS_LOGGING_CONFIG_FILE_PROP} $NETWORK $DEBUG $launchTarget $command_line
else
    cliExt="config/services/services.config"
    launchTarget=com.gigaspaces.admin.cli.GS
    script_classpath="-cp $PRE_CLASSPATH:$GS_JARS:$SPRING_JARS:$POST_CLASSPATH
"
    "$JAVACMD" ${JAVA_OPTIONS} $bootclasspath $script_classpath ${RMI_OPTIONS} ${LOOKUP_GROUPS_PROP} ${LOOKUP_LOCATORS_PROP} -Dcom.gs.logging.debug=false ${GS_LOGGING_CONFIG_FILE_PROP} $launchTarget $cliExt $command_line
    
fi
