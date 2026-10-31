enum InventorySort {
  expiryAsc,
  expiryDesc,
  nameAsc;

  String get apiValue {
    switch (this) {
      case InventorySort.expiryAsc:
        return 'expiry_asc';
      case InventorySort.expiryDesc:
        return 'expiry_desc';
      case InventorySort.nameAsc:
        return 'name_asc';
    }
  }

  static InventorySort fromApi(String? value) {
    switch (value) {
      case 'expiry_desc':
        return InventorySort.expiryDesc;
      case 'name_asc':
        return InventorySort.nameAsc;
      case 'expiry_asc':
      default:
        return InventorySort.expiryAsc;
    }
  }
}
