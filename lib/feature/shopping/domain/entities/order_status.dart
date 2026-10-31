import 'package:fridgy/core/helper/print_debug.dart';

enum OrderStatus {
  placed,
  received,
  addedToFridge;

  static OrderStatus? fromJson(String? value) {
    if (value == null) return null;
    switch (value) {
      case 'placed':
        return OrderStatus.placed;
      case 'received':
        return OrderStatus.received;
      case 'added_to_fridge':
        return OrderStatus.addedToFridge;
      default:
        printDebug(message: 'Unknown OrderStatus: $value');
        return null;
    }
  }

  String toJson() {
    switch (this) {
      case OrderStatus.placed:
        return 'placed';
      case OrderStatus.received:
        return 'received';
      case OrderStatus.addedToFridge:
        return 'added_to_fridge';
    }
  }
}
