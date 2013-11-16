@rem *************************************************************************
@rem This script is used to initialize common environment to GigaSpaces Server.
@rem
@rem It sets the following variables:
@rem
@rem JAVA_HOME  - Location of the JDK version used to start GigaSpaces 
@rem              Server.
@rem          Note that YOU MUST SUPPLY A JAVA_HOME environment variable 
@rem JAVACMD - The Java command-line
@rem  
@rem JAVA_OPTIONS   - Java command-line options for running the server,
@rem            Including: The Java args to override the standard memory arguments passed to java,
@rem            - Arg specifying the JVM to run.  (i.e. -server, -hotspot, -jrocket etc.)
@rem            - GC, profiling and management options.
@rem		- These settings can be overridden externally to this script.
@rem
@rem EXT_JAVA_OPTIONS 	- Extended java option such as system properties or other JVM arguments that can be passed to the JVM command line. 
@rem					- These settings can be overridden externally to this script.
@rem
@rem JAVA_VM_NAME JAVA_VERSION
@rem        - VM Name (i.e. All, HOTSPOT, J9, JROCKIT, etc.) and version of the JVM (1.5, 1.6)
@rem		- The JVM default settings are set according to the JVM 
@rem        vendor and version. A java code is executed in order to fetch these details.
@rem RMI_OPTIONS
@rem            - Additional RMI optional properties.  
@rem
@rem JSHOMEDIR - The GigaSpaces home directory.
@rem            
@rem POLICY - The default Java security policy file.
@rem LOOKUPGROUPS - Jini Lookup Service Group
@rem
@rem LOOKUPLOCATORS - Jini Lookup Service Locators used for unicast discovery
@rem
@rem NIC_ADDR 	  - The Network Interface card IP Address
@rem 
@rem PRE_CLASSPATH  - Path style variable to be added to the beginning of the 
@rem                  system CLASSPATH 
@rem POST_CLASSPATH - Path style variable to be added to the end of the 
@rem                  system CLASSPATH.
@rem 
@rem  For additional information, refer to the GigaSpaces OnLine Documentation
@rem  at http://www.gigaspaces.com/wiki/display/XAP91/System+Environment+and+Environment+Variables
@rem *************************************************************************
@echo off

@rem - Set VERBOSE=true for debugging output
if "%VERBOSE%" == "" (
	@set VERBOSE=false
)

@rem - Set or override the JAVA_HOME variable
@rem - By default, the system variable value is used.

@rem Note - If the JAVA_HOME is a path which contains white spaces, you need to surround the 
@rem JAVACMD, JAVACCMD and JAVAWCMD variable with quotes

@rem set JAVA_HOME=D:\jdk1.5.0_15
@rem - Reset JAVA_HOME unless JAVA_HOME is pre-defined.
if "%JAVA_HOME%" == "" goto noJavaHome
if not exist "%JAVA_HOME%\bin\java.exe" goto noJavaHome

@rem @echo JAVA_HOME environment variable is set to %JAVA_HOME% in "<GigaSpaces Root>\bin\setenv.bat"
set JAVACMD="%JAVA_HOME%\bin\java"
set JAVACCMD="%JAVA_HOME%\bin\javac"
set JAVAWCMD="%JAVA_HOME%\bin\javaw"
goto endOfJavaHome

:noJavaHome
@rem @echo The JAVA_HOME environment variable is not set. Using the java that is set in system path."
set JAVACMD=java
set JAVACCMD=javac
set JAVAWCMD=javaw

:endOfJavaHome

if "%JSHOMEDIR%" == "" set JSHOMEDIR=%~dp0\..

if "%1" == "javaversion"  (
%JAVACMD% -cp "%~dp0\..\lib\required\gs-runtime.jar" com.gigaspaces.internal.utils.OutputJVMVersion
goto END
)
FOR /F "usebackq tokens=*" %%i IN (`"%~dp0\..\bin\setenv.bat" javaversion`) DO @set JAVA_VERSION=%%i

if "%1" == "javavmname"  (
%JAVACMD% -cp "%~dp0\..\lib\required\gs-runtime.jar" com.gigaspaces.internal.utils.OutputJVMName
goto END
)
FOR /F "usebackq tokens=*" %%i IN (`"%~dp0\..\bin\setenv.bat" javavmname`) DO @set JAVA_VM_NAME=%%i

if "%EXT_JAVA_OPTIONS%" == "" (
set EXT_JAVA_OPTIONS=-Xmx512m
)

if DEFINED JAVA_OPTIONS goto continue
@rem Reset JAVA_VM_NAME/JAVA_VERSION unless JAVA_VM_NAME/JAVA_VERSION is defined already.
if DEFINED JAVA_VM_NAME goto noReset
if DEFINED JAVA_VERSION goto noReset

