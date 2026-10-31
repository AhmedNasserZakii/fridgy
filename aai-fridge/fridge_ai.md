# Fridge AI API

> Shared rules (envelope, errors, auth, naming, pagination): see [README.md](README.md).

**Screens using this:** Fridgy AI chat, Fridgy AI history  
**Auth required:** yes (Bearer access token on every endpoint below)

**Inventory side-effect rule:** The AI endpoints **never** mutate inventory. They only return structured proposals / clarifications. When the user confirms:

- `add_food` proposals → app calls existing `POST /inventory` once per proposed item (only items with non-null `quantity`)
- `use_food` consumptions → app calls existing `POST /inventory/{id}/consume` once per proposed consumption, with body `{ "quantity": <amount> }` for partial use

**Streaming:** v1 returns one full JSON response (required for the app’s `MockInterceptor`). SSE / chunked streaming is a later option and is **not** used by the app today.

## Data objects

### `reply_kind`

Top-level (on send) and on assistant history messages. Tells the app which UI to show.

| Value | Meaning |
| --- | --- |
| `text` | Plain assistant text only (no cards) |
| `clarification` | Needs more info — show `clarification` quick replies |
| `proposal` | Ready to confirm — show `proposed_items` and/or `proposed_consumptions` / recipes |

### `ChatMessage`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Message id |
| `role` | string | no | `user` \| `assistant` |
| `content` | string | no | Message text (may be empty string when the user sent only an image) |
| `created_at` | string | no | ISO 8601 datetime UTC |
| `reply_kind` | string | no | See `reply_kind` above. User messages use `text`. On send responses this key may be omitted on nested `user_message` / `assistant_message` (actions are top-level). On history messages it is always present. |
| `image_url` | string | yes | Absolute URL of an uploaded grocery photo on user messages; `null` otherwise |
| `proposed_items` | array of `ProposedItem` | yes | Confirmable add-food proposals; otherwise `null` |
| `recipe_suggestions` | array of `RecipeSuggestion` | yes | Use-food recipes; otherwise `null` |
| `proposed_consumptions` | array of `ProposedConsumption` | yes | Use-food inventory updates; otherwise `null` |
| `clarification` | `Clarification` | yes | Quantity / missing-field prompt UI; otherwise `null` |

On `POST /fridge-ai/messages` and `POST /fridge-ai/messages/image`, nested `user_message` / `assistant_message` omit action arrays and `clarification` (those live top-level on the send response). Nested messages **do** include `image_url` when relevant. On `GET …/messages`, every message includes all action keys and `image_url` (`null` when unused).

### `ProposedItem`

Proposal only — not yet in inventory. Mapped by the app to `POST /inventory` on confirm (`expires_at` → `expiry_date`). Confirm only when `quantity` is non-null.

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Stable proposal id (edit / remove / clarification target) |
| `name` | string | no | Food name |
| `quantity` | number | yes | Amount; `null` while clarifying |
| `unit` | string | yes | `g` \| `kg` \| `ml` \| `l` \| `pcs`, or `null` |
| `category` | string | yes | `vegetables` \| `fruits` \| `dairy` \| `meat` \| `bakery` \| `other`, or `null` |
| `expires_at` | string | yes | Date-only `YYYY-MM-DD`, or `null` |
| `emoji` | string | yes | Optional display emoji (e.g. `"🥛"`), or `null` |

### `ProposedConsumption`

Proposal only. On confirm the app calls `POST /inventory/{inventory_item_id}/consume` with `{ "quantity": <quantity> }`.

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Stable proposal id |
| `inventory_item_id` | string | no | Existing inventory item id |
| `name` | string | no | Display name for review UI |
| `quantity` | number | no | Amount to deduct |
| `unit` | string | yes | Unit enum, or `null` |

### `Clarification`

Returned when the assistant needs a quantity (or similar) before building a confirmable proposal. User taps a quick reply → app sends that `message` via `POST /fridge-ai/messages` again. `message: null` means focus the composer for free text. Cancel sends `cancel_message` (or the app starts a new chat if empty).

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `target_item` | `ProposedItem` | no | Draft item; `quantity` usually `null` |
| `quick_replies` | array of `QuickReply` | no | Choice chips (at least 1) |
| `hint` | string | yes | Small helper under the chips |
| `note` | string | yes | Supporting info banner (e.g. missing expiry) |
| `cancel_label` | string | yes | Secondary cancel button label |
| `cancel_message` | string | yes | Text to send when cancel is tapped |

