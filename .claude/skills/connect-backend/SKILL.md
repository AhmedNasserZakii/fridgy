---
name: connect-backend
description: Switch a Fridgy feature (or the whole app) from mock JSON to the real backend once the backend developer delivers it — verify real responses against docs/api, report mismatches, then disable the mocks. Use when the user says the backend/server/API is ready, gives a base URL, or asks to connect/integrate/go live.
---

# connect-backend — Phase 4 (Mocks → real API)

Goal: the app talks to the real server with **only** config changes. Any code change needed means the backend and the contract disagree — surface it, don't hide it.

## Step 1 — Get what you need from the user

- Base URL (dev and prod), and which features/endpoints are live.
- A test account (if auth is needed). Never write credentials into the repo — use env vars / Postman environment (Postman CLI is available; see `postman:variables` skill for where secrets go).

## Step 2 — Verify the real API against the contract (before touching the app)

For each endpoint marked `handed-off` in `docs/api/STATUS.md` and claimed live:
1. Call it for real (curl or Postman CLI collection built from `docs/api/<feature>.md`), success and the documented error cases.
2. Compare the real body to the mock / doc: envelope, every key name, types, nullability, date format, status codes, error shape.
3. Produce a mismatch table: `endpoint | field | doc says | server returns | impact on app`.

Mismatch decision (ask the user — it's their call):
- **Backend fixes it** (preferred — contract was agreed) → status `mismatch`, notes, stop for that endpoint.
- **App adapts** → update model + mock + `docs/api/<feature>.md` together, so all three still agree.

## Step 3 — Switch

- Set `WebConstant.baseUrl` / `baseUrlDev`.
- Per endpoint: remove (or comment out) its routes from `mock_routes.dart` — the interceptor falls through to the network for unmatched routes. When **all** endpoints are live, set `WebConstant.useMocks = false`.
- Make sure release builds can never use mocks (e.g. `useMocks` is `false` when `kReleaseMode`).
- Keep `assets/mocks/` for tests/dev, but remove `assets/mocks/` from `pubspec.yaml` assets for the release build if bundle size matters (ask the user).

## Step 4 — Verify in the app

- `flutter analyze`, run the app against the real server, walk each switched flow incl. one error case.
- Check auth: login stores token securely, `401` → refresh flow works, logout.
- Update `docs/api/STATUS.md` → `live` only for endpoints actually verified. Report exactly what was tested vs. not.

## Pre-launch checklist (when everything is `live`)

- [ ] No route left in `mock_routes.dart` / `useMocks` false in release
- [ ] Prod base URL set, no dev URLs or debug logging (`LogInterceptor`) in release
- [ ] No secrets in the repo
- [ ] Every row in `STATUS.md` is `live`
- [ ] `flutter build apk --release` / `flutter build ipa` succeed
