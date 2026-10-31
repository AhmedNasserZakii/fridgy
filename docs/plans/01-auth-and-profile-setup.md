# Plan 01 — Auth (Sign Up / Sign In) + Profile Setup (7 steps)

> **For the implementing agent (IDE).** This is the resolved, decided version of `docs/prompts/01-auth-and-profile-setup.md`.
> All of that prompt's "STOP and ask" questions are answered below, so **do not stop to ask them again**: implement phase by phase and stop only at the two **Checkpoints**.
> Rules that still apply in full: `CLAUDE.md`, `.cursor/rules/*.mdc`, `docs/api/README.md`. Reference code is `tara_car/` (copy and adapt, never import).

Figma file `gjTj3VJepWpXHMHG9pCuvh`, section `21:3949`. Node IDs are in the prompt (§0). Read exact spacing, sizes and copy from Figma (`get_design_context` / `get_screenshot`). **Never guess values.**

---

## 0. Decisions (answers to the prompt's §1 questions)

| # | Question | Decision |
| --- | --- | --- |
| D1 | "Welcome back, Alex." | Show `Welcome back, {first name}.` using the name of the last signed-in user, saved locally (SharedPreferences key `last_user_name`) on every successful login or register. If there is no saved name, show `Welcome back.` |
| D2 | Forgot password? | Visible. Tapping it shows a "Coming soon" snackbar. No route yet. |
| D3 | Terms / Privacy links | Show "Terms of Use" and "Privacy Policy" in brand color (semi-bold), but **not tappable** yet, because there are no URLs. Leave a `// TODO(legal-urls)`. |
| D4 | S4 "Nope, Not Right Now" | `works_out = false` and `workout_frequency = null`, then **skip S5** and go to S6. The counter shows `06 / 07`. Back from S6 returns to S4. |
| D5 | "I'll Do This Later" | Leaves the step's field(s) `null` and goes to the next step. On S4 it behaves like D4: S5 is skipped, because the workout answer is unknown. |
| D6 | Back chevron | Hidden on S1, because the user is already registered and can't go back to sign-up. S2–S6 go to the previous visible step and keep their answers. S7 has no back. Android system back behaves the same, and on S1 it does nothing (`PopScope(canPop: false)`). |
| D7 | Enable Notifications | No permission request in this task. **Enable Notifications** sets `notifications_enabled = true` and **Maybe Later** sets it to `false`. Real permission handling comes later. |
| D8 | When preferences are submitted | **On S6** (both buttons). This is the last step that collects data. While the request runs, the S6 primary button shows a spinner. Success goes to S7 and failure shows a snackbar and stays on S6. S7 sends nothing: "Let's Explore Fridgy" goes to Home. |
| D9 | After S7 | `HomePlaceholderScreen` (`lib/feature/home/presentation/pages/home_placeholder_screen.dart`). Replaced later. |
| D10 | Sign-in routing | `user.profile_completed == false` goes to Profile Setup (S1). Otherwise, go to Home. Register always goes to S1. |
| D11 | App launch routing | Splash, then: if there's no access token, go to the Welcome/onboarding flow (as today). If there's a token and the stored user has `profile_completed`, go to Home. Otherwise, go to Profile Setup. Welcome "Get started" goes to onboarding steps and then Sign Up. Welcome "Sign in" goes to Sign In. |
| D12 | Localization | Set up `easy_localization` now (ported from tara_car) with `en` + `ar`. **Every** user-facing string in this task goes through `LocaleKeys`. Default/fallback is `en`. |
| D13 | Font | Figma uses **Inter**. `google_fonts` is not in the approved stack, so bundle Inter TTFs under `assets/fonts/Inter/` (400, 500, 600, 700, 800) and set `fontFamily: 'Inter'` in `AppTheme`. |
| D14 | Fixed enums vs server lists | Household size and workout frequency are **app enums**, because their copy and icons are fixed in the design. Food categories, diets and avoid-ingredients are **server-driven** (`profile/setup-options`). |

