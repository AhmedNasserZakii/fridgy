import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/shopping/domain/entities/order_item_entity.dart';

class OrderItemModel {
  const OrderItemModel({
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

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json[ApiKeys.id] as String,
      catalogProductId: json[ApiKeys.catalogProductId] as String?,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      quantity: json[ApiKeys.quantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      storage: StorageLocation.fromJson(json[ApiKeys.storage] as String?),
    );
  }

  OrderItemEntity toEntity() {
    return OrderItemEntity(
      id: id,
      catalogProductId: catalogProductId,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      category: category,
      storage: storage,
    );
  }
}
