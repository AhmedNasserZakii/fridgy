import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class CartItemEntity extends Equatable {
  const CartItemEntity({
    required this.id,
    required this.catalogProductId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
    required this.currency,
    this.imageUrl,
    this.unit,
    this.category,
  });

  final String id;
  final String catalogProductId;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final num unitPrice;
  final String currency;
  final num lineTotal;

  @override
  List<Object?> get props => [
    id,
    catalogProductId,
    name,
    imageUrl,
    quantity,
    unit,
    category,
    unitPrice,
    currency,
    lineTotal,
  ];
}
