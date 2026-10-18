# Hunar Near Me — Android App + Admin Panel

**Release type:** reorganized Android Studio source bundle / functional MVP foundation (NOT a production-certified or independently device-tested release).

One Flutter app with **Customer** and **Worker** roles, a separate **Next.js 15** web administration interface, **NestJS 10** API, and **PostgreSQL 16 + PostGIS** for location calculations.

## What is included

| Component | Folder | Description |
|---|---|---|
| Android Flutter app | `flutter_app/` | Welcome, dual registration, OTP, login, service grid, locations, worker onboarding/fee submission, worker/customer dashboards, directory, profiles, booking negotiation, chat, reviews, notifications |
| Admin panel | `admin/` | Secure admin sign-in, worker approval/suspension, transaction verification, customers, services, locations, label/image/fee settings, moderation, notices, bookings and audit history |
| Backend | `backend/` | NestJS role-aware API, DTO validation, password hashing, JWT, OTP, private payment receipts, WebP upload conversion, booking/review guards, PostGIS geo-distance |
| PostGIS database | `docker-compose.yml` | Local PostgreSQL + PostGIS development service |
| Setup | `scripts/` | Windows helper scripts for generating secrets, starting services and initializing the Flutter Android host |
| Documentation | `docs/` | Features, security, manual testing, API/architecture and operational limitations |

## Minimum Windows development requirements

- **Node.js 22 LTS** and npm (NestJS/Next.js).
- **Docker Desktop** with Docker Compose (PostgreSQL/PostGIS). Start Docker Desktop first.
- **Flutter stable SDK** added to PATH, plus **Android Studio**, Android SDK, Android emulator (for Android build/run).
- Visual Studio Code with Dart + Flutter extensions.
- Internet connection *on your computer* for first-time `npm install`, `flutter pub get` and Android SDK setup.

> Without Flutter and Android SDK installed, a Windows laptop cannot compile an Android APK. These are source files, not a ready-built APK. The bundle intentionally excludes `node_modules`, Flutter engine, Android SDK, and build artifacts, which must be downloaded for your computer/OS.

## Quick start in VS Code (Windows)

**1.** Extract ZIP to e.g. `C:\Projects\HunarNearMe`. Open the `HunarNearMe` folder in VS Code.

**2.** Open PowerShell at the extracted folder:

```powershell
powershell -ExecutionPolicy Bypass -File .\scripts\setup-env.ps1
```

Choose a Pakistani admin number and a unique 12+ character password. The script generates a cryptographically random JWT signing key. Keep `backend/.env` private.

**3.** Start PostgreSQL using Docker Desktop, then:

```powershell
docker compose up -d db
```

Wait for the database to become healthy (`docker compose ps`).

**4.** Open a second terminal and start the API:

```powershell
cd backend
npm install
npm run dev
```

The API should respond at **http://localhost:4000/api/public/services**. On the first run it creates tables in development mode, seeds the 12 service types and sample Pakistani geography, and creates the initial administrator from `.env`.

**5.** Open a third terminal:

```powershell
cd admin
npm install
npm run dev
```

Open **http://localhost:3000**. Log in with your admin number/password from step 2. Open *App Content & Branding* and set the EasyPaisa / JazzCash receiving details and the worker fee.

**6.** Back in the project root, initialize the standard Android Gradle/manifest files (requires Flutter SDK):

```powershell
.\scripts\setup-flutter.bat
cd flutter_app
flutter pub get
flutter doctor
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:4000/api
```

`10.0.2.2` is the Android **emulator** alias for your laptop. For a physical Android phone on the same Wi-Fi, replace `10.0.2.2` with the laptop's Wi-Fi IP address; allow port 4000 through your dev firewall only as necessary. The API binds to 0.0.0.0 by default. For a live deployed server, use **HTTPS** and pass its URL with `--dart-define=API_BASE_URL=https://your-domain/api`.

Android project starter files are included. Run `scripts/setup-flutter.bat` once to generate the missing Flutter-owned Gradle wrapper and launcher artifacts, then analyze/build locally. See `docs/ANDROID_STUDIO_SETUP.md`.

**7.** Build an APK *after* Flutter/Android SDK are configured and tests pass:

```powershell
flutter build apk --release --dart-define=API_BASE_URL=https://your-real-secure-api.example/api
```

Release builds will not permit the local insecure HTTP connection; use a trusted TLS backend. Release signing, package name and Play Console account setup are separate production tasks.

