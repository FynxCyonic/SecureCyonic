@echo on && chcp 65001 >nul && setlocal
set "version=Rev"
rem Feito por manu
:: SecureCyonic, Made by Luis Antonio

SET "securecyonic-main=%0" && SET "url=%2" && SET output_file=%~1
if "%url%"=="" (goto :main) else (goto :online)

:online
set "online=true" && SET url=%2
curl -o "%output_file%" "%url%"
IF %ERRORLEVEL% NEQ 0 (exit /b 1)

:UpdateCheck1
rem a

for /f "tokens=*" %%i in ('powershell -Command "Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/FynxCyonic/SecureCyonic/main/currentversion.txt' -UseBasicParsing | Select-Object -ExpandProperty Content"') do set latest_version=%%i

if "%latest_version%"=="" (
    goto :main
)

if not "%latest_version%"=="%version%" (
    curl -o %~f0.tmp https://raw.githubusercontent.com/FynxCyonic/SecureCyonic/main/sc.cmd > nul 2>&1
    set "updatepending=true" >nul
)

if "%updatepending%"=="" (
    set "updfile11=%temp%/batfile_github.bat"
    curl -o "%updfile11%" https://raw.githubusercontent.com/FynxCyonic/SecureCyonic/main/sc.cmd
    fc %temp%/batfile_github.bat %~0 > nul
    if errorlevel 1 (
        msg * /time:5 SecureCyonic version isn't valid! >nul
    )
    del /q %temp%/batfile_github.bat >nul
)

:main
set "windowid=SecureCyonic %random%"
set "archive=.%~n1___%~x1"
if "%~1"=="" exit /b >nul
if /i "%~x1" neq ".bat" if /i "%~x1" neq ".cmd" exit /b
for /f %%i in ("certutil.exe") do if not exist "%%~$path:i" (exit /b)

:: Little-endian obfuscation
>"temp.~b64" echo(//4mY2xzDQo=
certutil.exe -f -decode "temp.~b64" ".%~n1___%~x1" >nul
del "temp.~b64" > nul
copy ".%~n1___%~x1" /b + "%~1" /b >nul 
move ".%~n1___%~x1" "%TEMP%\"
start "%windowid%" cmd /c "%temp%\%archive%" && SET "url=" && SET "output_file="
if "%online%"=="true" (del "%~1")

:GetWindowPID
for /f "tokens=2 delims=," %%a in ('tasklist /v /fi "windowtitle eq %windowid%" /fo csv ^| find "%windowid%"') do (set "window_pid=%%~a")

:CheckWindow
if not defined window_pid (exit /b)

set "pids="
for /f "tokens=2 delims=," %%i in ('tasklist /v /fo csv ^| findstr /i /c:"%archive%" ^| findstr /v /i /c:"cmd"') do (set "pids=%%i %pids%")
for %%p in (%pids%) do (taskkill /PID %%p /F && msg * /time:1 Acesso negado >nul)

tasklist /v /fi "PID eq %window_pid%" | findstr /i /c:"%window_pid%" >nul
if errorlevel 1 (goto :clear) else (goto :CheckWindow)

:clear
tasklist /v /fi "windowtitle eq SecureCyonic *" | findstr /i "SecureCyonic" >nul
IF %ERRORLEVEL% NEQ 1 (goto skipupdate)

:preupdate



rem AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
:checkpoint242
if "%updatepending%"=="true" (
    del /q "%temp%\%archive%" >nul
    move /y "%~f0.tmp" "%~f0" > nul 2>&1
)

:skipupdate
del /q "%temp%\%archive%" >nul && set "Status=Protected by SecureCyonic, %ver%"
set "online=" && set "window_pid=" && set "pids=" && set "windowid=" && set "archive="
exit /b

:endLoop
pause >nul && goto :endLoop
