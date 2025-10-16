@echo off
echo Removing Firebase files...
if exist functions rmdir /s /q functions
if exist .firebaserc del .firebaserc
if exist firebase.json del firebase.json
if exist firestore.rules del firestore.rules
if exist firestore.indexes.json del firestore.indexes.json
if exist storage.rules del storage.rules
if exist FIREBASE_SETUP.md del FIREBASE_SETUP.md
echo Firebase files removed successfully!

