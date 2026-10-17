@echo off
cd /d "%~dp0\..\admin"
if not exist .env.local copy .env.example .env.local
if not exist node_modules (echo Installing admin packages... & call npm install)
call npm run dev
