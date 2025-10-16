@echo off
echo Starting FitTrack Pro App...
cd /d "%~dp0"
echo Current directory: %CD%
echo.
echo Cleaning Flutter project...
call flutter clean
echo.
echo Getting dependencies...
call flutter pub get
echo.
echo Running Flutter app on port 8080...
call flutter run --web-port=8080 --web-hostname=0.0.0.0
pause
