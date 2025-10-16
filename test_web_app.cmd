@echo off
echo ========================================
echo FitTrack Pro - Web Test App
echo ========================================
echo.
echo This is a simplified version that bypasses all complex dependencies
echo and Java/Android issues by running web-only mode.
echo.

cd /d "%~dp0"
echo Current directory: %CD%
echo.

echo Running Flutter web test app...
echo The app will be available at: http://localhost:8080
echo.

call flutter run lib/main_web_test.dart -d web-server --web-port=8080 --web-hostname=0.0.0.0

echo.
echo If successful, open: http://localhost:8080
pause
