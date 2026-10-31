# Plan 02 — Home (+ Search, Notifications, Expiring Soon)

> **For the implementing agent (IDE).** Build this with the same contract-first workflow as plan 01. **Read the design yourself from Figma.** This plan decides the **API contract, mocks, data layer and behavior**. Don't change the contract to fit the UI. If the design needs data that isn't listed here, stop and ask.
> Rules: `CLAUDE.md`, `.cursor/rules/*.mdc`, `docs/api/README.md`. Reference code: `tara_car/` (copy and adapt, never import).
> **Conflicts:** for **anything visual** (layout, elements, copy), **Figma wins over this plan**. For **data and API shapes**, this plan wins. Report every conflict you find, and never work around one with UI logic.
> **Prerequisite:** plan 01 is done (core network, `MockInterceptor`, tokens, `AppRoute`, localization, `SegmentedProgressBar`/`PrimaryButton` etc.).

## 0. Design source (read it with Figma MCP)

File `gjTj3VJepWpXHMHG9pCuvh`, section **Home** `156:7990`.

| Screen | Node | Notes |
| --- | --- | --- |
| H1 Home | `21:4073` | scroll content `21:4310`, nav bar `145:4708` |
| H2 Search your food | `145:5965` | opened from the Home search field |
| H3 Notifications | `145:5096` | opened from the Home bell |
| H4 Expiring Soon | `145:5271` | opened from "Use These First → See All" |

Home's scroll content continues **below the visible fold**. These sections are visible and **in scope**, decided in D17–D19:
- "Browse Your Kitchen" (`21:4352` + `21:4353`): 6 tiles.
- "Your Weekly Impact" (`21:4372` + `21:4373`): savings card with a progress bar.
- "Fridgy Suggests" (`21:4378` + `21:4379`): AI suggestion card.

---

## 1. Decisions

