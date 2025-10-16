@echo off
echo Starting complete Firebase cleanup...

REM Remove Firebase configuration files
if exist .firebaserc del .firebaserc
if exist firebase.json del firebase.json
if exist firestore.rules del firestore.rules
if exist firestore.indexes.json del firestore.indexes.json
if exist storage.rules del storage.rules
if exist FIREBASE_SETUP.md del FIREBASE_SETUP.md

REM Remove functions directory
if exist functions rmdir /s /q functions

REM Remove Firebase code files
if exist lib\firebase_options.dart del lib\firebase_options.dart
if exist lib\services\firebase_service.dart del lib\services\firebase_service.dart
if exist lib\services\firebase_service_simple.dart del lib\services\firebase_service_simple.dart
if exist lib\services\sync_service.dart del lib\services\sync_service.dart
if exist lib\providers\firebase_auth_provider.dart del lib\providers\firebase_auth_provider.dart
if exist lib\providers\auth_provider.dart del lib\providers\auth_provider.dart
if exist lib\screens\auth\google_auth_test_screen.dart del lib\screens\auth\google_auth_test_screen.dart
if exist lib\main_simple.dart del lib\main_simple.dart
if exist lib\main_backup.dart del lib\main_backup.dart

REM Remove temporary files
if exist remove_firebase.cmd del remove_firebase.cmd
if exist complete_firebase_cleanup.cmd del complete_firebase_cleanup.cmd

echo Firebase cleanup completed successfully!
echo All Firebase files and references have been removed.
echo Your app is now completely Firebase-free!

