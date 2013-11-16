@echo off
rem This script is a wrapper around the "gs" script, and provides the command line instruction
rem to start the GigaSpaces Grid Service Container
rem
rem 	GSC_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for GSC such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
rem							- These settings can be overridden externally to this script.

title GigaSpaces Technologies Service Grid : GSC
set command_line=%*

@rem set GSC_JAVA_OPTIONS=
set COMPONENT_JAVA_OPTIONS=%GSC_JAVA_OPTIONS%

call "%~dp0\gs.bat" start startGSC %command_line%
