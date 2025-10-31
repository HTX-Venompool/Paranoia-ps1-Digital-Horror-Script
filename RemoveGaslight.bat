@echo off
taskkill /F /FI "WindowTitle eq Wake Up" /T
echo.
if exist "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\Gaslight.bat" (del /F /Q "%appdata%\Microsoft\Windows\Start Menu\Programs\Startup\Gaslight.bat")
echo.
if exist "%~dp0FixMouse.ps1" (powershell.exe -ExecutionPolicy Bypass -File "%~dp0FixMouse.ps1" && echo Mouse Restored To Default) else (echo. && echo ERROR: %~dp0FixMouse.ps1 Not Found)
echo.
pause
exit