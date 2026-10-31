# Task: Auth (Sign Up / Sign In) + Profile Setup (7 steps)

You are implementing a feature in the Fridgy Flutter app. Follow **strictly**: `CLAUDE.md`, `.cursor/rules/*.mdc`, `docs/api/README.md`, and the code patterns in `tara_car/lib/feature/onboarding/` + `tara_car/lib/feature/auth/` (copy & adapt, never import from `tara_car/`).

Work in the phases below. **Stop at every "STOP" and wait for my answer.** Do not jump ahead.

---

## 0. Design source (Figma)

File key: `gjTj3VJepWpXHMHG9pCuvh` — section "Create Acc." (`21:3949`)
Link: https://www.figma.com/design/gjTj3VJepWpXHMHG9pCuvh/fridgy?node-id=21-3949

| # | Screen | Node ID |
| --- | --- | --- |
| A1 | Sign Up — "A fresher start." (Full name, Email, Password, terms text, **Create account**, "Already have an account? Sign in") | `16:2002` |
| A2 | Sign In — "Welcome back, Alex." (Email, Password, "Forgot password?", **Sign in**, "New to Fridgy? Create account") | `16:2059` |
| S1 | 01/07 "Tell Us About Your Kitchen" — illustration + "How many people are you cooking for?" 1 / 2 / 3 / 4 / 5+ (single select) | `16:2213` |
| S2 | 02/07 "What Do You Love Eating?" — 3×3 grid of food categories with emoji + checkbox (multi select), helper "Pick as many as you like!" | `21:3322` |
| S3 | 03/07 "Anything We Should Know?" — "Do you follow a specific diet?" 2-column radio grid (No Specific Diet, Vegetarian, Vegan, High Protein, Low Carb, Other) + "Any food allergies or ingredients you avoid?" dropdown (multi select) | `21:3379` |
| S4 | 04/07 "Do You Work Out?" — illustration + "Do you work out regularly?" Yes, I Do! / Nope, Not Right Now (radio rows with emoji) | `21:3436` |
| S5 | 05/07 "How Often Do You Work Out?" — 1–2 / 3–4 / 5–6 Days / Every Day (icon + label + subtitle + radio), helper text | `21:3670` |
| S6 | 06/07 "Stay Fresh, Stay Ahead!" — illustration, 3 benefit rows (Expiry reminders, Smart recipe ideas, Shopping reminders), **Enable Notifications**, "Maybe Later" | `21:3727` |
| S7 | 07/07 "Your Smarter Kitchen Starts Here!" — illustration, text, **Let's Explore Fridgy** | `21:3784` |

Common to S1–S6: header (back chevron, Fridgy brand mark + wordmark centered, step count "0X / 07" on the right), 7-segment progress bar, fixed bottom actions: primary **Continue →** + text button **I'll Do This Later**.

**How to read the design:** use the Figma MCP (`get_design_context` / `get_screenshot` with the node IDs above) for exact spacing, sizes, radii, colors, fonts and copy. If you don't have Figma MCP access, tell me and I'll paste screenshots — do not guess values.

---

## 1. Understand & ask — STOP

Before any code, give me:
1. A list of reusable widgets you see across these screens (see section 3 for my expectations — confirm or improve).
2. New color / text-style tokens needed that are not already in `AppColors` / `AppTextStyles` (name them semantically).
3. Assets to export from Figma (illustrations → `assets/images/profile_setup/`, icons → `assets/icons/` as SVG) and their `AppAssets` names.
4. Answers to these open questions — propose a default for each and let me confirm:
   - **"Welcome back, Alex."** — the user isn't logged in yet on this screen. Proposal: show the name of the last signed-in user stored locally, otherwise "Welcome back."
   - **Forgot password?** — no screens in this design. Proposal: link is visible but navigates to a placeholder / does nothing until designed.
   - **Terms of Use / Privacy Policy** in sign-up text — tappable links? Where do they go?
   - **S4 "Nope, Not Right Now"** — proposal: skip S5 and go straight to S6 (step counter still shows 06/07).
   - **"I'll Do This Later"** — proposal: skips the current step without saving its answer (field stays `null`) and goes to the next step.
   - **Back chevron** on S1 — proposal: S1 back is hidden/disabled after sign-up (user is already registered); on S2–S7 it goes to the previous step keeping answers.
   - **Enable Notifications** — needs a permission package (e.g. `permission_handler` / FCM). Proposal: this task only stores `notifications_enabled: true/false` in the profile; real permission request is a later task.
   - **After S7** "Let's Explore Fridgy" → home. Home doesn't exist yet → navigate to a placeholder home page.
   - **Sign In routing:** if `user.profile_completed == false` → go to S1, else → home.
   - **Localization:** `easy_localization` is not set up in Fridgy yet. Proposal: set it up now (port from tara_car), with `en` and `ar` translations for all strings in this task.

