import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class UpsertFoodParams {
  const UpsertFoodParams({
    required this.name,
    required this.quantity,
    required this.isPartlyUsed,
    this.category,
    this.unit,
    this.storage,
    this.purchaseDate,
    this.expiryDate,
    this.imageUrl,
  });

  final String name;
  final FoodCategory? category;
  final num quantity;
  final FoodUnit? unit;
  final StorageLocation? storage;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;
  final String? imageUrl;
  final bool isPartlyUsed;
}
