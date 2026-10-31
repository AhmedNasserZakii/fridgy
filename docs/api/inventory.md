# Inventory API

> Shared rules (envelope, errors, auth, naming, pagination): see [README.md](README.md).

**Screens using this:** My Fridge, Add Food (manual), Food Detail, Food Edit, Search, Expiring Soon (Home “Use first” uses the same `FoodItem` shape)  
**Auth required:** yes (Bearer access token on every endpoint below)

## Data objects

### `FoodItem`

Single inventory row returned in list endpoints and as `data` on get / create / update.

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Item id |
| `name` | string | no | Display name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `quantity` | number | no | Amount on hand; may be decimal (e.g. `1.5`). **`0` = out of stock** |
| `unit` | string | yes | `g` \| `kg` \| `ml` \| `l` \| `pcs`, or `null` |
| `storage` | string | yes | `fridge` \| `freezer` \| `pantry`, or `null` |
| `category` | string | yes | `vegetables` \| `fruits` \| `dairy` \| `meat` \| `bakery` \| `other`, or `null` |
| `is_partly_used` | boolean | no | Whether the user marked the item as partly used |
| `purchase_date` | string | yes | Date-only `YYYY-MM-DD`, or `null` |
| `expiry_date` | string | yes | Date-only `YYYY-MM-DD`, or `null` if no expiry tracked |
| `days_left` | number | yes | Server-computed days until `expiry_date`; `null` when `expiry_date` is `null` |
| `expiry_status` | string | yes | Server-computed: `fresh` \| `use_soon` \| `expired`; `null` when `expiry_date` is `null` |
| `added_at` | string | no | ISO 8601 datetime UTC when the item was added |

When `expiry_date` is `null`, `days_left` and `expiry_status` must also be `null`. Out-of-stock items (`quantity == 0`) may still carry `expiry_status` from the server; the app treats stock state from `quantity` only.

### Create / update request body

Same JSON shape for `POST /inventory` and `PUT /inventory/{id}`. The app always sends every key below (missing optional values are `null`).

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `name` | string | yes | Non-empty (see `422` mock) |
| `category` | string | no | Food category enum, or `null` |
| `quantity` | number | yes | `>= 0` (see `422` mock) |
| `unit` | string | no | Unit enum, or `null` |
| `storage` | string | no | Storage enum, or `null` |
| `purchase_date` | string | no | Date-only `YYYY-MM-DD`, or `null` |
| `expiry_date` | string | no | Date-only `YYYY-MM-DD`, or `null`; must be valid when present |
| `image_url` | string | no | Absolute URL string, or `null` (no multipart upload in the app yet) |
| `is_partly_used` | boolean | yes | |

Example body (matches create flow):

```json
{
  "name": "Cucumbers",
  "category": "vegetables",
  "quantity": 2,
  "unit": "pcs",
  "storage": "fridge",
  "purchase_date": "2026-10-28",
  "expiry_date": "2026-11-04",
  "image_url": null,
  "is_partly_used": false
}
```

---

## 1. List inventory

`GET /inventory`

**When the app calls it:** My Fridge tab opens, pull-to-refresh, pagination, storage/category chips, search field, filter sheet (status, expires-within, sort).

**Path params:** none

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `storage` | string | no | `fridge` \| `freezer` \| `pantry`; omit = all |
| `category` | string | no | Food category enum; omit = all |
| `q` | string | no | Name search; omitted when empty after trim |
| `status` | string | no | `fresh` \| `use_soon` \| `expired` \| `out_of_stock` (`out_of_stock` ⇒ `quantity == 0`) |
| `expires_within_days` | number | no | App uses `3` or `7` from the filter sheet |
| `sort` | string | no | `expiry_asc` (default) \| `expiry_desc` \| `name_asc` |
| `include_out_of_stock` | boolean | no | App always sends this; default **`true`** in list requests so qty=0 rows can appear in the footer |
| `page` | number | no | Starts at 1; default 1 |
| `limit` | number | no | Default 20; max 100 per [README.md](README.md) |

