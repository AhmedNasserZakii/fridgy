# Notifications API

> Shared rules (envelope, errors, auth, naming, pagination): see [README.md](README.md).

**Screens using this:** Notifications  
**Auth required:** yes (Bearer access token)

## Data objects

### `NotificationAction`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `type` | string | no | `food_item` \| `shopping_list` \| `meal_plan` |
| `id` | string | no | Target resource id |

### `Notification`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Notification id |
| `type` | string | no | `expiry_reminder` \| `household_update` \| `meal_plan` |
| `title` | string | no | Already localized by the server (`Accept-Language`) |
| `body` | string | no | Already localized by the server |
| `image_url` | string | yes | Absolute image URL, or `null` (app uses a type fallback icon) |
| `is_read` | boolean | no | Read state |
| `created_at` | string | no | ISO 8601 datetime UTC |
| `action` | NotificationAction | yes | `null` or deep-link target; app shows a chevron when non-null |

### Pagination `meta` extension

Standard pagination keys from [README.md](README.md) §3, plus:

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `unread_count` | number | no | Total unread notifications (for the “{n} unread” chip). Required on list responses. |

---

## 1. List notifications

`GET /notifications`

**When the app calls it:** Notifications screen opens / refreshes / loads more.

**Path params:** none  

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `page` | number | no | Starts at 1; default 1 |
| `limit` | number | no | Default 20; max 100 |

**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "ntf_51c0",
      "type": "expiry_reminder",
      "title": "Spinach is up next",
      "body": "250 g · entered date 30 Oct · 1 day left",
      "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=200&h=200&q=80",
      "is_read": false,
      "created_at": "2026-10-31T07:00:00Z",
      "action": {
        "type": "food_item",
        "id": "itm_9a21"
      }
    },
    {
      "id": "ntf_51c1",
      "type": "expiry_reminder",
      "title": "Chicken for tonight?",
      "body": "500 g · entered date 30 Oct · 1 day left",
      "image_url": "https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=200&h=200&q=80",
      "is_read": false,
      "created_at": "2026-10-31T07:00:00Z",
      "action": {
        "type": "food_item",
        "id": "itm_2b18"
      }
    },
    {
      "id": "ntf_51c2",
      "type": "household_update",
      "title": "Nour updated the shopping list",
      "body": "Added eggs and bread to your shared list.",
      "image_url": null,
      "is_read": false,
      "created_at": "2026-10-31T06:42:00Z",
      "action": {
        "type": "shopping_list",
        "id": "shp_01"
      }
    },
    {
      "id": "ntf_51c3",
      "type": "meal_plan",
      "title": "Your weekly plan is ready",
      "body": "Spinach pasta is planned for Thursday.",
      "image_url": null,
      "is_read": true,
      "created_at": "2026-10-30T16:15:00Z",
      "action": {
        "type": "meal_plan",
        "id": "mpl_01"
      }
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 4,
    "last_page": 1,
    "unread_count": 3
  }
}
```

**Empty — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "last_page": 1,
    "unread_count": 0
  }
}
```

**Errors:** standard auth / server errors (`401`, `500`, …).

**Mock files:**  
`assets/mocks/notifications/get_notifications.json`,  
`assets/mocks/notifications/get_notifications_empty.json`

---

## 2. Mark one notification read

`PATCH /notifications/{id}/read`

**When the app calls it:** User taps a notification row (optimistic UI; rolls back on failure).

**Path params:** `id` (string) — notification id  
**Query params:** none  
**Request body:** none

**Success — `200`:** `data` is the updated notification with `is_read: true`.

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "ntf_51c0",
    "type": "expiry_reminder",
    "title": "Spinach is up next",
    "body": "250 g · entered date 30 Oct · 1 day left",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=200&h=200&q=80",
    "is_read": true,
    "created_at": "2026-10-31T07:00:00Z",
    "action": {
      "type": "food_item",
      "id": "itm_9a21"
    }
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown notification id | `null` |

Example `404`:

```json
{
  "success": false,
  "message": "Notification not found.",
  "errors": null
}
```

**Mock files:**  
`assets/mocks/notifications/patch_read.json`,  
`assets/mocks/notifications/patch_read_404.json`

---

## 3. Mark all notifications read

`POST /notifications/read-all`

**When the app calls it:** User taps mark-all-read in the Notifications header.

**Path params:** none  
**Query params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "updated_count": 3
  }
}
```

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `updated_count` | number | no | How many notifications were flipped to read |

**Errors:** standard auth / server errors (`401`, `500`, …).

**Mock files:** `assets/mocks/notifications/post_read_all.json`
