# <Feature name> API

> Shared rules (envelope, errors, auth, naming): see [README.md](README.md).

**Screens using this:** <screen names>
**Auth required:** yes / no

## Data objects

### `<ObjectName>`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | |

---

## 1. <Action name>

`<METHOD> /<path>`

**When the app calls it:** <user action / screen>

**Path params:** none | `id` (string)
**Query params:** none | `page`, `limit`, …

**Request body:**

```json
{}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {}
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | | |

Example `422`:

```json
{
  "success": false,
  "message": "",
  "errors": {}
}
```

**Mock files:** `assets/mocks/<feature>/…json`