:noReset
@rem set up JVM Vendors
if "%JAVA_VM_NAME%" == "ALL" goto all
if "%JAVA_VM_NAME%" == "JROCKIT" goto jrockit
if "%JAVA_VM_NAME%" == "HOTSPOT" goto hotspot
if "%JAVA_VM_NAME%" == "J9" goto j9
if "%JAVA_VM_NAME%" == "HP"  goto hp
goto continue

:all
set JAVA_OPTIONS= -server -showversion %EXT_JAVA_OPTIONS%
goto continue

:jrockit
@rem more available options:  -Xgcprio:pausetime -XpauseTarget=200ms
set JAVA_OPTIONS= -server -showversion -XXaggressive -Xgcprio:throughput -Djrockit.oomdiagnostics=true -XXexitOnOutOfMemory %EXT_JAVA_OPTIONS%
goto continue

rem The following parameters have been found optimal during extensive tests, using HotSpot JVM 6.
rem In order to apply these VM switches, please add them to the JAVA_OPTIONS variable:

rem Optimal performance has been achieved with 2GB heap, it should be adjusted to real RAM size
rem -Xms2g -Xmx2g
rem GC Threads quantity is, by default, equal to quantity of CPU cores 
rem On single/dual CPU systems recommended to be set as 4 - 8

rem Relevant to Solaris 10
rem -XX:LargePageSizeInBytes=256m

rem This VM option tells the HotSpot VM to generate a heap dump when the first thread throws OutOfMemoryError 
rem because the java heap or the permanent generation is full. A heap dump is useful in production systems 
rem where you need to diagnose an unexpected failure. Note it does not impact performance.
rem It is supported from 5.0u7 and JDK 1.6 but it is up to the VM vendor to
rem support it in future versions.
rem -XX:+HeapDumpOnOutOfMemoryError

rem The following parameters have been found optimal when using Oracle 1.5 JVM for low latency deterministic client and server behavior
rem excluding false failure recovery caused by very long GC pauses.
rem 
rem Note that these are advanced settings and specific to a given scenario. 
rem It might also reduce the throughput. It will probably require tuning adjustments 
rem to the recommended values and should be done with special care!
rem
rem In order to apply these VM switches, please add them to the JAVA_OPTIONS variable:
rem -server -showversion -Xmx512m -XX:+UseConcMarkSweepGC -XX:+UseParNewGC -Xmn100m -XX:ParallelGCThreads=4

:hotspot
rem -XX:+UseConcMarkSweepGC	- Use concurrent mark-sweep collection for the old generation
rem -XX:+UseParNewGC              	- Use a parallel collection for the young generation
rem -XX:+ParallelGCThreads=<value> 	- Quantity of garbage collection threads
rem -Xmx<value>                     		- Max JVM heap size - Note that each script sets its own -Xmx values and it is not been set through the JAVA_OPTIONS variable
rem -Xms<value>                     		- Initial JVM heap size - It is recommended to define Xms equal to Xmx to achieve higher performance
rem						Note that each script sets its own -Xms values and it is not been set through the JAVA_OPTIONS variable
rem
set JAVA_OPTIONS= -server -XX:+AggressiveOpts -showversion -XX:MaxPermSize=256m -XX:+HeapDumpOnOutOfMemoryError %EXT_JAVA_OPTIONS%
goto continue

:j9
set JAVA_OPTIONS= -Xbootclasspath/p:${JSHOMEDIR}/lib/platform/xml/xalan.jar -showversion -XX:MaxPermSize=256m %EXT_JAVA_OPTIONS%
goto continue

:hp
set JAVA_OPTIONS= -server -showversion %EXT_JAVA_OPTIONS%
goto continue


:continue

set JAVA_OPTIONS= %JAVA_OPTIONS% %COMPONENT_JAVA_OPTIONS%

rem Append all files of lib/ext directory to the classpath
set GS_JARS="%JSHOMEDIR%\lib\required\*;"
set SPRING_JARS="%JSHOMEDIR%\lib\optional\spring\*;%JSHOMEDIR%\lib\optional\security\*;"
set SIGAR_JARS="%JSHOMEDIR%\lib\platform\sigar\*;"
set ANT_JARS="%JSHOMEDIR%\lib\platform\ant\*;"
set JDBC_JARS="%JSHOMEDIR%\lib\platform\jdbc\*;%JSHOMEDIR%\lib\platform\jdbc\*;"
set XML_JARS="%JSHOMEDIR%\lib\platform\xml\*"
set UI_JARS="%JSHOMEDIR%\lib\platform\ui\*;%JSHOMEDIR%\lib\platform\poi\*;"
set EXT_JARS="%JSHOMEDIR%\lib\platform\ext\*;"
set PU_COMMON_JARS="%JSHOMEDIR%\lib\optional\pu-common\*;"

rem Path to scala jar files. (could be changed to point to SCALA_HOME\lib)
set SCALA_JARS="%JSHOMEDIR%\lib\platform\scala\lib\*;"