---

## 2. Data & API plan — STOP

Propose (and wait for my OK) the endpoints and mock files. My expected starting point — adjust if the design needs more:

| Method | Path | Purpose | Auth |
| --- | --- | --- | --- |
| POST | `auth/register` | Create account `{ name, email, password }` → tokens + user | no |
| POST | `auth/login` | `{ email, password }` → tokens + user | no |
| POST | `auth/refresh` | `{ refresh_token }` → new tokens (used by the token interceptor) | no |
| GET | `profile/setup-options` | Lists shown in S2 (food categories: id, name, emoji) and S3 (diets: id, name; ingredients to avoid: id, name). Server-driven so the backend can change them. | yes |
| PUT | `profile/preferences` | Save all answers at the end of S7 (or after S6) `{ household_size, favorite_food_ids[], diet_id, avoid_ingredient_ids[], works_out, workout_days_per_week, notifications_enabled }` — every field nullable (skipped steps). Returns the user with `profile_completed: true`. | yes |

- `user` object: `{ id, name, email, avatar_url, profile_completed }` — same in register, login, refresh.
- Household size (1–5+) and workout frequency (`1_2`, `3_4`, `5_6`, `every_day`) are fixed enums in the app — confirm or move them to `setup-options`.
- Auth response shape: exactly section 5 of `docs/api/README.md`.

Mock files (`assets/mocks/auth/`, `assets/mocks/profile/`), at minimum:
```
auth/post_register.json            auth/post_register_409.json (email taken)   auth/post_register_422.json
auth/post_login.json               auth/post_login_401.json (wrong credentials) auth/post_login_422.json
auth/post_login_profile_incomplete.json  (profile_completed: false)
auth/post_refresh.json
profile/get_setup_options.json
profile/put_preferences.json       profile/put_preferences_422.json
```
Realistic data: the 9 food categories and 6 diets from the design, ~10 common allergens (Peanuts, Tree nuts, Milk, Eggs, Gluten, Soy, Fish, Shellfish, Sesame, Mustard).

---

## 3. Build — Phase A: core + shared widgets + auth (A1, A2) — STOP after

