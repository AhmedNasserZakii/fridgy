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
| inventory | POST | `inventory/{id}/consume` | designed | [inventory.md](inventory.md) | Optional body `{ quantity }` for Fridge AI partial use; omit = full consume. Success `data: null` |
| inventory | GET | `inventory/search` | designed | [inventory.md](inventory.md) | |
| inventory | GET | `inventory/expiring` | designed | [inventory.md](inventory.md) | Align with Home `use_first` |
| notifications | GET | `notifications` | designed | [notifications.md](notifications.md) | `meta.unread_count` extension |
| notifications | PATCH | `notifications/{id}/read` | designed | [notifications.md](notifications.md) | |
| notifications | POST | `notifications/read-all` | designed | [notifications.md](notifications.md) | |
| fridge_ai | POST | `fridge-ai/messages` | designed | [fridge_ai.md](fridge_ai.md) | `reply_kind` + `clarification` + proposal ids/emoji. No inventory mutation; confirm via inventory. Mock picks use_food / clarification / add_food. |
| fridge_ai | POST | `fridge-ai/messages/image` | designed | [fridge_ai.md](fridge_ai.md) | multipart `image` + optional caption; returns same send shape with `user_message.image_url` + `proposed_items` |
| fridge_ai | GET | `fridge-ai/conversations` | designed | [fridge_ai.md](fridge_ai.md) | Paginated history |
| fridge_ai | GET | `fridge-ai/conversations/{id}/messages` | designed | [fridge_ai.md](fridge_ai.md) | |

| shopping | GET | `shopping/list` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/list` | designed | [shopping](shopping/shopping.md) | |
| shopping | PUT | `shopping/list/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | DELETE | `shopping/list/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/list/{id}/toggle` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/list/complete` | designed | [shopping](shopping/shopping.md) | Fridge intake draft only |
| shopping | GET | `shopping/catalog` | designed | [shopping](shopping/shopping.md) | |
| shopping | GET | `shopping/catalog/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | GET | `shopping/cart` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/cart/items` | designed | [shopping](shopping/shopping.md) | |
| shopping | PUT | `shopping/cart/items/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | DELETE | `shopping/cart/items/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | DELETE | `shopping/cart` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/orders` | designed | [shopping](shopping/shopping.md) | |
| shopping | GET | `shopping/orders` | designed | [shopping](shopping/shopping.md) | |
| shopping | GET | `shopping/orders/{id}` | designed | [shopping](shopping/shopping.md) | |
| shopping | POST | `shopping/orders/{id}/complete` | designed | [shopping](shopping/shopping.md) | Fridge intake draft only |
| shopping | POST | `shopping/fridge-intake/{id}/confirm` | designed | [shopping](shopping/shopping.md) | Creates inventory |