## Initial admin account

There is **no shared demo admin password**. Administrator credentials come from `backend/.env` created by `setup-env.ps1` and are seeded once (first run). Change existing admin passwords by an approved credential rotation process, not by changing `.env` after account creation.

## Testing OTP without SMS gateway (LOCAL DEV ONLY)

In development when `SMS_API_URL` is unset, the API writes the 6-digit OTP to its **backend terminal**. Register a customer/worker in the app and read the code there. In production, the API requires a real SMS delivery integration (`SMS_API_URL`, `SMS_API_KEY`) and you must test the provider payload for your chosen Pakistani SMS vendor. OTP expires in 5 minutes; resend is throttled, and verification attempts are limited.

## Admin approval + fee workflow

1. Worker enters name, phone, password → verifies via OTP.
2. Worker selects one or more categories, city, area and GPS coordinates.
3. Admin defines the registration fee in **PKR** (`0` means no fee) and official EasyPaisa/JazzCash receiving details.
4. Worker transfers money **outside the app** and submits the transaction reference; an image screenshot may optionally be attached.
5. Admin checks payment in the real receiving account, marks it VERIFIED/REJECTED and reviews profile.
6. API blocks worker approval if an enabled fee is not verified, worker GPS/city/skills are missing, or phone is unverified.
7. Approved worker becomes searchable; a separately verified badge must not be granted without real verification. Worker can choose whether their phone appears publicly.

**IMPORTANT:** This is manual transfer and admin reconciliation, **not direct EasyPaisa/JazzCash gateway payment**. Automated debit, payment webhooks, refunds and escrow require agreements and live merchant credentials from the respective providers. Do not claim payment success based solely on uploaded screenshots.

## Distance calculation

- Customer optionally shares live device GPS latitude/longitude; worker saves GPS coordinates and may refresh them when approved.
- `GET /api/public/workers?lat=...&lng=...&radiusKm=...` calculates **geodesic straight-line distance in kilometers** using PostGIS `ST_DistanceSphere`. Ranking can prioritize review-weighted score, number of reviews, highest star rating or nearest distance.
- Province > City > Area > Sub-area hierarchy is admin-managed; starter dataset covers selected Pakistani cities/areas only. Expand from Admin > Pakistan Locations.
- Distance is **not road travel distance/ETA**. Routing/traffic needs Google Maps Routes API or another provider, billing setup, credentials and permission-aware location policies.
- GPS can be inaccurate indoors, and distances update when coordinates and directory results refresh. This is not continuous background tracking.
- Precise worker coordinates are used server-side but omitted from public profile responses. Worker may opt to show their phone.

## Images and text

- Main language dictionaries (`en`,`ur`), service labels, Urdu names, category icons, display order, brand name, fee amount, merchant numbers, and app hero/logo images are managed from Admin.
- Uploaded files are decoded and converted into WebP with bounded size; fee proof screenshots are stored in a **private** folder accessed only through the admin endpoint.
- The Flutter `AppText` widget supports admin overrides using the English source phrase as a dictionary key. The seeded label catalog exposes most static screen strings in the admin editor; runtime/generated strings and a few platform labels still require engineering for full translation/template support.
- Admin changes become visible on next app content refresh / app restart, not always instantly to every open device.

## Security included and outstanding

See `docs/SECURITY_AND_RELEASE.md`. Included: hashed passwords, OTP with rate limits, JWT verification, server-side roles, DTO field validation, private fee screenshots, safe WebP conversion, upload limits, restricted admin proxy cookies, reviews restricted to completed bookings, audit trail, CORS, helmet, strict prod secret checks, and a review/verification workflow.

**Not complete yet:** penetration testing, SMS provider certification, refresh token rotation, advanced anti-fraud/ID verification, permanent data deletion policy, product/legal review of registration fees, mobile background push notification setup, database migrations/backup/restore, cloud object storage + malware screening, public scaling, comprehensive E2E tests, formal threat modeling and Play Store production compliance.

Never deploy this starter publicly as if it were production-certified. It is for iterative development and a local MVP trial.

## Local test scripts

```powershell
node backend/tests/check-contracts.cjs
cd backend && npm run build
cd ..\admin && npm run build
cd ..\flutter_app && flutter analyze && flutter test
```

A larger manual scenario checklist is in `docs/TESTING.md`.