---

## 1. API contract (prompt §2, decided)

All bodies follow `docs/api/README.md` (envelope, `snake_case`, keys always present, `null` not omitted).

| Method | Path (`WebConstant`) | Auth | Request | `data` on success |
| --- | --- | --- | --- | --- |
| POST | `auth/register` | no | `{ name, email, password }` | auth session |
| POST | `auth/login` | no | `{ email, password }` | auth session |
| POST | `auth/refresh` | no | `{ refresh_token }` | auth session |
| GET | `profile/setup-options` | yes | — | setup options |
| PUT | `profile/preferences` | yes | preferences (below) | `{ user }` |

**User object** (identical everywhere):
```json
{ "id": "usr_7f3c2a", "name": "Alex Morgan", "email": "alex@example.com", "avatar_url": null, "profile_completed": false }
```

**Auth session** (`data` of register/login/refresh):
```json
{ "access_token": "eyJ...", "refresh_token": "eyJ...", "expires_in": 3600, "user": { ...user } }
```

**Setup options** (`data` of `GET profile/setup-options`):
```json
{
  "food_categories": [ { "id": "egyptian_classics", "name": "Egyptian Classics", "emoji": "🍲" } ],
  "diets":           [ { "id": "no_specific_diet", "name": "No Specific Diet" } ],
  "avoid_ingredients": [ { "id": "peanuts", "name": "Peanuts" } ]
}
```
- food_categories (9, in design order): Egyptian Classics 🍲, Italian 🍝, Asian 🍜, Mediterranean 🫒, Grilled & BBQ 🍖, Healthy & Light 🥗, Fast & Easy Meals 🌮, Comfort Food 🥘, Sweet Treats 🧁
- diets (6): No Specific Diet, Vegetarian, Vegan, High Protein, Low Carb, Other
- avoid_ingredients (10): Peanuts, Tree Nuts, Milk, Eggs, Gluten, Soy, Fish, Shellfish, Sesame, Mustard
- IDs are `snake_case` strings (README: IDs are strings).

**Preferences request** (`PUT profile/preferences`): every field is nullable, because steps can be skipped:
```json
{
  "household_size": 2,
  "favorite_food_ids": ["italian", "healthy_and_light"],
  "diet_id": "no_specific_diet",
  "avoid_ingredient_ids": ["peanuts"],
  "works_out": true,
  "workout_frequency": "days_3_4",
  "notifications_enabled": true
}
```
- `household_size`: `1`–`5`, where `5` means "5+".
- `workout_frequency` enum: `days_1_2` | `days_3_4` | `days_5_6` | `every_day` | `null`.
- A skipped multi-select is sent as `null`, not `[]`. `[]` would mean "I chose none".
- Response `data`: `{ "user": { ...user, "profile_completed": true } }`.

### Mock files

Each file holds the exact full response body. The HTTP status lives in the route registry, not in the JSON.

| File | Status | Scenario |
| --- | --- | --- |
| `assets/mocks/auth/post_register.json` | 201 | success, `profile_completed: false` |
| `assets/mocks/auth/post_register_409.json` | 409 | email already registered, `errors: null` |
| `assets/mocks/auth/post_register_422.json` | 422 | `errors.email`, `errors.password` |
| `assets/mocks/auth/post_login.json` | 200 | success, `profile_completed: true` |
| `assets/mocks/auth/post_login_profile_incomplete.json` | 200 | success, `profile_completed: false` |
| `assets/mocks/auth/post_login_401.json` | 401 | wrong credentials, `errors: null` |
| `assets/mocks/auth/post_login_422.json` | 422 | `errors.email` |
| `assets/mocks/auth/post_refresh.json` | 200 | new token pair + user |
| `assets/mocks/profile/get_setup_options.json` | 200 | full lists above |
| `assets/mocks/profile/put_preferences.json` | 200 | user with `profile_completed: true` |
| `assets/mocks/profile/put_preferences_422.json` | 422 | `errors.household_size` |

