# Fridge AI — backend hand-off

Send this whole `aai-fridge/` folder to the backend developer.

| File | What it is |
| --- | --- |
| `README.md` | Shared API conventions (envelope, auth, errors, naming, multipart) |
| `fridge_ai.md` | Fridge AI endpoints + data objects (build these) |
| `inventory.md` | Inventory API — confirm uses `POST /inventory` and `POST /inventory/{id}/consume` |
| `STATUS.md` | Full app API status board |
| `mocks/` | Example response bodies the mobile app already parses |

## Fridge AI endpoints to implement

1. `POST /fridge-ai/messages` — text chat
2. `POST /fridge-ai/messages/image` — **multipart** grocery photo → detected items (`proposed_items`)
3. `GET /fridge-ai/conversations`
4. `GET /fridge-ai/conversations/{id}/messages`

## Related inventory endpoints on confirm

1. `POST /inventory` — one request per proposed add-food item
2. `POST /inventory/{id}/consume` — optional `{ "quantity": <n> }` for partial use

AI endpoints must **not** mutate inventory.
