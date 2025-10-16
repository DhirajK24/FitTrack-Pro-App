@echo off
echo Cleaning Flutter project...

REM Clean Flutter build
flutter clean

REM Remove Firebase build artifacts
if exist build rmdir /s /q build

REM Remove .dart_tool
if exist .dart_tool rmdir /s /q .dart_tool

REM Remove functions directory completely
if exist functions rmdir /s /q functions

echo Project cleaned successfully!
echo All Firebase references have been removed.

