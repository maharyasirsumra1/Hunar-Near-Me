# Security / Deployment Checklist

## Baseline protection in code

- Passwords hashed with bcrypt (cost 12), unique normalized +92 mobile numbers.
- OTP hashed before database storage; six digits, five-minute expiry, five failed attempts max; resend throttling and route-level limits.
- Password-protected sessions via signed JWT; every authenticated request checks active account/role/phone verification against DB.
- Admin API uses role check. Next.js server proxy stores admin JWT in HTTP-only SameSite=Strict cookie and checks Origin on state-changing requests.
- Standard request validation (`class-validator`), CORS allowlist, Helmet security headers and request throttling.
- Reviews require a completed booking and are unique per booking; moderation updates rating aggregates.
- Workers require administrator approval and (if fee > 0) a VERIFIED payment reference.
- Uploaded images decoded by Sharp and re-encoded to WebP, resized and capped in bytes/pixels.
- Payment screenshots kept outside the public media folder and returned only via authenticated admin route.
- Worker exact GPS coordinates are kept server-side; public worker response includes coarse city/area and computed rounded distance instead.
- Admin status/payment/review/content changes produce audit logs.

## Required before real users / money

- Do not run PostgreSQL with demo credentials; disable public database access and rotate secrets.
- Deploy NestJS behind HTTPS reverse proxy and set `NODE_ENV=production`. Configure a real SMS provider and turn off any dev console codes.
- Use a trusted domain and update `PUBLIC_API_URL`, `CORS_ORIGINS`, `BACKEND_INTERNAL_URL`, upload storage and Flutter API endpoint.
- Create and test production DB migrations rather than `synchronize`; `synchronize` is deliberately disabled in production and migrations are not provided in this starter.
- Replace local image storage with access-controlled cloud object storage; implement signed URLs, malware scanning, upload ownership and cleanup.
- Introduce 2FA/admin roles, access-token rotation and server-side revocation; monitor and alert on repeated failed logins.
- Validate merchant references with actual provider settlement evidence; enforce idempotency, reconciliation and refund policies.
- Do not label workers “verified” until consent-based ID/background verification process exists.
- Implement worker/customer consent UI, privacy policy, precise location retention policies, account export/deletion and payment-data retention.
- Audit changes to profile verification, image ownership, review abuse, race conditions, and transactional consistency.
- Implement abuse reports, dispute management, moderation roles and operational logs.
- Review local laws, platform fees and tax/merchant obligations for Pakistan.
- Review Flutter and all npm package versions with `npm audit` and current security advisories, then update dependencies.
- Complete load testing, API contract tests, device tests and backup/restore drills before deployment.

## SMS provider integration interface

`SMS_API_URL` is a generic POST endpoint receiving `{"phone":"+923...","message":"..."}` with Bearer `SMS_API_KEY`. Different providers require different field names, signatures, sending IDs and templates. Supply an adapter tested against your merchant/SMS provider before production.

## Current limitations

The source is intentionally not represented as fully secure or penetration-tested. Booking status transitions and review aggregates are not transactional across concurrent calls, live GPS updates only occur on explicit worker/customer actions, and in-app notifications are not Firebase background push. These must be addressed for scale.
