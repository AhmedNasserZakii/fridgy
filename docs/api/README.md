# Fridgy API — Shared Conventions

> **For the backend developer.** This file defines the rules that apply to **every** endpoint. Each feature has its own file in this folder (`docs/api/<feature>.md`) with its endpoints. `STATUS.md` tracks which endpoints are ready for you to build and which are already live.
>
> The mobile app is already built against these exact shapes. If something here is a problem for the backend, raise it **before** implementing — changing a shape later means changing the app.

*Status: PROPOSED — to be confirmed with the backend developer.*

---

## 1. Basics

| Rule | Value |
| --- | --- |
| Base URL | `https://<host>/api/v1/` |
| Format | JSON (`Content-Type: application/json`), UTF-8. File uploads use `multipart/form-data`. |
| Key naming | `snake_case` for all JSON keys and query params |
| IDs | Strings (UUID recommended). Never assume numeric. |
| Dates | ISO 8601 in UTC: `"2026-10-31T14:05:00Z"`. Date-only values (e.g. expiry date): `"2026-11-05"` |
| Booleans | Real JSON booleans, never `"true"` / `1` |
| Missing values | Key is **always present**; value is `null`. Don't omit keys. |
| Enums | Lowercase `snake_case` strings, e.g. `"fridge"`, `"freezer"`, `"pantry"` |
| Images | Absolute URLs (`"https://cdn…/x.jpg"`) or `null` |
| Language | App sends `Accept-Language: en` or `ar`; translatable `message` text should follow it |

## 2. Headers the app sends

```http
Accept: application/json
Content-Type: application/json
Accept-Language: en
Authorization: Bearer <access_token>      # only on authenticated endpoints
```

## 3. Success response envelope

Every successful response (2xx) has this shape:

```json
{
  "success": true,
  "message": "Item added successfully",
  "data": { }
}
```

- `data` is an object for single resources, an array for lists, or `null` when there's nothing to return (e.g. delete).
- `message` is a short human-readable string (may be shown to the user as a toast) or `null`.

### Paginated lists

```json
{
  "success": true,
  "message": null,
  "data": [ { }, { } ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 57,
    "last_page": 3
  }
}
```

Query params: `?page=1&limit=20` (page starts at 1, default limit 20, max 100).

## 4. Error response envelope

Every error (4xx / 5xx) has this shape:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email field is required."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

- `message` is always present and user-readable — the app shows it when there are no field errors.
- `errors` is an object of `field -> [messages]` for validation errors (422), otherwise `null`.

| Status | When |
| --- | --- |
| `400` | Malformed request |
| `401` | Missing / invalid / expired access token |
| `403` | Authenticated but not allowed |
| `404` | Resource not found |
| `409` | Conflict (e.g. email already registered) |
| `422` | Validation failed (`errors` filled) |
| `429` | Rate limited (e.g. OTP resend) |
| `500` | Server error (`message` generic, no stack traces) |

## 5. Authentication

- Login / register return:

```json
{
  "success": true,
  "message": "Logged in successfully",
  "data": {
    "access_token": "eyJ...",
    "refresh_token": "eyJ...",
    "expires_in": 3600,
    "user": { "id": "…", "name": "…", "email": "…" }
  }
}
```

- `access_token`: short-lived JWT, sent as `Authorization: Bearer …`.
- `POST /auth/refresh` with `{ "refresh_token": "…" }` returns a new pair in the same shape. Called automatically by the app on `401`.
- `POST /auth/logout` invalidates the refresh token.

## 6. Versioning & changes

- Breaking changes go to `/api/v2/`. Adding new optional fields is not breaking.
- Every endpoint doc in this folder shows the exact request and response JSON. The app parses those exact keys — **renaming a key breaks the app**.
