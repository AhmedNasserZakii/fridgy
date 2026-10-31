# Shopping API

> Shared rules (envelope, errors, auth, naming, pagination): see [README.md](../README.md).

**Screens using this:** Shopping hub (List / Store), Add list item, Product detail, Cart, Orders, Order detail, Review → fridge (intake confirm)  
**Auth required:** yes (Bearer access token on every endpoint below)

**Inventory side-effect rule:** Checking list rows, cart changes, and placing an order **must not** create or update inventory. Inventory is created only when the client confirms a fridge intake via `POST /shopping/fridge-intake/{id}/confirm`. Completing a list purchase or marking an order received only returns a `FridgeIntake` draft for review.

**Shared enums** (same as inventory where applicable):

| Enum | Values |
| --- | --- |
| `unit` | `g` \| `kg` \| `ml` \| `l` \| `pcs` |
| `category` | `vegetables` \| `fruits` \| `dairy` \| `meat` \| `bakery` \| `other` |
| `storage` | `fridge` \| `freezer` \| `pantry` |
| `order.status` | `placed` \| `received` \| `added_to_fridge` |
| `fridge_intake.source` | `list` \| `order` |

## Data objects

### `ShoppingListItem`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | List item id |
| `name` | string | no | Display name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `quantity` | number | no | Amount to buy; may be decimal |
| `unit` | string | yes | Unit enum, or `null` |
| `category` | string | yes | Category enum, or `null` |
| `is_checked` | boolean | no | Checked off for purchase / complete |
| `catalog_product_id` | string | yes | Linked catalog product id when added from store, else `null` |
| `notes` | string | yes | Free-text note, or `null` |
| `created_at` | string | no | ISO 8601 datetime UTC |
| `updated_at` | string | no | ISO 8601 datetime UTC |

### `CatalogProduct`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Product id |
| `name` | string | no | Display name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `category` | string | yes | Category enum, or `null` |
| `default_quantity` | number | no | Suggested quantity when adding to cart/list |
| `unit` | string | yes | Unit enum, or `null` |
| `default_storage` | string | yes | Suggested storage for fridge intake, or `null` |
| `price` | number | yes | Unit price, or `null` if not priced |
| `currency` | string | yes | ISO-like currency code (e.g. `EGP`), or `null` when `price` is `null` |

### `CartItem`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Cart line id |
| `catalog_product_id` | string | no | Source catalog product |
| `name` | string | no | Snapshot name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `quantity` | number | no | Line quantity |
| `unit` | string | yes | Unit enum, or `null` |
| `category` | string | yes | Category enum, or `null` |
| `unit_price` | number | no | Price per unit at add time |
| `currency` | string | no | Currency code |
| `line_total` | number | no | `quantity * unit_price` (server-computed) |

### `Cart`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Cart id (one active cart per user/household) |
| `items` | array of `CartItem` | no | May be empty |
| `item_count` | number | no | Count of lines (not sum of quantities) |
| `subtotal` | number | no | Sum of `line_total` |
| `currency` | string | no | Currency code |
| `updated_at` | string | no | ISO 8601 datetime UTC |

### `OrderItem`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Order line id |
| `catalog_product_id` | string | yes | Source product if any, or `null` |
| `name` | string | no | Snapshot name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `quantity` | number | no | Ordered quantity |
| `unit` | string | yes | Unit enum, or `null` |
| `category` | string | yes | Category enum, or `null` |
| `storage` | string | yes | Suggested storage for intake, or `null` |

### `Order`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Order id |
| `status` | string | no | `placed` \| `received` \| `added_to_fridge` |
| `items` | array of `OrderItem` | no | Order lines |
| `item_count` | number | no | Number of lines |
| `placed_at` | string | no | ISO 8601 datetime UTC |
| `received_at` | string | yes | When marked received; `null` until then |
| `added_to_fridge_at` | string | yes | When fridge intake was confirmed; `null` until then |
| `currency` | string | no | Currency code |
| `total` | number | no | Order total |

