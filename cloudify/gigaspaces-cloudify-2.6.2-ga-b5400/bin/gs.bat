@echo off
rem This script provides the command and control utility for the 
rem GigaSpaces Technologies Inc. Service Grid

rem Use local variables
setlocal

@call "%~dp0\setenv.bat"

rem Set local variables
set GS_LIB=%JSHOMEDIR%\lib

rem set booclasspath 
set bootclasspath=-Xbootclasspath/p:%XML_JARS%


:checkgsboot
if exist "%GS_LIB%\platform\boot\gs-boot.jar" goto setgsboot
if not exist "%GS_LIB%\platform\boot\gs-boot.jar" goto systemFailure
set gsboot=%GS_LIB%\platform\boot\gs-boot.jar
goto jarsfound
:setgsboot
set gsboot=%GS_LIB%\platform\boot\gs-boot.jar

:jarsfound

rem Parse command line
if "%1"=="" goto interactive
if "%1"=="start" goto start

:interactive
title GigaSpaces Technologies Service Grid : Interactive Shell
set cliExt=config/services/services.config
set command_line=%*
set launchTarget=com.gigaspaces.admin.cli.GS
set script_classpath=-cp %PRE_CLASSPATH%;%GS_JARS%;"%GS_LIB%";%SPRING_JARS%;%POST_CLASSPATH%

set COMMAND=%JAVACMD% %JAVA_OPTIONS% %bootclasspath% %script_classpath% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% -Dcom.gs.logging.debug=false %GS_LOGGING_CONFIG_FILE_PROP% %launchTarget% %cliExt% %command_line%

echo.
echo Starting with line:
echo %COMMAND%
echo.
%COMMAND%
goto end

:start

rem Slurp the command line arguments. This loop allows for an unlimited number
rem of arguments (up to the command line limit, anyway).

set services=

shift
:setupCommandLine
if "%1"=="" goto commandLineParsed
if "%1"=="startGSC" goto addGSC
if "%1"=="startGSM" goto addGSM
if "%1"=="startESM" goto addESM
if "%1"=="startGSA" goto addGSA
if "%1"=="startGS" goto addGS
if "%1"=="startLH" goto addLH
if "%1"=="startTM" goto addTM
if "%1"=="noJMX" goto noJMX
if "%1"=="noHTTP" goto noHTTP
if "%1"=="yesHTTP" goto yesHTTP

if "%options%"=="" goto addOptionsolo
   set options=%options% %1
   shift
   goto setupCommandLine
:addOptionsolo
   set options=%1
   shift
   goto setupCommandLine

rem If we've fallen through to here, we are done with the 
rem "startXXX" directives
goto commandLineParsed

:addGSC
    if "%services%"=="" goto addGSCsolo
    set services=%services%,GSC
    shift
    goto setupCommandLine

:addGSCsolo
    set services=GSC
    shift
    goto setupCommandLine

:addGSM
    if "%services%"=="" goto addGSMsolo
    set services=%services%,GSM
    shift
    goto setupCommandLine

:addESM
    if "%services%"=="" goto addESMsolo
    set services=%services%,ESM
    shift
    goto setupCommandLine

:addGSMsolo
    set services=GSM
    shift
    goto setupCommandLine

:addESMsolo
    set services=ESM
    shift
    goto setupCommandLine

:addGSA
    if "%services%"=="" goto addGSAsolo
    set services=%services%,GSA
    shift
    goto setupCommandLine

:addGSAsolo
    set services=GSA
    shift
    goto setupCommandLine

:addGS
    if "%services%"=="" goto addGSsolo
    set services=%services%,GS
    shift
    goto setupCommandLine

:addGSsolo
    set services=GS
    shift
    goto setupCommandLine

:addLH
    if "%services%"=="" goto addLHsolo
    set services=%services%,LH
    shift
    goto setupCommandLine

:addLHsolo
    set services=LH
    shift
    goto setupCommandLine

:addTM
    if "%services%"=="" goto addTMsolo
    set services=%services%,TM
    shift
    goto setupCommandLine

:addTMsolo
    set services=TM
    shift
    goto setupCommandLine

:noJMX
    if "%services%"=="" goto noJMXsolo
    set services=%services%,NO_JMX
    shift
    goto setupCommandLine

:noJMXsolo
    set services=NO_JMX
    shift
    goto setupCommandLine

:noHTTP
    if "%services%"=="" goto noHTTPsolo
    set services=%services%,NO_HTTP
    shift
    goto setupCommandLine

:noHTTPsolo
    set services=NO_HTTP
    shift
    goto setupCommandLine

:yesHTTP
    if "%services%"=="" goto yesHTTPsolo
    set services=%services%,YES_HTTP
    shift
    goto setupCommandLine

:yesHTTPsolo
    set services=YES_HTTP
    shift
    goto setupCommandLine

goto setupCommandLine

:commandLineParsed
set command_line=%options%
set startParm=com.gigaspaces.start.services=\"%services%\"
rem Set the path to include native library directory
set PATH=%PATH%;%GS_LIB%\platform\native
set launchTarget=com.gigaspaces.start.SystemBoot
set script_classpath=-cp %PRE_CLASSPATH%;"%JSHOMEDIR%";%SIGAR_JARS%;"%gsboot%";%POST_CLASSPATH%

set COMMAND=%JAVACMD% %JAVA_OPTIONS%  -DagentId=%AGENT_ID% -DgsaServiceID=%GSA_SERVICE_ID% -DenableDynamicLocators=%ENABLE_DYNAMIC_LOCATORS% %bootclasspath% %script_classpath% %RMI_OPTIONS% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% -Dcom.gs.logging.debug=false %GS_LOGGING_CONFIG_FILE_PROP%  %launchTarget% %startParm% %command_line%

echo.
echo Starting with line:
echo %COMMAND%
echo.
%COMMAND%

goto end

:systemFailure
echo "Cannot locate system jars in the expected directory structure, exiting"

:end
endlocal
set ERR=%ERRORLEVEL%
title Command Prompt
if "%OS%"=="Windows_NT" @endlocal
if "%OS%"=="WINNT" @endlocal
@%COMSPEC% /C exit %ERR% >nul
