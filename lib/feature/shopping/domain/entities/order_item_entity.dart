import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class OrderItemEntity extends Equatable {
  const OrderItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    this.catalogProductId,
    this.imageUrl,
    this.unit,
    this.category,
    this.storage,
  });

  final String id;
  final String? catalogProductId;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final StorageLocation? storage;

  @override
  List<Object?> get props => [
    id,
    catalogProductId,
    name,
    imageUrl,
    quantity,
    unit,
    category,
    storage,
  ];
}
