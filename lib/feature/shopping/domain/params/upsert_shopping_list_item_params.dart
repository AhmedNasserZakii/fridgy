import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class UpsertShoppingListItemParams {
  const UpsertShoppingListItemParams({
    required this.name,
    required this.quantity,
    this.unit,
    this.category,
    this.imageUrl,
    this.catalogProductId,
    this.notes,
  });

  final String name;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final String? imageUrl;
  final String? catalogProductId;
  final String? notes;
}
