# Hunar Near Me — Scope and Development Roadmap

## Implemented in starter source (integration and Android build must be tested locally)

**Customer**: registration, verified mobile OTP flow, login, area/city selection, GPS lookup, select category, list of approved workers, score/nearest sorting, short listing with worker name/photo/phone when authorized, area, average star rating and count, profile page with full verified job reviews, photo portfolio, send a booking request with optional budget, accept quote, chat by booking, review a completed job and in-app notifications.

**Worker**: registration, OTP, multiple service selection, city and area, geographic coverage radius, bio/experience, optional public phone consent, portfolio photo, selected service delivery modes, emergency availability, EasyPaisa/JazzCash transfer instructions, transaction ID and optional proof upload, approval status, jobs/quotes/chat, progress/completion updates, notifications, GPS update when approved and reply to reviews.

**Admin**: sign-in, role-gated dashboard, worker screening, suspend/reject/approve, optional verification badge, manual payment reference/check, private screenshot viewer, customer account suspension, service CRUD, image upload, ordering, location hierarchy CRUD, app copy and images, Urdu labels, fee & merchant account configuration, review moderation, in-app announcement publishing, bookings, audit events.

**Backend**: PostgreSQL/PostGIS, secure password hashes, expiring OTP, role authentication, basic rate limiting, client DTO validation, partial notification history, weighted review ranking, basic photo sanitization and image privacy.

## Planned for production / later sprints

### Critical before public launch
- Replace development OTP console with verified Pakistani SMS provider and abuse monitoring.
- Run physical Android test matrix and Flutter analyzer, add automated integration/E2E tests.
- Database migrations, backups/restore test, separate staging/production secrets and SSL/TLS deployment.
- Stronger admin protections: 2FA, role separation, session rotation, API request tracing and fraud alerts.
- Worker CNIC/identity verification with explicit consent, document protection, retention and audit controls.
- Proper privacy notice / user permissions for visible worker phone and precise location; dedicated delete account and image/deletion flows.
- Reliable review/payment dispute resolution and fraudulent review/report management.
- Confirm terms, fee disclosures, consumer law, and applicable Pakistani regulatory/tax obligations.

### High value next
- Google Maps embedded map and Google Routes driving distance/ETA (needs key and billing).
- AI Urdu/Roman Urdu voice intent recognition with confirmation and feedback.
- Firebase Cloud Messaging push when app is backgrounded.
- Service subcategories and guided problem questionnaire (AC cooling, wiring fault, water leak, etc).
- Better worker search rank: review Bayesian score + service relevance + distance + availability + completion/response rates.
- Worker schedule/availability and price range, booking availability calendar and job confirmation.
- Job-related media, audio notes and photo attachments with moderation and malware scanning.
- Direct EasyPaisa and JazzCash APIs for gateway processing (subject to merchant onboarding).
- Flexible pay-per-lead subscriptions, optional verification plans, admin-led refunds.

### Additional Pakistan-focused differentiation
- Urdu interface with audio help and low-literacy flow; Roman Urdu aliases for location names and skills.
- Cached low-bandwidth data mode and mobile image compression.
- Service providers who work at a shop vs home-visit, travel fees, emergency call-out fees.
- Multi-city coverage and multi-area worker preferences.
- Home & office saved addresses; accurate door-to-door ETA only once directions provider is connected.
- Worker strike/holiday hours and verification expiry.
- In-app referrals, hyperlocal neighborhood marketing, service package bundles.
- Customer support/ticket system, no-show policy, cancellation reasons and claims resolution.
- Job quote milestones, material purchase, warranty reminders and repeat-booking prompts.

## Why the starter is not a finished nationwide commercial product

It deliberately excludes provider secrets, production IAM settings, real merchant payments and official CNIC verification, which cannot responsibly be fabricated. It has an MVP UI/backend that can be expanded and tested locally, not a complete vetted nationwide service operation.