| # | Topic | Decision |
| --- | --- | --- |
| D1 | Greeting | Built on the client. "Good morning / afternoon / evening" comes from local time (05–11:59 / 12–16:59 / otherwise), plus the **first name** of the cached user (plan 01). The subtitle is static, via `LocaleKeys`. |
| D2 | Avatar | `user.avatar_url` if set, otherwise the initials of `user.name` (first letters of the first two words, e.g. "Alex Hassan" → "AH"). It isn't tappable yet. |
| D3 | Hero copy | The title, subtitle and food photo are **static app content** (`LocaleKeys` + a local asset exported from Figma). Only the numbers come from the API: "You have **{total_items}** items ready to enjoy", "**{total_items} Items** in your kitchen", "**{expiring_soon_count}** Expiring soon". |
| D4 | Days left / "Use soon" | The **server** sends `days_left` (int; 0 = today, negative = expired) and `expiry_status` (`expired` \| `use_soon` \| `fresh`). The app never calculates them, because the "soon" threshold is a business rule that belongs to the backend. The amber "Use soon · {date} · {n} day(s)" line appears only when `expiry_status == use_soon`. `fresh` shows only the date (see "Minced Beef" in H2). `expired` uses an error color and the text "Expired · {date}". Expired isn't in the design: ask for a color if no error token exists. |
| D5 | Quick actions (Scan Food, Add Item, Cook with AI, Meal Planner) | Not built yet. Each shows a "Coming soon" snackbar. |
| D6 | Bottom nav | New `NavBarScreen` (in `lib/feature/nav_bar/`) with tabs Home, My Fridge, Shopping and More. Only Home is real; the other tabs show a `ComingSoonView`. The raised center button shows the "Coming soon" snackbar. **It replaces `HomePlaceholderScreen` from plan 01** as the `home` route. "View My Fridge →" switches to the My Fridge tab. |
| D7 | Food card tap | No item detail screen yet, so the tap does nothing. Keep `onTap` nullable on the widget. |
| D8 | Search | Server-side search, debounced **400 ms**, minimum **2 characters**. Below 2 characters, show the **recent searches**. Recent searches are **local only** (SharedPreferences, last 5, newest first, de-duplicated, case-insensitive), saved when a search returns results or the keyboard's search button is pressed. Tapping one runs it. The grey guidance box is static text. "{n} matches in {first name}'s kitchen" uses `meta.total`. |
| D9 | Filter icons (H2, H4 sliders) | Not designed. The icon is visible but does nothing (`// TODO(filters)`). The API already accepts the params (§2). |
| D10 | Notifications grouping | Group by **local date** of `created_at`: "Today", "Yesterday", then a date header (`d MMM yyyy`). Time is shown as local `h:mm a`. Unread cards have a light-blue background and read ones are plain (compare the "Yesterday" row in Figma). |
| D11 | Notification tap | Marks it read (optimistic: update the UI first, roll back and show a snackbar on failure), then follows `action`: for `expiry_reminder`, nothing yet (D7). The chevron appears only when `action != null`. |
| D12 | Mark all as read | Both the top-right ✓✓ icon and the "Mark all as read" text call the same endpoint. Optimistic, like D11. Afterwards the "{n} unread" chip disappears when n = 0. Coming back to Home refreshes the bell dot. |
| D13 | Bell dot | Shown when `unread_notifications_count > 0`. |
| D14 | Expiring Soon header | "{meta.total} items to enjoy first · {today}". The date is the **device's** local date (`d MMM yyyy`). The "Soonest date first" chip shows the current sort (only `expiry_asc` exists) and isn't tappable. The footer note is static. |
| D15 | Loading / errors / empty | Home and the lists use `Skeletonizer` with fake **layout** data for loading only (never shown as real data). On failure, show an inline error with retry. Pull-to-refresh on Home, Notifications and Expiring Soon. Empty states (not designed): one centered line of text each ("Your kitchen is empty — add your first item", "No notifications yet", "Nothing is expiring soon", "No matches for "{q}""). On Home, hide the "Use These First" section when `use_first` is empty. |
| D17 | Browse Your Kitchen | **Static app content, no API.** The 6 tiles (Vegetables, Fruits, Dairy, Meat, Frozen, Pantry) are fixed navigation shortcuts: labels go through `LocaleKeys` and photos are exported from Figma into `assets/images/home/categories/`. Define them as a `KitchenCategory` enum in `home/domain/entities/`. A tap shows "Coming soon" for now. Later it will open My Fridge filtered (Frozen → `storage=freezer`, Pantry → `storage=pantry`, the others → a future `category` filter). |
| D18 | Your Weekly Impact | **From the API** (`weekly_impact` in E1). The numbers, the currency and the progress come from the server, while the sentences around them are app copy with placeholders ("You saved {n} items this week!", "Estimated savings {amount}", "{saved} of your {goal}-item weekly goal…"). Progress = `saved_items_count / goal_items_count`, clamped to 0–1. When `weekly_impact` is `null`, hide the whole section, heading included. Display money as "{currency} {amount}" (e.g. "EGP 420"), with whole amounts shown without decimals. Don't add a package for this. |
| D19 | Fridgy Suggests | **From the API** (`suggestion` in E1). `title` and `description` are server text (already localized), shown as-is. "Ask Fridgy →" and "Show Recipe" show "Coming soon" (there are no AI or recipe screens yet). The AI disclaimer under the button is static app copy. When `suggestion` is `null`, hide the whole section, heading included. |
| D16 | Pagination | Notifications, Expiring Soon and Search use infinite scroll (`limit=20`) and load the next page when 300 px from the bottom, while `page < last_page`. |

---

## 2. API contract

All shapes follow `docs/api/README.md`: envelope, `snake_case`, keys always present with `null`, ISO dates. All endpoints require auth (Bearer).

### Shared object: food item
Used by the Home `use_first` list, Search and Expiring Soon. This is also the object future My Fridge screens will use, so keep it complete.
```json
{
  "id": "itm_9a21",
  "name": "Baby Spinach",
  "image_url": "https://…/baby-spinach.jpg",
  "quantity": 250,
  "unit": "g",
  "storage": "fridge",
  "is_partly_used": false,
  "expiry_date": "2026-10-30",
  "days_left": 1,
  "expiry_status": "use_soon",
  "added_at": "2026-10-25T18:20:00Z"
}
```
- `quantity`: number (may be decimal, e.g. `1.5`). `unit`: `g` | `kg` | `ml` | `l` | `pcs`. Display: "250 g", "1 L", "6 pcs" (localized unit labels).
- `storage`: `fridge` | `freezer` | `pantry`.
- Subtitle on the card: "{quantity} {unit} · {storage}" plus " · Partly used" when `is_partly_used`.
- `expiry_date` may be `null` (no expiry, e.g. salt). Then `days_left` and `expiry_status` are `null` too, and the card shows no expiry line.

### Endpoints

