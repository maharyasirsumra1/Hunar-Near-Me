@echo off
cd /d "%~dp0\..\backend"
call npm test
if errorlevel 1 exit /b 1
cd ..\admin
if exist node_modules call npm run build
cd ..\flutter_app
where flutter >nul 2>nul
if not errorlevel 1 (call flutter analyze)
