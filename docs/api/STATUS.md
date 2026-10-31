# API Status

One row per endpoint. Updated by `/api-design` and `/connect-backend`.

| Status | Meaning |
| --- | --- |
| `mocked` | App works against mock JSON; API doc not written yet |
| `designed` | `docs/api/<feature>.md` written and matches the mocks — ready to hand off |
| `handed-off` | Given to the backend developer |
| `live` | Backend deployed; real responses verified against the doc; app switched to real API |
| `mismatch` | Backend response differs from the doc — needs a decision (see notes) |

| Feature | Method | Path | Status | Doc | Notes |
| --- | --- | --- | --- | --- | --- |