| # | Method | Path (`WebConstant`) | Query | Purpose |
| --- | --- | --- | --- | --- |
| E1 | GET | `home` | — | Home dashboard aggregate |
| E2 | GET | `inventory/search` | `q` (required, ≥ 2 chars), `include_out_of_stock` (bool, default `false`), `page`, `limit` | H2 results |
| E3 | GET | `inventory/expiring` | `sort` (`expiry_asc`, default), `storage` (optional filter), `page`, `limit` | H4 list |
| E4 | GET | `notifications` | `page`, `limit` | H3 list |
| E5 | PATCH | `notifications/{id}/read` | — | mark one read |
| E6 | POST | `notifications/read-all` | — | mark all read |

**E1 `GET home`, `data`:**
```json
{
  "kitchen_summary": { "total_items": 24, "expiring_soon_count": 5 },
  "unread_notifications_count": 3,
  "use_first": [ { "...food item": "max 3, soonest expiry first, only use_soon/expired" } ],
  "weekly_impact": {
    "saved_items_count": 8,
    "goal_items_count": 10,
    "estimated_savings": { "amount": 420, "currency": "EGP" },
    "week_start": "2026-10-25"
  },
  "suggestion": {
    "id": "sug_3e7b",
    "title": "<copy from Figma 21:4379>",
    "description": "<copy from Figma 21:4379>",
    "recipe_id": "rcp_omelet_01",
    "uses_item_ids": ["itm_9a21"]
  }
}
```
- `weekly_impact`: `null` when there's no data yet (new user). `amount` is a number in major units (EGP, not piasters). `currency` is an ISO 4217 code. The backend decides the week boundary and returns it as `week_start`. `goal_items_count` is server-side (not editable in the app yet).
- `suggestion`: `null` when there's nothing to suggest. `recipe_id` and `uses_item_ids` are for the future recipe screen; the app doesn't use them yet but must parse them.
"See All" opens H4 (E3). The backend decides which items count as "expiring soon", using the same rule for `expiring_soon_count`, `use_first` and E3.

**E2 / E3, paginated** (README §3): `data` is an array of food items, plus `meta { page, limit, total, last_page }`.
- E3 returns the items with `expiry_status` `use_soon` or `expired`, sorted by `expiry_date` ascending.

**E4 `GET notifications`, paginated.** Item:
```json
{
  "id": "ntf_51c0",
  "type": "expiry_reminder",
  "title": "Spinach is up next",
  "body": "250 g · entered date 30 Oct · 1 day left",
  "image_url": "https://…/baby-spinach.jpg",
  "is_read": false,
  "created_at": "2026-10-31T07:00:00Z",
  "action": { "type": "food_item", "id": "itm_9a21" }
}
```
- `type`: `expiry_reminder` | `household_update` | `meal_plan`. The app uses it for the label under the card ("Expiry reminder", "Household update", "Meal plan") and for the **fallback icon when `image_url` is null** (`household_update` → users icon, `meal_plan` → calendar icon).
- `title` / `body` are **already localized by the server** (`Accept-Language`). The app displays them as-is.
- `action`: `null` or `{ type: "food_item" | "shopping_list" | "meal_plan", id }`.
- `meta` adds **`unread_count`** (int) next to the standard pagination keys, for the "{n} unread" chip. Document this extension in `docs/api/notifications.md`.

**E5 `PATCH notifications/{id}/read`.** `data`: the updated notification. Returns 404 if the id is unknown.
**E6 `POST notifications/read-all`.** `data`: `{ "updated_count": 3 }`.

---

## 3. Mocks

Each file is the exact full body. The status lives in `mock_routes.dart`. **Extend `MockInterceptor`** for this plan:
1. Match the path **without the query string**.
2. Support `{param}` segments in route keys (`'PATCH notifications/{id}/read'`).
3. Search mocks: if `q` matches no item in `get_search.json` by name (case-insensitive contains), return `get_search_empty.json`. This one small piece of mock logic makes the screen testable. Keep it inside the mock layer.

