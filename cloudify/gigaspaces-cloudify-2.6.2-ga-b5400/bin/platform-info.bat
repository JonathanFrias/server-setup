@echo off
@title Platform Info

if "%1" == "-verbose" (
	goto VERBOSE
)

@set VERBOSE=false
@call "%~dp0\setenv.bat"
%JAVACMD% -classpath %GS_JARS% com.j_spaces.kernel.PlatformVersion
goto END

:VERBOSE

@set VERBOSE=true
@call "%~dp0\setenv.bat"
%JAVACMD% -classpath %GS_JARS% com.gigaspaces.admin.cli.RuntimeInfo

:END

ECHO Press Enter to exit . . .
SET /P =
