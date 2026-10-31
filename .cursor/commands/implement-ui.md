# Implement UI for a Fridgy feature

Implement the UI described below for the Fridgy app. Follow `CLAUDE.md`, `.cursor/rules/10-ui-implementation.mdc`, `.cursor/rules/20-mock-api-contract.mdc`, and the patterns in `tara_car/lib/feature/onboarding/`.

## Steps — do them in order and stop where it says STOP

1. **Understand.** Read the design/description I gave. List: the screens, the widgets on each screen, the data each screen shows, the user actions, and the states (loading / empty / error / success). Write any questions you have. **STOP and wait for my answers** if anything is unclear.
2. **Data plan.** Say whether this UI needs server data.
   - If yes: propose the endpoints (`METHOD path — purpose`) and the mock JSON files (`assets/mocks/<feature>/…`) following `docs/api/README.md`. **STOP and wait for my OK.**
   - If no (static UI only): say why, and continue.
3. **File plan.** List every file you'll create or edit (pages, widgets — one per file, cubit/state, entities, models, repo, mocks, DI, AppRoute, translations, pubspec). Reuse existing shared widgets and `AppColors`/`AppTextStyles`/`AppAssets` — list any new tokens you need to add.
4. **Build** in this order: mocks → `WebConstant`/`ApiKeys` → domain (entities, params, repo contract + impl) → models → cubit/state → DI + AppRoute → widgets → page.
5. **Verify:** `dart format` and `flutter analyze` on changed paths; valid mock JSON; all 4 states reachable via `mock_routes.dart` scenarios; RTL/Arabic OK.
6. **Report:** files created/changed, what you ran and the result, anything not done. Then remind me: next step is to write `docs/api/<feature>.md` and update `docs/api/STATUS.md` (api-design step).

## The feature

<!-- Describe the screen(s) here, or attach the Figma link / screenshots -->