| File | Status | Scenario |
| --- | --- | --- |
| `assets/mocks/home/get_home.json` | 200 | 24 items, 5 expiring, 3 unread, 3 `use_first` (Baby Spinach, Strawberries, Fresh Milk, exactly as in Figma H1; each must be the same object as in `get_expiring.json`), `weekly_impact` 8/10 + EGP 420, `suggestion` = the omelet copy from Figma |
| `assets/mocks/home/get_home_empty.json` | 200 | all zeros, `use_first: []`, `weekly_impact: null`, `suggestion: null` |
| `assets/mocks/home/get_home_500.json` | 500 | error envelope (for the retry UI) |
| `assets/mocks/inventory/get_search.json` | 200 | the H2 example: Fresh Milk (partly used, use_soon, 3 days) + Minced Beef (freezer, fresh, 15 Dec 2026); `total: 2` |
| `assets/mocks/inventory/get_search_empty.json` | 200 | `data: []`, `total: 0` |
| `assets/mocks/inventory/get_expiring.json` | 200 | the 5 H4 items in Figma order, `total: 5`, `last_page: 1` |
| `assets/mocks/inventory/get_expiring_empty.json` | 200 | empty |
| `assets/mocks/notifications/get_notifications.json` | 200 | the 4 H3 items (3 unread), `meta.unread_count: 3` |
| `assets/mocks/notifications/get_notifications_empty.json` | 200 | empty, `unread_count: 0` |
| `assets/mocks/notifications/patch_read.json` | 200 | one notification, `is_read: true` |
| `assets/mocks/notifications/patch_read_404.json` | 404 | not found |
| `assets/mocks/notifications/post_read_all.json` | 200 | `updated_count: 3` |

Mock data rules:
- Copy names, quantities, dates, titles and bodies **from Figma**.
- `image_url`: real, publicly loadable absolute URLs. Use stable Unsplash photo URLs of the same foods, and check that each one loads.
- Because mock dates are fixed, `days_left` and Today/Yesterday grouping won't match the real calendar. That's expected and fine.

Add `assets/mocks/home/`, `inventory/` and `notifications/` to `pubspec.yaml`. Each file must pass `python3 -m json.tool`.

---

## 4. Code structure

