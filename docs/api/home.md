# Home API

> Shared rules (envelope, errors, auth, naming): see [README.md](README.md).

**Screens using this:** Home tab  
**Auth required:** yes (Bearer access token)

## Data objects

### `KitchenSummary`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `total_items` | number | no | Total inventory items in the kitchen |
| `expiring_soon_count` | number | no | Items with `expiry_status` `use_soon` or `expired` (same rule as `GET inventory/expiring`) |

### `Money`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `amount` | number | no | Major currency units (e.g. EGP, not piasters) |
| `currency` | string | no | ISO 4217 code, e.g. `EGP` |

### `WeeklyImpact`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `saved_items_count` | number | no | Items saved from waste this week |
| `goal_items_count` | number | no | Server-side weekly goal (not editable in the app yet) |
| `estimated_savings` | Money | no | Estimated money saved this week |
| `week_start` | string | no | Week boundary as date-only ISO `YYYY-MM-DD` (UTC/server-defined) |

### `Suggestion`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Suggestion id |
| `title` | string | no | Short dish / recipe name (localized by server via `Accept-Language`) |
| `description` | string | no | Longer suggestion line (localized by server) |
| `recipe_id` | string | yes | Future recipe screen id |
| `uses_item_ids` | string[] | no | Inventory item ids this suggestion uses |

### `FoodItem`

Shared with [inventory.md](inventory.md). See that file.

---

## 1. Get home dashboard

`GET /home`

**When the app calls it:** Home tab opens, pull-to-refresh, and after returning from Notifications (to refresh the bell unread count).

**Path params:** none  
**Query params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "kitchen_summary": {
      "total_items": 24,
      "expiring_soon_count": 5
    },
    "unread_notifications_count": 3,
    "use_first": [
      {
        "id": "itm_9a21",
        "name": "Baby Spinach",
        "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=200&h=200&q=80",
        "quantity": 250,
        "unit": "g",
        "storage": "fridge",
        "is_partly_used": false,
        "expiry_date": "2026-10-30",
        "days_left": 1,
        "expiry_status": "use_soon",
        "added_at": "2026-10-25T18:20:00Z"
      },
      {
        "id": "itm_7c44",
        "name": "Strawberries",
        "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=200&h=200&q=80",
        "quantity": 300,
        "unit": "g",
        "storage": "fridge",
        "is_partly_used": false,
        "expiry_date": "2026-10-31",
        "days_left": 2,
        "expiry_status": "use_soon",
        "added_at": "2026-10-26T10:00:00Z"
      },
      {
        "id": "itm_4d90",
        "name": "Fresh Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=200&h=200&q=80",
        "quantity": 1,
        "unit": "l",
        "storage": "fridge",
        "is_partly_used": true,
        "expiry_date": "2026-11-01",
        "days_left": 3,
        "expiry_status": "use_soon",
        "added_at": "2026-10-28T08:00:00Z"
      }
    ],
    "weekly_impact": {
      "saved_items_count": 8,
      "goal_items_count": 10,
      "estimated_savings": {
        "amount": 420,
        "currency": "EGP"
      },
      "week_start": "2026-10-25"
    },
    "suggestion": {
      "id": "sug_3e7b",
      "title": "Your spinach is almost due. How about a quick omelet tonight?",
      "description": "Your spinach is almost due. How about a quick omelet tonight?",
      "recipe_id": "rcp_omelet_01",
      "uses_item_ids": ["itm_9a21"]
    }
  }
}
```

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `kitchen_summary` | KitchenSummary | no | Totals for the hero card |
| `unread_notifications_count` | number | no | Drives the Home bell badge |
| `use_first` | FoodItem[] | no | Max 3 items, soonest expiry first, only `use_soon` / `expired`. Same objects as in `GET inventory/expiring` when ids overlap. Empty array when none. |
| `weekly_impact` | WeeklyImpact \| null | yes | `null` when there is no data yet (e.g. new user) — app hides the section |
| `suggestion` | Suggestion \| null | yes | `null` when nothing to suggest — app hides the section |

**Empty / new-user success** (`weekly_impact` and `suggestion` null, zeros, empty `use_first`):

```json
{
  "success": true,
  "message": null,
  "data": {
    "kitchen_summary": {
      "total_items": 0,
      "expiring_soon_count": 0
    },
    "unread_notifications_count": 0,
    "use_first": [],
    "weekly_impact": null,
    "suggestion": null
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `401` | Missing / invalid access token | `null` |
| `500` | Server error | `null` |

Example `500`:

```json
{
  "success": false,
  "message": "Something went wrong. Please try again.",
  "errors": null
}
```

**Backend rules:**
- Use the **same** “expiring soon” rule for `expiring_soon_count`, `use_first`, and `GET inventory/expiring`.
- `use_first` items must be complete `FoodItem` objects (not stubs).
- `title` and `description` on `suggestion` are already localized; the app displays them as-is.

**Mock files:**  
`assets/mocks/home/get_home.json`,  
`assets/mocks/home/get_home_empty.json`,  
`assets/mocks/home/get_home_500.json`
