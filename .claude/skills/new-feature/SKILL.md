---
name: new-feature
description: Build a new Fridgy feature end to end (domain, data, cubit, UI) against local mock JSON at the HTTP layer, so the repo code is already production-ready. Use when the user asks to add/build/implement a feature, screen flow, or endpoint in Fridgy before the backend exists.
---

# new-feature — Phase 1 (Build against mocks)

Read `CLAUDE.md` and `docs/api/README.md` first. Use `tara_car/lib/feature/onboarding/` and `tara_car/AGENTS.md` as the code-pattern reference.

## Step 0 — Agree on the feature (ask, don't guess)

Before writing code, confirm with the user:
1. Screens and user flow (what the user taps, what they see).
2. Data each screen shows and each form sends.
3. States: loading, empty, error, success. Which errors does the UI care about (validation, not found, …)?
4. Auth required?

Then propose the endpoints in a short table (`METHOD path — purpose`) following `docs/api/README.md` naming. Wait for the user's OK.

## Step 1 — Core mock infrastructure (only if missing)

If `lib/core/network_services/mock/` does not exist yet, create it once:

- `mock_route.dart` — `MockRoute { method, path (supports :param segments), asset, statusCode = 200, delay = 400ms }`.
- `mock_routes.dart` — `abstract class MockRoutes { static const List<MockRoute> all = [...]; }` grouped by feature with comments. Allow a per-route `scenario` override so a developer can switch one endpoint to its error mock while testing.
- `mock_interceptor.dart` — Dio `Interceptor`; in `onRequest`, if `ApiModeController.useMocks` and a route matches method + path, wait `delay`, load the asset with `rootBundle.loadString`, `jsonDecode`, and:
  - `statusCode` 2xx → `handler.resolve(Response(...))`
  - otherwise → `handler.reject(DioException.badResponse(...))` so `ServerFailure.fromDioException` handles it exactly like a real server error.
  - no matching route → `handler.next(options)` (falls through to real network).
- `ApiModeController` (runtime local/live switch, default local; toggled on the Welcome and More screens).
- Add the interceptor in `ApiService.client()` **before** the token/log interceptors.
- `NetworkInfo`: in mock mode it may return `true` so the app works offline.

If `ApiService`, `WebConstant`, `ApiKeys`, `ServerFailure`, `NetworkInfo`, `service_locator.dart`, `AppRoute`, `printDebug` are missing, port them from `tara_car/lib/core/` (rename package imports to `fridgy`) and adapt `ServerFailure` message extraction to Fridgy's error envelope (`message` + `errors` map).

## Step 2 — Mock JSON (the contract)

For each endpoint create files in `assets/mocks/<feature>/`:

```
<method>_<resource>[_<scenario>].json
get_items.json
get_items_empty.json
post_item.json
post_item_422.json
get_item_404.json
```

Rules:
- Full response body including envelope (`success`, `message`, `data`, `meta` / `errors`).
- Realistic values (real food names, real dates, real UUID-looking ids, `null` where real data would be null). At least 3–5 items in lists.
- `snake_case` keys, ISO dates, every key present.
- Register each file in `mock_routes.dart`; add `- assets/mocks/<feature>/` to `pubspec.yaml` assets.
- Validate: `python3 -m json.tool <file> > /dev/null`.

## Step 3 — Code (tara_car onboarding pattern)

1. `WebConstant` paths + `ApiKeys` keys.
2. `domain/entities/`, `domain/params/` (only when needed).
3. `domain/repos/<feature>_repo.dart` (contract, `Either<ServerFailure, T>`) + `<feature>_repo_impl.dart` — **real Dio calls** via `apiService.client(requireAuth: …)`, network guard, `try/catch (e, stackTrace)` + `printDebug`.
4. `data/models/` — `fromJson` / `toJson` using `ApiKeys`, nullable where the doc allows null, `toEntity()`.
5. `presentation/logic/<feature>_cubit.dart` + `<feature>_state.dart` (Equatable, `isClosed` guards).
6. Register in `core/di/service_locator.dart`; provide cubit from `AppRoute`.
7. `presentation/pages/` + `presentation/widgets/` — one widget per file, loading (Skeletonizer reusing the content widget), empty, error (single feedback path), success. Disable submit while loading.

Never put fake data in `data/data_source/` or in the repo — the only fake data is in `assets/mocks/`.

## Step 4 — Verify and hand over to Phase 2

- `dart format` + `flutter analyze` on changed paths.
- Run the app if possible and walk the flow; switch the scenario to an error mock once to check the error UI.
- Add rows to `docs/api/STATUS.md` with status `mocked`.
- Tell the user what was built, list the mock files, and say: **next step is `/api-design <feature>`** (or run it right away if the user wants).