### `QuickReply`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `label` | string | no | Chip label shown in UI |
| `message` | string | yes | Next user message to send; `null` = free-text / “Other” |

### `RecipeSuggestion`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Recipe id |
| `title` | string | no | Display title |
| `description` | string | no | Short description |
| `uses_item_ids` | array of string | no | Inventory item ids the recipe uses (may be empty) |

### `ConversationSummary`

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `id` | string | no | Conversation id |
| `mode` | string | no | `add_food` \| `use_food` |
| `title` | string | no | Short list title |
| `preview` | string | no | Last assistant / summary snippet |
| `created_at` | string | no | ISO 8601 datetime UTC |
| `updated_at` | string | no | ISO 8601 datetime UTC |

### `SendMessageResult` (`data` of POST messages)

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `conversation_id` | string | no | New or continued conversation id |
| `mode` | string | no | Echo of request mode: `add_food` \| `use_food` |
| `reply_kind` | string | no | `text` \| `clarification` \| `proposal` |
| `user_message` | `ChatMessage` (without action arrays) | no | Persisted user turn |
| `assistant_message` | `ChatMessage` (without action arrays) | no | Full assistant reply text |
| `proposed_items` | array of `ProposedItem` | yes | For `proposal` + `add_food`; else `null` |
| `recipe_suggestions` | array of `RecipeSuggestion` | yes | For `use_food` when applicable; else `null` |
| `proposed_consumptions` | array of `ProposedConsumption` | yes | For `use_food` when applicable; else `null` |
| `clarification` | `Clarification` | yes | For `reply_kind: clarification`; else `null` |

### `ConversationDetail` (`data` of GET messages)

| Field | Type | Nullable | Description |
| --- | --- | --- | --- |
| `conversation_id` | string | no | |
| `mode` | string | no | `add_food` \| `use_food` |
| `messages` | array of `ChatMessage` | no | Chronological; each includes action keys |

---

## 1. Send message

`POST /fridge-ai/messages`

**When the app calls it:** User taps send, a suggested prompt, a clarification quick reply, or cancel.

**Path params:** none  
**Query params:** none

**Request body:**

```json
{
  "mode": "add_food",
  "message": "I bought 2 liters of milk, 12 eggs, and half a kilo of tomatoes.",
  "conversation_id": null
}
```

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `mode` | string | yes | `add_food` \| `use_food` |
| `message` | string | yes | Non-empty after trim (see `422`) |
| `conversation_id` | string | no | Omit/`null` to start a new conversation; send prior id to continue |

**Success — `200` (`add_food` proposal):**

```json
{
  "success": true,
  "message": null,
  "data": {
    "conversation_id": "conv_7f2a1c9e",
    "mode": "add_food",
    "reply_kind": "proposal",
    "user_message": {
      "id": "msg_u_01",
      "role": "user",
      "content": "I bought 2 liters of milk, 12 eggs, and half a kilo of tomatoes.",
      "created_at": "2026-10-31T09:41:00Z"
    },
    "assistant_message": {
      "id": "msg_a_01",
      "role": "assistant",
      "content": "Got it — I found 3 items to add. Review them and confirm when you're ready.",
      "created_at": "2026-10-31T09:41:02Z"
    },
    "proposed_items": [
      {
        "id": "prop_milk_01",
        "name": "Milk",
        "quantity": 2,
        "unit": "l",
        "category": "dairy",
        "expires_at": "2026-11-05",
        "emoji": "🥛"
      }
    ],
    "recipe_suggestions": null,
    "proposed_consumptions": null,
    "clarification": null
  }
}
```

**Success — `200` (`add_food` clarification):** see mock `post_messages_clarification.json` — `reply_kind: clarification`, `clarification` filled, proposals `null`.

