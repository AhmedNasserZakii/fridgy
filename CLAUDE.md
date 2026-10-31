# Fridgy — Project Rules

Fridgy is a Flutter app (fridge / pantry tracking, expiry reminders, recipes). It is built **frontend-first, contract-first**: the app is built against local mock JSON, the mock JSON becomes the API design, the backend developer builds the server from that design, and finally the app is switched to the real API.

`tara_car/` is the **reference project**. Follow its patterns (see `tara_car/AGENTS.md`, reference slice: `tara_car/lib/feature/onboarding/`) unless this file says otherwise. Never import from `tara_car/`; copy and adapt.

## The Workflow (every feature goes through these phases)

| Phase | What happens | Output | Skill |
| --- | --- | --- | --- |
| 1. Build | Implement the feature end to end against mock JSON | Feature code + `assets/mocks/<feature>/*.json` | `/new-feature` |
| 2. Design | Turn the feature's mocks + models into the backend API design | `docs/api/<feature>.md` + row(s) in `docs/api/STATUS.md` | `/api-design` |
| 3. Hand-off | User gives `docs/api/` to the backend developer | STATUS → `handed-off` | — |
| 4. Connect | Backend is live: verify real responses against the design, flip to real API | STATUS → `live` | `/connect-backend` |

A feature is **not done** until phase 2 is complete. Never finish phase 1 without its mock JSON files and never change a mock without updating the API doc in the same change.

## The Golden Rule: mocks live at the HTTP layer

- Repo implementations are written **once, as final production code**: they call `ApiService` / Dio with real `WebConstant` paths and parse with real models.
- In mock mode, a Dio `MockInterceptor` (`lib/core/network_services/mock/`) answers requests from `assets/mocks/` instead of the network. Routes are registered in `lib/core/network_services/mock/mock_routes.dart`.
- Switching to the real backend = setting `WebConstant.useMocks = false` (or removing a route from the mock registry for per-endpoint switching). **No repo, cubit, model, or UI change should be needed.** If one is, the mock was wrong — fix the mock and the API doc too.
- Mock JSON files contain the **exact full response body**, including the envelope from `docs/api/README.md`. No shortcuts, no fields the backend won't send, no missing fields.
- Every endpoint needs at least: one success mock, and mocks for the realistic failures the UI handles (e.g. `422` validation, `404`, empty list).

## API Conventions

All shared rules (envelope, errors, auth, pagination, naming, dates) are in `docs/api/README.md`. That file is the source of truth for the backend developer and for models. Read it before writing any model or mock.

## Architecture (from tara_car, adapted to Fridgy's scaffold)

```text
lib/
|-- main.dart / my_app.dart          # Bootstrap only
|-- core/
|   |-- network_services/            # ApiService, WebConstant, ApiKeys, ServerFailure, interceptors
|   |   `-- mock/                    # MockInterceptor + mock_routes.dart (mock mode only)
|   |-- di/                          # GetIt service_locator.dart
|   |-- connection/                  # NetworkInfo
|   |-- local_storage/, theme/, shared_widgets/, constants/, helper/, utils/ (AppRoute) ...
`-- feature/<feature>/
    |-- domain/
    |   |-- entities/                # UI-agnostic data the screens use
    |   |-- params/                  # Immutable request inputs
    |   `-- repos/                   # <feature>_repo.dart (contract) + <feature>_repo_impl.dart
    |-- data/
    |   |-- models/                  # Request/response models (fromJson/toJson), map to entities
    |   `-- data_source/             # ONLY real local persistence/cache — never fake API data
    `-- presentation/
        |-- logic/                   # Cubit + state (Fridgy keeps state here, not in data/)
        |-- pages/                   # Route-level screens
        `-- widgets/                 # One widget per file (no private _Widget classes in pages)
assets/mocks/<feature>/              # Mock response bodies, one file per endpoint+scenario
docs/api/                            # API design handed to the backend developer
```

Layer rules (same as tara_car):
- Repos return `Either<ServerFailure, T>` (dartz); contract returns entities, not models.
- Cubits depend on the repo contract; no use-case layer, no `remote_data_source` layer by default.
- Widgets never touch Dio; cubits never touch Dio.
- Every repo method checks `NetworkInfo.isConnected` first (in mock mode `NetworkInfo` may report true).
- Endpoint paths go in `WebConstant`, JSON keys in `ApiKeys` — no hard-coded strings in repos/models.
- Route-specific cubits are provided from `AppRoute`, not inside pages.
- Errors: `ServerFailure` carries the message; only the presentation layer shows it, once.
- `catch (error, stackTrace)` + `printDebug` — never swallow.
- Model fields that the API may omit are nullable; never invent fallback values.

Stack (add packages when first needed, matching tara_car's versions): `flutter_bloc`, `equatable`, `dio`, `dartz`, `get_it`, `connectivity_plus`, `flutter_secure_storage`, `shared_preferences`, `easy_localization`, `skeletonizer`, `cached_network_image`. Don't add other packages without asking.

## Verification before saying a feature is done

1. `dart format lib/feature/<feature> lib/core`
2. `flutter analyze lib/feature/<feature> lib/core`
3. Every mock JSON is valid (`python3 -m json.tool <file>`), registered in `mock_routes.dart`, and its folder listed under `flutter: assets:` in `pubspec.yaml`.
4. `docs/api/<feature>.md` matches the mocks field-for-field and `docs/api/STATUS.md` is updated.
5. Report honestly what was run and what was not.
