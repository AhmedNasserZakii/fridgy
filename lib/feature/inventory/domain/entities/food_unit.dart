import 'package:fridgy/core/helper/print_debug.dart';

enum FoodUnit {
  g,
  kg,
  ml,
  l,
  pcs;

  static FoodUnit? fromJson(String? value) {
    if (value == null) return null;
    for (final unit in FoodUnit.values) {
      if (unit.name == value) return unit;
    }
    printDebug(message: 'Unknown FoodUnit: $value');
    return null;
  }
}
