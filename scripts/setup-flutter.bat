@echo off
setlocal
where flutter >nul 2>nul
if errorlevel 1 (
 echo ERROR: Flutter SDK not found. Install Flutter and Android Studio first.
 exit /b 1
)
cd /d "%~dp0\..\flutter_app"
rem Populate the Flutter-owned generated files (Gradle wrapper, Android launcher assets) without changing Dart UI.
call flutter create --platforms=android --project-name hunar_near_me --org pk.hunarnearme .
if errorlevel 1 exit /b 1
call flutter pub get
if errorlevel 1 exit /b 1
call flutter analyze
if errorlevel 1 exit /b 1
 echo Open flutter_app in Android Studio and run an Android emulator.
echo For emulator API: flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api
endlocal
