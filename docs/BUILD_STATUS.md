# Build and preservation status (reorganized bundle)

- Original Dart widget bodies: unchanged; split verbatim into `lib/src/` Dart part files.
- Original Next.js admin, NestJS API, and data models: unchanged.
- Android Gradle/manifest/Kotlin host scaffold: added.
- Missing `assets/images` declaration: removed (folder absent and no code uses bundled assets).
- Flutter/Android build test: **NOT RUN**, required SDK tools unavailable in packaging environment.
- Full services smoke/integration testing: **NOT RUN**, dependency installation and database unavailable.
- The source contains more than 10 screen classes; preserved rather than deleting behavior. Proposal UI screenshots are visual references, not a pixel-perfect match guarantee.
- Complete first-time Android setup by running `scripts/setup-flutter.bat` on a Flutter-enabled Windows computer.
