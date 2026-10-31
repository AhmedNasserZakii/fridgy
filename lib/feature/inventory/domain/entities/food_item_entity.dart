import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/expiry_status.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class FoodItemEntity extends Equatable {
  const FoodItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isPartlyUsed,
    required this.addedAt,
    this.imageUrl,
    this.unit,
    this.storage,
    this.category,
    this.purchaseDate,
    this.expiryDate,
    this.daysLeft,
    this.expiryStatus,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final StorageLocation? storage;
  final FoodCategory? category;
  final DateTime? purchaseDate;
  final bool isPartlyUsed;
  final DateTime? expiryDate;
  final int? daysLeft;
  final ExpiryStatus? expiryStatus;
  final DateTime addedAt;

  bool get isOutOfStock => quantity == 0;

  @override
  List<Object?> get props => [
        id,
        name,
        imageUrl,
        quantity,
        unit,
        storage,
        category,
        purchaseDate,
        isPartlyUsed,
        expiryDate,
        daysLeft,
        expiryStatus,
        addedAt,
      ];
}
