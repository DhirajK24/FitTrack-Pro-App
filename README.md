# FitTrack-Pro-App

FitTrack-Pro is a Flutter-based fitness tracking application that helps users log workouts, track progress, and (optionally) sync data with Firebase.

This repository contains the main app under `FitTrack_pro_Final_1_2/fit_final_1/` and several helper scripts and notes for building and troubleshooting the Android/iOS/web builds.

## Table of contents
- About
- Key features
- Repository layout
- Prerequisites
- Quick start
- Common scripts
- Configuration notes
- Troubleshooting
- Contributing
- License

## About

FitTrack-Pro aims to provide a simple, extensible fitness tracker with workout logging, progress visualization, and optional cloud sync. The codebase is written with Flutter and targets Android, iOS, and web.

## Key features
- Workout and activity logging
- Progress charts and statistics
- User authentication (optional, Firebase)
- Cross-platform: Android, iOS and Web (Flutter)

## Repository layout

Top-level important items:

- `FitTrack_pro_Final_1_2/fit_final_1/` — main Flutter app. Explore this folder for the app source, assets and platform directories.
	- `pubspec.yaml` — Flutter/Dart dependencies and assets
	- `android/` — Android platform project and Gradle settings
	- `assets/` — images, icons, fonts and animations used by the app
	- `build/` — generated build artifacts (can be removed with `flutter clean`)

Helper and documentation files in the app folder:

- `ANDROID_BUILD_FIX.md` — Android build fixes and notes
- `CORE_FEATURES_README.md` — core feature descriptions
- Scripts: `run_app.bat`, `run_web_only.cmd`, `clean_build.bat`, etc. (Windows/CI helpers)

## Prerequisites

- Flutter SDK (stable channel recommended)
- Dart SDK (bundled with Flutter)
- Android SDK & Android Studio (if building for Android)
- Optional: Xcode & iOS toolchain (macOS only) for iOS builds
- Optional: Firebase CLI and a configured Firebase project if you intend to enable cloud features

## Quick start

1. Open the workspace in VS Code or your IDE of choice.
2. Change directory to the Flutter app folder:

```bash
cd FitTrack_pro_Final_1_2/fit_final_1
```

3. Get dependencies:

```bash
flutter pub get
```

4. Run the app on an available device or emulator:

```bash
# Run on default connected device/emulator
flutter run

# Run on Chrome (web)
flutter run -d chrome
```

5. To create a release build for Android:

```bash
flutter build apk --release
```

## Common scripts

- `run_app.bat` / `run_web_only.cmd` — convenience scripts in the app folder for quick runs on Windows.
- `clean_build.bat` / `flutter clean` — remove build artifacts.
- `remove_firebase.cmd` / `complete_firebase_cleanup.cmd` — helper scripts related to removing Firebase integration (see the app folder for details).

## Configuration notes

- Android: if you encounter Gradle or dependency issues, see `FitTrack_pro_Final_1_2/fit_final_1/ANDROID_BUILD_FIX.md` for platform-specific fixes.
- Firebase: enable and configure services using `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) following Firebase docs. The project includes helper scripts to add/remove Firebase configuration.

## Troubleshooting

- Common steps:

```bash
flutter clean
flutter pub get
flutter pub upgrade
```

- If Android builds fail due to Gradle or Kotlin versions, open `FitTrack_pro_Final_1_2/fit_final_1/android/` and follow the recommendations in `ANDROID_BUILD_FIX.md`.
- Check `build/reports/problems` in the Android folder for more detailed Gradle reports.

## Contributing

- Follow the existing code patterns. Create feature branches and submit pull requests against `main`.
- Add tests where appropriate and document any new configuration steps in this README or the app subfolder README.

## License

See the project root for licensing information. If a license file is not present, add one (for example, `LICENSE` or `LICENSE.md`) before publishing.

---

If you want, I can:

- Add badges (build / Flutter version / license)
- Create a short `CONTRIBUTING.md` and `ISSUE_TEMPLATE.md`
- Update the `FitTrack_pro_Final_1_2/fit_final_1/README.md` with app-specific run instructions

Tell me which of the above you'd like next.