### `FridgeIntakeLine`

Draft inventory row shown on the review screen. Confirm sends these back (client may edit storage / quantity / dates).

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Line id within the intake |
| `name` | string | no | Food name |
| `image_url` | string | yes | Absolute image URL, or `null` |
| `quantity` | number | no | Amount to add to inventory |
| `unit` | string | yes | Unit enum, or `null` |
| `category` | string | yes | Category enum, or `null` |
| `storage` | string | yes | Storage enum, or `null` |
| `purchase_date` | string | yes | Date-only `YYYY-MM-DD`, or `null` |
| `expiry_date` | string | yes | Date-only `YYYY-MM-DD`, or `null` |

### `FridgeIntake`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Intake id (used in confirm path) |
| `source` | string | no | `list` \| `order` |
| `source_id` | string | yes | Order id when `source` is `order`; otherwise `null` |
| `lines` | array of `FridgeIntakeLine` | no | At least one line on success |
| `created_at` | string | no | ISO 8601 datetime UTC |

### `FridgeIntakeConfirmResult`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `intake_id` | string | no | Confirmed intake id |
| `created_inventory_ids` | array of string | no | New inventory item ids (same order as lines when possible) |
| `created_count` | number | no | `created_inventory_ids.length` |

### Upsert shopping list item body

Used by `POST /shopping/list` and `PUT /shopping/list/{id}`. The app sends every key (`null` when unused).

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `name` | string | yes | Non-empty |
| `quantity` | number | yes | `>= 0.01` |
| `unit` | string | no | Unit enum, or `null` |
| `category` | string | no | Category enum, or `null` |
| `image_url` | string | no | Absolute URL, or `null` |
| `catalog_product_id` | string | no | Catalog id when adding from store, or `null` |
| `notes` | string | no | Free text, or `null` |

Example:

```json
{
  "name": "Cucumbers",
  "quantity": 2,
  "unit": "pcs",
  "category": "vegetables",
  "image_url": null,
  "catalog_product_id": null,
  "notes": null
}
```

---

## 1. Get shopping list

`GET /shopping/list`

**When the app calls it:** Shopping hub List tab opens / pull-to-refresh / after returning from add or fridge confirm.

**Path params:** none  
**Query params:** none  
**Request body:** none

