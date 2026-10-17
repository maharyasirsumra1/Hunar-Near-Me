# Manual Acceptance Scenarios

Run these after `npm install`, Docker DB startup and Flutter Android initialization. None of the end-to-end device cases could be executed in the artifact creation environment (no Flutter SDK, Docker or npm network access).

1. Verify admin login succeeds with initial credentials; customer credentials cannot open admin.
2. Admin edit branding labels, worker fee, EasyPaisa/JazzCash numbers; reopen app and confirm updated values.
3. Add new service in admin, verify it appears in Flutter grid; disable it and check removal.
4. Add Province > City > Area > Subarea. Select city and area on Flutter screen; assert invalid parent associations are rejected.
5. Register customer, inspect OTP in backend console (development only), verify code and login; reject invalid/expired code.
6. Register worker; select multiple services, city/area/GPS, save; worker should be PENDING and absent from public results.
7. Submit EasyPaisa fee reference with **no** screenshot; confirm admin can see it. Submit another with optional proof; confirm protected preview.
8. Try approving worker before the fee is VERIFIED (expect API rejection). Verify actual transaction outside platform, mark VERIFIED, then APPROVED.
9. Check worker with approved profile appears in customer directory for matching city/area/service and search radius.
10. Confirm directory displays rating average/count only, and full review content appears solely in profile detail.
11. Verify worker can opt out of public contact number; API should omit phone when opted out.
12. Compare `sort=best`, `rating`, `reviews`, `nearest`; check 5.0/one-review worker does not always outrank 4.8/hundreds-of-reviews worker in weighted mode.
13. Enable customer GPS and worker GPS; confirm geodesic kilometers appear and nearby results are filtered by radius. Assert it is straight-line, not driving distance.
14. Customer requests service with description and optional quote; worker sends quote, customer accepts, worker marks in progress/completed.
15. Verify only completed booking customer can submit a single review; second review rejected. Confirm aggregate updates if admin hides review.
16. Exchange booking chat messages; receive in-app notifications on the opposite account (refresh view).
17. Add announcement from admin, verify targeted customer/worker notification histories.
18. Confirm phone verification guards and role checks block unauthorized endpoints, image proof inaccessible without admin session, and oversized/corrupted image rejected.
19. Perform Flutter `flutter analyze`, `flutter test`, Android emulator smoke test, release APK build and multiple display sizes.
20. Test backend npm build, admin npm build, DB recovery, TLS, mobile permissions and security checks before commercial launch.

For production, create integration tests using an isolated PostGIS instance and a fake SMS adapter; no real payment transfers should be used as test traffic.