**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "itm_9a21",
      "name": "Baby Spinach",
      "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 250,
      "unit": "g",
      "storage": "fridge",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-25",
      "expiry_date": "2026-10-30",
      "days_left": 1,
      "expiry_status": "use_soon",
      "added_at": "2026-10-25T18:20:00Z"
    },
    {
      "id": "itm_2b18",
      "name": "Chicken Breast",
      "image_url": "https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 500,
      "unit": "g",
      "storage": "fridge",
      "category": "meat",
      "is_partly_used": false,
      "purchase_date": "2026-10-27",
      "expiry_date": "2026-10-30",
      "days_left": 1,
      "expiry_status": "use_soon",
      "added_at": "2026-10-27T09:15:00Z"
    },
    {
      "id": "itm_7c44",
      "name": "Strawberries",
      "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 300,
      "unit": "g",
      "storage": "fridge",
      "category": "fruits",
      "is_partly_used": false,
      "purchase_date": "2026-10-26",
      "expiry_date": "2026-10-31",
      "days_left": 2,
      "expiry_status": "use_soon",
      "added_at": "2026-10-26T10:00:00Z"
    },
    {
      "id": "itm_8f33",
      "name": "White Cheese",
      "image_url": "https://images.unsplash.com/photo-1452195100486-9cc805987862?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 200,
      "unit": "g",
      "storage": "fridge",
      "category": "dairy",
      "is_partly_used": false,
      "purchase_date": "2026-10-24",
      "expiry_date": "2026-10-31",
      "days_left": 2,
      "expiry_status": "use_soon",
      "added_at": "2026-10-24T16:45:00Z"
    },
    {
      "id": "itm_4d90",
      "name": "Fresh Milk",
      "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "l",
      "storage": "fridge",
      "category": "dairy",
      "is_partly_used": true,
      "purchase_date": "2026-10-28",
      "expiry_date": "2026-11-01",
      "days_left": 3,
      "expiry_status": "use_soon",
      "added_at": "2026-10-28T08:00:00Z"
    },
    {
      "id": "itm_e012",
      "name": "Bread",
      "image_url": null,
      "quantity": 1,
      "unit": "pcs",
      "storage": "pantry",
      "category": "bakery",
      "is_partly_used": false,
      "purchase_date": "2026-10-29",
      "expiry_date": "2026-11-02",
      "days_left": 4,
      "expiry_status": "fresh",
      "added_at": "2026-10-29T08:30:00Z"
    },
    {
      "id": "itm_e015",
      "name": "Bananas",
      "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 4,
      "unit": "pcs",
      "storage": "pantry",
      "category": "fruits",
      "is_partly_used": false,
      "purchase_date": "2026-10-29",
      "expiry_date": "2026-11-02",
      "days_left": 4,
      "expiry_status": "fresh",
      "added_at": "2026-10-29T07:00:00Z"
    },
    {
      "id": "itm_e002",
      "name": "Tomatoes",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 6,
      "unit": "pcs",
      "storage": "fridge",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-28",
      "expiry_date": "2026-11-03",
      "days_left": 5,
      "expiry_status": "fresh",
      "added_at": "2026-10-28T11:00:00Z"
    },
    {
      "id": "itm_e003",
      "name": "Cucumbers",
      "image_url": "https://images.unsplash.com/photo-1449301253381-0d682b1f0a0a?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 3,
      "unit": "pcs",
      "storage": "fridge",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-28",
      "expiry_date": "2026-11-04",
      "days_left": 6,
      "expiry_status": "fresh",
      "added_at": "2026-10-28T11:05:00Z"
    },
    {
      "id": "itm_e011",
      "name": "Greek Yogurt",
      "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 2,
      "unit": "pcs",
      "storage": "fridge",
      "category": "dairy",
      "is_partly_used": false,
      "purchase_date": "2026-10-29",
      "expiry_date": "2026-11-04",
      "days_left": 6,
      "expiry_status": "fresh",
      "added_at": "2026-10-29T09:00:00Z"
    },
    {
      "id": "itm_e001",
      "name": "Eggs",
      "image_url": "https://images.unsplash.com/photo-1582722877110-4f7d4b0b3b3a?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 4,
      "unit": "pcs",
      "storage": "fridge",
      "category": "other",
      "is_partly_used": false,
      "purchase_date": "2026-10-20",
      "expiry_date": "2026-11-05",
      "days_left": 7,
      "expiry_status": "fresh",
      "added_at": "2026-10-20T12:00:00Z"
    },
    {
      "id": "itm_e004",
      "name": "Bell Peppers",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 2,
      "unit": "pcs",
      "storage": "fridge",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-27",
      "expiry_date": "2026-11-05",
      "days_left": 7,
      "expiry_status": "fresh",
      "added_at": "2026-10-27T14:00:00Z"
    },
    {
      "id": "itm_e010",
      "name": "Cheddar",
      "image_url": "https://images.unsplash.com/photo-1452195100486-9cc805987862?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 150,
      "unit": "g",
      "storage": "fridge",
      "category": "dairy",
      "is_partly_used": true,
      "purchase_date": "2026-10-21",
      "expiry_date": "2026-11-08",
      "days_left": 10,
      "expiry_status": "fresh",
      "added_at": "2026-10-21T13:00:00Z"
    },
    {
      "id": "itm_e006",
      "name": "Carrots",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 500,
      "unit": "g",
      "storage": "fridge",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-22",
      "expiry_date": "2026-11-10",
      "days_left": 12,
      "expiry_status": "fresh",
      "added_at": "2026-10-22T10:00:00Z"
    },
    {
      "id": "itm_e017",
      "name": "Oranges",
      "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 4,
      "unit": "pcs",
      "storage": "fridge",
      "category": "fruits",
      "is_partly_used": false,
      "purchase_date": "2026-10-26",
      "expiry_date": "2026-11-10",
      "days_left": 12,
      "expiry_status": "fresh",
      "added_at": "2026-10-26T12:00:00Z"
    },
    {
      "id": "itm_e016",
      "name": "Apples",
      "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 5,
      "unit": "pcs",
      "storage": "fridge",
      "category": "fruits",
      "is_partly_used": false,
      "purchase_date": "2026-10-25",
      "expiry_date": "2026-11-12",
      "days_left": 14,
      "expiry_status": "fresh",
      "added_at": "2026-10-25T12:00:00Z"
    },
    {
      "id": "itm_e005",
      "name": "Potatoes",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "kg",
      "storage": "pantry",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-15",
      "expiry_date": "2026-11-15",
      "days_left": 17,
      "expiry_status": "fresh",
      "added_at": "2026-10-15T09:00:00Z"
    },
    {
      "id": "itm_e018",
      "name": "Lemons",
      "image_url": "https://images.unsplash.com/photo-1464965911861-746a04b4bca6?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 3,
      "unit": "pcs",
      "storage": "fridge",
      "category": "fruits",
      "is_partly_used": false,
      "purchase_date": "2026-10-20",
      "expiry_date": "2026-11-15",
      "days_left": 17,
      "expiry_status": "fresh",
      "added_at": "2026-10-20T12:00:00Z"
    },
    {
      "id": "itm_e007",
      "name": "Onions",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "kg",
      "storage": "pantry",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-10",
      "expiry_date": "2026-11-20",
      "days_left": 22,
      "expiry_status": "fresh",
      "added_at": "2026-10-10T08:00:00Z"
    },
    {
      "id": "itm_e008",
      "name": "Garlic",
      "image_url": "https://images.unsplash.com/photo-1546470427-e26264be0d40?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 2,
      "unit": "pcs",
      "storage": "pantry",
      "category": "vegetables",
      "is_partly_used": false,
      "purchase_date": "2026-10-10",
      "expiry_date": "2026-11-20",
      "days_left": 22,
      "expiry_status": "fresh",
      "added_at": "2026-10-10T08:10:00Z"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 25,
    "last_page": 2
  }
}
```

**Empty list — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "last_page": 1
  }
}
```

