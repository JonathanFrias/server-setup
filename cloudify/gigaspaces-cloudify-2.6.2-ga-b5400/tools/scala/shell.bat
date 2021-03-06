@call "%~dp0\..\..\bin\setenv.bat"

set REPL_CLASSPATH=-cp %GS_JARS%;%SPRING_JARS%;%SIGAR_JARS%;%SCALA_JARS%;%GS_SCALA_JARS%
set REPL_EXTRA_JAVA_OPTS=-Dcom.gs.logging.debug=false
set REPL_JAVA_OPTS=%JAVA_OPTIONS% %RMI_OPTIONS% %LOOKUP_LOCATORS_PROP% %LOOKUP_GROUPS_PROP% %GS_LOGGING_CONFIG_FILE_PROP% %REPL_EXTRA_JAVA_OPTS%
set REPL_MAIN_CLASS=org.openspaces.scala.repl.GigaSpacesScalaRepl
set REPL_COMPILER_OPTS=-usejavacp -Yrepl-sync
set REPL_COMMAND=%JAVACMD% %REPL_JAVA_OPTS% %REPL_CLASSPATH% %REPL_MAIN_CLASS% %REPL_COMPILER_OPTS%

%REPL_COMMAND%
