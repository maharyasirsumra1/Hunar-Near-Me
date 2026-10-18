# Android Studio setup / precise validation scope

The Flutter/Dart UI widgets and layout parameters were not changed in this reorganization. `screens.dart` is now a Dart `part` library; related classes live in `lib/src/`.

## Required tools
Flutter stable with Dart >=3.5, Android Studio with Android SDK, Android SDK command-line tools, and JDK 17. The included Gradle/Android host files are a starter scaffold. Since the Flutter SDK, Android SDK and Gradle wrapper JAR are not available in the packaging environment, the first setup **must** run `flutter create` to complete native generated files.

## Windows steps
1. Extract the ZIP, open a terminal in `HunarNearMe`.
2. Run `scripts\setup-flutter.bat` to generate Flutter platform files, fetch dependencies and run Flutter analysis.
3. Open `flutter_app` in Android Studio (Flutter/Dart plugins installed); allow Gradle synchronization and SDK downloads.
4. Start backend database/API per the root README, then start an Android emulator.
5. Run `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api` from `flutter_app`.
6. Run `flutter test` and `flutter build apk --debug --dart-define=API_BASE_URL=http://10.0.2.2:4000/api` to confirm locally.

For a physical Android device replace 10.0.2.2 with the development computer's reachable LAN IP. Debug/profile-only HTTP permission is included; release requires HTTPS. Android permissions for location, internet and speech are declared.

## Important limits
- **No APK / emulator build was executed here** because Flutter, Android SDK and Gradle are unavailable. Compilation and device behavior must be tested on the development machine.
- The existing source contains **more than ten distinct navigable screen classes**. No visual screens or features were removed or merged, to preserve your requested original UI/behavior. A hard ten-screen cap would require explicit decisions about which flows to merge or remove.
- The uploaded source references external API, PostgreSQL and a Next.js admin panel. These services must be installed and running for the full app to function. OTP uses a development backend mode unless an SMS provider is connected.
- Proposal screenshots are *reference mockups*; the original source UI was not a pixel-identical recreation of those screenshots, and this packaging does not claim it is.