**Errors:** standard auth / server errors (`401`, `500`, …). No dedicated list error mocks in the app.

**Mock files:** `assets/mocks/inventory/get_inventory.json`, `assets/mocks/inventory/get_inventory_empty.json`

---

## 2. Get inventory item

`GET /inventory/{id}`

**When the app calls it:** Food Detail and Edit screens load an item by id.

**Path params:** `id` (string) — inventory item id

**Query params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "itm_9a21",
    "name": "Baby Spinach",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 250,
    "unit": "g",
    "storage": "fridge",
    "category": "vegetables",
    "is_partly_used": false,
    "purchase_date": "2026-10-25",
    "expiry_date": "2026-10-30",
    "days_left": 1,
    "expiry_status": "use_soon",
    "added_at": "2026-10-25T18:20:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown id | `null` |

Example `404`:

```json
{
  "success": false,
  "message": "Food item not found.",
  "errors": null
}
```

**Mock files:** `assets/mocks/inventory/get_inventory_item.json`, `assets/mocks/inventory/get_inventory_item_404.json`

---

## 3. Create inventory item

`POST /inventory`

**When the app calls it:** User submits Add Food (manual) form.

**Path params:** none  
**Query params:** none

**Request body:** see [Create / update request body](#create--update-request-body) above.

**Success — `201`:**

```json
{
  "success": true,
  "message": "Item added successfully",
  "data": {
    "id": "itm_new01",
    "name": "Cucumbers",
    "image_url": "https://images.unsplash.com/photo-1449301253381-0d682b1f0a0a?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 2,
    "unit": "pcs",
    "storage": "fridge",
    "category": "vegetables",
    "is_partly_used": false,
    "purchase_date": "2026-10-28",
    "expiry_date": "2026-11-04",
    "days_left": 6,
    "expiry_status": "fresh",
    "added_at": "2026-10-31T10:00:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Validation failed | `name`, `quantity`, … |

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "name": [
      "The name field is required."
    ],
    "quantity": [
      "The quantity must be at least 0."
    ]
  }
}
```

**Mock files:** `assets/mocks/inventory/post_inventory.json`, `assets/mocks/inventory/post_inventory_422.json`

---

## 4. Update inventory item

`PUT /inventory/{id}`

**When the app calls it:** User submits Edit Food form.

**Path params:** `id` (string)

**Query params:** none

**Request body:** see [Create / update request body](#create--update-request-body) above.

**Success — `200`:**

```json
{
  "success": true,
  "message": "Item updated successfully",
  "data": {
    "id": "itm_9a21",
    "name": "Baby Spinach",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 200,
    "unit": "g",
    "storage": "fridge",
    "category": "vegetables",
    "is_partly_used": false,
    "purchase_date": "2026-10-25",
    "expiry_date": "2026-10-30",
    "days_left": 1,
    "expiry_status": "use_soon",
    "added_at": "2026-10-25T18:20:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown id | `null` |
| `422` | Validation failed | e.g. `expiry_date` |

Example `404`:

```json
{
  "success": false,
  "message": "Food item not found.",
  "errors": null
}
```

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "expiry_date": [
      "The expiry date must be a valid date."
    ]
  }
}
```

**Mock files:** `assets/mocks/inventory/put_inventory.json`, `assets/mocks/inventory/put_inventory_404.json`, `assets/mocks/inventory/put_inventory_422.json`

---

## 5. Mark item consumed

`POST /inventory/{id}/consume`

**When the app calls it:** User taps “Mark as consumed” on Food Detail. The app ignores response `data` (expects `null` on success) and navigates back on success.

**Path params:** `id` (string)

**Query params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": "Item marked as consumed",
  "data": null
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown id | `null` |

Example `404`:

```json
{
  "success": false,
  "message": "Food item not found.",
  "errors": null
}
```

**Mock files:** `assets/mocks/inventory/post_consume.json`, `assets/mocks/inventory/post_consume_404.json`

---

## 6. Search inventory

`GET /inventory/search`

**When the app calls it:** User types in Search (≥ 2 characters). Debounced on the client.

**Path params:** none

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `q` | string | yes | Search text; app sends only when length ≥ 2 |
| `include_out_of_stock` | boolean | no | Default `false` in search params |
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
      "added_at": "2026-10-28T08:00:00Z",
      "category": "dairy",
      "purchase_date": "2026-10-28"
    },
    {
      "id": "itm_6e12",
      "name": "Minced Beef",
      "image_url": "https://images.unsplash.com/photo-1603048588665-791ca8aea617?auto=format&fit=crop&w=200&h=200&q=80",
      "quantity": 500,
      "unit": "g",
      "storage": "freezer",
      "is_partly_used": false,
      "expiry_date": "2026-12-15",
      "days_left": 45,
      "expiry_status": "fresh",
      "added_at": "2026-10-20T14:30:00Z",
      "category": "other",
      "purchase_date": "2026-10-20"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 2,
    "last_page": 1
  }
}
```

**Empty results — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 0,
    "last_page": 1
  }
}
```

