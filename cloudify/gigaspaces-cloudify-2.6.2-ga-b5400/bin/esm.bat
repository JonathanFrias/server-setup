@echo off
rem This script is a wrapper around the "gs" script, and provides the command line instruction
rem to start the GigaSpaces Elastic Grid Service Manager
rem 	ESM_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for ESM such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
rem							- These settings can be overridden externally to this script.

title GigaSpaces Technologies Service Grid : ESM
set command_line=%*

@rem set ESM_JAVA_OPTIONS=
set COMPONENT_JAVA_OPTIONS=%ESM_JAVA_OPTIONS%

@call "%~dp0\gs.bat" start startESM %command_line%
