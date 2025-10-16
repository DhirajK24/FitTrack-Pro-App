@echo off
echo Testing FitTrack Pro with minimal app...
cd /d "%~dp0"
echo Current directory: %CD%
echo.
echo Running minimal test app...
call flutter run lib/main_minimal_test.dart --web-port=8080 --web-hostname=0.0.0.0
pause