**Success — `200`:** `data` is an array of `ShoppingListItem` (empty array when none).

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "sli_01",
      "name": "Baby Spinach",
      "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 2,
      "unit": "pcs",
      "category": "vegetables",
      "is_checked": false,
      "catalog_product_id": "prd_01",
      "notes": null,
      "created_at": "2026-10-28T10:00:00Z",
      "updated_at": "2026-10-28T10:00:00Z"
    },
    {
      "id": "sli_02",
      "name": "Greek Yogurt",
      "image_url": "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "pcs",
      "category": "dairy",
      "is_checked": true,
      "catalog_product_id": "prd_02",
      "notes": null,
      "created_at": "2026-10-27T09:00:00Z",
      "updated_at": "2026-10-30T12:00:00Z"
    },
    {
      "id": "sli_03",
      "name": "Chicken Breast",
      "image_url": "https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 500,
      "unit": "g",
      "category": "meat",
      "is_checked": false,
      "catalog_product_id": "prd_03",
      "notes": "Boneless",
      "created_at": "2026-10-29T08:00:00Z",
      "updated_at": "2026-10-29T08:00:00Z"
    },
    {
      "id": "sli_04",
      "name": "Bananas",
      "image_url": "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 6,
      "unit": "pcs",
      "category": "fruits",
      "is_checked": true,
      "catalog_product_id": "prd_04",
      "notes": null,
      "created_at": "2026-10-26T11:00:00Z",
      "updated_at": "2026-10-30T11:00:00Z"
    },
    {
      "id": "sli_05",
      "name": "Sourdough Bread",
      "image_url": "https://images.unsplash.com/photo-1549931319-a545dcf3bc73?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "pcs",
      "category": "bakery",
      "is_checked": false,
      "catalog_product_id": null,
      "notes": null,
      "created_at": "2026-10-30T07:00:00Z",
      "updated_at": "2026-10-30T07:00:00Z"
    }
  ]
}
```

**Errors:** standard auth / 500. Empty list is success with `data: []` (see empty mock).

**Mock files:** `get_list.json`, `get_list_empty.json`

---

## 2. Add shopping list item

`POST /shopping/list`

**When the app calls it:** Add list item form submit; Product detail “Add to list”.

**Request body:** Upsert shopping list item body (above).

**Success — `201`:**

```json
{
  "success": true,
  "message": "Item added to shopping list",
  "data": {
    "id": "sli_06",
    "name": "Cucumbers",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 2,
    "unit": "pcs",
    "category": "vegetables",
    "is_checked": false,
    "catalog_product_id": null,
    "notes": null,
    "created_at": "2026-10-31T12:00:00Z",
    "updated_at": "2026-10-31T12:00:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Validation failed | `name`, `quantity`, … |

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "name": [
      "The name field is required."
    ],
    "quantity": [
      "The quantity must be at least 0.01."
    ]
  }
}
```

**Mock files:** `post_list.json`, `post_list_422.json`

---

## 3. Update shopping list item

`PUT /shopping/list/{id}`

**When the app calls it:** Edit an existing list row (quantity / name / etc.).

**Path params:** `id` (string) — list item id  
**Request body:** same Upsert body as create.

**Success — `200`:**

```json
{
  "success": true,
  "message": "Shopping list item updated",
  "data": {
    "id": "sli_01",
    "name": "Baby Spinach",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 3,
    "unit": "pcs",
    "category": "vegetables",
    "is_checked": false,
    "catalog_product_id": "prd_01",
    "notes": null,
    "created_at": "2026-10-28T10:00:00Z",
    "updated_at": "2026-10-31T12:10:00Z"
  }
}
```

**Mock files:** `put_list_item.json`

---

## 4. Delete shopping list item

`DELETE /shopping/list/{id}`

**When the app calls it:** User deletes a row on the List tab.

**Path params:** `id` (string)

**Success — `200`:**

```json
{
  "success": true,
  "message": "Item removed",
  "data": null
}
```

**Mock files:** `delete_list_item.json`

---

## 5. Toggle shopping list item checked

`POST /shopping/list/{id}/toggle`

**When the app calls it:** User taps checkbox / row on the List tab. Flips `is_checked`. Does **not** touch inventory.

**Path params:** `id` (string)  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "sli_01",
    "name": "Baby Spinach",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "quantity": 2,
    "unit": "pcs",
    "category": "vegetables",
    "is_checked": true,
    "catalog_product_id": "prd_01",
    "notes": null,
    "created_at": "2026-10-28T10:00:00Z",
    "updated_at": "2026-10-31T12:15:00Z"
  }
}
```

**Mock files:** `post_list_toggle.json`

---

## 6. Complete list purchase → fridge intake draft

`POST /shopping/list/complete`

**When the app calls it:** “Complete purchase (N)” with at least one checked item. Returns a `FridgeIntake` for the review screen. Does **not** create inventory yet. Server should build lines from **checked** items only.

