@echo off
echo Testing FitTrack Pro Authentication System...
echo.

echo 1. Cleaning previous build...
flutter clean

echo.
echo 2. Getting dependencies...
flutter pub get

echo.
echo 3. Running app in debug mode...
echo    - The app should start without Firebase errors
echo    - You can test sign up and sign in functionality
echo    - All data will be stored locally using Hive
echo.

flutter run --debug

echo.
echo Test completed!
pause

