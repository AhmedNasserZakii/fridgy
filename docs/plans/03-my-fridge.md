# Plan 03 — My Fridge (inventory list, filter, add, detail, edit)

> Figma section `151:7989`. Visuals: Figma wins. Data/API: this plan wins.
> Extend `lib/feature/inventory/`. Colors only from `AppColors` (`brandPrimary` `#087CB9`).
> Keep shared food-item field `expiry_date` (date-only). Do **not** rename to `expires_at`.

## Decisions (confirmed)

| # | Decision |
| --- | --- |
| D1 | Scan Food / Take Photo → Coming soon snackbar. Manual add only. |
| D2 | Find a recipe → Coming soon. |
| D3 | Flat paginated `GET inventory`, default `sort=expiry_asc`. Client groups by `expiry_status` (`use_soon` → "Use soon" cards; `fresh`/`expired` → "The rest of your kitchen"). Filter chips + sheet call the API. |
| D4 | Out of stock = `quantity == 0`. No flag. Query `status=out_of_stock` supported. Active count = items with `quantity > 0`. Out-of-stock rows shown in footer guidance when present. |
| D5 | Feature lives under `lib/feature/inventory/`. |
| D6 | Photo on create/edit: UI field exists; sending `image_url` is optional string/`null` (no multipart in this task). Tapping photo → Coming soon. |

## Food item (extended)

Existing fields +:

| Field | Type | Notes |
| --- | --- | --- |
| `category` | string \| null | `vegetables` \| `fruits` \| `dairy` \| `meat` \| `bakery` \| `other` |
| `purchase_date` | date-only \| null | `"2026-10-28"` |

`expiry_date` stays date-only. `days_left` + `expiry_status` stay server-computed (`fresh` \| `use_soon` \| `expired`). When `quantity == 0`, item is out of stock regardless of `expiry_status`.

## Endpoints

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| GET | `inventory` | yes | List (filters + pagination) |
| GET | `inventory/{id}` | yes | Detail |
| POST | `inventory` | yes | Create |
| PUT | `inventory/{id}` | yes | Update |
| POST | `inventory/{id}/consume` | yes | Mark consumed (`data: null`) |
| GET | `inventory/search` | yes | (existing) |
| GET | `inventory/expiring` | yes | (existing) |

### List query

| Param | Values | Default |
| --- | --- | --- |
| `storage` | `fridge` \| `freezer` \| `pantry` | omit = all |
| `category` | food category enum | omit = all |
| `q` | string | omit |
| `status` | `fresh` \| `use_soon` \| `expired` \| `out_of_stock` | omit |
| `expires_within_days` | `3` \| `7` | omit |
| `sort` | `expiry_asc` \| `expiry_desc` \| `name_asc` | `expiry_asc` |
| `include_out_of_stock` | bool | `false` (My Fridge sets `true` so footer can show qty=0) |
| `page`, `limit` | pagination | 1 / 20 |

### Create / update body

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

Response `data`: full food item. Create → `201`. Consume → `200`, `data: null`.

## Screens / routes

| Route | Screen |
| --- | --- |
| Nav tab index 1 | `MyFridgeScreen` (replaces ComingSoonView) |
| `/add-food` | Add chooser |
| `/add-food/manual` | Add manually form |
| `/inventory/:id` | Detail |
| `/inventory/:id/edit` | Edit form |

Filter sheet = modal bottom sheet from My Fridge (not a route).

## Mocks required

```
get_inventory.json / get_inventory_empty.json
get_inventory_item.json / get_inventory_item_404.json
post_inventory.json / post_inventory_422.json
put_inventory.json / put_inventory_422.json / put_inventory_404.json
post_consume.json / post_consume_404.json
(+ existing search/expiring mocks; add category + purchase_date to all food items)
```

## Done checklist

`dart format` + `flutter analyze` on changed paths; mocks valid + registered; `docs/api/inventory.md` + STATUS rows `designed`.
