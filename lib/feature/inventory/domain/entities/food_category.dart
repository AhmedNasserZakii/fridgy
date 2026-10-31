import 'package:fridgy/core/helper/print_debug.dart';

enum FoodCategory {
  vegetables,
  fruits,
  dairy,
  meat,
  bakery,
  other;

  static FoodCategory? fromJson(String? value) {
    if (value == null) return null;
    for (final category in FoodCategory.values) {
      if (category.name == value) return category;
    }
    printDebug(message: 'Unknown FoodCategory: $value');
    return null;
  }

  String toJson() => name;
}
