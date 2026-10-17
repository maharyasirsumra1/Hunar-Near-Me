@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
 echo ERROR: Flutter SDK not found. Install Flutter + Android Studio, then reopen terminal.
 echo Guide: https://docs.flutter.dev/get-started/install/windows/mobile
 exit /b 1
)
cd /d "%~dp0\..\flutter_app"
echo Generating standard Flutter Android host project...
call flutter create --platforms=android --project-name hunar_near_me --org pk.hunarnearme .
if errorlevel 1 exit /b 1
powershell -NoProfile -ExecutionPolicy Bypass -File "..\scripts\configure-android.ps1"
echo.
echo Flutter project ready. Start Android emulator, then:
echo flutter pub get
echo flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api
endlocal