Add `assets/mocks/auth/` and `assets/mocks/profile/` under `flutter: assets:` in `pubspec.yaml`. Every file must pass `python3 -m json.tool`.

---

## 2. Phase A — Core

Packages to add (tara_car versions): `flutter_bloc ^9.1.1`, `equatable ^2.0.5`, `dio ^5.9.2`, `dartz ^0.10.1`, `get_it ^9.2.1`, `connectivity_plus ^7.0.0`, `flutter_secure_storage ^10.0.0`, `shared_preferences ^2.5.5`, `easy_localization ^3.0.8`, `skeletonizer ^2.1.3`. Don't add any other package.

### 2.1 Clean up the scaffold
- [ ] Delete the tara_car-style placeholder folders under `lib/feature/auth/` (`data/register/logic`, `data/forget_password/*`, `presentation/register|login|forget_password/*`, `presentation/shared_widgets`). Fridgy uses the flat `CLAUDE.md` layout (§3.2).

### 2.2 Network (`lib/core/network_services/`)
- [ ] `web_constant.dart`: `baseUrl` (`https://<host>/api/v1/`, placeholder), `static const bool useMocks = true`, paths `register`, `login`, `refresh`, `setupOptions`, `preferences`.
- [ ] `api_keys.dart`: every JSON key used in this task (`success`, `message`, `data`, `errors`, `access_token`, `refresh_token`, `expires_in`, `user`, `id`, `name`, `email`, `password`, `avatar_url`, `profile_completed`, `food_categories`, `diets`, `avoid_ingredients`, `emoji`, `household_size`, `favorite_food_ids`, `diet_id`, `avoid_ingredient_ids`, `works_out`, `workout_frequency`, `notifications_enabled`).
- [ ] `api_service.dart`: port from tara_car. Methods `get/post/put/delete`, with headers from README §2 (`Accept-Language` from the current locale).
- [ ] `server_failure.dart`: **rewrite, don't copy.** tara_car parses a different error shape. Fields: `message` (String), `statusCode` (int?), `fieldErrors` (`Map<String, List<String>>`, empty when `errors` is null). Factories `fromDioException` (timeouts, connection error and so on map to localized messages) and `fromResponse(status, body)` (reads `message` and `errors` per README §4). Add the helper `String? firstErrorFor(String field)`.
- [ ] `token_interceptor.dart`: `QueuedInterceptor`. `onRequest` adds `Authorization: Bearer` when the route needs auth. `onError` with 401 on an authenticated request calls `auth/refresh` using a **separate bare Dio** (no token interceptor), saves the new pair and retries the original request once. If refresh fails, it clears the session and goes to Sign In via a global navigator key.
- [ ] `mock/mock_response.dart`: `MockResponse(assetPath, statusCode)`.
- [ ] `mock/mock_routes.dart`: `Map<String, MockResponse>` keyed by `'METHOD path'` (e.g. `'POST auth/login'`) pointing at the success mock. Also add `static final Map<String, MockResponse> overrides = {}` with a commented example for switching a route to its 401/409/422 file while testing.
- [ ] `mock/mock_interceptor.dart`: if `WebConstant.useMocks` and the route is registered, wait 600 ms, load the asset, then resolve on 2xx or reject with a `DioException.badResponse` carrying the same `Response` on 4xx/5xx. This way `ServerFailure` sees exactly what the real server would send. Unregistered routes pass through to the network.

