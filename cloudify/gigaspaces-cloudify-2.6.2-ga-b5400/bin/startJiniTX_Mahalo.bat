rem 	JTX_JAVA_OPTIONS 	- Extended java options that are proprietary defined  for Jini Transaction Manager such as heap size, system properties or other JVM arguments that can be passed to the JVM command line. 
rem							- These settings can be overridden externally to this script.

@title=Jini Transaction Manager - Mahalo
@echo Starting a Mahalo Jini Transaction Manager instance

set command_line=%*

@rem set JTX_JAVA_OPTIONS=
set COMPONENT_JAVA_OPTIONS=%JTX_JAVA_OPTIONS%

call "%~dp0\gs.bat" start startTM %command_line%