**Errors:** standard auth / server errors (`401`, `500`, …). No error scenario mocks for search.

**Mock files:** `assets/mocks/inventory/get_search.json`, `assets/mocks/inventory/get_search_empty.json`

---

## 7. List expiring items

`GET /inventory/expiring`

**When the app calls it:** Expiring Soon screen opens / refreshes / loads more; Home “See all” on Use First.

**Path params:** none

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `sort` | string | no | Default `expiry_asc` (soonest first) |
| `storage` | string | no | Optional filter: `fridge` \| `freezer` \| `pantry` |
| `page` | number | no | Starts at 1; default 1 |
| `limit` | number | no | Default 20; max 100 |

**Request body:** none

**Success — `200`:** items with `expiry_status` `use_soon` or `expired` (same rule as Home `expiring_soon_count` / `use_first`).

```json
{
  "success": true,
  "message": null,
  "data": [
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
      "added_at": "2026-10-25T18:20:00Z",
      "category": "vegetables",
      "purchase_date": "2026-10-25"
    },
    {
      "id": "itm_2b18",
      "name": "Chicken Breast",
      "image_url": "https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=200&h=200&q=80",
      "quantity": 500,
      "unit": "g",
      "storage": "fridge",
      "is_partly_used": false,
      "expiry_date": "2026-10-30",
      "days_left": 1,
      "expiry_status": "use_soon",
      "added_at": "2026-10-27T09:15:00Z",
      "category": "meat",
      "purchase_date": "2026-10-27"
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
      "added_at": "2026-10-26T10:00:00Z",
      "category": "fruits",
      "purchase_date": "2026-10-26"
    },
    {
      "id": "itm_8f33",
      "name": "White Cheese",
      "image_url": "https://images.unsplash.com/photo-1452195100486-9cc805987862?auto=format&fit=crop&w=200&h=200&q=80",
      "quantity": 200,
      "unit": "g",
      "storage": "fridge",
      "is_partly_used": false,
      "expiry_date": "2026-10-31",
      "days_left": 2,
      "expiry_status": "use_soon",
      "added_at": "2026-10-24T16:45:00Z",
      "category": "dairy",
      "purchase_date": "2026-10-24"
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
      "added_at": "2026-10-28T08:00:00Z",
      "category": "dairy",
      "purchase_date": "2026-10-28"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 5,
    "last_page": 1
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
    "last_page": 1
  }
}
```