### 2.3 Other core
- [ ] `connection/network_info.dart`: port. In mock mode it returns `true`.
- [ ] `local_storage/`: `secure_storage.dart` for access/refresh tokens. `local_storage.dart` (SharedPreferences) for the cached user JSON and `last_user_name`. `local_storage_keys.dart`.
- [ ] `di/service_locator.dart`: register Dio + interceptors, `ApiService`, `NetworkInfo`, storages and the repos (§3, §4).
- [ ] `utils/app_route.dart`: named routes `splash`, `welcome`, `onboarding`, `signUp`, `signIn`, `profileSetup`, `home`. It provides route cubits (`RegisterCubit`, `LoginCubit`, `ProfileSetupCubit`), with `navigatorKey` global. **Replace the `AppEntry` state machine in `my_app.dart`** with `onGenerateRoute`. Splash decides the first route (D11).
- [ ] `helper/print_debug.dart` and `helper/app_validator.dart`. Validators: name 2–50 chars after trim, email regex, password ≥ 8. They return `LocaleKeys` messages.
- [ ] `easy_localization`: `assets/translations/en.json`, `ar.json`, `lib/core/constants/locale_keys.dart` (hand-written constants, like tara_car). Wrap the app in `main.dart`.
- [ ] Theme: Inter font (D13). Add the tokens below.

### 2.4 Design tokens to add

Colors (`AppColors`), from Figma variables:
| Name | Value | Figma variable | Used for |
| --- | --- | --- | --- |
| `brandLight` | `#DDF4FC` | `blue/light` | selected tile/chip background |
| `borderStrong` | `#CCDDE7` | `neutral/border-strong` | input + tile borders, unselected radio |
| `error` | read from Figma; if no token exists, ask | — | field error text/border |

Text styles (`AppTextStyles`), all Inter:
| Name | Size / weight / height | Figma style |
| --- | --- | --- |
| `largeTitleBold30` | 30 / 700 / 1.13 | Large Title/Bold/30 |
| `titleBold20` | 20 / 700 / 1.4 | Title 3/Bold/20 |
| `secondaryBodyRegular14Text` | 14 / 400 / 1.4, `textSecondary` | Secondary Body/Regular/14 |
| `secondaryBodySemiBold14` | 14 / 600 / 1.4, `textPrimary` | Secondary Body/Semi Bold/14 |
| `captionRegular12` | 12 / 400 / 1.4, `textSecondary` | Caption/Regular/12 |

Check the existing styles first and reuse any that already match. Name new ones by role, like the existing ones.

### 2.5 Shared widgets (`lib/core/shared_widgets/`)
- [ ] `PrimaryButton`: add `trailingIcon` (arrow-right) and `isLoading` (spinner, disabled). Keep the current API working (onboarding uses it).
- [ ] `TextActionButton`: unchanged unless Figma differs.
- [ ] `AppTextField`: label above, hint, suffix icon, `isPassword` with an eye/eye-off toggle, `errorText` (server error) + `validator` (client), `keyboardType`, `textInputAction`, `onFieldSubmitted`, `autofillHints`.
- [ ] `FixedBottomActions`: primary + optional secondary text action, with bottom `SafeArea`.
- [ ] `BackTitleHeader`: chevron + title (A1/A2).
- [ ] `SegmentedProgressBar`: N equal-width segments across the full width, with segments `<= currentIndex` filled `brandPrimary` and the rest `borderDefault`. This is **new**. The onboarding `OnboardingStepProgress` is a dots style; leave it alone.
- [ ] `AppSnackBar.show(context, message)`: one place for showing errors.

---

## 3. Phase A — Auth feature (`lib/feature/auth/`)

### 3.1 Domain / data
- [ ] `domain/entities/user_entity.dart` (`id, name, email, avatarUrl?, profileCompleted`), `auth_session_entity.dart` (`accessToken, refreshToken, expiresIn, user`).
- [ ] `domain/params/register_params.dart`, `login_params.dart`.
- [ ] `domain/repos/auth_repo.dart` (`register`, `login`, each `Future<Either<ServerFailure, UserEntity>>`) + `auth_repo_impl.dart`: checks `NetworkInfo`, makes the real `ApiService` call, parses the model, **saves tokens + cached user + `last_user_name`**, then returns the entity. Add `getLastUserName()` for D1.
- [ ] `data/models/user_model.dart`, `auth_session_model.dart` (`fromJson`/`toJson`, `toEntity()`), plus `register_request_model.dart` and `login_request_model.dart`. Nullable fields follow the contract.

