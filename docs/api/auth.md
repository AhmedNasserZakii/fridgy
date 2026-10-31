# Auth API

> Shared rules (envelope, errors, auth, naming): see [README.md](README.md).

**Screens using this:** Sign Up, Sign In, token refresh (interceptor)
**Auth required:** no (all three endpoints are public)

## Data objects

### `User`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | User id |
| `name` | string | no | Full name |
| `email` | string | no | Email address |
| `avatar_url` | string | yes | Absolute image URL, or `null` |
| `profile_completed` | boolean | no | `false` until preferences are saved |

### `AuthSession`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `access_token` | string | no | Short-lived JWT |
| `refresh_token` | string | no | Long-lived refresh token |
| `expires_in` | number | no | Access token lifetime in seconds |
| `user` | User | no | Authenticated user |

---

## 1. Register

`POST /auth/register`

**When the app calls it:** User taps **Create account** on Sign Up.

**Path params:** none  
**Query params:** none

**Request body:**

```json
{
  "name": "Alex Morgan",
  "email": "alex@example.com",
  "password": "password123"
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `name` | string | yes | Trimmed, 2–50 characters |
| `email` | string | yes | Valid email |
| `password` | string | yes | At least 8 characters |

**Success — `201`:**

```json
{
  "success": true,
  "message": "Account created successfully",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.register_access",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.register_refresh",
    "expires_in": 3600,
    "user": {
      "id": "usr_7f3c2a",
      "name": "Alex Morgan",
      "email": "alex@example.com",
      "avatar_url": null,
      "profile_completed": false
    }
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `409` | Email already registered | `null` |
| `422` | Validation failed | `email`, `password` (and/or `name`) |

Example `409`:

```json
{
  "success": false,
  "message": "This email is already registered.",
  "errors": null
}
```

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "email": ["The email field must be a valid email address."],
    "password": ["The password must be at least 8 characters."]
  }
}
```

**Mock files:**  
`assets/mocks/auth/post_register.json`,  
`assets/mocks/auth/post_register_409.json`,  
`assets/mocks/auth/post_register_422.json`

---

## 2. Login

`POST /auth/login`

**When the app calls it:** User taps **Sign in**.

**Path params:** none  
**Query params:** none

**Request body:**

```json
{
  "email": "alex@example.com",
  "password": "password123"
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `email` | string | yes | Valid email |
| `password` | string | yes | At least 8 characters (client); server may return 401 |

**Success — `200`:**

```json
{
  "success": true,
  "message": "Logged in successfully",
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.login_access",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.login_refresh",
    "expires_in": 3600,
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

App routing after login: `profile_completed == false` → Profile Setup; otherwise → Home.

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `401` | Wrong credentials | `null` |
| `422` | Validation failed | `email` |

Example `401`:

```json
{
  "success": false,
  "message": "Invalid email or password.",
  "errors": null
}
```

**Mock files:**  
`assets/mocks/auth/post_login.json`,  
`assets/mocks/auth/post_login_profile_incomplete.json`,  
`assets/mocks/auth/post_login_401.json`,  
`assets/mocks/auth/post_login_422.json`

---

## 3. Refresh

`POST /auth/refresh`

**When the app calls it:** Automatically by the token interceptor when an authenticated request returns `401`.

**Path params:** none  
**Query params:** none

**Request body:**

```json
{
  "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.login_refresh"
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `refresh_token` | string | yes | Current refresh token |

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "access_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.refreshed_access",
    "refresh_token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.refreshed_refresh",
    "expires_in": 3600,
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

**Rotation:** every refresh returns a **new** refresh token, and the old one becomes invalid. The app always saves both new tokens. `user` must reflect the current server state (e.g. `profile_completed`); the app updates its cached user from it.

**Errors:** `401` if the refresh token is invalid, expired or already used. The app then clears the session and goes to Sign In.

```json
{
  "success": false,
  "message": "Your session has expired. Please sign in again.",
  "errors": null
}
```

**Backend rules for all auth endpoints:**
- Treat email as **case-insensitive** and trim it: `Alex@Example.com` and `alex@example.com` are the same account (that's a `409` on register).
- Login `401` must not reveal whether the email exists. Use the same message for "wrong email" and "wrong password".
- Register returns `201` with `profile_completed: false`.

**Mock files:** `assets/mocks/auth/post_refresh.json`, `assets/mocks/auth/post_refresh_401.json`

---

## 4. Logout

`POST /auth/logout`

Documented with the More settings contract in [more.md](more.md). Invalidates the refresh token; the app clears local session afterward.