### 4.1 Shared food item
Used by three features, so it lives in one place:
- `lib/feature/inventory/domain/entities/food_item_entity.dart` + enums (`FoodUnit`, `StorageLocation`, `ExpiryStatus`) with `fromJson`-safe parsing (unknown value → `null`, logged with `printDebug`).
- `lib/feature/inventory/data/models/food_item_model.dart` (`toEntity()`).
- `lib/core/shared_widgets/food_card.dart`: image (`cached_network_image` with a placeholder and an error fallback), name, subtitle, expiry line (D4), `onTap`.
- Add `cached_network_image` (tara_car version `^3.4.1`; it's in the approved stack).
- Shared pagination: `lib/core/network_services/models/pagination_meta_model.dart` + `PaginationMeta` entity, and a generic `PaginatedList<T>` (items + meta).

### 4.2 `lib/feature/home/`
- domain: `HomeDashboardEntity` (`totalItems`, `expiringSoonCount`, `unreadNotificationsCount`, `useFirst`, `weeklyImpact?`, `suggestion?`), `WeeklyImpactEntity`, `MoneyEntity(amount, currency)`, `SuggestionEntity`, `KitchenCategory` enum (D17), `HomeRepo` (`getDashboard()`) + impl.
- data: `home_dashboard_model.dart`, `kitchen_summary_model.dart`, `weekly_impact_model.dart`, `money_model.dart`, `suggestion_model.dart`.
- logic: `HomeCubit` with states `loading | loaded(dashboard) | failure(message)`, plus `refresh()`. It also exposes the cached user for D1/D2.
- pages: `home_screen.dart` (the Home **tab** body, not a route).
- widgets (one per file): `home_greeting_header.dart`, `home_avatar.dart`, `notification_bell.dart`, `home_search_field.dart` (read-only, tap opens H2), `kitchen_overview_card.dart`, `quick_actions_row.dart`, `quick_action_item.dart`, `section_header.dart` (title + subtitle + optional action, so it's reusable), `use_first_section.dart`, `kitchen_categories_grid.dart`, `kitchen_category_tile.dart`, `weekly_impact_card.dart`, `fridgy_suggests_card.dart`, `home_error_view.dart`.

### 4.3 `lib/feature/inventory/` (search + expiring)
- domain: `InventoryRepo` (`search(SearchParams)`, `getExpiring(ExpiringParams)` → `PaginatedList<FoodItemEntity>`) + impl; `SearchParams(q, includeOutOfStock, page, limit)`, `ExpiringParams(sort, storage?, page, limit)`.
- data: `data_source/recent_searches_local_data_source.dart` (SharedPreferences, D8; real local persistence, so it's allowed).
- logic: `SearchCubit` (debounce, min length, results + pagination, recent searches; cancels stale requests or ignores them by query token) and `ExpiringSoonCubit` (pagination, refresh).
- pages: `search_screen.dart`, `expiring_soon_screen.dart`. widgets: `search_input.dart` (autofocus), `search_results_count.dart`, `recent_searches_list.dart`, `recent_search_row.dart`, `search_guidance_box.dart`, `expiring_soon_header.dart`, `sort_chip.dart`, `list_footer_note.dart`.

### 4.4 `lib/feature/notification/`
- domain: `NotificationEntity`, `NotificationType`, `NotificationAction`; `NotificationRepo` (`getNotifications(page, limit)` → list + `unreadCount`, `markRead(id)`, `markAllRead()`) + impl.
- data: `notification_model.dart`, `notification_action_model.dart`, `notifications_page_model.dart` (reads `meta.unread_count`).
- logic: `NotificationsCubit`: pagination, grouping (D10) done in the **cubit/state**, not the widget, and optimistic read updates (D11, D12).
- pages: `notifications_screen.dart`. widgets: `unread_chip.dart`, `notification_group_header.dart`, `notification_card.dart` (image or type icon, title, body, chevron, footer "{time} · {type label}"), `notification_row_read.dart` if Figma styles read items differently.

### 4.5 `lib/feature/nav_bar/`
- `nav_bar_screen.dart` (`IndexedStack` of tabs) + `app_bottom_nav_bar.dart`, `nav_bar_item.dart`, `nav_center_button.dart`, `coming_soon_view.dart`. Selected tab state lives in a tiny `NavBarCubit`.

### 4.6 Routing (`AppRoute`)
- `home` → `NavBarScreen`, which provides `HomeCubit` and `NavBarCubit`.
- New routes: `search` (provides `SearchCubit`), `notifications` (`NotificationsCubit`) and `expiringSoon` (`ExpiringSoonCubit`).
- When coming back from H3 to Home, call `HomeCubit.refresh()` (await the push, then refresh) so the bell dot and count are correct.

### 4.7 Strings, assets, tokens
- Every string goes in `en.json` + `ar.json` via `LocaleKeys`, including unit and storage labels and plurals ("1 day" / "2 days": use easy_localization `plural`).
- Icons from Figma as SVG into `assets/icons/` (bell, search, scan-line, plus, sparkles, calendar-days, sliders-horizontal, check-check, history, users, chevron-right, info, and the nav icons: home, fridge, cart, menu). The hero photo goes to `assets/images/home/`. Register them all in `AppAssets`.
- New colors/text styles (e.g. the amber "Use soon" color, card surface tint): name them semantically and take the values from Figma variables. Never hard-code them in widgets.
- RTL-safe (`EdgeInsetsDirectional`), and the chevrons flip in RTL.

---

## 5. Build order and checkpoints

1. **Data first:** mocks → `MockInterceptor` extensions → models/entities → repos. Check that each repo parses its mocks, by running the app or writing a quick unit test per model `fromJson` against the mock file.
2. **Home + nav bar** (H1).
3. **Checkpoint A (stop here for review):** format + analyze clean. Show Home in the loaded, empty (`get_home_empty`), error + retry (`get_home_500`) and skeleton states, plus pull-to-refresh.
4. **Search** (H2) and **Expiring Soon** (H4).
5. **Notifications** (H3), including mark one read, mark all read and the 404 rollback.
6. **Checkpoint B (stop here for review):** format + analyze clean. Walk through every screen, each empty state, the D8 search flow (type "mi", type "xyz" → empty, clear → recent searches), and mark-read → back to Home → bell dot updated.

## 6. Finish (phase 2 of the CLAUDE.md workflow)
- [ ] `docs/api/home.md`, `docs/api/inventory.md` (food item object + E2, E3) and `docs/api/notifications.md` (E4–E6, including the `meta.unread_count` extension), following `.claude/skills/api-design/SKILL.md` + `docs/api/_TEMPLATE.md`. They must match the mocks field-for-field.
- [ ] `docs/api/STATUS.md`: 6 rows (E1–E6), `designed`.
- [ ] Final report: files created/changed, commands run + results, what couldn't be verified, and any deviation from Figma and why.

## Out of scope
Item detail, Add Item, Scan Food, Cook with AI, Meal Planner, My Fridge, Shopping and More content, filter sheets, push notifications/FCM, the AI chat ("Ask Fridgy"), the recipe screen ("Show Recipe"), and editing the weekly goal.
