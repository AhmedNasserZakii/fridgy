import 'package:fridgy/core/network_services/api_keys.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_category.dart';
import 'package:fridgy/feature/inventory/domain/entities/food_unit.dart';
import 'package:fridgy/feature/inventory/domain/entities/storage_location.dart';
import 'package:fridgy/feature/shopping/domain/entities/fridge_intake_line_entity.dart';

class FridgeIntakeLineModel {
  const FridgeIntakeLineModel({
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

  factory FridgeIntakeLineModel.fromJson(Map<String, dynamic> json) {
    final purchaseRaw = json[ApiKeys.purchaseDate] as String?;
    final expiryRaw = json[ApiKeys.expiryDate] as String?;
    return FridgeIntakeLineModel(
      id: json[ApiKeys.id] as String,
      name: json[ApiKeys.name] as String,
      imageUrl: json[ApiKeys.imageUrl] as String?,
      quantity: json[ApiKeys.quantity] as num,
      unit: FoodUnit.fromJson(json[ApiKeys.unit] as String?),
      category: FoodCategory.fromJson(json[ApiKeys.category] as String?),
      storage: StorageLocation.fromJson(json[ApiKeys.storage] as String?),
      purchaseDate: purchaseRaw == null ? null : DateTime.parse(purchaseRaw),
      expiryDate: expiryRaw == null ? null : DateTime.parse(expiryRaw),
    );
  }

  Map<String, dynamic> toJson() {
    String? dateOnly(DateTime? d) {
      if (d == null) return null;
      final y = d.year.toString().padLeft(4, '0');
      final m = d.month.toString().padLeft(2, '0');
      final day = d.day.toString().padLeft(2, '0');
      return '$y-$m-$day';
    }

    return {
      ApiKeys.id: id,
      ApiKeys.name: name,
      ApiKeys.imageUrl: imageUrl,
      ApiKeys.quantity: quantity,
      ApiKeys.unit: unit?.name,
      ApiKeys.category: category?.toJson(),
      ApiKeys.storage: storage?.name,
      ApiKeys.purchaseDate: dateOnly(purchaseDate),
      ApiKeys.expiryDate: dateOnly(expiryDate),
    };
  }

  factory FridgeIntakeLineModel.fromEntity(FridgeIntakeLineEntity entity) {
    return FridgeIntakeLineModel(
      id: entity.id,
      name: entity.name,
      imageUrl: entity.imageUrl,
      quantity: entity.quantity,
      unit: entity.unit,
      category: entity.category,
      storage: entity.storage,
      purchaseDate: entity.purchaseDate,
      expiryDate: entity.expiryDate,
    );
  }

  FridgeIntakeLineEntity toEntity() {
    return FridgeIntakeLineEntity(
      id: id,
      name: name,
      imageUrl: imageUrl,
      quantity: quantity,
      unit: unit,
      category: category,
      storage: storage,
      purchaseDate: purchaseDate,
      expiryDate: expiryDate,
    );
  }
}