**Core (only what's missing, port from tara_car):** `ApiService`, `WebConstant` (+ `useMocks`), `ApiKeys`, `ServerFailure` (adapted to our error envelope: `message` + `errors` map — expose field errors so the form can show them under the right input), `TokenInterceptor` (+ refresh on 401), `MockInterceptor` + `mock_routes.dart`, `NetworkInfo`, `LocalStorage` (tokens in secure storage), `service_locator.dart`, `AppRoute`, `printDebug`, easy_localization. Add packages from the stack in `CLAUDE.md` only.

**Shared widgets (`lib/core/shared_widgets/`)** — check existing `PrimaryButton`, `TextActionButton`, `FridgyBrandHeader`, and `feature/onboarding/presentation/widgets/onboarding_step_progress.dart` first and extend instead of duplicating:
- `AppTextField` — label above, placeholder, suffix icon, password visibility toggle (eye / eye-off), error text, keyboard type, text input action, validator.
- `PrimaryButton` — add optional trailing icon (arrow-right) and `isLoading` (spinner + disabled).
- `FixedBottomActions` — primary + optional secondary text action, SafeArea bottom.
- `BackTitleHeader` — chevron + title (A1/A2).
- `SegmentedProgressBar` — N segments, current index (reuse/generalize the onboarding one).

**Feature `lib/feature/auth/`:**
- domain: `UserEntity`, `AuthSessionEntity`, params `LoginParams`, `RegisterParams`, `AuthRepo` + `AuthRepoImpl` (real Dio calls → mocks).
- data: `UserModel`, `AuthResponseModel`, request models.
- presentation/logic: `LoginCubit`, `RegisterCubit` (states: initial, loading, success(user), failure(message, fieldErrors)).
- pages: `SignUpScreen`, `SignInScreen`; widgets one per file (`sign_up_form.dart`, `sign_in_form.dart`, `auth_intro_text.dart`, `terms_text.dart`, `auth_switch_prompt.dart`, …).
- Behavior: client-side validation (name required 2–50 chars; valid email; password ≥ 8 chars), submit disabled + loading while requesting, server field errors shown under the matching field, other errors as one toast/snackbar, keyboard "next"/"done", tokens saved securely on success, navigation per section 1 answers.

Then: format, analyze, run, and show me A1/A2 in success + 401/409/422 mock scenarios. **STOP for review.**

---

## 4. Build — Phase B: profile setup (S1–S7) — STOP after

**Feature `lib/feature/profile_setup/`:**
- domain: `SetupOptionsEntity` (food categories, diets, ingredients), `ProfilePreferencesParams`, `ProfileSetupRepo` + impl.
- data: models for options + preferences request/response.
- presentation/logic: **one** `ProfileSetupCubit` holding all answers + current step + options loading state (load options on start; loading → Skeletonizer, failure → retry view). Submit preferences on the final step; loading on the button; on success → home.
- pages: `ProfileSetupScreen` — one screen with a `PageView` (no swipe; controlled by the cubit), header + progress + fixed actions shared, each step a separate widget file:
  `kitchen_step.dart`, `food_favorites_step.dart`, `diet_step.dart`, `workout_step.dart`, `workout_frequency_step.dart`, `notifications_step.dart`, `setup_done_step.dart`.
- Reusable widgets (in `profile_setup/presentation/widgets/`, or `core/shared_widgets/` if generic):
  `SetupHeader` (back + brand + "0X / 07"), `StepIntro` (headline + description), `SetupIllustration` (rounded image), `NumberChoiceChip` (S1), `FoodFavoriteTile` (emoji + checkbox + label, S2), `RadioChoiceTile` (variants: compact grid S3, emoji row S4, icon + subtitle S5), `IngredientsDropdown` (multi-select bottom sheet, reuse `core/shared_widgets/bottom_sheet_widgets/`), `HelperMessage` (info icon + text), `BenefitRow` (S6).
- Continue is disabled until the step has a valid answer (S2 needs ≥ 1); "I'll Do This Later" always enabled.

Then: format, analyze, run, walk all 7 steps incl. skip paths and the 422 scenario. **STOP for review.**

---

## 5. Finish

1. Rows added to `docs/api/STATUS.md` (status `mocked`).
2. Report: files created/changed, commands run + results, what you could not verify, any deviation from the design and why.
3. Remind me the next step is the API design doc (`docs/api/auth.md`, `docs/api/profile.md`) using `.claude/skills/api-design/SKILL.md`.

## Hard rules (repeat)

- Pixel-match Figma. Colors/text styles only via `AppColors` / `AppTextStyles`; assets via `AppAssets`.
- One widget per file; no private `_Widget` classes in pages. `const` where possible. RTL-safe (`EdgeInsetsDirectional`).
- No fake data in widgets/cubits/repos — only in `assets/mocks/`. Repos make real Dio calls.
- Cubits provided from `AppRoute`, not inside pages. Repos return `Either<ServerFailure, T>`.
- No new packages beyond `CLAUDE.md`'s stack without asking. Don't touch unrelated features.
