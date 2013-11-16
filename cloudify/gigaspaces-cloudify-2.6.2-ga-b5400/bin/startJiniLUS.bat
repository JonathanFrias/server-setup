rem 	LUS_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for LUS such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
rem							- These settings can be overridden externally to this script.

@title=Jini Lookup Service - Reggie
@echo Starting a Reggie Jini Lookup Service instance

set command_line=%*

@rem set LUS_JAVA_OPTIONS=
set COMPONENT_JAVA_OPTIONS=%LUS_JAVA_OPTIONS%

call "%~dp0\gs.bat" start startLH %command_line%
