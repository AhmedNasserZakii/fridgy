import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/shopping/domain/entities/catalog_product_entity.dart';

class CatalogProductModel {
  const CatalogProductModel({
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

  factory CatalogProductModel.fromJson(Map<String, dynamic> json) {
    return CatalogProductModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      defaultQuantity: json[ApiKeys.defaultQuantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      defaultStorage: StorageLocation.fromJson(
        json[ApiKeys.defaultStorage] as String?,
      ),
      price: json[ApiKeys.price] as num?,
      currency: json[ApiKeys.currency] as String?,
    );
  }

  CatalogProductEntity toEntity() {
    return CatalogProductEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      category: category,
      defaultQuantity: defaultQuantity,
      unit: unit,
      defaultStorage: defaultStorage,
      price: price,
      currency: currency,
    );
  }
}
