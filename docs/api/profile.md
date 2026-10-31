# Profile Setup API

> Shared rules (envelope, errors, auth, naming): see [README.md](README.md).

**Screens using this:** Profile Setup (7 steps)
**Auth required:** yes (Bearer access token)

## Data objects

### `FoodCategory`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Snake_case id, e.g. `egyptian_classics` |
| `name` | string | no | Display name |
| `emoji` | string | no | Single emoji character |

### `Option`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Snake_case id |
| `name` | string | no | Display name |

### `SetupOptions`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `food_categories` | FoodCategory[] | no | Ordered list for the favorites grid |
| `diets` | Option[] | no | Diet single-select options |
| `avoid_ingredients` | Option[] | no | Allergy / avoid multi-select options |

### `User`

Same as [auth.md](auth.md) `User`. After preferences are saved, `profile_completed` is `true`.

---

## 1. Get setup options

`GET /profile/setup-options`

**When the app calls it:** Profile Setup screen opens (and on retry after failure).

**Path params:** none  
**Query params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "food_categories": [
      { "id": "egyptian_classics", "name": "Egyptian Classics", "emoji": "🍲" },
      { "id": "italian", "name": "Italian", "emoji": "🍝" },
      { "id": "asian", "name": "Asian", "emoji": "🍜" },
      { "id": "mediterranean", "name": "Mediterranean", "emoji": "🫒" },
      { "id": "grilled_and_bbq", "name": "Grilled & BBQ", "emoji": "🍖" },
      { "id": "healthy_and_light", "name": "Healthy & Light", "emoji": "🥗" },
      { "id": "fast_and_easy_meals", "name": "Fast & Easy Meals", "emoji": "🌮" },
      { "id": "comfort_food", "name": "Comfort Food", "emoji": "🥘" },
      { "id": "sweet_treats", "name": "Sweet Treats", "emoji": "🧁" }
    ],
    "diets": [
      { "id": "no_specific_diet", "name": "No Specific Diet" },
      { "id": "vegetarian", "name": "Vegetarian" },
      { "id": "vegan", "name": "Vegan" },
      { "id": "high_protein", "name": "High Protein" },
      { "id": "low_carb", "name": "Low Carb" },
      { "id": "other", "name": "Other" }
    ],
    "avoid_ingredients": [
      { "id": "peanuts", "name": "Peanuts" },
      { "id": "tree_nuts", "name": "Tree Nuts" },
      { "id": "milk", "name": "Milk" },
      { "id": "eggs", "name": "Eggs" },
      { "id": "gluten", "name": "Gluten" },
      { "id": "soy", "name": "Soy" },
      { "id": "fish", "name": "Fish" },
      { "id": "shellfish", "name": "Shellfish" },
      { "id": "sesame", "name": "Sesame" },
      { "id": "mustard", "name": "Mustard" }
    ]
  }
}
```

**Errors:** standard auth / server errors (`401`, `500`, …).

**Mock files:** `assets/mocks/profile/get_setup_options.json`

---

## 2. Save preferences

`PUT /profile/preferences`

**When the app calls it:** On Profile Setup step 6 (**Enable Notifications** or **Maybe Later**). This is the last step that collects data.

**Path params:** none  
**Query params:** none

**Request body:** every field is nullable because steps can be skipped. A skipped multi-select is sent as `null`, not `[]` (`[]` would mean “chose none”).

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

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `household_size` | number \| null | no | `1`–`5`, where `5` means “5+” |
| `favorite_food_ids` | string[] \| null | no | Ids from `food_categories` |
| `diet_id` | string \| null | no | Id from `diets` |
| `avoid_ingredient_ids` | string[] \| null | no | Ids from `avoid_ingredients` |
| `works_out` | boolean \| null | no | |
| `workout_frequency` | string \| null | no | `days_1_2` \| `days_3_4` \| `days_5_6` \| `every_day` \| `null` |
| `notifications_enabled` | boolean \| null | no | Set on step 6; no OS permission in this version |

**Meaning of each value (backend must store all of them):**

| Field | `null` | `[]` / `false` | value |
| --- | --- | --- | --- |
| `household_size` | user skipped the step | — | the size |
| `favorite_food_ids` | user skipped the step | — (the app requires ≥ 1 when answered) | chosen ids |
| `diet_id` | user skipped the step | — | chosen diet |
| `avoid_ingredient_ids` | user skipped the step (**unknown**, don't assume safe) | `[]` = user answered "nothing to avoid" | ingredients to avoid |
| `works_out` | user skipped the step | `false` = doesn't work out | `true` |
| `workout_frequency` | skipped, or `works_out` is not `true` | — | frequency |

**Backend rules:**
- **PUT replaces everything.** Store exactly what is sent, `null`s included. A `null` overwrites an older value: it does not mean "keep the old one".
- On success, set `user.profile_completed = true`, even if every field is `null` (the user skipped everything). The endpoint can be called again later; that's safe.
- Every id must exist in the current `setup-options` lists. Otherwise return `422` with the field name as the key (e.g. `"favorite_food_ids": ["Unknown id: xyz"]`).
- `workout_frequency` must be `null` unless `works_out == true`. Otherwise return `422` on `workout_frequency`.
- Duplicate ids in arrays: de-duplicate silently, no error.
- `avoid_ingredient_ids` is **allergy data**. Later features (recipes, AI suggestions) must exclude these ingredients. `null` means unknown, not "no allergies".

**Success — `200`:**

```json
{
  "success": true,
  "message": "Preferences saved successfully",
  "data": {
    "user": {
      "id": "usr_7f3c2a",
      "name": "Alex Morgan",
      "email": "alex@example.com",
      "avatar_url": null,
      "profile_completed": true
    }
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Validation failed | e.g. `household_size` |

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "household_size": ["The household size must be between 1 and 5."]
  }
}
```

**Mock files:**  
`assets/mocks/profile/put_preferences.json`,  
`assets/mocks/profile/put_preferences_422.json`
