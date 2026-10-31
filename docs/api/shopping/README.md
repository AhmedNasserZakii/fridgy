# Shopping

Backend API design for the Fridgy Shopping feature (list, store/catalog, cart, orders, fridge intake).

- **Full contract:** [shopping.md](shopping.md)
- **Shared API rules:** [../README.md](../README.md)
- **Status:** [../STATUS.md](../STATUS.md)

Auth required on every endpoint. Inventory is created only via `POST /shopping/fridge-intake/{id}/confirm`.