**Path params:** none  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": "Ready to add to fridge",
  "data": {
    "id": "fi_01",
    "source": "list",
    "source_id": null,
    "lines": [
      {
        "id": "fil_01",
        "name": "Greek Yogurt",
        "image_url": "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "pcs",
        "category": "dairy",
        "storage": "fridge",
        "purchase_date": "2026-10-31",
        "expiry_date": "2026-11-07"
      },
      {
        "id": "fil_02",
        "name": "Bananas",
        "image_url": "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 6,
        "unit": "pcs",
        "category": "fruits",
        "storage": "pantry",
        "purchase_date": "2026-10-31",
        "expiry_date": "2026-11-04"
      }
    ],
    "created_at": "2026-10-31T12:00:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | No checked items | `items` |

```json
{
  "success": false,
  "message": "Select at least one checked item.",
  "errors": {
    "items": [
      "No checked items on the shopping list."
    ]
  }
}
```

**Mock files:** `post_list_complete.json`, `post_list_complete_422.json`

---

## 7. List catalog products

`GET /shopping/catalog`

**When the app calls it:** Store tab opens, search debounce, category chip, pagination.

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `q` | string | no | Name search; omit when empty after trim |
| `category` | string | no | Category enum; omit = all |
| `page` | number | no | Starts at 1; default 1 |
| `limit` | number | no | Default 20; max 100 |

**Success — `200`:** paginated `CatalogProduct` list.

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "prd_01",
      "name": "Baby Spinach",
      "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "vegetables",
      "default_quantity": 1,
      "unit": "pcs",
      "default_storage": "fridge",
      "price": 25.0,
      "currency": "EGP"
    },
    {
      "id": "prd_02",
      "name": "Greek Yogurt",
      "image_url": "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "dairy",
      "default_quantity": 1,
      "unit": "pcs",
      "default_storage": "fridge",
      "price": 45.0,
      "currency": "EGP"
    },
    {
      "id": "prd_03",
      "name": "Chicken Breast",
      "image_url": "https://images.unsplash.com/photo-1604503468506-a8da13d82791?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "meat",
      "default_quantity": 500,
      "unit": "g",
      "default_storage": "fridge",
      "price": 120.0,
      "currency": "EGP"
    },
    {
      "id": "prd_04",
      "name": "Bananas",
      "image_url": "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "fruits",
      "default_quantity": 6,
      "unit": "pcs",
      "default_storage": "pantry",
      "price": 30.0,
      "currency": "EGP"
    },
    {
      "id": "prd_05",
      "name": "Whole Milk",
      "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "dairy",
      "default_quantity": 1,
      "unit": "l",
      "default_storage": "fridge",
      "price": 38.0,
      "currency": "EGP"
    },
    {
      "id": "prd_06",
      "name": "Tomatoes",
      "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
      "category": "vegetables",
      "default_quantity": 1,
      "unit": "kg",
      "default_storage": "fridge",
      "price": 22.0,
      "currency": "EGP"
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 6,
    "last_page": 1
  }
}
```

**Mock files:** `get_catalog.json`, `get_catalog_empty.json`

---

## 8. Get catalog product

`GET /shopping/catalog/{id}`

**When the app calls it:** Product detail screen opens.

**Path params:** `id` (string)

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "prd_01",
    "name": "Baby Spinach",
    "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
    "category": "vegetables",
    "default_quantity": 1,
    "unit": "pcs",
    "default_storage": "fridge",
    "price": 25.0,
    "currency": "EGP"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown product | `null` |

```json
{
  "success": false,
  "message": "Product not found.",
  "errors": null
}
```

**Mock files:** `get_catalog_product.json`, `get_catalog_product_404.json`

---

## 9. Get cart

`GET /shopping/cart`

**When the app calls it:** Shopping hub header badge, Cart screen open / refresh.

**Success — `200`:** always a `Cart` object (empty `items` when empty).

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "cart_01",
    "items": [
      {
        "id": "ci_01",
        "catalog_product_id": "prd_05",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "unit_price": 38.0,
        "currency": "EGP",
        "line_total": 76.0
      },
      {
        "id": "ci_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "unit_price": 22.0,
        "currency": "EGP",
        "line_total": 22.0
      }
    ],
    "item_count": 2,
    "subtotal": 98.0,
    "currency": "EGP",
    "updated_at": "2026-10-30T15:00:00Z"
  }
}
```

