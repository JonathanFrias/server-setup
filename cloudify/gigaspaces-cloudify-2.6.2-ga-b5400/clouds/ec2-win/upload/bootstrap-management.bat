@echo off
rem /*******************************************************************************
rem  * Copyright (c) 2012 GigaSpaces Technologies Ltd. All rights reserved
rem  *
rem  * Licensed under the Apache License, Version 2.0 (the "License");
rem  * you may not use this file except in compliance with the License.
rem  * You may obtain a copy of the License at
rem  *
rem  *       http://www.apache.org/licenses/LICENSE-2.0
rem  *
rem  * Unless required by applicable law or agreed to in writing, software
rem  * distributed under the License is distributed on an "AS IS" BASIS,
rem  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
rem  * See the License for the specific language governing permissions and
rem  * limitations under the License.
rem  *******************************************************************************/



rem Bootstrapping launcher for Windows based cloudify agent.
rem This file launches a power shell script that is responsible for downloading and setting up cloudify,
rem as well as creating the agent startup script which will be invoked asynchronously via the task scheduler.
rem Author: barakm
rem Since: 2.1


rem Setting the execution policy has to happen outside the powershell script.
echo Setting execution policy
rem output of this command is piped to null to prevent error messages generated by loading a profile for killing 
rem the remote powershell session. Powershell considers any writes to syserr as an error indication.
powershell Set-ExecutionPolicy Unrestricted > NUL 2> NUL

echo Loading Cloudify environment file
if exist %~dp0\cloudify_env.bat (
    call %~dp0\cloudify_env.bat
) else (
	if exist %~dp0\..\cloudify_env.bat (
		call %~dp0\..\cloudify_env.bat
	) else (
		echo Missing Cloudify environment file! Cannot proceed with bootstrapping!
		exit /B 105
	)
)

echo calling bootstrap script: %WORKING_HOME_DIRECTORY%\bootstrap-management.ps1 
powershell %WORKING_HOME_DIRECTORY%\bootstrap-management.ps1 

