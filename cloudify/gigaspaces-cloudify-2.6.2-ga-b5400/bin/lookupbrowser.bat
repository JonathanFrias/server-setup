@call "%~dp0\setenv.bat"

@%JAVACMD% -Djava.security.policy=%POLICY% -classpath "%JSHOMEDIR%";%UI_JARS%;%GS_JARS% com.gigaspaces.admin.ui.lookupbrowser.Browser
