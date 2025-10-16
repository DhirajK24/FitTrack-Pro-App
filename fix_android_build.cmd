@echo off
echo Fixing Android build configuration...

echo.
echo 1. Cleaning Flutter build...
flutter clean

echo.
echo 2. Getting dependencies...
flutter pub get

echo.
echo 3. Testing Android build...
flutter build apk --debug

echo.
echo Build test completed!
echo If successful, you can now run: flutter run --debug
pause

