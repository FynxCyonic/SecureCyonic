:: Dearly, developer of SecureCyonic
:: Copyright [2024] [Luis Antonio]

:: Licensed under the Apache License, Version 2.0 (the "License");
:: you may not use this file except in compliance with the License.
:: You may obtain a copy of the License at
::
::    http://www.apache.org/licenses/LICENSE-2.0
::
:: Unless required by applicable law or agreed to in writing, software
:: distributed under the License is distributed on an "AS IS" BASIS,
:: WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
:: See the License for the specific language governing permissions and
:: limitations under the License.

@echo on && chcp 65001 >nul && setlocal
set "version=1.1beta"

SET "securecyonic-main=%~f0"
SET "url=%2" && SET output_file=%~1 
if "%url%"=="" (goto :main) else (goto :online)

:online
set "online=true" && SET url=%2

:updateCheck
curl -o currentversion.txt https://raw.githubusercontent.com/FynxCyonic/SecureCyonic/main/currentversion.txt > nul 2>&1
set /p latest_version=<currentversion.txt && del currentversion.txt
if not "%latest_version%"=="%version%" (
        curl -o sc.cmd https://raw.githubusercontent.com/FynxCyonic/SecureCyonic/main/sc.cmd
)

:filedownload
curl -o "%output_file%" "%url%"
IF %ERRORLEVEL% NEQ 0 (
    echo Error: Failed to download file from %url%
    exit /b 1
)

goto :main

:main
set "windowid=SecureCyonic %random%"
set "archive=.%~n1___%~x1"
if "%~1"=="" exit /b >nul
if /i "%~x1" neq ".bat" if /i "%~x1" neq ".cmd" exit /b
for /f %%i in ("certutil.exe") do if not exist "%%~$path:i" (
  echo CertUtil.exe not found.
  exit /b
)

>"temp.~b64" echo(//4mY2xzDQo=
certutil.exe -f -decode "temp.~b64" ".%~n1___%~x1" >nul
del "temp.~b64" >nul
copy ".%~n1___%~x1" /b + "%~1" /b >nul
move ".%~n1___%~x1" "%TEMP%\"

start "%windowid%" cmd /c "%temp%\%archive%"

SET "url=" && SET "output_file="
if "%online%"=="true" (del "%~1")


:GetWindowPID
for /f "tokens=2 delims=," %%a in ('tasklist /v /fi "windowtitle eq %windowid%" /fo csv ^| find "%windowid%"') do (
    set "window_pid=%%~a"
)

:CheckWindow
if not defined window_pid (
    exit /b
)
set "pids="

for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv ^| findstr /i /c:"%archive%" ^| findstr /v /i /c:"cmd"') do (
    set "pids=%%i %pids%"
)

for %%p in (%pids%) do (
    taskkill /PID %%p /F
    msg * /time:1 Acesso negado >nul
)
set "pids="


tasklist /v /fi "PID eq %window_pid%" | findstr /i /c:"%window_pid%" >nul
if errorlevel 1 (
    goto :clear
) else (
    goto :CheckWindow
)

:clear

del "%temp%\%archive%" && set "Status=Protected by SecureCyonic, %ver%"
set "online=" && set "window_pid=" && set "pids=" && set "windowid=" && set "archive="
exit /b

:endLoop
pause >nul && goto :endLoop