**Mock files:** `get_cart.json`, `get_cart_empty.json`

---

## 10. Add cart item

`POST /shopping/cart/items`

**When the app calls it:** Product detail “Add to cart”.

**Request body:**

```json
{
  "catalog_product_id": "prd_01",
  "quantity": 1
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `catalog_product_id` | string | yes | Must exist in catalog |
| `quantity` | number | yes | `> 0` |

**Success — `201`:** full updated `Cart`.

```json
{
  "success": true,
  "message": "Added to cart",
  "data": {
    "id": "cart_01",
    "items": [
      {
        "id": "ci_01",
        "catalog_product_id": "prd_05",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "unit_price": 38.0,
        "currency": "EGP",
        "line_total": 76.0
      },
      {
        "id": "ci_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "unit_price": 22.0,
        "currency": "EGP",
        "line_total": 22.0
      },
      {
        "id": "ci_03",
        "catalog_product_id": "prd_01",
        "name": "Baby Spinach",
        "image_url": "https://images.unsplash.com/photo-1576045057995-568f588f82fb?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "pcs",
        "category": "vegetables",
        "unit_price": 25.0,
        "currency": "EGP",
        "line_total": 25.0
      }
    ],
    "item_count": 3,
    "subtotal": 123.0,
    "currency": "EGP",
    "updated_at": "2026-10-31T12:20:00Z"
  }
}
```

**Mock files:** `post_cart_item.json`

---

## 11. Update cart item quantity

`PUT /shopping/cart/items/{id}`

**When the app calls it:** Cart quantity change.

**Path params:** `id` (string) — cart line id

**Request body:**

```json
{
  "quantity": 3
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `quantity` | number | yes | `> 0` |

**Success — `200`:** full updated `Cart`.

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "cart_01",
    "items": [
      {
        "id": "ci_01",
        "catalog_product_id": "prd_05",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 3,
        "unit": "l",
        "category": "dairy",
        "unit_price": 38.0,
        "currency": "EGP",
        "line_total": 114.0
      },
      {
        "id": "ci_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "unit_price": 22.0,
        "currency": "EGP",
        "line_total": 22.0
      }
    ],
    "item_count": 2,
    "subtotal": 136.0,
    "currency": "EGP",
    "updated_at": "2026-10-31T12:25:00Z"
  }
}
```

**Mock files:** `put_cart_item.json`

---

## 12. Remove cart item

`DELETE /shopping/cart/items/{id}`

**When the app calls it:** Cart delete icon.

**Success — `200`:** full updated `Cart`.

```json
{
  "success": true,
  "message": "Removed from cart",
  "data": {
    "id": "cart_01",
    "items": [
      {
        "id": "ci_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "unit_price": 22.0,
        "currency": "EGP",
        "line_total": 22.0
      }
    ],
    "item_count": 1,
    "subtotal": 22.0,
    "currency": "EGP",
    "updated_at": "2026-10-31T12:30:00Z"
  }
}
```

**Mock files:** `delete_cart_item.json`

---

## 13. Clear cart

`DELETE /shopping/cart`

**When the app calls it:** Clear-all (available in API; UI may not expose yet).

**Success — `200`:** empty `Cart`.

```json
{
  "success": true,
  "message": "Cart cleared",
  "data": {
    "id": "cart_01",
    "items": [],
    "item_count": 0,
    "subtotal": 0.0,
    "currency": "EGP",
    "updated_at": "2026-10-31T12:35:00Z"
  }
}
```

**Mock files:** `delete_cart.json`

---

## 14. Place order

`POST /shopping/orders`

**When the app calls it:** Cart “Place order”. Creates an order from the current cart, clears cart. Status starts as `placed`. Does **not** create inventory.

**Request body:** none

**Success — `201`:**

```json
{
  "success": true,
  "message": "Order placed",
  "data": {
    "id": "ord_01",
    "status": "placed",
    "items": [
      {
        "id": "oi_01",
        "catalog_product_id": "prd_05",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "storage": "fridge"
      },
      {
        "id": "oi_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "storage": "fridge"
      }
    ],
    "item_count": 2,
    "placed_at": "2026-10-30T16:00:00Z",
    "received_at": null,
    "added_to_fridge_at": null,
    "currency": "EGP",
    "total": 98.0
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Cart empty | `cart` |

```json
{
  "success": false,
  "message": "Cart is empty.",
  "errors": {
    "cart": [
      "Add items before placing an order."
    ]
  }
}
```

**Mock files:** `post_order.json`, `post_order_422.json`

---

## 15. List orders

`GET /shopping/orders`

**When the app calls it:** Orders screen open / pull-to-refresh.

**Query params:**

| Param | Type | Required | Rules |
| --- | --- | --- | --- |
| `page` | number | no | Starts at 1; default 1 |
| `limit` | number | no | Default 20; max 100 |

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": [
    {
      "id": "ord_01",
      "status": "placed",
      "items": [
        {
          "id": "oi_01",
          "catalog_product_id": "prd_05",
          "name": "Whole Milk",
          "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
          "quantity": 2,
          "unit": "l",
          "category": "dairy",
          "storage": "fridge"
        },
        {
          "id": "oi_02",
          "catalog_product_id": "prd_06",
          "name": "Tomatoes",
          "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
          "quantity": 1,
          "unit": "kg",
          "category": "vegetables",
          "storage": "fridge"
        }
      ],
      "item_count": 2,
      "placed_at": "2026-10-30T16:00:00Z",
      "received_at": null,
      "added_to_fridge_at": null,
      "currency": "EGP",
      "total": 98.0
    },
    {
      "id": "ord_02",
      "status": "received",
      "items": [
        {
          "id": "oi_03",
          "catalog_product_id": "prd_02",
          "name": "Greek Yogurt",
          "image_url": "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&h=400&q=80",
          "quantity": 1,
          "unit": "pcs",
          "category": "dairy",
          "storage": "fridge"
        }
      ],
      "item_count": 1,
      "placed_at": "2026-10-28T12:00:00Z",
      "received_at": "2026-10-29T09:00:00Z",
      "added_to_fridge_at": null,
      "currency": "EGP",
      "total": 45.0
    },
    {
      "id": "ord_03",
      "status": "added_to_fridge",
      "items": [
        {
          "id": "oi_04",
          "catalog_product_id": "prd_04",
          "name": "Bananas",
          "image_url": "https://images.unsplash.com/photo-1571771894821-ce9b6c11b08e?auto=format&fit=crop&w=400&h=400&q=80",
          "quantity": 6,
          "unit": "pcs",
          "category": "fruits",
          "storage": "pantry"
        }
      ],
      "item_count": 1,
      "placed_at": "2026-10-25T10:00:00Z",
      "received_at": "2026-10-26T08:00:00Z",
      "added_to_fridge_at": "2026-10-26T08:30:00Z",
      "currency": "EGP",
      "total": 30.0
    }
  ],
  "meta": {
    "page": 1,
    "limit": 20,
    "total": 3,
    "last_page": 1
  }
}
```

**Mock files:** `get_orders.json`, `get_orders_empty.json`

---

## 16. Get order

`GET /shopping/orders/{id}`

**When the app calls it:** Order detail screen.

**Path params:** `id` (string)

**Success — `200`:**

```json
{
  "success": true,
  "message": null,
  "data": {
    "id": "ord_01",
    "status": "placed",
    "items": [
      {
        "id": "oi_01",
        "catalog_product_id": "prd_05",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "storage": "fridge"
      },
      {
        "id": "oi_02",
        "catalog_product_id": "prd_06",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "storage": "fridge"
      }
    ],
    "item_count": 2,
    "placed_at": "2026-10-30T16:00:00Z",
    "received_at": null,
    "added_to_fridge_at": null,
    "currency": "EGP",
    "total": 98.0
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown order | `null` |

```json
{
  "success": false,
  "message": "Order not found.",
  "errors": null
}
```

**Mock files:** `get_order.json`, `get_order_404.json`

---

## 17. Complete order → fridge intake draft

`POST /shopping/orders/{id}/complete`

**When the app calls it:** Order detail “Mark received & add to fridge” when status is `placed` (or still needs intake). Marks order received and returns a `FridgeIntake` draft. Does **not** create inventory yet.

**Path params:** `id` (string)  
**Request body:** none

**Success — `200`:**

```json
{
  "success": true,
  "message": "Order marked as received",
  "data": {
    "id": "fi_02",
    "source": "order",
    "source_id": "ord_01",
    "lines": [
      {
        "id": "fil_03",
        "name": "Whole Milk",
        "image_url": "https://images.unsplash.com/photo-1563636619-e9143da7973b?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "storage": "fridge",
        "purchase_date": "2026-10-31",
        "expiry_date": "2026-11-10"
      },
      {
        "id": "fil_04",
        "name": "Tomatoes",
        "image_url": "https://images.unsplash.com/photo-1546470427-e2706767e0c1?auto=format&fit=crop&w=400&h=400&q=80",
        "quantity": 1,
        "unit": "kg",
        "category": "vegetables",
        "storage": "fridge",
        "purchase_date": "2026-10-31",
        "expiry_date": "2026-11-05"
      }
    ],
    "created_at": "2026-10-31T12:05:00Z"
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `409` | Status not completable (e.g. already `added_to_fridge`) | `null` |

```json
{
  "success": false,
  "message": "Order cannot be completed in its current status.",
  "errors": null
}
```

**Mock files:** `post_order_complete.json`, `post_order_complete_409.json`

---

## 18. Confirm fridge intake → create inventory

`POST /shopping/fridge-intake/{id}/confirm`

**When the app calls it:** Review screen “Add to fridge”. **This is the only shopping endpoint that creates inventory items.** After success: clear checked list items for `source=list`, or set order status to `added_to_fridge` for `source=order`.

**Path params:** `id` (string) — intake id

**Request body:**

```json
{
  "lines": [
    {
      "id": "fil_01",
      "name": "Greek Yogurt",
      "image_url": "https://images.unsplash.com/photo-1488477181946-6428a0291777?auto=format&fit=crop&w=400&h=400&q=80",
      "quantity": 1,
      "unit": "pcs",
      "category": "dairy",
      "storage": "fridge",
      "purchase_date": "2026-10-31",
      "expiry_date": "2026-11-07"
    }
  ]
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `lines` | array of `FridgeIntakeLine` | yes | Non-empty; each line needs `name` + `quantity` |

Created inventory rows should match inventory `FoodItem` / `POST /inventory` field semantics (`purchase_date`, `expiry_date`, `storage`, etc.). `is_partly_used` defaults to `false`.

**Success — `200`:**

```json
{
  "success": true,
  "message": "Added to your fridge",
  "data": {
    "intake_id": "fi_01",
    "created_inventory_ids": [
      "itm_shop_01",
      "itm_shop_02"
    ],
    "created_count": 2
  }
}
```

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Invalid lines | `lines` |
| `404` | Unknown intake | `null` |

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "lines": [
      "Each line needs a name and quantity."
    ]
  }
}
```

```json
{
  "success": false,
  "message": "Fridge intake not found.",
  "errors": null
}
```

**Mock files:** `post_fridge_intake_confirm.json`, `post_fridge_intake_confirm_422.json`, `post_fridge_intake_confirm_404.json`

---

## Mock registry

All files live under `assets/mocks/shopping/` and are registered in `lib/core/network_services/mock/mock_routes.dart`. Named error/empty scenarios are exposed as `MockRoutes.shopping*` constants for manual UI testing.
