import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/shopping/domain/entities/cart_item_entity.dart';

class CartItemModel {
  const CartItemModel({
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json[ApiKeys.id] as String,
      catalogProductId: json[ApiKeys.catalogProductId] as String,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      quantity: json[ApiKeys.quantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      unitPrice: json[ApiKeys.unitPrice] as num,
      currency: json[ApiKeys.currency] as String,
      lineTotal: json[ApiKeys.lineTotal] as num,
    );
  }

  CartItemEntity toEntity() {
    return CartItemEntity(
      id: id,
      catalogProductId: catalogProductId,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      category: category,
      unitPrice: unitPrice,
      currency: currency,
      lineTotal: lineTotal,
    );
  }
}
