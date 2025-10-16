@echo off
echo Testing the fixed app...

echo.
echo 1. Cleaning build...
flutter clean

echo.
echo 2. Getting dependencies...
flutter pub get

echo.
echo 3. Running analysis...
flutter analyze --no-fatal-infos

echo.
echo 4. Testing build...
flutter build apk --debug

echo.
echo Test completed!
pause