**Errors:** standard auth / server errors (`401`, `500`, …).

**Backend note:** When Home includes an id in `use_first`, that `FoodItem` object should match this endpoint for the same id.

**Mock files:** `assets/mocks/inventory/get_expiring.json`, `assets/mocks/inventory/get_expiring_empty.json`

---

## Mock files (inventory)

| File | Scenario |
| --- | --- |
| `assets/mocks/inventory/get_inventory.json` | List success (paginated) |
| `assets/mocks/inventory/get_inventory_empty.json` | List empty |
| `assets/mocks/inventory/get_inventory_item.json` | Get by id success |
| `assets/mocks/inventory/get_inventory_item_404.json` | Get by id not found |
| `assets/mocks/inventory/post_inventory.json` | Create success (`201`) |
| `assets/mocks/inventory/post_inventory_422.json` | Create validation error |
| `assets/mocks/inventory/put_inventory.json` | Update success |
| `assets/mocks/inventory/put_inventory_404.json` | Update not found |
| `assets/mocks/inventory/put_inventory_422.json` | Update validation error |
| `assets/mocks/inventory/post_consume.json` | Consume success |
| `assets/mocks/inventory/post_consume_404.json` | Consume not found |
| `assets/mocks/inventory/get_search.json` | Search success |
| `assets/mocks/inventory/get_search_empty.json` | Search empty |
| `assets/mocks/inventory/get_expiring.json` | Expiring list success |
| `assets/mocks/inventory/get_expiring_empty.json` | Expiring list empty |

## Open questions for backend

- Exact server behavior for **consume** (delete row vs set `quantity` to `0`) — the app only requires `200` with `data: null` and then refreshes lists.
- Thresholds for **`use_soon` vs `fresh` vs `expired`** (must stay consistent with Home `kitchen_summary.expiring_soon_count` and `use_first`).
- Whether **`include_out_of_stock=false`** should hide qty=0 items when no `status=out_of_stock` filter is set (app relies on this for My Fridge footer vs active list).
