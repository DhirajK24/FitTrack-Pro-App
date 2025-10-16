@echo off
echo Cleaning Flutter and Gradle build caches...

REM Stop all Gradle daemons
echo.
echo Stopping Gradle daemons...
cd android
call gradlew.bat --stop
cd ..

REM Clean Flutter build
echo.
echo Cleaning Flutter build...
call flutter clean

REM Delete Gradle cache in project
echo.
echo Deleting Gradle caches...
if exist "%USERPROFILE%\.gradle\caches\" (
    rd /s /q "%USERPROFILE%\.gradle\caches"
)

REM Delete build directories
if exist "build\" rd /s /q "build\"
if exist "android\build\" rd /s /q "android\build\"
if exist "android\.gradle\" rd /s /q "android\.gradle\"

REM Delete crash logs
if exist "hs_err_pid*.log" del /q "hs_err_pid*.log"
if exist "android\hs_err_pid*.log" del /q "android\hs_err_pid*.log"

echo.
echo Cleanup complete!
echo.
echo Now run: flutter pub get
echo Then run: flutter build apk
echo.
pause

