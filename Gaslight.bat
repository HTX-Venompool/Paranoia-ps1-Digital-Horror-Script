@echo off
if exist "%~dp0Paranoia.ps1" (powershell.exe -WindowStyle Hidden -ExecutionPolicy Bypass -File "%~dp0Paranoia.ps1") else (echo. && echo ERROR: %~dp0Paranoia.ps1 Not Found && echo. && pause)
exit