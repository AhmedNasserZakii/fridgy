# More / Settings API

> Shared rules (envelope, errors, auth, naming): see [README.md](README.md).

**Screens using this:** More hub, Edit Profile, Notification Settings, Food Preferences (edit mode)
**Auth required:** yes (Bearer access token), except where noted for logout behavior

## Data objects

### `User`

Same as [auth.md](auth.md) `User`.

### `NotificationSettings`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `os_permission_granted` | boolean | no | OS permission preview flag (read-only for the app) |
| `expiry_reminders_enabled` | boolean | no | |
| `remind_days_before` | number | no | Integer 1–14 |
| `reminder_time` | string | no | `HH:mm` 24h |
| `timezone` | string | no | IANA timezone, e.g. `Africa/Cairo` |
| `shopping_list_updates` | boolean | no | |
| `household_activity` | boolean | no | |
| `weekly_impact_recap` | boolean | no | |

### `ProfilePreferences`

Same fields as the PUT body in [profile.md](profile.md) (`household_size`, `favorite_food_ids`, `diet_id`, `avoid_ingredient_ids`, `works_out`, `workout_frequency`, `notifications_enabled`).

---

## 1. Update profile

`PUT /profile`

**When the app calls it:** User taps **Save changes** on Edit Profile.

**Request body:**

```json
{
  "name": "Alex Hassan",
  "email": "alex.hassan@example.com"
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `name` | string | yes | 2–50 chars after trim |
| `email` | string | yes | Valid email; case-insensitive unique |

**Success — `200`:**

```json
{
  "success": true,
  "message": "Profile updated successfully",
  "data": {
    "user": {
      "id": "usr_7f3c2a",
      "name": "Alex Hassan",
      "email": "alex.hassan@example.com",
      "avatar_url": null,
      "profile_completed": true
    }
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Validation failed | `name`, `email` |

**Mock files:** `assets/mocks/profile/put_profile.json`, `assets/mocks/profile/put_profile_422.json`

---

## 2. Get preferences

`GET /profile/preferences`

**When the app calls it:** Food Preferences edit mode opens from More.

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "household_size": 2,
    "favorite_food_ids": ["italian", "healthy_and_light", "egyptian_classics"],
    "diet_id": "no_specific_diet",
    "avoid_ingredient_ids": ["peanuts", "shellfish"],
    "works_out": true,
    "workout_frequency": "days_3_4",
    "notifications_enabled": true
  }
}
```

**Mock files:** `assets/mocks/profile/get_preferences.json`

---

## 3. Logout

`POST /auth/logout`

**When the app calls it:** User taps **Sign out** on More.

**Request body:** none (Bearer access token). Backend should invalidate the refresh token associated with the session.

**Success — `200`:**

```json
{
  "success": true,
  "message": "Signed out successfully",
  "data": null
}
```

**Client behavior:** always clears local tokens and cached user after the attempt, even if the network call fails.

**Mock files:** `assets/mocks/auth/post_logout.json`

---

## 4. Get notification settings

`GET /notification-settings`

**When the app calls it:** Notification Settings screen opens.

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "os_permission_granted": true,
    "expiry_reminders_enabled": true,
    "remind_days_before": 2,
    "reminder_time": "09:00",
    "timezone": "Africa/Cairo",
    "shopping_list_updates": true,
    "household_activity": true,
    "weekly_impact_recap": false
  }
}
```

**Mock files:** `assets/mocks/notification_settings/get_notification_settings.json`

---

## 5. Update notification settings

`PUT /notification-settings`

**When the app calls it:** User toggles a setting or changes remind-days on Notification Settings.

**Request body:** same fields as `NotificationSettings` **except** `os_permission_granted` (OS-owned).

```json
{
  "expiry_reminders_enabled": true,
  "remind_days_before": 2,
  "reminder_time": "09:00",
  "timezone": "Africa/Cairo",
  "shopping_list_updates": true,
  "household_activity": true,
  "weekly_impact_recap": false
}
```

**Success — `200`:** full `NotificationSettings` object in `data` (including `os_permission_granted`).

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Invalid remind days / time | `remind_days_before`, `reminder_time` |

**Mock files:** `assets/mocks/notification_settings/put_notification_settings.json`, `assets/mocks/notification_settings/put_notification_settings_422.json`