### 3.2 Presentation
- [ ] `presentation/logic/register_cubit.dart` + `register_state.dart`, and `login_cubit.dart` + `login_state.dart`. States: `initial`, `loading`, `success(user)`, `failure(message, fieldErrors)`.
- [ ] `presentation/pages/sign_up_screen.dart` (A1, `16:2002`), `sign_in_screen.dart` (A2, `16:2059`).
- [ ] Widgets, one per file in `presentation/widgets/`: `auth_intro_text.dart` (headline + subtitle), `sign_up_form.dart`, `sign_in_form.dart`, `terms_text.dart` (D3), `auth_switch_prompt.dart` ("Already have an account? **Sign in**" / "New to Fridgy? **Create account**", uses `pushReplacement`), `forgot_password_link.dart` (D2).
- [ ] Behavior:
  - Client validation runs on submit and then on change.
  - Keyboard: Next → Next → Done. Done submits the form.
  - While loading, the button shows a spinner and the fields are disabled.
  - A 422 shows each `fieldErrors[key].first` under its field (`name`, `email`, `password`). Editing a field clears its server error.
  - 401/409/other errors: one snackbar with `failure.message`, shown once.
  - Success routes per D10 with `pushNamedAndRemoveUntil`.

### Checkpoint A (stop here for review)
1. `dart format lib/feature/auth lib/core` and `flutter analyze lib/feature/auth lib/core` are clean.
2. Run the app. Show A1/A2 in each case: success, register 409, register 422, login 401, login 422, login with incomplete profile. Switch cases via `MockRoutes.overrides`.
3. Report what was run and what was not.

---

## 4. Phase B — Profile setup (`lib/feature/profile_setup/`)

### 4.1 Domain / data
- [ ] Entities: `SetupOptionsEntity` (`foodCategories`, `diets`, `avoidIngredients`), `FoodCategoryEntity(id, name, emoji)`, `OptionEntity(id, name)`.
- [ ] Enums (`domain/entities/`): `HouseholdSize` (`one`…`fivePlus`, with `toJson()` giving 1–5), `WorkoutFrequency` (`days12`, `days34`, `days56`, `everyDay`, with `toJson()` giving the contract strings, plus label/subtitle `LocaleKeys` and icon `AppAssets`).
- [ ] `domain/params/profile_preferences_params.dart`: all fields nullable (§1).
- [ ] `domain/repos/profile_setup_repo.dart` (`getSetupOptions`, `savePreferences` returning `UserEntity`) + impl. On success, `savePreferences` updates the cached user.
- [ ] `data/models/`: `setup_options_model.dart`, `food_category_model.dart`, `option_model.dart`, `preferences_request_model.dart`. Reuse the auth `UserModel` for the response.

### 4.2 Cubit (`presentation/logic/profile_setup_cubit.dart` + state)
One cubit and one `Equatable` state:
- `optionsStatus` (`loading | loaded | failure`), `options`, `optionsError`
- `currentStep` (`0..6`), the answers (`householdSize?`, `favoriteFoodIds` Set, `dietId?`, `avoidIngredientIds` Set, `worksOut?`, `workoutFrequency?`, `notificationsEnabled?`) and a `skipped` set per step (D5: skipped → send `null`)
- `submitStatus` (`idle | loading | success | failure`), `submitError`
- Methods: `loadOptions()` (called on create), `select…()` for each answer, `continueStep()`, `skipStep()`, `back()`, `enableNotifications()`, `maybeLater()` (both set the value and then `submit()`), `submit()`.
- Navigation rules: D4/D5 (skip S5), D6 (back), D8 (submit on S6 and go to S7 on success).
- `canContinue` getter: S1 needs a size, S2 needs ≥ 1 food, S3 needs a diet (allergies are optional), S4 needs a yes/no, S5 needs a frequency.