rem Path to openspaces scala extension jars.
set GS_SCALA_JARS="%JSHOMEDIR%\lib\platform\scala\*;"

rem the GS_JARS contains the same list as defined in the Class-Path entry of the gs-runtime.jar manifest file.
rem These jars are required for client application and starting a Space from within your application.
set GS_JARS=%EXT_JARS%;"%JSHOMEDIR%";%GS_JARS%;%PU_COMMON_JARS%

set PLATFORM_VERSION=9.0
set POLICY="%JSHOMEDIR%\policy\policy.all"

if "%LOOKUPGROUPS%" == ""  (
set LOOKUPGROUPS="gigaspaces-Cloudify-2.6.2-ga"
)
set LOOKUP_GROUPS_PROP=-Dcom.gs.jini_lus.groups=%LOOKUPGROUPS%

if "%LOOKUPLOCATORS%" == ""  (
set LOOKUPLOCATORS=
)
set LOOKUP_LOCATORS_PROP=-Dcom.gs.jini_lus.locators=%LOOKUPLOCATORS%

rem The NIC_ADDR represents the specific network interface card IP address or the default host name.
rem Note - When using Multi Network-Interface cards, explicitly set it with the NIC address (e.g. 192.168.0.2)
rem as it is the value of the the java.rmi.server.hostname system property. (see RMI_OPTIONS)
if "%NIC_ADDR%" == "" (
set NIC_ADDR="%COMPUTERNAME%"
)

rem RMI properties
rem Note: In a setup for Multi Network-Interface cards please append -Djava.rmi.server.hostname="%NIC_ADDR%" 
rem with proper network-interface IP address to the RMI_OPTIONS
set RMI_OPTIONS=-Dsun.rmi.dgc.client.gcInterval=36000000 -Dsun.rmi.dgc.server.gcInterval=36000000 -Djava.rmi.server.hostname="%NIC_ADDR%" -Djava.rmi.server.RMIClassLoaderSpi=default -Djava.rmi.server.logCalls=false

rem For IDE remote debugging add the "%IDE_REMOTE_DEBUG%" variable to the command line:
set IDE_REMOTE_DEBUG=-Xdebug -Xnoagent -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=y

rem Set and add the system property -Djava.util.logging.config.file to the command line. It indicates file path to 
rem the Java logging file location. Use it to enable finest logging troubleshooting of various Jini Services and GS modules.
rem Setting this property will redirect all Jini services and GS modules output messages to a file.
rem Specific logging settings can be provided by setting the following before calling setenv:
rem export GS_LOGGING_CONFIG_FILE=/somepath/my_logging.properties
if "%GS_LOGGING_CONFIG_FILE%" == "" (
set GS_LOGGING_CONFIG_FILE=%JSHOMEDIR%/config/gs_logging.properties
)
set GS_LOGGING_CONFIG_FILE_PROP=-Djava.util.logging.config.file="%GS_LOGGING_CONFIG_FILE%"

rem Enable monitoring and management from remote systems using JMX jconsole.
set REMOTE_JMX=-Dcom.sun.management.jmxremote.port=5001 -Dcom.sun.management.jmxremote.ssl=false -Dcom.sun.management.jmxremote.authenticate=false

if "%VERBOSE%"=="true" (
	echo ====================================================================================
	echo VERBOSE is on
	echo.
	echo GigaSpaces %PLATFORM_VERSION% environment set successfully from JSHOMEDIR: %JSHOMEDIR%
	echo.
	echo JAVACMD: %JAVACMD%    		JAVACCMD: %JAVACCMD%		JAVAWCMD: %JAVAWCMD%
	echo.
	echo JAVA_OPTIONS: %JAVA_OPTIONS%	EXT_JAVA_OPTIONS: %EXT_JAVA_OPTIONS%	JAVA_VERSION: %JAVA_VERSION% JAVA_VM_NAME: %JAVA_VM_NAME%
	echo.
	echo NIC_ADDR: %NIC_ADDR%
	echo.
	echo RMI_OPTIONS: %RMI_OPTIONS%
	echo.
	echo GS_JARS: %GS_JARS%
	echo.
	echo LOOKUPGROUPS: %LOOKUPGROUPS%  LOOKUPLOCATORS: %LOOKUPLOCATORS%
	echo.
	echo ANT_JARS: %ANT_JARS%
	echo.
	echo JDBC_JARS: %JDBC_JARS%
	echo.
	echo XML_JARS: %XML_JARS%
	echo.
	echo UI_JARS: %UI_JARS%
	echo.
	echo SPRING_JARS: %SPRING_JARS%
	echo.
	echo EXT_JARS: %EXT_JARS%
	echo.
	echo GS_LOGGING_CONFIG_FILE_PROP: %GS_LOGGING_CONFIG_FILE_PROP%
	echo.
	echo ====================================================================================
)

:end
