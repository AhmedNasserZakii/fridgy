import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class FridgeIntakeLineEntity extends Equatable {
  const FridgeIntakeLineEntity({
    required this.id,
    required this.name,
    required this.quantity,
    this.imageUrl,
    this.unit,
    this.category,
    this.storage,
    this.purchaseDate,
    this.expiryDate,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final StorageLocation? storage;
  final DateTime? purchaseDate;
  final DateTime? expiryDate;

  FridgeIntakeLineEntity copyWith({
    String? name,
    num? quantity,
    FoodUnit? unit,
    FoodCategory? category,
    StorageLocation? storage,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    bool clearExpiryDate = false,
  }) {
    return FridgeIntakeLineEntity(
      id: id,
      name: name ?? this.name,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      category: category ?? this.category,
      storage: storage ?? this.storage,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: clearExpiryDate ? null : (expiryDate ?? this.expiryDate),
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    quantity,
    unit,
    category,
    storage,
    purchaseDate,
    expiryDate,
  ];
}