### 4.3 UI
- [ ] `presentation/pages/profile_setup_screen.dart`: header + `SegmentedProgressBar` (7) + a `PageView` (`NeverScrollableScrollPhysics`, driven by `currentStep` through a `BlocListener`) + `FixedBottomActions`. S6 and S7 swap the bottom actions (S6: **Enable Notifications** + "Maybe Later", S7: **Let's Explore Fridgy** only). `PopScope` follows D6.
- [ ] Options loading uses `Skeletonizer` over S2/S3 content. On failure, show `OptionsErrorView` with a retry button.
- [ ] Steps, one file each: `kitchen_step.dart` (S1 `16:2213`), `food_favorites_step.dart` (S2 `21:3322`), `diet_step.dart` (S3 `21:3379`), `workout_step.dart` (S4 `21:3436`), `workout_frequency_step.dart` (S5 `21:3670`), `notifications_step.dart` (S6 `21:3727`), `setup_done_step.dart` (S7 `21:3784`).
- [ ] Reusable widgets in `presentation/widgets/`: `setup_header.dart` (back, brand mark + "FRIDGY" centered, `0X / 07`; reuse `FridgyBrandHeader` parts where possible), `step_intro.dart`, `setup_illustration.dart`, `number_choice_chip.dart`, `food_favorite_tile.dart`, `radio_choice_tile.dart` (variants `compact` S3 / `emoji` S4 / `iconSubtitle` S5), `ingredients_dropdown.dart` (opens a multi-select bottom sheet; put the generic sheet in `core/shared_widgets/bottom_sheet_widgets/multi_select_bottom_sheet.dart`), `helper_message.dart`, `benefit_row.dart`, `options_error_view.dart`.
- [ ] Selected state, from the design: background `brandLight` and border `brandPrimary`. Unselected: white background and `borderStrong` border.

### 4.4 Assets (export from Figma, register in `AppAssets`)
| `AppAssets` name | Path | From |
| --- | --- | --- |
| `setupKitchen` | `assets/images/profile_setup/kitchen.png` | S1 illustration |
| `setupWorkout` | `assets/images/profile_setup/workout.png` | S4 illustration |
| `setupNotifications` | `assets/images/profile_setup/notifications.png` | S6 illustration |
| `setupDone` | `assets/images/profile_setup/done.png` | S7 illustration |
| `icUser`, `icMail`, `icEye`, `icEyeOff` | `assets/icons/*.svg` | A1/A2 field icons |
| `icArrowRight`, `icChevronLeft`, `icChevronDown`, `icInfo` | `assets/icons/*.svg` | buttons, header, dropdown, helper |
| `icWorkoutLight`, `icWorkoutConsistent`, `icWorkoutActive`, `icWorkoutDaily` | `assets/icons/*.svg` | S5 row icons |
| `icBellRing`, `icChefHat`, `icBasket` | `assets/icons/*.svg` | S6 benefit icons |
| S4 emoji (🏃 / 🌱) | text emoji | not assets |

Export at 2x/3x (or the largest available) for PNGs. Add `assets/images/profile_setup/` and `assets/fonts/` to `pubspec.yaml`.

### Checkpoint B (stop here for review)
1. `dart format` + `flutter analyze` on `lib/feature/profile_setup lib/feature/auth lib/core` are clean.
2. Run and walk through: all 7 steps answered; every step skipped; S4 "Nope" (skips S5, counter `06/07`, back returns to S4); back from S2–S6 keeps answers; options failure + retry; `put_preferences_422` on S6; relaunching the app routes per D11.

---

## 5. Finish (phase 2 of the CLAUDE.md workflow; the feature isn't done without it)
- [ ] `docs/api/auth.md` and `docs/api/profile.md`, written per `.claude/skills/api-design/SKILL.md` and `docs/api/_TEMPLATE.md`. They must match the mocks field-for-field.
- [ ] `docs/api/STATUS.md`: 5 rows (§1 table), status `designed` once the docs are written (otherwise `mocked`).
- [ ] Final report: files created/changed, commands run + results, what couldn't be verified, and any deviation from Figma and why.

## Out of scope
Forgot-password flow, logout UI, real notification permission/FCM, social login, Home content, editing preferences after setup.