**Success — `200` (`use_food`):** see mock `post_messages_use_food.json` — `proposed_items` is `null`; `recipe_suggestions` and/or `proposed_consumptions` may be arrays.

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Empty / missing `message` | `message` |
| `429` | Rate limited | `null` |
| `503` | AI provider unavailable | `null` |

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "message": ["The message field is required."]
  }
}
```

**Mock files:**  
`assets/mocks/fridge_ai/post_messages_add_food.json` (default),  
`assets/mocks/fridge_ai/post_messages_clarification.json` (mock interceptor when message looks quantity-incomplete, e.g. “I bought some milk”),  
`assets/mocks/fridge_ai/post_messages_use_food.json` (body `mode` is `use_food`),  
`assets/mocks/fridge_ai/post_messages_422.json`,  
`assets/mocks/fridge_ai/post_messages_429.json`,  
`assets/mocks/fridge_ai/post_messages_503.json`

---

## 2. Send image (vision)

`POST /fridge-ai/messages/image`

**When the app calls it:** User attaches a grocery photo in Fridgy AI (camera or gallery) and taps send. Optional caption may be included.

**Content-Type:** `multipart/form-data` (not JSON)

**Path params:** none  
**Query params:** none

**Multipart fields:**

| Field | Type | Required | Rules |
| --- | --- | --- | --- |
| `mode` | string | yes | `add_food` \| `use_food` |
| `image` | file | yes | JPEG/PNG/WebP; max size backend-defined (app compresses ~1600px / quality 85) |
| `message` | string | no | Optional caption; omit or empty when photo-only |
| `conversation_id` | string | no | Omit/`null` to start a new conversation; send prior id to continue |

**Success — `200`:** Same `SendMessageResult` shape as text send. Typical `reply_kind` is `proposal` with `proposed_items` filled from vision. `user_message.image_url` is the stored absolute URL of the upload. `user_message.content` is the caption or a short default like `"What's in this photo?"`.

See mock `post_messages_image.json`.

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `422` | Missing / invalid `image` | `image` |
| `429` | Rate limited | `null` |
| `503` | AI / vision provider unavailable | `null` |

Example `422`:

```json
{
  "success": false,
  "message": "The given data was invalid.",
  "errors": {
    "image": ["The image field is required."]
  }
}
```

**Mock files:**  
`assets/mocks/fridge_ai/post_messages_image.json`,  
`assets/mocks/fridge_ai/post_messages_image_422.json`

---

## 3. List conversations

`GET /fridge-ai/conversations`

**When the app calls it:** User opens History from Fridgy AI.

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
      "id": "conv_7f2a1c9e",
      "mode": "add_food",
      "title": "Milk, eggs & tomatoes",
      "preview": "Got it — I found 3 items to add. Review them and confirm when you're ready.",
      "created_at": "2026-10-31T09:41:00Z",
      "updated_at": "2026-10-31T09:41:02Z"
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

Empty list uses the same shape with `"data": []` and `total: 0`.

**Errors:** none dedicated beyond shared auth / 500.

**Mock files:**  
`assets/mocks/fridge_ai/get_conversations.json`,  
`assets/mocks/fridge_ai/get_conversations_empty.json`

---

## 4. Get conversation messages

`GET /fridge-ai/conversations/{id}/messages`

**When the app calls it:** User taps a conversation in History.

**Path params:** `id` (string)  
**Query params:** none  
**Request body:** none

**Success — `200`:** see mock `get_conversation_messages.json` — each message includes `reply_kind`, action arrays, and `clarification`.

**Errors:**

| Status | When | `errors` keys |
| --- | --- | --- |
| `404` | Unknown conversation id | `null` |

Example `404`:

```json
{
  "success": false,
  "message": "Conversation not found.",
  "errors": null
}
```

**Mock files:**  
`assets/mocks/fridge_ai/get_conversation_messages.json`,  
`assets/mocks/fridge_ai/get_conversation_messages_404.json`

---

## Mock file index

| File | Purpose |
| --- | --- |
| `post_messages_add_food.json` | Send success (`add_food` proposal) |
| `post_messages_clarification.json` | Send success (`add_food` clarification) |
| `post_messages_use_food.json` | Send success (`use_food`) |
| `post_messages_image.json` | Image vision success (`proposal`) |
| `post_messages_image_422.json` | Missing image validation |
| `post_messages_422.json` | Empty message validation |
| `post_messages_429.json` | Rate limit |
| `post_messages_503.json` | AI unavailable |
| `get_conversations.json` | History list |
| `get_conversations_empty.json` | Empty history |
| `get_conversation_messages.json` | Open conversation |
| `get_conversation_messages_404.json` | Unknown conversation |

## Open questions for backend

- Max length for `message` (app only requires non-empty trim today).
- Max upload size / allowed MIME types for `image`.
- Whether continuing a conversation with a different `mode` than the conversation’s original mode is allowed (app currently resets local thread when the user switches mode).
- How many clarification turns are allowed before forcing a proposal.
- Whether vision results can also return `clarification` when quantity is unclear from the photo.
- Streaming protocol for a future v2 (not used by the app yet).
