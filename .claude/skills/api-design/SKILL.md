---
name: api-design
description: Turn a finished Fridgy feature's mock JSON, models, and params into the backend API design document (docs/api/<feature>.md) for the backend developer, and update docs/api/STATUS.md. Use after /new-feature, when the user asks for the API design/contract/doc for a feature, or to re-sync docs after a mock changed.
---

# api-design — Phase 2 (Mocks → backend API doc)

The doc is what the backend developer builds from. It must describe **exactly** what the app already parses — derived from the code, not from memory.

## Inputs to read (all of them)

1. `docs/api/README.md` — shared conventions (don't repeat them in the feature doc, link to them).
2. `lib/core/network_services/mock/mock_routes.dart` — the feature's routes (method, path, status per scenario).
3. Every file in `assets/mocks/<feature>/`.
4. `lib/feature/<feature>/data/models/` — which keys are parsed, which are nullable, types.
5. `lib/feature/<feature>/domain/params/` + request models' `toJson` — the request bodies / query params the app sends.
6. `lib/core/network_services/web_constant.dart` — paths.
7. The repo impl — `requireAuth`, HTTP method, query params.

## Write `docs/api/<feature>.md`

Start from `docs/api/_TEMPLATE.md`. For each endpoint:
- Method + path, when the app calls it, auth.
- Path / query params table.
- Request body JSON example (from `toJson`) + field table with type, required, validation rules (ask the user for rules you can't infer, e.g. max length).
- Success response JSON — copy from the success mock.
- Error table + one JSON example per error scenario mock.
- `Data objects` section: one table per object (type, nullable, description) — reuse objects across endpoints instead of re-describing them.
- List the mock files at the bottom.

Write it for a backend developer who has never seen the app: plain language, no Dart.

## Consistency check (must pass before marking `designed`)

Cross-check and report every mismatch to the user instead of silently fixing:
- Every key parsed in models exists in the success mock, and vice versa.
- Nullable in model ⇔ `Nullable: yes` in doc ⇔ mock has a `null` example somewhere or the field is documented as nullable.
- Request `toJson` keys = documented request fields.
- Envelope and naming follow `docs/api/README.md` (snake_case, ISO dates, string ids).
- Every route in `mock_routes.dart` for this feature is documented.

## Update `docs/api/STATUS.md`

One row per endpoint: feature, method, path, status `designed`, link to doc, notes (open questions for backend).

## Finish

Summarize: endpoints documented, open questions, and remind the user that `docs/api/README.md` + `docs/api/<feature>.md` is what to send the backend developer. When the user confirms they sent it, set status to `handed-off`.

If a later change edits a mock or model, re-run this skill for that feature — doc and mocks must never drift.
