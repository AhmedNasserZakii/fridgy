import 'package:fridgy/core/helper/print_debug.dart';

/// Query `status` for `GET inventory` (includes out-of-stock, which is
/// quantity-based, not an [ExpiryStatus]).
enum InventoryStatusFilter {
  fresh,
  useSoon,
  expired,
  outOfStock;

  static InventoryStatusFilter? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'fresh':
        return InventoryStatusFilter.fresh;
      case 'use_soon':
        return InventoryStatusFilter.useSoon;
      case 'expired':
        return InventoryStatusFilter.expired;
      case 'out_of_stock':
        return InventoryStatusFilter.outOfStock;
      default:
        printDebug(message: 'Unknown InventoryStatusFilter: $value');
        return null;
    }
  }

  String get apiValue {
    switch (this) {
      case InventoryStatusFilter.fresh:
        return 'fresh';
      case InventoryStatusFilter.useSoon:
        return 'use_soon';
      case InventoryStatusFilter.expired:
        return 'expired';
      case InventoryStatusFilter.outOfStock:
        return 'out_of_stock';
    }
  }
}
