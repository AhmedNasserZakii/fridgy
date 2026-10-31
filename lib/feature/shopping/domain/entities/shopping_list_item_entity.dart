import 'package:equatable/equatable.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';

class ShoppingListItemEntity extends Equatable {
  const ShoppingListItemEntity({
    required this.id,
    required this.name,
    required this.quantity,
    required this.isChecked,
    required this.createdAt,
    required this.updatedAt,
    this.imageUrl,
    this.unit,
    this.category,
    this.catalogProductId,
    this.notes,
  });

  final String id;
  final String name;
  final String? imageUrl;
  final num quantity;
  final FoodUnit? unit;
  final FoodCategory? category;
  final bool isChecked;
  final String? catalogProductId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShoppingListItemEntity copyWith({
    bool? isChecked,
    num? quantity,
    String? name,
  }) {
    return ShoppingListItemEntity(
      id: id,
      name: name ?? this.name,
      imageUrl: imageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit,
      category: category,
      isChecked: isChecked ?? this.isChecked,
      catalogProductId: catalogProductId,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
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
    isChecked,
    catalogProductId,
    notes,
    createdAt,
    updatedAt,
  ];
}
