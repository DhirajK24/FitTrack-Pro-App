@echo off
echo ========================================
echo FitTrack Pro - Web Only Mode
echo ========================================
echo.
echo This will run Flutter in web-only mode to avoid Java/Android issues
echo.

cd /d "%~dp0"
echo Current directory: %CD%
echo.

echo Step 1: Cleaning project...
call flutter clean
if %errorlevel% neq 0 (
    echo ERROR: Flutter clean failed
    pause
    exit /b 1
)

echo.
echo Step 2: Getting dependencies...
call flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Flutter pub get failed
    pause
    exit /b 1
)

echo.
echo Step 3: Running Flutter web app...
echo The app will be available at: http://localhost:8080
echo.
call flutter run -d web-server --web-port=8080 --web-hostname=0.0.0.0
if %errorlevel% neq 0 (
    echo.
    echo ERROR: Flutter run failed
    echo.
    echo Trying alternative method...
    call flutter run --web-port=8080 --web-hostname=0.0.0.0
)

echo.
echo If the app started successfully, open: http://localhost:8080
pause
