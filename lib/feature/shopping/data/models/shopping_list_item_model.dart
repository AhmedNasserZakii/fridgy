import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/shopping/domain/entities/shopping_list_item_entity.dart';

class ShoppingListItemModel {
  const ShoppingListItemModel({
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

  factory ShoppingListItemModel.fromJson(Map<String, dynamic> json) {
    return ShoppingListItemModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      quantity: json[ApiKeys.quantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      isChecked: json[ApiKeys.isChecked] as bool,
      catalogProductId: json[ApiKeys.catalogProductId] as String?,
      notes: json[ApiKeys.notes] as String?,
      createdAt: DateTime.parse(json[ApiKeys.createdAt] as String),
      updatedAt: DateTime.parse(json[ApiKeys.updatedAt] as String),
    );
  }

  ShoppingListItemEntity toEntity() {
    return ShoppingListItemEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      category: category,
      isChecked: isChecked,
      catalogProductId: catalogProductId,
      notes: notes,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
