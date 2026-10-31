# API Status

One row per endpoint. Updated by `/api-design` and `/connect-backend`.

| Status | Meaning |
| --- | --- |
| `mocked` | App works against mock JSON; API doc not written yet |
| `designed` | `docs/api/<feature>.md` written and matches the mocks — ready to hand off |
| `handed-off` | Given to the backend developer |
| `live` | Backend deployed; real responses verified against the doc; app switched to real API |
| `mismatch` | Backend response differs from the doc — needs a decision (see notes) |

| Feature | Method | Path | Status | Doc | Notes |
| --- | --- | --- | --- | --- | --- |
| auth | POST | `auth/register` | handed-off | [auth.md](auth.md) | |
| auth | POST | `auth/login` | handed-off | [auth.md](auth.md) | |
| auth | POST | `auth/refresh` | handed-off | [auth.md](auth.md) | Used by TokenInterceptor; 401 mock `post_refresh_401.json` |
| auth | POST | `auth/logout` | designed | [more.md](more.md) | Clears local session even if request fails |
| profile | GET | `profile/setup-options` | handed-off | [profile.md](profile.md) | |
| profile | GET | `profile/preferences` | designed | [more.md](more.md) | Prefill Food Preferences edit mode |
| profile | PUT | `profile/preferences` | handed-off | [profile.md](profile.md) | Submitted on step 6; `[]` vs `null` for allergies |
| profile | PUT | `profile` | designed | [more.md](more.md) | Edit Profile name/email |
| more | GET | `notification-settings` | designed | [more.md](more.md) | |
| more | PUT | `notification-settings` | designed | [more.md](more.md) | Auto-save on toggle |
| home | GET | `home` | designed | [home.md](home.md) | Plan 02 Checkpoint B |
| inventory | GET | `inventory` | designed | [inventory.md](inventory.md) | List filters + pagination; `include_out_of_stock` |
| inventory | GET | `inventory/{id}` | designed | [inventory.md](inventory.md) | |
| inventory | POST | `inventory` | designed | [inventory.md](inventory.md) | Returns `201` + full `FoodItem` |
| inventory | PUT | `inventory/{id}` | designed | [inventory.md](inventory.md) | |
| inventory | POST | `inventory/{id}/consume` | designed | [inventory.md](inventory.md) | Success `data: null` |
| inventory | GET | `inventory/search` | designed | [inventory.md](inventory.md) | |
| inventory | GET | `inventory/expiring` | designed | [inventory.md](inventory.md) | Align with Home `use_first` |
| notifications | GET | `notifications` | designed | [notifications.md](notifications.md) | `meta.unread_count` extension |
| notifications | PATCH | `notifications/{id}/read` | designed | [notifications.md](notifications.md) | |
| notifications | POST | `notifications/read-all` | designed | [notifications.md](notifications.md) | |
