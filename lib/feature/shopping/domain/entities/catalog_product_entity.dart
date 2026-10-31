import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';

class CatalogProductEntity extends Equatable {
  const CatalogProductEntity({
    required this.id,
    required this.name,
    required this.defaultQuantity,
    this.imageUrl,
    this.category,
    this.unit,
    this.defaultStorage,
    this.price,
    this.currency,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final FoodCategory? category;
  final num defaultQuantity;
  final FoodUnit? unit;
  final StorageLocation? defaultStorage;
  final num? price;
  final String? currency;

  @override
  List<Object?> get props => [
    id,
    name,
    imageUrl,
    category,
    defaultQuantity,
    unit,
    defaultStorage,
    price,
    currency,
  ];
}
