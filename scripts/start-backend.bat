@echo off
cd /d "%~dp0\..\backend"
if not exist .env (echo Missing backend\.env. Run PowerShell ..\scripts\setup-env.ps1 first. & exit /b 1)
if not exist node_modules (echo Installing backend packages... & call npm install)
echo Check backend\.env for JWT_SECRET and ADMIN_PASSWORD before proceeding.
call npm run dev
